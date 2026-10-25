package net.bigpoint.darkorbit.mvc.chatclient.model.backend
{
   import Infinicast.Client.Api.Errors.ICError;
   import Infinicast.Client.Api.IEndpoint;
   import Infinicast.Client.Api.IInfinicastClient;
   import Infinicast.Client.Api.IPath;
   import Infinicast.Client.Api.Paths.IAPathContext;
   import Infinicast.Client.Api.Paths.IPathAndEndpointContext;
   import Infinicast.Client.Impl.Contexts.APathContext;
   import Infinicast.Client.Impl.InfinicastClient;
   import Infinicast.Client.Impl.PathAccess.IEndpointAndData;
   import Infinicast.ICErrorType;
   import Infinicast.Runtime.NotImplementedException;
   
   public class AChatGameClientConnector implements IAChatGameClientConnector
   {
      
      private static const MINS_TO_MILIS_FACTOR:int = 60000;
      
      private var gameName:String;
      
      private var infinicastClient:IInfinicastClient = new InfinicastClient();
      
      private var joinedRoomsByType:Object = {};
      
      private var joinedRoomsTypeByPath:Object = {};
      
      private var wordFilterEngine:WordFilterEngine = new WordFilterEngine();
      
      private var onEndpointIdChange:Function = null;
      
      private var onSystemDefinedRoomChange:Function = null;
      
      private var onServerStatusInfo:Function = null;
      
      private var onChatMessage:Function = null;
      
      private var onChatMessageError:Function = null;
      
      private var onWhisperFunc:Function = null;
      
      private var unhandeledErrorFunc:Function = null;
      
      private var onRoomListeningRemovedByServer:Function = null;
      
      private var whisperId:String = null;
      
      private var onReceiveInvite:Function;
      
      private var onConnectionStatusChanged:Function;
      
      private var onBan:Function;
      
      private var _currentState:Object;
      
      public function AChatGameClientConnector(param1:String)
      {
         super();
         this.gameName = param1;
      }
      
      public static function encodeString(param1:String) : String
      {
         return param1.replace(/\//g,"&#47;").replace(/\*/g,"&#42;");
      }
      
      public function setWhisperId(param1:String) : void
      {
         this.whisperId = encodeString(param1);
      }
      
      public function setUnhandeledErrorFunc(param1:Function) : void
      {
         this.unhandeledErrorFunc = param1;
      }
      
      public function setOnBanFunc(param1:Function) : void
      {
         this.onBan = param1;
      }
      
      public function getRoomPath(param1:String, param2:String) : String
      {
         return "/room/" + param1 + "/" + param2 + "/";
      }
      
      public function resetRooms(param1:String) : void
      {
         var _loc2_:String = this.joinedRoomsTypeByPath[param1];
         if(_loc2_)
         {
            if(this.joinedRoomsByType[_loc2_] == param1)
            {
               this.joinedRoomsByType[_loc2_] = null;
            }
         }
         this.joinedRoomsTypeByPath[param1] = null;
      }
      
      public function connect(param1:String, param2:String, param3:String) : void
      {
         var address:String = param1;
         var space:String = param2;
         var connectRole:String = param3;
         try
         {
            this.infinicastClient.disconnect();
         }
         catch(e:Error)
         {
         }
         this.reset();
         this.infinicastClient.onDisconnect(function():void
         {
            _currentState = null;
            triggerConnectionStatusChange(AChatConnectionStatus.Disconnected);
         });
         this.triggerConnectionStatusChange(AChatConnectionStatus.Connecting);
         this.infinicastClient.connect(address,space,connectRole,function(param1:ICError):void
         {
            if(param1 == null)
            {
               triggerConnectionStatusChange(AChatConnectionStatus.LoggingIn);
               registerHandlersAfterConnect();
            }
            else
            {
               triggerConnectionStatusChange(AChatConnectionStatus.Failed);
               triggerUnhandeledError(param1);
            }
         });
      }
      
      public function disconnect() : void
      {
         this._currentState = null;
         this.infinicastClient.disconnect();
      }
      
      public function setOnEndpointIdChange(param1:Function) : void
      {
         this.onEndpointIdChange = param1;
      }
      
      public function setOnConnectionStatusChange(param1:Function) : void
      {
         this.onConnectionStatusChanged = param1;
      }
      
      public function setOnSystemDefinedRoomChange(param1:Function) : void
      {
         this.onSystemDefinedRoomChange = param1;
      }
      
      public function setOnServerStatusInfo(param1:Function) : void
      {
         this.onServerStatusInfo = param1;
      }
      
      public function setOnChatMessage(param1:Function, param2:Function = null) : void
      {
         this.onChatMessage = param1;
         this.onChatMessageError = param2;
      }
      
      public function setOnWhisper(param1:Function) : void
      {
         this.onWhisperFunc = param1;
      }
      
      public function sendChatMessageToRoomPath(param1:String, param2:String, param3:Function) : void
      {
         var roomPath:String = param1;
         var message:String = param2;
         var onFinishSending:Function = param3;
         var json:Object = {"msg":message};
         this.infinicastClient.path(roomPath).sendMessage(json,function(param1:ICError):void
         {
            if(onFinishSending != null)
            {
               onFinishSending(param1);
            }
         });
      }
      
      public function sendChatMessageToRoomType(param1:String, param2:String, param3:Function) : void
      {
         throw new NotImplementedException("this message is not implemented. Please use sendChatMessageToRoomPath");
      }
      
      public function sendWhisper(param1:String, param2:String, param3:Function) : void
      {
         var targetWhisperId:String = param1;
         var message:String = param2;
         var onFinishSendingFunc:Function = param3;
         this.infinicastClient.path("/whisper/" + encodeString(targetWhisperId) + "/").sendMessage({"msg":message},function(param1:ICError):void
         {
            if(onFinishSendingFunc != null)
            {
               if(param1 != null)
               {
                  onFinishSendingFunc(param1);
               }
               else
               {
                  onFinishSendingFunc(null);
               }
            }
         });
      }
      
      public function sendReportToRoomPath(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:Function) : void
      {
         var roomPath:String = param1;
         var userID:String = param2;
         var targetGlobalId:String = param3;
         var reasonKey:String = param4;
         var reason:String = param5;
         var message:String = param6;
         var onFinishSendingFunc:Function = param7;
         var json:Object = {};
         json["targetUserId"] = userID;
         json["targetGlobalId"] = targetGlobalId;
         json["reason"] = reason;
         json["reasonKey"] = reasonKey;
         json["message"] = message;
         this.infinicastClient.path(roomPath + "/reportUser").sendRequest(json,function(param1:ICError, ... rest):void
         {
            if(onFinishSendingFunc != null)
            {
               onFinishSendingFunc(param1);
            }
         });
      }
      
      public function getUserListByRoomType(param1:String, param2:Function) : void
      {
         if(param1)
         {
            this.getUserListByRoomPath(param1,param2);
         }
         else
         {
            param2(this.createCustomICError(AChatErrors.roomTypeNotExisting,param1),null);
         }
      }
      
      public function getUserListByRoomPath(param1:String, param2:Function) : void
      {
         var roomPath:String = param1;
         var onResult:Function = param2;
         this.infinicastClient.path(roomPath).listeners.filterRole("chatter").toList(function(param1:ICError, param2:Vector.<IEndpointAndData>, param3:APathContext):void
         {
            var _loc4_:Array = null;
            var _loc5_:IEndpointAndData = null;
            if(param1 == null)
            {
               _loc4_ = [];
               for each(_loc5_ in param2)
               {
                  _loc4_.push({
                     "endpointId":_loc5_.endpoint.id,
                     "endpointData":_loc5_.data
                  });
               }
               onResult(roomPath,_loc4_);
            }
            else
            {
               onResult(roomPath,null,param1);
            }
         });
      }
      
      public function setOnReceiveUserRoomInvite(param1:Function) : void
      {
         this.onReceiveInvite = param1;
      }
      
      public function createUserRoom(param1:String, param2:Function) : void
      {
         var roomName:String = param1;
         var onResult:Function = param2;
         this.infinicastClient.path("/roomSvc/usr/createRoom/").sendRequest({"roomName":roomName},function(param1:ICError, param2:Object, param3:*):void
         {
            handleRequestAnswer(param1,onResult,param2);
         });
      }
      
      public function acceptUserRoomInvite(param1:String, param2:Function) : void
      {
         var uniqueRoomName:String = param1;
         var onResult:Function = param2;
         this.infinicastClient.path("/roomSvc/usr/acceptInvite/").sendRequest({"roomName":uniqueRoomName},function(param1:ICError, param2:Object, param3:*):void
         {
            handleRequestAnswer(param1,onResult,param2);
         });
      }
      
      public function inviteChatterToUserRoom(param1:String, param2:String, param3:Function) : void
      {
         var uniqueRoomName:String = param1;
         var toBeAddedWhisperId:String = param2;
         var onResult:Function = param3;
         this.infinicastClient.path("/roomSvc/usr/inviteUser/").sendRequest({
            "roomName":uniqueRoomName,
            "whisperId":toBeAddedWhisperId
         },function(param1:ICError, param2:Object, param3:*):void
         {
            handleRequestAnswer(param1,onResult,param2);
         });
      }
      
      public function removeChatterFromUserRoom(param1:String, param2:String, param3:Function) : void
      {
         var uniqueRoomName:String = param1;
         var toBeRemovedWhisperId:String = param2;
         var onResult:Function = param3;
         this.infinicastClient.path("/roomSvc/usr/removeUser/").sendRequest({
            "roomName":uniqueRoomName,
            "whisperId":toBeRemovedWhisperId
         },function(param1:ICError, param2:Object, param3:*):void
         {
            handleRequestAnswer(param1,onResult,param2);
         });
      }
      
      public function closeUserRoom(param1:String, param2:Function) : void
      {
         var uniqueRoomName:String = param1;
         var onResult:Function = param2;
         this.infinicastClient.path("/roomSvc/usr/close/").sendRequest({"roomName":uniqueRoomName},function(param1:ICError, param2:Object, param3:*):void
         {
            handleRequestAnswer(param1,onResult,param2);
         });
      }
      
      public function setOnRoomListeningRemovedByServer(param1:Function) : void
      {
         this.onRoomListeningRemovedByServer = param1;
      }
      
      public function getInfinicast() : IInfinicastClient
      {
         return this.infinicastClient;
      }
      
      private function callEndpointIdChange() : void
      {
         if(this.onEndpointIdChange != null)
         {
            this.onEndpointIdChange(this.infinicastClient.getOwnEndpoint().endpointId);
         }
      }
      
      private function registerHandlersAfterConnect() : void
      {
         var serverStatusRegistered:Boolean = false;
         var changePredefinedRoomRegistered:Boolean = false;
         serverStatusRegistered = false;
         changePredefinedRoomRegistered = false;
         this.infinicastClient.getOwnEndpoint().path("serverStatus").onMessage(function(param1:Object, param2:*):void
         {
            var banDate:Date = null;
            var time2:Number = NaN;
            var endpointId:String = null;
            var json:Object = param1;
            var context:* = param2;
            if(json)
            {
               if(_currentState == json.type)
               {
                  return;
               }
               if(json.type == "loggedIn")
               {
                  wordFilterEngine.loadFromJsonArray(json.wordFilter);
                  triggerConnectionStatusChange(AChatConnectionStatus.LoggedIn);
                  if(whisperId != null)
                  {
                     infinicastClient.path("/whisper/" + whisperId + "/").onMessage(function(param1:Object, param2:IPathAndEndpointContext):void
                     {
                        var _loc3_:String = null;
                        var _loc4_:Number = NaN;
                        if(onWhisperFunc != null)
                        {
                           _loc3_ = "";
                           if(param1.msg)
                           {
                              _loc3_ = param1.msg;
                           }
                           _loc4_ = NaN;
                           if(param1.sentAt != null)
                           {
                              _loc4_ = Number(param1.sentAt);
                           }
                           _loc3_ = wordFilterEngine.applyWordFilter(_loc3_);
                           onWhisperFunc(_loc3_,param2.endpointData.userId,param2.endpointData,_loc4_);
                        }
                        else
                        {
                           triggerNoHandlerDefinedError("onWhisperFunc");
                        }
                     },function(param1:ICError):void
                     {
                        if(param1 != null)
                        {
                           triggerUnhandeledError(param1);
                        }
                     });
                     infinicastClient.path("/userRoomInvite/" + whisperId + "/").onMessage(function(param1:Object, param2:*):void
                     {
                        if(onReceiveInvite != null)
                        {
                           onReceiveInvite(param1["roomName"],param1["invitingUserData"]);
                        }
                        else
                        {
                           triggerNoHandlerDefinedError("onReceiveInvite");
                        }
                     },function(param1:ICError):void
                     {
                        if(param1 != null)
                        {
                           triggerUnhandeledError(param1);
                        }
                     });
                  }
                  else
                  {
                     triggerUnhandeledError(ICError.create(ICErrorType.InternalError,"no whisperId set,whisper and userRoomInvites will not work ",""));
                  }
               }
               else if(json.type == "banned")
               {
                  triggerConnectionStatusChange(AChatConnectionStatus.Banned);
                  if(onBan != null)
                  {
                     banDate = new Date();
                     time2 = banDate.time + json.remaining * MINS_TO_MILIS_FACTOR;
                     banDate.time = time2;
                     onBan(json.reason,banDate);
                  }
               }
               if(onServerStatusInfo != null)
               {
                  endpointId = infinicastClient.getOwnEndpoint().endpointId;
                  onServerStatusInfo(json,endpointId);
               }
               _currentState = json.type;
            }
         },function(param1:ICError):void
         {
            if(param1 != null)
            {
               triggerUnhandeledError(param1,onChatMessageError);
            }
            else
            {
               serverStatusRegistered = true;
               if(changePredefinedRoomRegistered && serverStatusRegistered)
               {
                  callEndpointIdChange();
               }
            }
         });
         this.infinicastClient.getOwnEndpoint().path("changePredefinedRoom").onMessage(function(param1:Object, param2:*):void
         {
            var _loc3_:String = null;
            var _loc4_:String = null;
            var _loc5_:String = null;
            var _loc6_:String = null;
            if(param1)
            {
               _loc3_ = param1.roomType;
               _loc4_ = param1.newRoomName;
               _loc5_ = param1.roomClass;
               _loc6_ = getRoomPath(_loc5_,_loc4_);
               if(updateJoinedRoomCacheAndReturnIfRequiresListen(_loc3_,_loc6_))
               {
                  listenOnRoom(_loc3_,_loc5_,_loc4_);
                  if(onSystemDefinedRoomChange != null)
                  {
                     onSystemDefinedRoomChange(_loc3_,_loc4_,_loc6_);
                  }
                  else
                  {
                     triggerNoHandlerDefinedError("onSystemDefinedRoomChange");
                  }
               }
            }
            else
            {
               triggerUnhandeledError(ICError.create(ICErrorType.InternalError,"unknown changePredefinedRoom message","",null));
            }
         },function(param1:ICError):void
         {
            if(param1 != null)
            {
               triggerUnhandeledError(param1);
            }
            else
            {
               changePredefinedRoomRegistered = true;
               if(changePredefinedRoomRegistered && serverStatusRegistered)
               {
                  callEndpointIdChange();
               }
            }
         });
      }
      
      private function updateJoinedRoomCacheAndReturnIfRequiresListen(param1:String, param2:String) : Boolean
      {
         var roomType:String = param1;
         var roomPath:String = param2;
         var doJoin:Boolean = true;
         if(roomType)
         {
            if(this.joinedRoomsByType[roomType] == roomPath)
            {
               doJoin = false;
            }
            else if(this.joinedRoomsByType[roomType])
            {
               this.infinicastClient.path(this.joinedRoomsByType[roomType]).onMessage(null,function():void
               {
               });
            }
            this.joinedRoomsByType[roomType] = roomPath;
            this.joinedRoomsTypeByPath[roomPath] = roomType;
         }
         else
         {
            if(this.joinedRoomsTypeByPath[roomPath] != undefined && this.joinedRoomsTypeByPath[roomPath] != null)
            {
               doJoin = false;
            }
            this.joinedRoomsTypeByPath[roomPath] = "";
         }
         return doJoin;
      }
      
      private function triggerConnectionStatusChange(param1:int) : void
      {
         if(this.onConnectionStatusChanged != null)
         {
            this.onConnectionStatusChanged(param1);
         }
      }
      
      private function listenOnRoom(param1:String, param2:String, param3:String) : void
      {
         var roomAddress:String = null;
         var roomPath:IPath = null;
         var roomType:String = param1;
         var roomClass:String = param2;
         var roomName:String = param3;
         roomAddress = this.getRoomPath(roomClass,roomName);
         roomPath = this.infinicastClient.path(roomAddress);
         roomPath.onMessage(null,function():void
         {
            roomPath.onMessage(function(param1:Object, param2:IPathAndEndpointContext):void
            {
               var _loc11_:String = null;
               var _loc12_:String = null;
               var _loc3_:String = param1.msg;
               var _loc4_:* = param2.endpointData;
               var _loc5_:String = "";
               var _loc6_:IEndpoint = param2.endpoint;
               var _loc7_:String = "";
               var _loc8_:String = "chatter";
               var _loc9_:String = "";
               var _loc10_:String = "";
               var _loc13_:String = null;
               var _loc14_:Number = NaN;
               var _loc15_:Number = NaN;
               if(_loc4_)
               {
                  _loc12_ = _loc4_.globalId;
                  _loc9_ = _loc4_.userId;
                  _loc10_ = _loc4_.id;
                  if(_loc4_.factionId != null)
                  {
                     _loc13_ = String(_loc4_.factionId);
                  }
                  if(_loc4_.role)
                  {
                     _loc8_ = _loc4_.role;
                  }
                  if(_loc4_.clanTag)
                  {
                     _loc11_ = _loc4_.clanTag;
                  }
               }
               else
               {
                  triggerUnhandeledAChatError(AChatErrors.invalidMessageReceived,"no endpointdata for object in onMessage");
               }
               if(param1.muteUntil != null)
               {
                  _loc14_ = Number(param1.muteUntil);
               }
               if(param1.sentAt != null)
               {
                  _loc15_ = Number(param1.sentAt);
               }
               var _loc16_:String = "";
               if(_loc3_)
               {
                  _loc16_ = _loc3_;
               }
               if(_loc6_)
               {
                  _loc7_ = _loc6_.endpointId;
               }
               else
               {
                  triggerUnhandeledAChatError(AChatErrors.invalidMessageReceived,"no endpoint in onMessage");
               }
               if(onChatMessage != null)
               {
                  onChatMessage(roomAddress,_loc9_,wordFilterEngine.applyWordFilter(_loc16_),_loc8_,_loc11_,_loc12_,_loc10_,_loc13_,_loc14_,_loc15_);
               }
               else
               {
                  triggerNoHandlerDefinedError("onChatMessage");
               }
            },function(param1:ICError):void
            {
               if(param1 != null)
               {
                  triggerUnhandeledError(param1,onChatMessageError);
               }
            },function(param1:int, param2:IAPathContext):void
            {
               var _loc3_:String = joinedRoomsTypeByPath[roomAddress];
               if(_loc3_)
               {
                  if(joinedRoomsByType[_loc3_] == roomAddress)
                  {
                     joinedRoomsByType[_loc3_] = null;
                  }
               }
               joinedRoomsTypeByPath[roomAddress] = null;
               if(onRoomListeningRemovedByServer != null)
               {
                  onRoomListeningRemovedByServer(roomAddress);
               }
            });
         });
      }
      
      private function reset() : void
      {
         this.joinedRoomsByType = {};
         this.joinedRoomsTypeByPath = {};
      }
      
      private function handleRequestAnswer(param1:ICError, param2:Function, param3:Object) : void
      {
         if(!param1)
         {
            if(param3["success"] == true)
            {
               param2(null);
            }
            else
            {
               param2(param1);
            }
         }
         else
         {
            param2(param1);
         }
      }
      
      private function triggerNoHandlerDefinedError(param1:String) : void
      {
         this.triggerUnhandeledError(ICError.create(ICErrorType.InternalError,"no handler defined " + param1,"",null));
      }
      
      private function createCustomICError(param1:int, param2:String) : *
      {
         return ICError.create(ICErrorType.Custom,param2,"",{"errorCode":param1});
      }
      
      private function triggerUnhandeledAChatError(param1:int, param2:String) : void
      {
         this.triggerUnhandeledError(this.createCustomICError(param1,param2));
      }
      
      private function triggerUnhandeledError(param1:ICError, param2:Function = null) : void
      {
         if(param2 != null)
         {
            param2(param1);
         }
         else if(this.unhandeledErrorFunc != null)
         {
            this.unhandeledErrorFunc(param1);
         }
      }
   }
}

