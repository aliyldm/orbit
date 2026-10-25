package Infinicast.Client.Impl
{
   import Infinicast.*;
   import Infinicast.Client.Api.*;
   import Infinicast.Client.Api.Errors.*;
   import Infinicast.Client.Api.Paths.*;
   import Infinicast.Client.Api.Paths.Handler.*;
   import Infinicast.Client.Api.Paths.Handler.Lists.*;
   import Infinicast.Client.Api.Paths.Handler.Messages.*;
   import Infinicast.Client.Api.Paths.Handler.Objects.*;
   import Infinicast.Client.Api.Paths.Handler.Reminders.*;
   import Infinicast.Client.Api.Paths.Handler.Requests.*;
   import Infinicast.Client.Api.Paths.Options.*;
   import Infinicast.Client.Api.Paths.TaskObjects.*;
   import Infinicast.Client.Api.Query.*;
   import Infinicast.Client.Impl.Contexts.*;
   import Infinicast.Client.Impl.Helper.*;
   import Infinicast.Client.Impl.Messaging.*;
   import Infinicast.Client.Impl.Messaging.Handlers.*;
   import Infinicast.Client.Impl.Messaging.Receiver.*;
   import Infinicast.Client.Impl.Messaging.sender.*;
   import Infinicast.Client.Impl.ObjectState.*;
   import Infinicast.Client.Impl.PathAccess.*;
   import Infinicast.Client.Impl.Query.*;
   import Infinicast.Client.Impl.Responder.*;
   import Infinicast.Client.Protocol.*;
   import Infinicast.Client.Protocol.Messages.*;
   import Infinicast.Client.Utils.*;
   import Infinicast.Runtime.*;
   
   public class InfinicastClient extends PathImpl implements IPath, IInfinicastClient, IConnector
   {
      
      private var _endpoint2ServerNetLayer:IEndpoint2ServerNetLayer;
      
      private var _objectStateManager:ObjectStateManager;
      
      private var _role:String = "";
      
      private var _space:String = "";
      
      private var _thisEndpoint:Endpoint;
      
      private var _credentials:* = null;
      
      private var _ClientLogger:Logger = LoggerFactory.getLogger("InfinicastClient");
      
      private var _onConnect:Function;
      
      private var _onDisconnect:Function;
      
      private var _unhandeledErrorHandler:Function;
      
      private var _disconnectManager:DisconnectManager;
      
      public function InfinicastClient()
      {
         super("");
         this._ClientLogger.info("Infinicast Client " + VersionHelper.clientVersion);
         Connector2EpsMessageTypeConverter.init();
         Eps2ConnectorMessageTypeConverter.init();
      }
      
      private function setCredentials(param1:*) : void
      {
         this._credentials = param1;
      }
      
      public function connectWithCredentials(param1:String, param2:String, param3:String, param4:*, param5:Function) : void
      {
         var connector:InfinicastClient = null;
         var e2SNetLayer:TcpEndpoint2ServerNetLayer = null;
         var netSettings:Endpoint2ServerNetSettings = null;
         var result:String = null;
         var address:String = param1;
         var space:String = param2;
         var connectRole:String = param3;
         var credentials:* = param4;
         var onConnect_:Function = param5;
         this.init();
         try
         {
            this._onConnect = onConnect_;
            connector = this;
            e2SNetLayer = new TcpEndpoint2ServerNetLayer();
            netSettings = new Endpoint2ServerNetSettings();
            netSettings.ServerAddress = NetFactory.createServerAddress(address);
            connector.setSpace(space);
            connector.setRole(connectRole);
            connector.setCredentials(credentials);
            netSettings.Handler = super.messageManager;
            this._endpoint2ServerNetLayer = e2SNetLayer;
            super.messageManager.setSender(new MessageSender(e2SNetLayer));
            super.messageManager.setConnector(this);
            result = e2SNetLayer.Open(netSettings);
            if(!StringExtensions.IsNullOrEmpty(result))
            {
               onConnect_(ICError.create(6,result,""));
            }
         }
         catch(e:Error)
         {
            this._onConnect(ICError.fromException(e,""));
         }
      }
      
      public function connect(param1:String, param2:String, param3:String, param4:Function) : void
      {
         this.connectWithCredentials(param1,param2,param3,null,param4);
      }
      
      public function onDisconnect(param1:Function) : void
      {
         this._onDisconnect = param1;
      }
      
      public function disconnect() : void
      {
         this.whenDisconnected();
      }
      
      private function whenDisconnected() : void
      {
         var _loc1_:DisconnectManager = this._disconnectManager;
         if(_loc1_ != null)
         {
            _loc1_.StopDisconnectChecker();
            this._disconnectManager = null;
         }
         super.messageManager.destroy();
         this._credentials = null;
         this._thisEndpoint = null;
         var _loc2_:IEndpoint2ServerNetLayer = this._endpoint2ServerNetLayer;
         if(_loc2_ != null)
         {
            _loc2_.Close();
            this._endpoint2ServerNetLayer = null;
         }
      }
      
      public function getOwnEndpoint() : IEndpoint
      {
         return this._thisEndpoint;
      }
      
      public function getEndpointById(param1:String) : IEndpoint
      {
         var _loc2_:String = PathUtils.getEndpointPath(param1);
         return new Endpoint(_loc2_,param1,this);
      }
      
      public function getEndpointByPath(param1:IPath) : IEndpoint
      {
         var _loc2_:String = param1.toString();
         if(!StringUtils.startsWith(_loc2_,"/~endpoints/"))
         {
            throw new Error("not a valid Endpoint path!");
         }
         var _loc3_:String = _loc2_.substr(12);
         _loc3_ = StringUtils.remove(_loc3_,_loc3_.lastIndexOf("/"));
         return new Endpoint(_loc2_,_loc3_,this);
      }
      
      public function getEndpointByPathString(param1:String) : IEndpoint
      {
         var _loc2_:String = param1;
         if(!StringUtils.startsWith(param1,"/~endpoints/"))
         {
            throw new Error("not a valid Endpoint path!");
         }
         var _loc3_:String = param1.substr(12);
         _loc3_ = StringUtils.remove(_loc3_,_loc3_.lastIndexOf("/"));
         return new Endpoint(_loc2_,_loc3_,this);
      }
      
      public function getEndpointListPath() : IPath
      {
         return super.path("/~endpoints/");
      }
      
      public function systemCommand(param1:String, param2:*, param3:Function) : void
      {
         var path:String = param1;
         var data:* = param2;
         var result:Function = param3;
         var self:InfinicastClient = this;
         super.messageManager.sendMessageWithResponseString(43,path,data,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            result(param1);
         });
      }
      
      public function systemCommandWithHandler(param1:String, param2:*, param3:Function, param4:Function) : void
      {
         var type:String = null;
         var path:String = param1;
         var data:* = param2;
         var onEvent:Function = param3;
         var registrationCompleteHandler:Function = param4;
         var self:InfinicastClient = this;
         if(data["type"])
         {
            type = String(data["type"]);
            if(!StringExtensions.IsNullOrEmpty(type) && type == "registerMsgDebugger")
            {
               if(onEvent == null)
               {
                  data["remove"] = true;
                  super.messageManager.registerHandler(47,super.path(PathUtils.infinicastInternStart),null);
               }
               else
               {
                  super.messageManager.registerHandler(47,super.path(PathUtils.infinicastInternStart),function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
                  {
                     onEvent(param1);
                  });
               }
               super.messageManager.sendMessageWithResponseString(43,path,data,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
               {
                  if(param2 != null)
                  {
                     registrationCompleteHandler(param2);
                  }
                  else if(param1 == null || Boolean(param1["error"]))
                  {
                     registrationCompleteHandler(ICError.create(6,String(param1["error"]),""));
                  }
                  else
                  {
                     registrationCompleteHandler(null);
                  }
               });
            }
         }
      }
      
      public function pathRoleSetup(param1:String, param2:String, param3:PathRoleSettings, param4:Function = null) : void
      {
         var message:*;
         var self:InfinicastClient = null;
         var path:String = param1;
         var role:String = param2;
         var pathSettings:PathRoleSettings = param3;
         var onComplete:Function = param4;
         self = this;
         if(!StringExtensions.IsNullOrEmpty(path))
         {
            path = PathUtils.cleanup(path);
         }
         message = new Object();
         if(pathSettings != null)
         {
            message["data"] = pathSettings.toJson();
         }
         message["role"] = role;
         super.messageManager.sendMessageWithResponseString(26,path,message,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            ErrorHandlingHelper.checkIfHasErrorsAndCallHandlersFull(self.getConnector(),param2,onComplete,param3.path);
         });
      }
      
      public function introduceObjectToEndpoint(param1:String, param2:IPath) : void
      {
         var _loc3_:* = new Object();
         _loc3_["target"] = param1;
         super.messageManager.sendMessage(6,param2,_loc3_);
      }
      
      public function updateDebugStatistics(param1:*, param2:Function) : void
      {
         super.messageManager.sendUpdateDebugStatistics(param1,param2);
      }
      
      public function setLogLevel(param1:int) : void
      {
         LoggerSettings.CurrentLogLevel = param1;
      }
      
      public function getRole() : String
      {
         return this._role;
      }
      
      public function getSpace() : String
      {
         return this._space;
      }
      
      public function triggerDisconnect() : void
      {
         this._ClientLogger.info("disconnected");
         this.whenDisconnected();
         Console.writeLine("Disconnect triggered");
         if(this._onDisconnect != null)
         {
            this._onDisconnect();
         }
      }
      
      public function unhandeledError(param1:IPath, param2:*) : void
      {
         var _loc3_:String = "";
         if(param2 != null)
         {
            _loc3_ = JSON.stringify(param2);
         }
         if(this._unhandeledErrorHandler != null)
         {
            this._unhandeledErrorHandler(param1,_loc3_);
            return;
         }
         if(param1 != null)
         {
            _loc3_ = " path: " + param1.toString();
         }
         this._ClientLogger.error("an Unhandeled Error occured: " + _loc3_);
      }
      
      public function unhandeledErrorInfo(param1:IPath, param2:ICError) : void
      {
         if(this._unhandeledErrorHandler != null)
         {
            this._unhandeledErrorHandler(param1,param2.message);
            return;
         }
         var _loc3_:String = param2.message;
         if(param1 != null)
         {
            _loc3_ = " path: " + param1.toString();
         }
         this._ClientLogger.error("an Unhandeled Error occured: " + _loc3_);
      }
      
      public function getCredentials() : *
      {
         return this._credentials;
      }
      
      public function receivedPing(param1:int, param2:int) : void
      {
         var _loc3_:DisconnectManager = this._disconnectManager;
         if(_loc3_ != null)
         {
            _loc3_.ReceivedPing();
         }
      }
      
      public function onInitConnector(param1:ICError, param2:*, param3:*) : void
      {
         if(param2 != null && param2["error"] != null)
         {
            this._onConnect(ICError.fromJson(param2["error"]));
         }
         else
         {
            this._thisEndpoint = new Endpoint(String(param3["path"]),String(param3["endpoint"]),this);
            this._onConnect(null);
         }
      }
      
      public function getObjectStateManager() : ObjectStateManager
      {
         return this._objectStateManager;
      }
      
      public function getRootPath() : PathImpl
      {
         return this;
      }
      
      private function init() : void
      {
         if(this._objectStateManager == null)
         {
            super.messageManager = new ConnectorMessageManager();
            this._objectStateManager = new ObjectStateManager(this);
            if(this._disconnectManager == null)
            {
               this.initDisconnectDetection();
            }
            super.setConnector(this);
         }
      }
      
      private function initDisconnectDetection() : void
      {
         var self:InfinicastClient = null;
         self = this;
         this._disconnectManager = new DisconnectManager();
         this._disconnectManager.StartDisconnectChecker(function():void
         {
            self._ClientLogger.warn("disconnecting because of missing pings");
            self.triggerDisconnect();
         },30000,60000 * 3);
      }
      
      public function onUnhandeledError(param1:Function) : void
      {
         this._unhandeledErrorHandler = param1;
      }
      
      public function onOtherEndpointDisconnected(param1:String, param2:Function, param3:Function = null) : void
      {
         var role:String = param1;
         var callback:Function = param2;
         var registrationCompleteCallback:Function = param3;
         var self:InfinicastClient = this;
         super.messageManager.addHandler(false,46,super.path(PathUtils.endpointDisconnectedByRolePath(role)),function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
         {
            var _loc5_:APEndpointContext = new APEndpointContext();
            _loc5_.endpoint = param3.endpoint;
            _loc5_.endpointData = param3.endpointData;
            callback(_loc5_);
         },registrationCompleteCallback,null);
      }
      
      public function setRole(param1:String) : void
      {
         this._role = param1;
      }
      
      public function setSpace(param1:String) : void
      {
         this._space = param1;
      }
      
      public function getEndpointHandler() : IEndpoint2ServerNetLayerHandler
      {
         return super.messageManager;
      }
      
      public function settings() : IStormSettings
      {
         return new StormSettings(super.messageManager);
      }
      
      public function getEndpointPath(param1:String) : IPath
      {
         return super.path("/~endpoints/" + param1 + "/");
      }
   }
}

