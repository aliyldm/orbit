package net.bigpoint.darkorbit.mvc.chatclient.model
{
   import Infinicast.Client.Api.Errors.ICError;
   import com.adobe.utils.StringUtil;
   import com.bigpoint.utils.TimeFormatter;
   import flash.globalization.DateTimeStyle;
   import flash.globalization.LocaleID;
   import flash.system.Security;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.ChatAuthenticateUserRequest;
   import net.bigpoint.darkorbit.mvc.chatclient.DOChatClientNotifications;
   import net.bigpoint.darkorbit.mvc.chatclient.model.backend.AChatConnectionStatus;
   import net.bigpoint.darkorbit.mvc.chatclient.model.backend.AChatGameClientConnector;
   import net.bigpoint.darkorbit.mvc.chatclient.model.backend.ChatSettings;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.ContactsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.ContactsWindowProxy;
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListEntryVO;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.mvc.gui.messages.model.LogMessageProfileVOFactory;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.time.ServerTime;
   import net.bigpoint.eventstream.EventStreamClient;
   import org.osflash.signals.Signal;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   import spark.formatters.DateTimeFormatter;
   
   public class DOChatProxy extends Proxy
   {
      
      public static const NAME:String = "ChatProxy";
      
      public static const BAN_MSG:String = "achat_ban_user";
      
      public static const MAX_MESSAGE_LENGTH:int = 140;
      
      private static const UNKNOWN:String = "UNKNOWN";
      
      private static const RECONNECT_DELAY_MS:uint = 3000;
      
      private static const EMOJI_TOKEN_PATTERN:RegExp = /\[emoji:emoji_[0-9]+\]|<sprite\s+name=(?:"emoji_[0-9]+"|'emoji_[0-9]+'|emoji_[0-9]+)\s*\/?>/g;
      
      private const _statusHandler:Object = {};
      
      private var _reconnectTimeoutId:uint;
      
      private var _disconnectRequested:Boolean;
      
      private var _connectionAttemptInProgress:Boolean;
      
      private var _autoReconnectActive:Boolean;
      
      private var _loginSignal:Signal = new Signal();
      
      private var _chatConnected:Boolean = false;
      
      private var _ignoredUsers:Dictionary = new Dictionary();
      
      private var _spamProtectionLog:Vector.<String> = new Vector.<String>();
      
      private var _endpointInvalid:Boolean = true;
      
      private var _endpointLogShown:Boolean;
      
      private var _handler:AChatGameClientConnector = new AChatGameClientConnector(ChatSettings.gameName);
      
      public function DOChatProxy()
      {
         super(NAME,new DOChatModelVO());
         Settings.displayChat.changed.add(this.handleDisplayChat);
         if(ChatSettings.chat_cross_ip != "")
         {
            Security.loadPolicyFile(ChatSettings.chat_cross_ip);
         }
         this._statusHandler[AChatConnectionStatus.Connecting] = this.connectionStarted;
         this._statusHandler[AChatConnectionStatus.LoggedIn] = this.connectionRestored;
         this._statusHandler[AChatConnectionStatus.Disconnected] = this.connectionClosed;
         this._statusHandler[AChatConnectionStatus.Failed] = this.connectionFailed;
         this._statusHandler[AChatConnectionStatus.Banned] = this.banned;
         this._handler.setOnChatMessage(this.onChatMessage);
         this._handler.setOnConnectionStatusChange(this.onConnectionStatusChanged);
         this._handler.setOnEndpointIdChange(this.onEndpointIdChange);
         this._handler.setOnServerStatusInfo(this.onServerStatusInfo);
         this._handler.setOnSystemDefinedRoomChange(this.onSystemDefinedRoomChange);
         this._handler.setOnWhisper(this.onWhisper);
         this._handler.setOnRoomListeningRemovedByServer(this.onRemoveRoom);
         this._handler.setUnhandeledErrorFunc(this.onUnhandledError);
         this._handler.setOnReceiveUserRoomInvite(this.onInvite);
         this._handler.setOnBanFunc(this.onBan);
         Hero.clanChanged.add(this.changeHeroInfo);
         Hero.factionChanged.add(this.changeHeroInfo);
      }
      
      private function changeHeroInfo() : *
      {
         this.chatModel.cleanup();
         this.reconnect();
      }
      
      public function get handler() : AChatGameClientConnector
      {
         return this._handler;
      }
      
      public function get chatModel() : DOChatModelVO
      {
         return data as DOChatModelVO;
      }
      
      override public function onRemove() : void
      {
         if(ChatSettings.autoReconnectEnabled)
         {
            this._disconnectRequested = true;
            this.cancelScheduledReconnect();
         }
         Settings.displayChat.changed.remove(this.handleDisplayChat);
      }
      
      public function report(param1:DOChatReportVO) : void
      {
         this._handler.sendReportToRoomPath(param1.roomPath,param1.user.userId,param1.user.globalID,param1.reason,param1.reasonID,param1.msg.join("\n"),this.onError);
      }
      
      public function disconnect() : void
      {
         if(ChatSettings.autoReconnectEnabled)
         {
            this._disconnectRequested = true;
            this._connectionAttemptInProgress = false;
            this._autoReconnectActive = false;
            this.cancelScheduledReconnect();
         }
         if(this._chatConnected)
         {
            this._handler.disconnect();
            this.chatModel.cleanup();
            this._chatConnected = false;
            if(!ChatSettings.autoReconnectEnabled)
            {
               this.connectionClosed();
            }
         }
      }
      
      public function leaveGroup() : void
      {
         var _loc1_:DOChatRoomVO = this.chatModel.getRoomByType(DOChatRoomVO.TYPE_GROUP);
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:String = _loc1_.path;
         this.chatModel.closeRoom(_loc2_);
         this._handler.resetRooms(_loc2_);
      }
      
      public function connectionClosed() : void
      {
         this._chatConnected = false;
         if(ChatSettings.autoReconnectEnabled)
         {
            this._connectionAttemptInProgress = false;
            if(this._disconnectRequested || !Settings.displayChat.value || Boolean(this.chatModel.banned.value))
            {
               return;
            }
            if(!this._autoReconnectActive)
            {
               this._autoReconnectActive = true;
               this.sendChatDisconnectedAuthentication();
            }
            this.scheduleReconnect();
            return;
         }
         sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(BPLocale.getItemInCategory("chat","dochat.chat.connectionLost")));
         sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(BPLocale.getItemInCategory("chat","dochat.chat.connectionLost"),DOChatUserVO.getDefaultSystemUser()));
         this.sendChatDisconnectedAuthentication();
      }
      
      private function sendChatDisconnectedAuthentication() : void
      {
         var _loc1_:ChatAuthenticateUserRequest = new ChatAuthenticateUserRequest("",ChatSettings.chatLanguage);
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc1_);
      }
      
      public function reconnect() : void
      {
         if(ChatSettings.autoReconnectEnabled)
         {
            this._disconnectRequested = false;
            this._autoReconnectActive = true;
            this._connectionAttemptInProgress = false;
            this.cancelScheduledReconnect();
            this.connect();
            return;
         }
         this.disconnect();
         setTimeout(this.connect,1);
      }
      
      private function connectionStarted() : void
      {
         if(!ChatSettings.autoReconnectEnabled)
         {
            return;
         }
         this._connectionAttemptInProgress = true;
         this.cancelScheduledReconnect();
      }
      
      private function connectionRestored() : void
      {
         if(!ChatSettings.autoReconnectEnabled)
         {
            return;
         }
         this._connectionAttemptInProgress = false;
         this._autoReconnectActive = false;
         this.cancelScheduledReconnect();
      }
      
      private function connectionFailed() : void
      {
         if(ChatSettings.autoReconnectEnabled)
         {
            this.connectionClosed();
         }
      }
      
      private function scheduleReconnect() : void
      {
         if(!ChatSettings.autoReconnectEnabled || this._disconnectRequested || !Settings.displayChat.value || this._reconnectTimeoutId != 0)
         {
            return;
         }
         this._reconnectTimeoutId = setTimeout(this.runScheduledReconnect,RECONNECT_DELAY_MS);
      }
      
      private function runScheduledReconnect() : void
      {
         this._reconnectTimeoutId = 0;
         if(!ChatSettings.autoReconnectEnabled || this._disconnectRequested || !Settings.displayChat.value || this._connectionAttemptInProgress)
         {
            return;
         }
         this.connect();
      }
      
      private function cancelScheduledReconnect() : void
      {
         if(this._reconnectTimeoutId == 0)
         {
            return;
         }
         clearTimeout(this._reconnectTimeoutId);
         this._reconnectTimeoutId = 0;
      }
      
      public function displayBanMessage(param1:Date, param2:Date, param3:String) : void
      {
         var _loc4_:Number = param2.valueOf() - param1.valueOf();
         var _loc5_:DateTimeFormatter = new DateTimeFormatter();
         _loc5_.setStyle("locale",flash.globalization.LocaleID.DEFAULT);
         _loc5_.dateStyle = DateTimeStyle.SHORT;
         _loc5_.timeStyle = DateTimeStyle.NONE;
         var _loc6_:String = _loc5_.format(param1);
         _loc5_.dateStyle = DateTimeStyle.NONE;
         _loc5_.timeStyle = DateTimeStyle.SHORT;
         var _loc7_:String = _loc5_.format(param1);
         _loc5_.dateStyle = DateTimeStyle.SHORT;
         _loc5_.timeStyle = DateTimeStyle.NONE;
         var _loc8_:String = _loc5_.format(param2);
         _loc5_.dateStyle = DateTimeStyle.NONE;
         _loc5_.timeStyle = DateTimeStyle.SHORT;
         var _loc9_:String = _loc5_.format(param2);
         var _loc10_:String = TimeFormatter.getSmartFormatedTime(_loc4_ / 1000);
         var _loc11_:String = BPLocale.getItemInCategory("chat","dochat.loginerror.banned").replace("%BEGINDATE",_loc6_).replace("%BEGINTIME",_loc7_).replace("%ENDDATE",_loc8_).replace("%ENDTIME",_loc9_).replace("%PERIOD",_loc10_).replace("%TIME","") + "\n" + param3;
         this.chatModel.banned.value = _loc11_;
         sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(_loc11_,DOChatUserVO.getDefaultSystemUser(),DOChatMessageVO.WHISPER_TYPE_NONE,true));
         sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(_loc11_));
      }
      
      public function floodWarning() : void
      {
         sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(BPLocale.getItemInCategory("chat","chat_frequency_fast")).setType(LogMessageProfileVOFactory.STANDARD_MESSAGE));
      }
      
      public function loginOk() : void
      {
         this._chatConnected = true;
         this.connectionRestored();
         this._loginSignal.dispatch();
      }
      
      public function roomAlreadyExists() : void
      {
         sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(BPLocale.getItemInCategory("chat","dochat.chat.privateRoomAlreadyExist"),DOChatUserVO.getDefaultSystemUser()));
      }
      
      public function userDoesntExist(param1:ICError) : void
      {
         if(param1 == null)
         {
            return;
         }
         sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(BPLocale.getItemInCategory("chat","dochat.chat.userNotExistOrOnline"),DOChatUserVO.getDefaultSystemUser()));
      }
      
      public function initChat() : Signal
      {
         this.logChatDiagnostic("A-Chat initChat: server=" + ChatSettings.address);
         if(this._chatConnected)
         {
            return this._loginSignal;
         }
         this.connect();
         return this._loginSignal;
      }
      
      public function sendMessage(param1:String) : void
      {
         if(Boolean(param1) && Boolean(param1.replace(/[\s\r\n]+/gim,"").length > 0) && Boolean(this.chatModel.activeRoom))
         {
            if(this.checkAndHandleFloodProtection(param1))
            {
               return;
            }
            if(this.checkAndHandleIgnoreAllowUser(param1))
            {
               return;
            }
            if(this.checkAndHandleCreatePrCommand(param1))
            {
               return;
            }
            if(this.checkAndHandleLeavePrCommand(param1))
            {
               return;
            }
            if(this.checkAndHandleClosePrCommand(param1))
            {
               return;
            }
            if(this.checkAndHandleHelpRequest(param1))
            {
               return;
            }
            if(this.checkAndHandleRequestUserList(param1))
            {
               return;
            }
            if(this.checkAndHandleSendInvite(param1))
            {
               return;
            }
            if(this.checkAndHandleMessageLength(param1))
            {
               return;
            }
            if(this.checkAndHandleReport(param1))
            {
               return;
            }
            if(this.checkAndHandleSpamProtection(param1))
            {
               return;
            }
            if(this.checkAndHandleMissspelledCommand(param1))
            {
               return;
            }
            this._handler.sendChatMessageToRoomPath(this.chatModel.activeRoom.path,param1,this.onError);
         }
      }
      
      public function whisperMessage(param1:DOChatWhisperMessageVO) : void
      {
         var recipient:DOChatUserVO = null;
         var whisperVo:DOChatWhisperMessageVO = param1;
         if(!whisperVo || whisperVo.user == ChatSettings.userName || Boolean(this.chatModel.banned.value))
         {
            return;
         }
         if(this.checkAndHandleMessageLength(whisperVo.msg))
         {
            return;
         }
         recipient = this.resolveWhisperRecipient(whisperVo);
         this._handler.sendWhisper(Settings.instanceID + "_" + whisperVo.user,whisperVo.msg,function(param1:*):void
         {
            var _loc2_:DOChatMessageVO = null;
            var _loc3_:DOChatRoomVO = null;
            if(param1 == null)
            {
               _loc2_ = new DOChatMessageVO(whisperVo.msg,recipient,DOChatMessageVO.WHISPER_TYPE_YOU);
               DOChatWhisperHistoryStorage.addMessage(_loc2_);
               for each(_loc3_ in chatModel.getRoomsAsVector())
               {
                  _loc3_.addMessage(_loc2_);
               }
            }
            else
            {
               sendSystemMessage(BPLocale.getItemInCategory("chat","dochat.chat.userNotExistOrOnline"));
            }
         });
      }
      
      private function resolveWhisperRecipient(param1:DOChatWhisperMessageVO) : DOChatUserVO
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:DOChatUserVO = null;
         var _loc2_:String = param1.user;
         var _loc3_:Array = [param1.userData,this.findRoomUser(_loc2_),this.findContactUser(_loc2_),DOChatWhisperHistoryStorage.getUserByName(_loc2_)];
         for each(_loc10_ in _loc3_)
         {
            if(_loc10_)
            {
               if(!_loc4_)
               {
                  _loc4_ = _loc10_.usertype;
               }
               if(!_loc5_)
               {
                  _loc5_ = _loc10_.clanTag == Hero.NO_CLAN ? "" : _loc10_.clanTag;
               }
               if(!_loc6_)
               {
                  _loc6_ = _loc10_.globalID;
               }
               if(!_loc7_)
               {
                  _loc7_ = _loc10_.userId;
               }
               if(!_loc8_)
               {
                  _loc8_ = _loc10_.avatarUrl;
               }
               if(!_loc9_)
               {
                  _loc9_ = _loc10_.factionId;
               }
            }
         }
         return new DOChatUserVO(_loc2_,_loc4_ || DOChatUserVO.TYPE_USER,_loc5_ || "",_loc6_,_loc7_,_loc8_,_loc9_);
      }
      
      private function findRoomUser(param1:String) : DOChatUserVO
      {
         var _loc3_:DOChatRoomVO = null;
         var _loc4_:DOChatUserVO = null;
         if(!param1)
         {
            return null;
         }
         var _loc2_:String = param1.toLowerCase();
         loop0:
         for each(_loc3_ in this.chatModel.getRoomsAsVector())
         {
            var _loc7_:int = 0;
            var _loc8_:* = _loc3_.users;
            do
            {
               for each(_loc4_ in _loc8_)
               {
               }
               continue loop0;
            }
            while(!(Boolean(_loc4_) && Boolean(_loc4_.username) && _loc4_.username.toLowerCase() == _loc2_));
            return _loc4_;
         }
         return null;
      }
      
      private function findContactUser(param1:String) : DOChatUserVO
      {
         var _loc4_:ContactsWindowContactListEntryVO = null;
         var _loc2_:ContactsWindowProxy = facade.retrieveProxy(ContactsWindowProxy.NAME) as ContactsWindowProxy;
         if(!_loc2_ || !_loc2_.model || !param1)
         {
            return null;
         }
         var _loc3_:String = param1.toLowerCase();
         for each(_loc4_ in _loc2_.model.listEntries)
         {
            if(!(!_loc4_.username || _loc4_.username.toLowerCase() != _loc3_))
            {
               return new DOChatUserVO(_loc4_.username,DOChatUserVO.TYPE_USER,_loc4_.clanTag,null,_loc4_.userID > 0 ? _loc4_.userID.toString() : null,null,_loc4_.factionId);
            }
         }
         return null;
      }
      
      public function changeActiveRoom(param1:String) : void
      {
         this.chatModel.setActiveRoomByID(param1);
      }
      
      public function displayInternalChatMessage(param1:DOChatMessageVO) : void
      {
         var _loc2_:DOChatRoomVO = null;
         if(param1.forceToAllRooms)
         {
            for each(_loc2_ in this.chatModel.getRoomsAsVector())
            {
               this.displayDOChatMessage(_loc2_.path,param1);
            }
         }
         else
         {
            this.displayDOChatMessage(this.chatModel.activeRoom ? this.chatModel.activeRoom.path : "",param1);
         }
      }
      
      public function displayInternalChatProposal(param1:DOChatProposalVO) : void
      {
         this.displayDOChatMessage(this.chatModel.activeRoom ? this.chatModel.activeRoom.path : "",param1);
      }
      
      public function handlePrivateRoomAccepted(param1:DOChatInviteVO) : void
      {
         var vo:DOChatInviteVO = param1;
         this._handler.acceptUserRoomInvite(vo.roomName,function(param1:ICError):void
         {
            if(param1 != null)
            {
               onError(param1);
               return;
            }
            var _loc2_:DOChatRoomVO = chatModel.getRoomByName(vo.roomName);
            if(_loc2_)
            {
               chatModel.setActiveRoomByID(_loc2_.path);
            }
         });
      }
      
      public function resendGameSeverAuth() : void
      {
         var _loc1_:ChatAuthenticateUserRequest = null;
         if(this._chatConnected && this._endpointInvalid)
         {
            EventStreamClient.track("chat_auth",{
               "endpointID":ChatSettings.endpointID,
               "lang":ChatSettings.chatLanguage,
               "whisperID":ChatSettings.userName
            });
            _loc1_ = new ChatAuthenticateUserRequest(this.chatModel.banned.value ? "" : ChatSettings.endpointID,ChatSettings.chatLanguage);
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc1_);
            this._endpointInvalid = false;
         }
      }
      
      public function invalidateEndpoint() : void
      {
         this._endpointInvalid = true;
      }
      
      private function banned() : void
      {
         if(ChatSettings.autoReconnectEnabled)
         {
            this._connectionAttemptInProgress = false;
            this._autoReconnectActive = false;
            this.cancelScheduledReconnect();
         }
         var _loc1_:String = BPLocale.getItemInCategory("chat","dochat.chat.banBySystem");
         if(!this.chatModel.banned.value)
         {
            this.chatModel.banned.value = _loc1_;
         }
         sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(_loc1_,DOChatUserVO.getDefaultSystemUser(),DOChatMessageVO.WHISPER_TYPE_NONE,true));
      }
      
      private function onConnectionStatusChanged(param1:int) : void
      {
         this.logChatDiagnostic("A-Chat connection status: " + AChatConnectionStatus.toString(param1));
         if(this._statusHandler[param1])
         {
            this._statusHandler[param1]();
         }
      }
      
      private function onBan(param1:String, param2:Date, param3:* = null) : void
      {
         var _loc4_:Date = new Date();
         var _loc5_:String = this.createReportBanMessage(param3);
         if(_loc5_)
         {
            this.chatModel.banned.value = _loc5_;
            sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(_loc5_,DOChatUserVO.getDefaultSystemUser(),DOChatMessageVO.WHISPER_TYPE_NONE,true));
         }
         else
         {
            this.displayBanMessage(_loc4_,param2,"[" + param1 + "]");
         }
         var _loc6_:ChatAuthenticateUserRequest = new ChatAuthenticateUserRequest("",ChatSettings.chatLanguage);
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc6_);
      }
      
      private function createReportBanMessage(param1:*) : String
      {
         if(param1 == null)
         {
            return null;
         }
         if(param1 is Number && isNaN(Number(param1)))
         {
            return null;
         }
         var _loc2_:String = String(param1);
         if(!_loc2_ || _loc2_ == "null" || _loc2_ == "undefined" || _loc2_ == "NaN")
         {
            return null;
         }
         var _loc3_:String = BPLocale.getItemInCategory("chat","chat_chat_report_message");
         if(!_loc3_ || _loc3_.indexOf("%VALUE1%") < 0)
         {
            return null;
         }
         var _loc4_:String = _loc3_.replace("%VALUE1%",_loc2_);
         return _loc4_.indexOf("%VALUE1%") < 0 ? _loc4_ : null;
      }
      
      private function onUnhandledError(param1:ICError) : void
      {
         if(param1 == null || ChatSettings.autoReconnectEnabled && this._autoReconnectActive)
         {
            return;
         }
         sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(DOChatICErrorTranslator.getTranslation(param1),DOChatUserVO.getDefaultSystemUser(),DOChatMessageVO.WHISPER_TYPE_NONE));
      }
      
      private function onInvite(param1:String, param2:Object) : void
      {
         var _loc3_:DOChatUserVO = DOChatUserVO.fromJsonInvite(param2);
         if(this.isBlacklistedWhisperUser(_loc3_))
         {
            return;
         }
         if(_loc3_.isMod() || !this._ignoredUsers[_loc3_.username])
         {
            sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(BPLocale.getItemInCategory("chat","dochat.chat.inviteMessage").replace("%ROOM",param1.replace(DOChatRoomVO.TYPE_PRIVATE,"")).replace("%CREATOR",_loc3_.username),_loc3_,DOChatMessageVO.WHISPER_TYPE_NONE));
            sendNotification(DOChatClientNotifications.NEW_PROPOSAL,new DOChatProposalVO(BPLocale.getItemInCategory("chat","dochat.chat.inviteMessageAccept"),_loc3_,new DOChatInviteVO(param1,param1,_loc3_.username)));
         }
      }
      
      private function onRemoveRoom(param1:String) : void
      {
         this.chatModel.closeRoom(param1);
      }
      
      private function onWhisper(param1:String, param2:String, param3:Object, param4:Number) : void
      {
         var _loc6_:DOChatMessageVO = null;
         var _loc7_:DOChatRoomVO = null;
         var _loc5_:DOChatUserVO = DOChatUserVO.fromJsonInvite(param3);
         if(this.isBlacklistedWhisperUser(_loc5_))
         {
            return;
         }
         if(_loc5_.isMod() || !this._ignoredUsers[param2])
         {
            _loc6_ = new DOChatMessageVO(param1,_loc5_,DOChatMessageVO.WHISPER_TYPE_THEY);
            _loc6_.timestamp = param4;
            DOChatWhisperHistoryStorage.addMessage(_loc6_);
            sendNotification(ContactsWindowNotifications.ADD_WHISPER_CONTACT,_loc5_);
            for each(_loc7_ in this.chatModel.getRoomsAsVector())
            {
               _loc7_.addMessage(_loc6_);
            }
         }
      }
      
      private function isBlacklistedWhisperUser(param1:DOChatUserVO) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         var _loc2_:ContactsWindowProxy = facade.retrieveProxy(ContactsWindowProxy.NAME) as ContactsWindowProxy;
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:Number = Number(param1.userId);
         return _loc2_.isUserBlacklisted(param1.username,isNaN(_loc3_) || _loc3_ <= 0 ? -1 : int(_loc3_));
      }
      
      private function onSystemDefinedRoomChange(param1:String, param2:String, param3:String) : void
      {
         this.logChatDiagnostic("A-Chat room parsed: type=" + param1 + ", name=" + param2 + ", path=" + param3);
         this.chatModel.addRoom(new DOChatRoomVO(param2,param3,param1,false,0,new Vector.<DOChatUserVO>(0),new Vector.<DOChatMessageVO>(0)));
      }
      
      private function onServerStatusInfo(param1:Object, param2:String) : void
      {
         this.logChatDiagnostic("A-Chat serverStatus: endpoint=" + param2 + ", payload=" + this.toDiagnosticJson(param1));
      }
      
      private function onPredefinedRoomInfo(param1:Object, param2:String) : void
      {
         this.logChatDiagnostic("A-Chat changePredefinedRoom: endpoint=" + param2 + ", payload=" + this.toDiagnosticJson(param1));
      }
      
      private function toDiagnosticJson(param1:Object) : String
      {
         var result:String = null;
         var value:Object = param1;
         try
         {
            result = JSON.stringify(value);
         }
         catch(error:Error)
         {
            result = String(value);
         }
         if(!result)
         {
            return "null";
         }
         return result.length > 1200 ? result.substr(0,1200) + "..." : result;
      }
      
      private function logChatDiagnostic(param1:String) : void
      {
      }
      
      private function onChatMessage(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String, param8:String, param9:Number, param10:Number) : void
      {
         var _loc14_:DOChatMessageVO = null;
         var _loc12_:DOChatUserVO = DOChatUserVO.createUser(param2,param4,param5,param6,param7,null,param8);
         if(this.isBlacklistedWhisperUser(_loc12_))
         {
            return;
         }
         if(!_loc12_.isMod() && !_loc12_.isSystem() && Boolean(this._ignoredUsers[param2]))
         {
            return;
         }
         if(_loc12_.isSystem())
         {
            if(param3 == BAN_MSG)
            {
               param3 = this.formatBanMessage(param3,param9);
            }
            else
            {
               param3 = this.translateServerMessage(param3);
            }
         }
         else if(!param6)
         {
            EventStreamClient.track("flash.achat.error",{
               "error":"Global ID is null on message",
               "arguments":arguments
            });
         }
         var _loc13_:DOChatRoomVO = this.getDOChatRoom(param1);
         if(_loc13_)
         {
            _loc14_ = new DOChatMessageVO(param3,_loc12_);
            _loc14_.timestamp = param10;
            _loc13_.addMessage(_loc14_);
         }
      }
      
      private function formatBanMessage(param1:String, param2:Number) : String
      {
         return BPLocale.getItemInCategory("chat","chat_chat_report_message").replace("%VALUE1%",this.formatTimestamp(param2));
      }
      
      private function formatTimestamp(param1:Number) : String
      {
         var _loc2_:Date = new Date(param1 + ServerTime.instance.utcTimeOffset);
         return _loc2_.fullYearUTC + "-" + this.pad(_loc2_.monthUTC + 1) + "-" + this.pad(_loc2_.dateUTC) + " " + this.pad(_loc2_.hoursUTC) + ":" + this.pad(_loc2_.minutesUTC) + ":" + this.pad(_loc2_.secondsUTC);
      }
      
      private function pad(param1:int) : String
      {
         return param1 < 10 ? "0" + param1 : String(param1);
      }
      
      private function translateServerMessage(param1:String) : String
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:Array = param1.split("|");
         param1 = BPLocale.getItemInCategory("chat",_loc2_.shift());
         var _loc3_:int = _loc2_.length - 1;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            _loc6_ = _loc2_[_loc4_ + 1];
            param1 = param1.replace(_loc5_,_loc6_);
            _loc4_ += 2;
         }
         return param1;
      }
      
      private function onEndpointIdChange(param1:String) : void
      {
         ChatSettings.endpointID = param1;
         this.loginOk();
         this.invalidateEndpoint();
         this.resendGameSeverAuth();
      }
      
      private function handleDisplayChat() : void
      {
         if(Settings.displayChat.value)
         {
            this.connect();
         }
         else
         {
            this.disconnect();
         }
      }
      
      private function connect() : void
      {
         if(Settings.displayChat.value && (!ChatSettings.autoReconnectEnabled || !this._connectionAttemptInProgress))
         {
            if(ChatSettings.autoReconnectEnabled)
            {
               this._disconnectRequested = false;
               this._connectionAttemptInProgress = true;
            }
            this._handler.setWhisperId(Settings.instanceID + "_" + ChatSettings.userName);
            if(!ChatSettings.userName)
            {
               throw new Error("ChatSettings.userName missing");
            }
            this._handler.connect(ChatSettings.address,ChatSettings.space,ChatSettings.role);
         }
      }
      
      private function displayDOChatMessage(param1:String, param2:DOChatMessageVO) : void
      {
         var _loc3_:DOChatRoomVO = null;
         if(param2.user.usertype == DOChatUserVO.TYPE_SYSTEM && this.chatModel.getRoomById(param1) == null)
         {
            if(this.chatModel.activeRoom)
            {
               this.chatModel.activeRoom.addMessage(param2);
            }
         }
         else
         {
            _loc3_ = this.getDOChatRoom(param1);
            if(_loc3_)
            {
               _loc3_.addMessage(param2);
            }
         }
      }
      
      private function getDOChatRoom(param1:String) : DOChatRoomVO
      {
         return this.chatModel.getRoomById(param1);
      }
      
      private function checkAndHandleMissspelledCommand(param1:String) : Boolean
      {
         if(param1.indexOf("/") == 0)
         {
            this.printHelpMessage();
            return true;
         }
         return false;
      }
      
      private function checkAndHandleReport(param1:String) : Boolean
      {
         if(param1.indexOf("/report") == 0)
         {
            sendNotification(DOChatClientNotifications.OPEN_REPORT);
            return true;
         }
         return false;
      }
      
      private function checkAndHandleFloodProtection(param1:String) : Boolean
      {
         if(getTimer() - this.chatModel.lastMessageTime < 1000)
         {
            this.floodWarning();
            return true;
         }
         this.chatModel.lastMessageTime = getTimer();
         return false;
      }
      
      private function checkAndHandleClosePrCommand(param1:String) : Boolean
      {
         if(param1.indexOf("/close") == 0)
         {
            this._handler.closeUserRoom(this.chatModel.activeRoom.name,this.handleClosePr);
            return true;
         }
         return false;
      }
      
      private function handleClosePr(... rest) : void
      {
      }
      
      private function checkAndHandleLeavePrCommand(param1:String) : Boolean
      {
         if(param1.indexOf("/leave") == 0)
         {
            this._handler.removeChatterFromUserRoom(this.chatModel.activeRoom.name,Settings.instanceID + "_" + ChatSettings.userName,this.onError);
            return true;
         }
         return false;
      }
      
      private function onError(param1:ICError, ... rest) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc3_:String = DOChatICErrorTranslator.getTranslation(param1);
         if(_loc3_)
         {
            sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(_loc3_,DOChatUserVO.getDefaultSystemUser(),DOChatMessageVO.WHISPER_TYPE_NONE));
         }
      }
      
      private function checkAndHandleMessageLength(param1:String) : Boolean
      {
         if(this.getVisibleMessageLength(param1) > MAX_MESSAGE_LENGTH)
         {
            sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(BPLocale.getItemInCategory("chat","dochat.chat.messageTooLong"),DOChatUserVO.getDefaultSystemUser()));
            return true;
         }
         return false;
      }
      
      private function getVisibleMessageLength(param1:String) : int
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(!param1)
         {
            return 0;
         }
         EMOJI_TOKEN_PATTERN.lastIndex = 0;
         var _loc2_:String = param1.replace(EMOJI_TOKEN_PATTERN,"￼");
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = _loc2_.charCodeAt(_loc4_);
            if(_loc5_ >= 55296 && _loc5_ <= 56319 && _loc4_ + 1 < _loc2_.length)
            {
               _loc6_ = _loc2_.charCodeAt(_loc4_ + 1);
               if(_loc6_ >= 56320 && _loc6_ <= 57343)
               {
                  _loc4_++;
               }
            }
            _loc3_++;
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function checkAndHandleSendInvite(param1:String) : Boolean
      {
         var username:String = null;
         var message:String = param1;
         if(message.indexOf("/invite ") == 0)
         {
            username = message.substr("/invite ".length);
            username = StringUtil.trim(username);
            if(username == ChatSettings.userName)
            {
               return true;
            }
            this._handler.inviteChatterToUserRoom(this.chatModel.activeRoom.name,Settings.instanceID + "_" + username,function(param1:ICError):void
            {
               if(!param1)
               {
                  sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(BPLocale.getItemInCategory("chat","dochat.chat.youInvited").replace("%USER",username),DOChatUserVO.getDefaultSystemUser()));
               }
               else
               {
                  onError(param1);
               }
            });
            return true;
         }
         return false;
      }
      
      private function checkAndHandleSpamProtection(param1:String) : Boolean
      {
         if(this._spamProtectionLog.length < 2)
         {
            this._spamProtectionLog.push(param1);
            return false;
         }
         if(this._spamProtectionLog[0] == this._spamProtectionLog[1] && this._spamProtectionLog[1] == param1)
         {
            sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(BPLocale.getItemInCategory("chat","dochat.chat.spamWarning"),DOChatUserVO.getDefaultSystemUser()));
            return true;
         }
         this._spamProtectionLog.length = 0;
         this._spamProtectionLog.push(param1);
         return false;
      }
      
      private function checkAndHandleHelpRequest(param1:String) : Boolean
      {
         if(param1.indexOf("/help") == 0)
         {
            this.printHelpMessage();
            return true;
         }
         return false;
      }
      
      private function checkAndHandleRequestUserList(param1:String) : Boolean
      {
         if(param1.indexOf("/users") == 0)
         {
            this._handler.getUserListByRoomPath(this.chatModel.activeRoom.path,this.addUsersFormJson);
            return true;
         }
         return false;
      }
      
      private function addUsersFormJson(param1:String, param2:Array, param3:ICError = null) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:DOChatUserVO = null;
         if(param3)
         {
            this.onError(param3);
            return;
         }
         var _loc4_:DOChatRoomVO = this.chatModel.getRoomById(param1);
         if(_loc4_)
         {
            _loc4_.removeAllUsers();
            _loc5_ = int(param2.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = param2[_loc6_];
               _loc8_ = _loc7_.endpointData.userId;
               _loc9_ = _loc4_.getUserByName(_loc8_);
               if(!_loc9_)
               {
                  _loc4_.addUser(DOChatUserVO.fromJson(_loc7_));
               }
               _loc6_++;
            }
            this.dispatchUsersListMessage(param1);
         }
      }
      
      private function dispatchUsersListMessage(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc2_:DOChatRoomVO = this.chatModel.getRoomById(param1);
         if(_loc2_)
         {
            _loc3_ = _loc2_.users.join("\n");
            sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(BPLocale.getItemInCategory("chat","dochat.chat.userInRoom") + "\n" + _loc3_,DOChatUserVO.getDefaultSystemUser()));
         }
      }
      
      private function checkAndHandleCreatePrCommand(param1:String) : Boolean
      {
         var createAndInvite:Boolean = false;
         var tokens:Array = null;
         var roomName:String = null;
         var message:String = param1;
         var createNormal:Boolean = message.indexOf("/create ") == 0;
         createAndInvite = message.indexOf("/createpr ") == 0;
         if(createNormal || createAndInvite)
         {
            tokens = message.split(" ");
            if(tokens.length >= 2)
            {
               if(createNormal)
               {
                  roomName = "private_" + tokens.slice(1).join(" ");
               }
               else
               {
                  roomName = "private_" + tokens[1];
               }
               this._handler.createUserRoom(roomName,function(... rest):void
               {
                  var room:DOChatRoomVO;
                  var filteredTokens:* = undefined;
                  var len:int = 0;
                  var i:int = 0;
                  var username:String = null;
                  var args:Array = rest;
                  if(args.length > 0 && args[0] is ICError)
                  {
                     roomAlreadyExists();
                     return;
                  }
                  room = chatModel.getRoomByName(roomName);
                  if(room)
                  {
                     chatModel.setActiveRoomByID(room.path);
                  }
                  try
                  {
                     if(createAndInvite)
                     {
                        filteredTokens = tokens.slice(2);
                        len = int(filteredTokens.length);
                        i = 0;
                        while(i < len)
                        {
                           username = filteredTokens[i];
                           _handler.inviteChatterToUserRoom(roomName,Settings.instanceID + "_" + username,function(param1:ICError):void
                           {
                              if(!param1)
                              {
                                 sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(BPLocale.getItemInCategory("chat","dochat.chat.youInvited").replace("%USER",username),DOChatUserVO.getDefaultSystemUser()));
                              }
                              else
                              {
                                 sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(BPLocale.getItemInCategory("chat","dochat.chat.inviteErrorUserNotFound"),DOChatUserVO.getDefaultSystemUser(),DOChatMessageVO.WHISPER_TYPE_NONE,true));
                              }
                           });
                           i++;
                        }
                     }
                  }
                  catch(e:Error)
                  {
                  }
               });
            }
            return true;
         }
         return false;
      }
      
      private function checkAndHandleIgnoreAllowUser(param1:String) : Boolean
      {
         var _loc2_:String = null;
         if(param1.indexOf("/ignore ") == 0)
         {
            _loc2_ = param1.substr("/ignore ".length);
            _loc2_ = StringUtil.trim(_loc2_);
            if(_loc2_ == Hero.username)
            {
               sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(BPLocale.getItemInCategory("chat","dochat.chat.cannotIgnoreYourself"),DOChatUserVO.getDefaultSystemUser()));
               return true;
            }
            this._ignoredUsers[_loc2_] = true;
            sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(BPLocale.getItemInCategory("chat","dochat.chat.userNowIgnored").replace("%USER",_loc2_),DOChatUserVO.getDefaultSystemUser()));
            return true;
         }
         if(param1.indexOf("/allow ") == 0)
         {
            _loc2_ = param1.substr("/allow ".length);
            _loc2_ = StringUtil.trim(_loc2_);
            delete this._ignoredUsers[_loc2_];
            sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(BPLocale.getItemInCategory("chat","dochat.chat.userNoMoreIgnored").replace("%USER",_loc2_),DOChatUserVO.getDefaultSystemUser()));
            return true;
         }
         return false;
      }
      
      private function sendSystemMessage(param1:String) : void
      {
         sendNotification(DOChatClientNotifications.NEW_MESSAGE,new DOChatMessageVO(param1,DOChatUserVO.getDefaultSystemUser()));
      }
      
      private function printHelpMessage() : void
      {
         this.displayInternalChatMessage(new DOChatMessageVO("<font color=\'#FFFF00\'>/create &#60;roomname&#62; </font>" + BPLocale.getItemInCategory("chat","dochat.help.create"),DOChatUserVO.getCommandUser("/create"),this.chatModel.activeRoom.path));
         this.displayInternalChatMessage(new DOChatMessageVO("<font color=\'#FFFF00\'>/createpr &#60;roomname&#62; &#60;user1&#62; &#60;user2&#62; ... </font>",DOChatUserVO.getCommandUser("/createpr"),this.chatModel.activeRoom.path));
         this.displayInternalChatMessage(new DOChatMessageVO("<font color=\'#FFFF00\'>/close </font>" + BPLocale.getItemInCategory("chat","dochat.help.close"),DOChatUserVO.getCommandUser("/close"),this.chatModel.activeRoom.path));
         this.displayInternalChatMessage(new DOChatMessageVO("<font color=\'#FFFF00\'>/leave </font>" + BPLocale.getItemInCategory("chat","dochat.help.leave"),DOChatUserVO.getCommandUser("/leave"),this.chatModel.activeRoom.path));
         this.displayInternalChatMessage(new DOChatMessageVO("<font color=\'#FFFF00\'>/invite &#60;user&#62; </font>" + BPLocale.getItemInCategory("chat","dochat.help.invite"),DOChatUserVO.getCommandUser("/invite"),this.chatModel.activeRoom.path));
         this.displayInternalChatMessage(new DOChatMessageVO("<font color=\'#FFFF00\'>/w &#60;user&#62; </font>" + BPLocale.getItemInCategory("chat","dochat.help.whisper"),DOChatUserVO.getCommandUser("/w"),this.chatModel.activeRoom.path));
         this.displayInternalChatMessage(new DOChatMessageVO("<font color=\'#FFFF00\'>/ignore &#60;user&#62; </font>" + BPLocale.getItemInCategory("chat","dochat.help.ignore"),DOChatUserVO.getCommandUser("/ignore"),this.chatModel.activeRoom.path));
         this.displayInternalChatMessage(new DOChatMessageVO("<font color=\'#FFFF00\'>/allow &#60;user&#62; </font>" + BPLocale.getItemInCategory("chat","dochat.help.allow"),DOChatUserVO.getCommandUser("/allow"),this.chatModel.activeRoom.path));
         this.displayInternalChatMessage(new DOChatMessageVO("<font color=\'#FFFF00\'>/users </font>" + BPLocale.getItemInCategory("chat","dochat.help.users"),DOChatUserVO.getCommandUser("/users"),this.chatModel.activeRoom.path));
         this.displayInternalChatMessage(new DOChatMessageVO("<font color=\'#FFFF00\'>/report </font>" + BPLocale.getItemInCategory("chat","dochat.help.report"),DOChatUserVO.getCommandUser("/report"),this.chatModel.activeRoom.path));
      }
   }
}

