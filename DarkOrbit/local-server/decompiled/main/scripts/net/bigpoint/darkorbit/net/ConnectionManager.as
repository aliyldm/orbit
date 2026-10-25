package net.bigpoint.darkorbit.net
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.hurlant.math.BigInteger;
   import flash.events.Event;
   import flash.sampler.getSampleCount;
   import flash.system.Capabilities;
   import flash.system.System;
   import flash.utils.ByteArray;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.ChannelCloseRequest;
   import net.bigpoint.darkorbit.com.module.KeepAlive;
   import net.bigpoint.darkorbit.com.module.KillScreenRepairRequest;
   import net.bigpoint.darkorbit.com.module.LegacyModule;
   import net.bigpoint.darkorbit.com.module.LoginRequest;
   import net.bigpoint.darkorbit.com.module.ReadyRequest;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.com.module.VersionRequest;
   import net.bigpoint.darkorbit.comHash.VersionHash;
   import net.bigpoint.darkorbit.data.stats.PingStats;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.windows.components.Killscreen;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.BezierRocketEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.RocketEffect;
   import net.bigpoint.darkorbit.map.model.env.Station;
   import net.bigpoint.darkorbit.map.model.ship.ShipManager;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.application.model.ProfileProxy;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.global.notifications.GameNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.net.netty.DownstreamCompression;
   import net.bigpoint.darkorbit.net.netty.SocketManager;
   import net.bigpoint.darkorbit.net.netty.record.RequestRecorder;
   import net.bigpoint.darkorbit.pattern.RocketPattern;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.eventstream.EventStreamClient;
   
   public class ConnectionManager implements IFrameObserver
   {
      
      public static var REQUEST_MODE__REGULAR:uint = 1;
      
      public static var REQUEST_MODE__HANDSHAKE:uint = 2;
      
      public static var ATTRIBUTE_SEPERATOR:String = "|";
      
      public static var LIST_SEPERATOR:String = ",";
      
      public static var PARAM_1:String = "%!";
      
      public static var PARAM_2:String = "%2!";
      
      private static const LOGIN_WHITELIST_MODULE_IDS:Vector.<int> = new <int>[VersionRequest.instance.getLibcomModuleId(),LoginRequest.instance.getLibcomModuleId(),KillScreenRepairRequest.instance.getLibcomModuleId(),ChannelCloseRequest.instance.getLibcomModuleId()];
      
      private var lastConnectedServerIP:String;
      
      public var port:int = 5001;
      
      private var _main:Main;
      
      public var upcomingSpawns:Array = [];
      
      private var uiAssembly:UserInterfaceAssembly;
      
      private var attributesAssembly:SetAttributeAssembly;
      
      private var techAssembly:TechAssembly;
      
      private var boxCollectAssembly:BoxCollectResponseAssembly;
      
      private var rocketLauncherAssembly:RocketLauncherAssembly;
      
      private var skillsAssembly:SkillsAssembly;
      
      public var petAssembly:PetAssembly;
      
      private var _questAssembly:QuestAssembly;
      
      private var shipAssembly:ShipAssembly;
      
      private var combatAssembly:CombatAssembly;
      
      private var refinementAssembly:RefinementAssembly;
      
      private var mapEventsAssembly:MapEventsAssembly;
      
      private var _currentIPAddress:String;
      
      public var isMapLoaded:Boolean = false;
      
      public var isHeroLoaded:Boolean = false;
      
      private var _isLoggingGameServerIO:Boolean;
      
      private var _tpf:Number = 0;
      
      private var pingTime:Number = 0;
      
      private var pingTimerOn:Boolean = false;
      
      public var socketManager:SocketManager;
      
      private var gameFacade:GameFacade;
      
      private var privateKey:BigInteger;
      
      private var _commandQueue:Vector.<IModule> = new Vector.<IModule>();
      
      public const loginMode:BindableBoolean = new BindableBoolean();
      
      private var attackerID:int;
      
      private var targetID:int;
      
      private var posX:int;
      
      private var posY:int;
      
      private var hash:String;
      
      private var nextMapID:int;
      
      private var portalID:int;
      
      private var subCmd:String;
      
      private var ammoType:String;
      
      private var typeID:int;
      
      private var category:String;
      
      private var amount:int;
      
      private var currency:String;
      
      private var selectedConfiguration:int;
      
      private var plainMessage:String;
      
      public function ConnectionManager(param1:Main)
      {
         super();
         this._isLoggingGameServerIO = false;
         this._main = param1;
         this.gameFacade = GameFacade.getInstance();
         this.loginMode.changed.add(this.handleLoginModeChanged);
         this.initSocketManager();
         this.initAssemblies();
      }
      
      public static function log(param1:String) : void
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(param1));
      }
      
      public function disable() : void
      {
         if(this.socketManager)
         {
            this.socketManager.disable();
         }
      }
      
      private function initAssemblies() : void
      {
         this.uiAssembly = UserInterfaceAssembly.getInstance();
         this.rocketLauncherAssembly = RocketLauncherAssembly.getInstance();
         this.attributesAssembly = SetAttributeAssembly.getInstance();
         this.boxCollectAssembly = BoxCollectResponseAssembly.getInstance();
         this.boxCollectAssembly.setParams(PARAM_1,PARAM_2);
         this.petAssembly = PetAssembly.getInstance();
         this._questAssembly = new QuestAssembly();
         this._questAssembly.setMain(this._main);
         this.shipAssembly = new ShipAssembly();
         this.shipAssembly.setMain(this._main);
         this.combatAssembly = new CombatAssembly();
         this.combatAssembly.setMain(this._main);
         this.refinementAssembly = new RefinementAssembly();
         this.refinementAssembly.setMain(this._main);
         this.mapEventsAssembly = MapEventsAssembly.getInstance();
      }
      
      private function initSocketManager() : void
      {
         this.socketManager = new SocketManager();
         this.socketManager.addEventListener(SocketManager.CONNECTION_SUCCESS,this.handleGameServerConnect);
         this.socketManager.addEventListener(SocketManager.CONNECTION_LOST,this.handleConnectionLost);
         this.socketManager.addEventListener(SocketManager.CONNECTION_ERROR,this.handleGameServerConnectionError);
      }
      
      public function activatePingTick() : void
      {
         this.pingTimerOn = true;
         this.handlePingTick();
      }
      
      private function handlePingTick() : void
      {
         this.sendRequest(new KeepAlive());
         PingStats.instance.ping();
      }
      
      private function startConnectionMonitorTimer() : void
      {
         ScreenManager.addObserver(this);
      }
      
      private function stopConnectionMonitorTimer() : void
      {
         ScreenManager.removeObserver(this);
         this.pingTimerOn = true;
      }
      
      public function updateTimer(param1:Number) : void
      {
         this._tpf += param1;
         if(this._tpf > 499)
         {
            if(!this.socketManager.isConnected())
            {
               if(!Hero.isKilled)
               {
                  this._main.setScheduledDisconnect(false);
                  this._main.getGuiManager().showConnectionLostWindow();
                  this.stopConnectionMonitorTimer();
               }
            }
            this._tpf = 0;
         }
         if(this.pingTimerOn)
         {
            this.pingTime += param1;
            if(this.pingTime > PingStats.PING_INTERVAL)
            {
               this.handlePingTick();
               this.pingTime = 0;
            }
         }
      }
      
      public function connectToMap(param1:int) : void
      {
         var _loc2_:String = null;
         Settings.mapID = param1;
         this.uiAssembly = UserInterfaceAssembly.getInstance();
         if(Settings.defaultGameServer != null && Settings.useDefaultGameServer)
         {
            this.connect(Settings.defaultGameServer);
         }
         else
         {
            _loc2_ = Map.getServerIP(param1);
            this.connect(_loc2_);
         }
      }
      
      public function connect(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         this.stopConnectionMonitorTimer();
         if(param1 != this._currentIPAddress)
         {
            this.gameFacade.sendNotification(ConnectionNotifications.IP_CHANGED);
         }
         this._currentIPAddress = param1;
         this.lastConnectedServerIP = param1;
         if(param1 != null)
         {
            _loc3_ = param1.split(":");
            if(_loc3_.length == 2)
            {
               param1 = _loc3_[0];
               _loc2_ = int(_loc3_[1]);
            }
            this.loginMode.value = true;
            this._commandQueue.length = 0;
            this.socketManager.connect(param1,_loc2_ || this.port);
            return;
         }
         this.handleConnectionLost(null);
      }
      
      private function handleConnectionLost(param1:Event) : void
      {
         this.isHeroLoaded = false;
         this.gameFacade.forwardNotification(GameNotifications.CONNECTION_LOST,this._main.getScheduledDisconnect());
         if(!Hero.isKilled || Killscreen.getInstance().visibleStatus)
         {
            if(this._main.getScheduledDisconnect())
            {
               if(!this._main.userAskedForLogout)
               {
                  this.connectToMap(Settings.nextMapID);
               }
            }
            else
            {
               Settings.lastMapID = -1;
               this._main.getGuiManager().removeConnectionWindow();
               this._main.getGuiManager().showConnectionLostWindow();
            }
         }
         this.petAssembly.assemblePetDeactivation();
         var _loc2_:Map = this._main.screenManager.map;
         var _loc3_:ShipManager = _loc2_.getShipManager();
         if(Boolean(_loc2_.hero) && _loc2_.hero.pet != null)
         {
            _loc3_.removeShip(_loc2_.hero.pet.id);
         }
      }
      
      private function handleGameServerConnectionError(param1:Event = null) : void
      {
         if(this.socketManager.isConnected())
         {
            this._main.setScheduledDisconnect(false);
            this.handleConnectionLost(new Event(Event.CLOSE));
         }
      }
      
      public function getLastConnectedServerIP() : String
      {
         return this.lastConnectedServerIP;
      }
      
      public function handleLoginModeChanged() : void
      {
         var _loc1_:IModule = null;
         if(!this.loginMode.value)
         {
            while(this._commandQueue.length != 0)
            {
               _loc1_ = this._commandQueue.pop();
               this.sendRequest(_loc1_);
            }
            this.activatePingTick();
         }
      }
      
      public function dispatchLoginSucceed() : void
      {
         this.gameFacade.forwardNotification(GameNotifications.CONNECTION_SUCCESS);
      }
      
      public function filterAndSendLoginRequests(param1:IModule) : void
      {
         if(LOGIN_WHITELIST_MODULE_IDS.indexOf(param1.getLibcomModuleId()) != -1)
         {
            this.socketManager.sendMessage(param1);
         }
         else
         {
            this._commandQueue.unshift(param1);
         }
      }
      
      public function sendRequest(param1:IModule) : void
      {
         if(this.loginMode.value)
         {
            this.filterAndSendLoginRequests(param1);
         }
         else if(!Hero.isKilled || this.isCommandDeathRelated(param1.getLibcomModuleId()))
         {
            this.socketManager.sendMessage(param1);
            if(Settings.traceCom)
            {
               RequestRecorder.INSTANCE.record(param1);
            }
         }
      }
      
      private function isCommandDeathRelated(param1:int) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:Array = new Array(KillScreenRepairRequest.instance.getLibcomModuleId(),KeepAlive.instance.getLibcomModuleId(),ChannelCloseRequest.instance.getLibcomModuleId());
         for each(_loc3_ in _loc2_)
         {
            if(param1 == _loc3_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function sendCommand(param1:String, param2:Array = null) : String
      {
         if(!this.socketManager.isConnected())
         {
            return "";
         }
         var _loc3_:String = param1;
         if(param2 != null)
         {
            _loc3_ += ATTRIBUTE_SEPERATOR + param2.join(ATTRIBUTE_SEPERATOR);
         }
         this.sendRequest(this.getLegacyModuleMessage(_loc3_));
         return _loc3_;
      }
      
      public function sendRawCommand(param1:String) : void
      {
         if(!this.socketManager.isConnected())
         {
            return;
         }
         this.sendRequest(this.getLegacyModuleMessage(param1));
      }
      
      private function getLegacyModuleMessage(param1:String) : LegacyModule
      {
         var _loc2_:LegacyModule = new LegacyModule();
         _loc2_.message = param1;
         return _loc2_;
      }
      
      public function dispatchSpacemapLoaded() : void
      {
         var mapView:IMapView = null;
         var requestViewData:String = null;
         var obj:* = undefined;
         var stats:ByteArray = null;
         if(this.isHeroLoaded && this.isMapLoaded)
         {
            mapView = ScreenManager.getInstance().mapView;
            requestViewData = mapView.toString();
            try
            {
               obj = mapView;
               while(Boolean(obj.parent) && obj.parent != obj.stage)
               {
                  obj = obj.parent;
               }
               stats = obj.getData();
               stats.position = 0;
               stats.readInt();
               requestViewData += " " + stats.readUTF();
               requestViewData += " " + Capabilities.isDebugger;
               requestViewData += " " + getSampleCount();
            }
            catch(error:Error)
            {
               EventStreamClient.track("flash.error",{
                  "message":error.message,
                  "name":error.name,
                  "errorID":error.errorID,
                  "stackTrace":error.getStackTrace()
               });
            }
            this.sendMapLoadedRequest(requestViewData,mapView.readyRequestType);
            this.sendReadyUI(requestViewData);
            this.sendCommand(ServerCommands.LOGIN_FLAG,["w"]);
            if(Settings.displayNotifications.value || Settings.allowAutoQuality.value)
            {
               ProfileProxy(GameFacade.getInstance().retrieveProxy(ProfileProxy.NAME)).getProfiler().start();
            }
            this.gameFacade.forwardNotification(GameNotifications.HERO_INIT);
         }
      }
      
      public function sendReadyUI(param1:String) : void
      {
         var _loc2_:ReadyRequest = new ReadyRequest(param1,ReadyRequest.READYMESSAGE_UI_READY);
         this.sendRequest(_loc2_);
      }
      
      public function sendMapLoadedRequest(param1:String, param2:int = -1) : void
      {
         if(param2 < 0)
         {
            param2 = ReadyRequest.READYMESSAGE_MAP_LOADED_3D;
         }
         var _loc3_:ReadyRequest = new ReadyRequest(param1,param2);
         this.sendRequest(_loc3_);
         EventStreamClient.track("flash_client_usersettings",Settings.getCurrentSettingsTrackData());
      }
      
      public function handleGameServerConnect(param1:Event) : void
      {
         this.pingTimerOn = false;
         this.sendVersionRequest();
      }
      
      private function sendVersionRequest() : void
      {
         var _loc1_:VersionRequest = new VersionRequest(VersionHash.VERSION_HASH);
         this.sendRequest(_loc1_);
      }
      
      public function handleVersionResponse(param1:Boolean) : void
      {
         if(param1)
         {
            this.startConnectionMonitorTimer();
            this.sendLoginRequest();
         }
         else
         {
            this.handleGameServerConnectionError();
         }
      }
      
      public function sendLoginRequest() : void
      {
         var _loc1_:int = Settings.instanceID;
         var _loc2_:LoginRequest = new LoginRequest();
         _loc2_.userID = Hero.userID;
         _loc2_.factionID = Hero.factionID.value;
         _loc2_.sessionID = Hero.sessionID;
         while(_loc2_.sessionID.charAt(_loc2_.sessionID.length - 1) == " ")
         {
            _loc2_.sessionID = _loc2_.sessionID.slice(0,_loc2_.sessionID.length - 1);
         }
         _loc2_.version = DownstreamCompression.CAPABILITY;
         _loc2_.instanceId = _loc1_;
         _loc2_.isMiniClient = Settings.platform == Settings.platformTypeClient;
         this.sendRequest(_loc2_);
      }
      
      public function handleGameServerIOError(param1:Event) : void
      {
         param1.stopPropagation();
         this._main.setScheduledDisconnect(false);
         this.handleConnectionLost(new Event(Event.CLOSE));
      }
      
      public function onData(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Vector.<MapEntity> = null;
         var _loc11_:MapEntity = null;
         var _loc12_:MapEntity = null;
         var _loc13_:AttackerTrait = null;
         var _loc14_:MapEntity = null;
         var _loc15_:String = null;
         var _loc16_:uint = 0;
         _loc2_ = param1.split(ATTRIBUTE_SEPERATOR);
         switch(_loc2_[1])
         {
            case ServerCommands.PET:
               this.petAssembly.assembleCommand(_loc2_);
               break;
            case ServerCommands.ROCKET_ATTACK:
               this.attackerID = int(_loc2_[2]);
               this.targetID = int(_loc2_[3]);
               if(_loc2_[4] == "H")
               {
                  _loc3_ = true;
               }
               _loc4_ = int(_loc2_[5]);
               _loc5_ = int(_loc2_[6]);
               _loc6_ = Boolean(int(_loc2_[7]));
               if(this.map != null)
               {
                  _loc11_ = this.map.getEntityById(this.attackerID);
                  _loc12_ = this.map.getEntityById(this.targetID);
                  if(Boolean(_loc11_) && Boolean(_loc12_))
                  {
                     if(_loc4_ == RocketPattern.BEZIER)
                     {
                        this.map.effects.playEffect(new BezierRocketEffect(_loc11_,_loc12_,RocketPattern.R310,_loc3_,_loc5_,0,false,0,3,true));
                        _loc13_ = _loc11_.getFirstTrait(AttackerTrait) as AttackerTrait;
                        _loc13_.target = _loc12_.getFirstTrait(AttackTargetTrait) as AttackTargetTrait;
                     }
                     else
                     {
                        this.map.effects.playEffect(new RocketEffect(_loc11_,_loc12_,_loc4_,_loc3_,_loc5_,_loc6_));
                     }
                  }
               }
               break;
            case ServerCommands.TECHS:
               if(this.techAssembly == null)
               {
                  this.techAssembly = TechAssembly.getInstance();
               }
               this.techAssembly.assembleCommand(_loc2_);
               break;
            case ServerCommands.SKILL_DESIGNS:
               if(this.skillsAssembly == null)
               {
                  this.skillsAssembly = SkillsAssembly.getInstance();
               }
               this.skillsAssembly.assembleCommand(_loc2_);
               break;
            case ServerCommands.REMOVE_BOX:
               this.hash = _loc2_[2];
               if(this.map != null)
               {
                  this.map.removeEntityByHash(this.hash);
               }
               break;
            case ServerCommands.PLAY_PORTAL_ANIMATION:
               this._main.setScheduledDisconnect(true);
               this.nextMapID = int(_loc2_[2]);
               this.portalID = int(_loc2_[3]);
               Settings.nextMapID = this.nextMapID;
               AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_VOICE_ACTIVATE);
               this._main.getGuiManager().lockWindow(GuiConstants.LOGOUT_WINDOW);
               break;
            case ClientCommands.SELECT:
               this.subCmd = _loc2_[2];
               switch(this.subCmd)
               {
                  case ClientCommands.CONFIGURATION:
                     this.selectedConfiguration = int(_loc2_[3]);
                     Settings.selectedConfiguration = this.selectedConfiguration;
                     this._main.getGuiManager().updateInfoField(GuiConstants.SHIP_WINDOW,SimpleContainer.CONTAINER_CLASS_HERO_INFO_0,SimpleElement.TYPE_CONFIGURATION);
               }
               break;
            case ServerCommands.PORTAL_JUMP:
               this.portalJump(int(_loc2_[2]));
               break;
            case ServerCommands.BOX_COLLECT_RESPONSE:
            case ServerCommands.LOG_MESSAGE:
               this.boxCollectAssembly.assembleBoxCollectResponse(_loc2_);
               break;
            case ServerCommands.SET_ATTRIBUTE:
               this.attributesAssembly.assembleCommand(_loc2_);
               break;
            case ServerCommands.QUESTFM_INFO:
               this._questAssembly.assembleCommand(_loc2_);
               break;
            case ServerCommands.NO_AMMUNITION:
               this.ammoType = _loc2_[2];
               _loc7_ = int(_loc2_[4]);
               this._main.getGuiManager().noAmmunition(this.ammoType,_loc7_);
               break;
            case ServerCommands.AUTO_AMMUNITION_CHANGE:
               this.ammoType = _loc2_[2];
               _loc8_ = int(_loc2_[4]);
               break;
            case ServerCommands.NEW_MAP:
            case ServerCommands.SET_MAP_PVP_STATUS:
            case ServerCommands.CREATE_STATION:
               break;
            case ServerCommands.CHANGE_HEALTH_STATION_STATUS:
               _loc9_ = Boolean(int(_loc2_[2]));
               _loc10_ = this.map.getEntityByType(Station);
               for each(_loc14_ in _loc10_)
               {
                  Station(_loc14_).isEnabled = _loc9_;
               }
               break;
            case ServerCommands.CARGO_FULL:
               log(BPLocale.getItem("loadfull"));
               if(Settings.JS_EVENT_TRACKING_ENABLED)
               {
                  JavascriptProxy.call(JavascriptProxy.FUNCTION_CLIENT_EVENT,[JavascriptProxy.CARGO_FULL]);
               }
               break;
            case ServerCommands.RESOURCE_DISABLED:
               log(BPLocale.getItem("resourcedisabled"));
               break;
            case ServerCommands.REMOVE_ORE:
               this.hash = _loc2_[2];
               this.map.removeEntityByHash(this.hash);
               break;
            case ServerCommands.MAP_EVENT:
               if(this.mapEventsAssembly == null)
               {
                  this.mapEventsAssembly = MapEventsAssembly.getInstance();
               }
               this.mapEventsAssembly.assembleCommand(_loc2_);
               break;
            case ServerCommands.LOGOUT:
               this._main.userAskedForLogout = true;
               this._main.setScheduledDisconnect(true);
               JavascriptProxy.call(JavascriptProxy.FUNCTION_BP_CLOSE_WINDOW,[""],System.exit,[0]);
               break;
            case ServerCommands.LOGOUT_CANCEL_FROM_SERVER:
               this._main.getGuiManager().logoutCancelFromServer();
               break;
            case ServerCommands.BUY:
               switch(_loc2_[2])
               {
                  case ServerCommands.BUY_SUCCESS:
                     this.category = _loc2_[3];
                     _loc15_ = TextUtils.getTranslationByType(String(_loc2_[4]),ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_SHORT);
                     this.amount = int(_loc2_[5]);
                     if(this.category == "b")
                     {
                        log(BPLocale.getItem("bought_bat").replace("%TYPE%",_loc15_).replace("%COUNT%",TextFormatter.roundInteger(this.amount)));
                     }
                     else if(this.category == "r")
                     {
                        log(BPLocale.getItem("bought_rok").replace("%TYPE%",_loc15_).replace("%COUNT%",TextFormatter.roundInteger(this.amount)));
                     }
                     break;
                  case ServerCommands.BUY_FAILED:
                     switch(_loc2_[3])
                     {
                        case ServerCommands.BUY_FAILED_NO_MONEY:
                           this.currency = _loc2_[4];
                           if(this.currency == "U")
                           {
                              log(BPLocale.getItem("ammobuy_fail_uri"));
                           }
                           else if(this.currency == "C")
                           {
                              log(BPLocale.getItem("ammobuy_fail_cre"));
                           }
                           break;
                        case ServerCommands.BUY_FAILED_NO_CARGO:
                           log(BPLocale.getItem("ammobuy_fail_space"));
                     }
               }
               break;
            case ServerCommands.CLIENT_SETTING:
               GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_COMMAND,[ServerCommands.ADVANCED_JUMP_CPU,[ServerCommands.GET]]);
               break;
            case ServerCommands.JUMP_FAILED:
               this.plainMessage = BPLocale.getItem("jumplevelfalse").replace(/%!/,_loc2_[2]);
               log(this.plainMessage);
               AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_VOICE_ACCESS_DENIED);
               break;
            case ServerCommands.USER_INTERFACE:
               this.uiAssembly.assembleCommand(_loc2_);
               break;
            case ServerCommands.ROCKETLAUNCHER:
               this.rocketLauncherAssembly.assembleCommand(_loc2_);
               break;
            case ServerCommands.CHANGE_MAP:
               this.handleServerChanged();
         }
         switch(_loc2_[0])
         {
            case ServerCommands.ERROR:
               _loc16_ = uint(int(_loc2_[1]));
               switch(_loc16_)
               {
                  case ServerCommands.LOGIN_FAILED:
                     this.handleGameServerConnectionError();
                     break;
                  case ServerCommands.NOT_LOGGED_IN:
                     this._main.setScheduledDisconnect(true);
                     this._main.getGuiManager().removeConnectionWindow();
                     GameFacade.getInstance().sendNotification(GuiNotifications.SHOW_MESSAGE_SMALL,new MessageCommandParams("notloggedin"));
                     break;
                  case ServerCommands.DOUBLE_LOGGED_IN:
                     this._main.setScheduledDisconnect(true);
                     this._main.getGuiManager().removeConnectionWindow();
                     GameFacade.getInstance().sendNotification(GuiNotifications.SHOW_MESSAGE_SMALL,new MessageCommandParams("doubleloggedin"));
                     break;
                  case ServerCommands.INVALID_SESSION:
                  case ServerCommands.LOGIN_CHECK_FAILED:
                  case ServerCommands.TWICE_LOGGED:
               }
               break;
            case ServerCommands.KICKED:
         }
      }
      
      public function portalJump(param1:int) : void
      {
         var _loc2_:ChannelCloseRequest = new ChannelCloseRequest();
         _loc2_.close = true;
         this.sendRequest(_loc2_);
         this._main.setScheduledDisconnect(true);
         Settings.nextMapID = param1;
      }
      
      public function handleServerChanged() : void
      {
         this.isHeroLoaded = false;
         this.isMapLoaded = false;
      }
      
      public function get isLoggingGameServerIO() : Boolean
      {
         return this._isLoggingGameServerIO;
      }
      
      public function set isLoggingGameServerIO(param1:Boolean) : void
      {
         this._isLoggingGameServerIO = param1;
         if(this._isLoggingGameServerIO)
         {
         }
      }
      
      public function getAndDeletePrivateKey() : BigInteger
      {
         var _loc1_:BigInteger = this.privateKey;
         this.privateKey = null;
         return _loc1_;
      }
      
      public function getMapEventsAssembly() : MapEventsAssembly
      {
         return this.mapEventsAssembly;
      }
      
      public function getRefinementAssembly() : RefinementAssembly
      {
         return this.refinementAssembly;
      }
      
      public function getShipAssembly() : ShipAssembly
      {
         return this.shipAssembly;
      }
      
      public function getPetAssembly() : PetAssembly
      {
         return this.petAssembly;
      }
      
      public function getCombatAssembly() : CombatAssembly
      {
         return this.combatAssembly;
      }
      
      public function getAttributeAssembly() : SetAttributeAssembly
      {
         return this.attributesAssembly;
      }
      
      public function getBoxCollectAssembly() : BoxCollectResponseAssembly
      {
         return this.boxCollectAssembly;
      }
      
      public function get questAssembly() : QuestAssembly
      {
         return this._questAssembly;
      }
      
      private function get map() : Map
      {
         return ScreenManager.getInstance().map;
      }
      
      public function get currentIPAddress() : String
      {
         return this._currentIPAddress;
      }
   }
}

