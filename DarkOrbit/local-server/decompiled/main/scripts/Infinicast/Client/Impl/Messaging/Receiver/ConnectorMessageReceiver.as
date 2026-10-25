package Infinicast.Client.Impl.Messaging.Receiver
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
   import Infinicast.Client.Impl.*;
   import Infinicast.Client.Impl.Contexts.*;
   import Infinicast.Client.Impl.Helper.*;
   import Infinicast.Client.Impl.Messaging.*;
   import Infinicast.Client.Impl.Messaging.Handlers.*;
   import Infinicast.Client.Impl.Messaging.sender.*;
   import Infinicast.Client.Impl.ObjectState.*;
   import Infinicast.Client.Impl.PathAccess.*;
   import Infinicast.Client.Impl.Query.*;
   import Infinicast.Client.Impl.Responder.*;
   import Infinicast.Client.Protocol.*;
   import Infinicast.Client.Protocol.Messages.*;
   import Infinicast.Client.Utils.*;
   import Infinicast.Runtime.*;
   import flash.utils.Dictionary;
   
   public class ConnectorMessageReceiver implements IMessageReceiver, IEndpoint2ConnectorProtocolHandler
   {
      
      private var _handlerMap:Dictionary = new Dictionary();
      
      private var _logger:Logger = LoggerFactory.getLogger("ConnectorMessageReceiver");
      
      private var _receiveProtocol:Eps2ConnectorProtocol = new Eps2ConnectorProtocol();
      
      private var handlerPool:HandlerPool = new HandlerPool();
      
      private var _connector:IConnector;
      
      public function ConnectorMessageReceiver()
      {
         super();
      }
      
      public function onInitConnector(param1:ICError, param2:*, param3:*) : void
      {
         this._connector.onInitConnector(param1,param2,param3);
      }
      
      public function onReceiveRequestResponse(param1:ICError, param2:*, param3:int, param4:*) : void
      {
         var _loc5_:PathAndEndpointContext = this.getEndpointContext(param4,"");
         this.callHandlersLimited(param1,"",0,param2,_loc5_,param3,1);
      }
      
      public function onReceiveRequest(param1:ICError, param2:*, param3:String, param4:int, param5:*) : void
      {
         var _loc6_:PathAndEndpointContext = this.getEndpointContext(param5,param3);
         this.callHandlers(param1,param3,1,param2,_loc6_,param4);
      }
      
      public function onReceiveJsonQueryResult(param1:ICError, param2:Vector.<Object>, param3:int, param4:int) : void
      {
         var _loc5_:* = new Object();
         _loc5_["list"] = param2;
         _loc5_["fullCount"] = param3;
         this.callHandlersLimited(param1,"",0,_loc5_,new PathAndEndpointContext(null,null,null),param4,1);
      }
      
      public function onCreateChildSuccess(param1:ICError, param2:*, param3:String, param4:int) : void
      {
         this.callHandlersLimited(param1,"",0,param2,this.getEndpointContext(null,""),param4,1);
      }
      
      public function onGetOrCreate(param1:ICError, param2:*, param3:String, param4:int, param5:Boolean) : void
      {
         var _loc6_:* = new Object();
         _loc6_["data"] = param2;
         _loc6_["newlyCreated"] = param5;
         this.callHandlersLimited(param1,"",0,_loc6_,this.getEndpointContext(null,param3),param4,1);
      }
      
      public function onCreateOrUpdateRole(param1:ICError, param2:*, param3:int) : void
      {
         this.callHandlersLimited(param1,"",0,param2,this.getEndpointContext(null,""),param3,1);
      }
      
      public function onDestroyRole(param1:ICError, param2:*, param3:int) : void
      {
         this.callHandlersLimited(param1,"",0,param2,this.getEndpointContext(null,""),param3,1);
      }
      
      public function onGetRoleForPathResult(param1:ICError, param2:Vector.<Object>, param3:*, param4:int) : void
      {
         if(param3 == null)
         {
            param3 = new Object();
         }
         param3["list"] = param2;
         this.callHandlersLimited(param1,"",0,param3,this.getEndpointContext(null,""),param4,1);
      }
      
      public function onIntroduceObject(param1:ICError, param2:*, param3:String, param4:*) : void
      {
         var _loc5_:PathAndEndpointContext = this.getEndpointContext(param4,param3);
         this.callHandlers(param1,PathUtils.getObjectListPath(param3),6,param2,_loc5_,0);
      }
      
      public function onListeningEnded(param1:ICError, param2:String, param3:*, param4:Boolean, param5:*) : void
      {
         param5["disconnected"] = param4;
         var _loc6_:PathAndEndpointContext = this.getEndpointContext(param3,param2);
         this.callHandlers(param1,param2,20,param5,_loc6_,0);
      }
      
      public function onListeningStarted(param1:ICError, param2:String, param3:*, param4:*) : void
      {
         var _loc5_:PathAndEndpointContext = this.getEndpointContext(param3,param2);
         this.callHandlers(param1,param2,21,param4,_loc5_,0);
      }
      
      public function onListeningChanged(param1:ICError, param2:String, param3:*, param4:*) : void
      {
         param4["path"] = PathUtils.getEndpointPath(String(param4["endpoint"]));
         var _loc5_:PathAndEndpointContext = this.getEndpointContext(param4,param2);
         this.callHandlers(param1,param2,40,param4,_loc5_,0);
      }
      
      public function onReceiveMessage(param1:ICError, param2:*, param3:String, param4:*) : void
      {
         var _loc5_:PathAndEndpointContext = this.getEndpointContext(param4,param3);
         this.callHandlers(param1,param3,7,param2,_loc5_,0);
      }
      
      public function onReceiveMessageValidate(param1:ICError, param2:*, param3:String, param4:*) : void
      {
         var _loc5_:PathAndEndpointContext = this.getEndpointContext(param4,param3);
         this.callHandlers(param1,param3,8,param2,_loc5_,0);
      }
      
      public function onReceiveDataChangeValidate(param1:ICError, param2:*, param3:String, param4:*) : void
      {
         var _loc5_:PathAndEndpointContext = this.getEndpointContext(param4,param3);
         this.callHandlers(param1,param3,44,param2,_loc5_,0);
      }
      
      public function onListAdd(param1:ICError, param2:*, param3:String, param4:String, param5:*) : void
      {
         var _loc6_:PathAndEndpointContext = this.getEndpointContext(param5,param4);
         this.callHandlers(param1,param3,10,param2,_loc6_,0);
      }
      
      public function onListChange(param1:ICError, param2:*, param3:String, param4:String, param5:*) : void
      {
         var _loc6_:PathAndEndpointContext = this.getEndpointContext(param5,param4);
         this.callHandlers(param1,param3,12,param2,_loc6_,0);
      }
      
      public function onListRemove(param1:ICError, param2:*, param3:String, param4:String, param5:*) : void
      {
         var _loc6_:PathAndEndpointContext = this.getEndpointContext(param5,param4);
         this.callHandlers(param1,param3,11,param2,_loc6_,0);
      }
      
      public function onSetObjectData(param1:ICError, param2:*, param3:String, param4:*) : void
      {
         var _loc5_:ObjectStateManager = this._connector.getObjectStateManager();
         var _loc6_:PathAndEndpointContext = this.getEndpointContext(param4,param3);
         this.callHandlers(param1,param3,5,param2,_loc6_,0);
      }
      
      public function onDebugStatistics(param1:ICError, param2:*, param3:int) : void
      {
         this.callHandlersLimited(param1,"",0,ObjectExtensions.clone(param2),this.getEndpointContext(null,""),param3,1);
      }
      
      public function onPathRoleSetup(param1:ICError, param2:*, param3:int) : void
      {
         this.callHandlersLimited(param1,"",0,param2,this.getEndpointContext(null,""),param3,1);
      }
      
      public function onReminderTriggered(param1:ICError, param2:String, param3:*) : void
      {
         this.callHandlers(param1,param2,35,param3,null,0);
      }
      
      public function onListenTerminate(param1:ICError, param2:*) : void
      {
         var _loc3_:Vector.<Object> = Vector.<Object>(param2["paths"]);
         var _loc4_:String = String(param2["handlerType"]);
         if(!StringExtensions.IsNullOrEmpty(_loc4_))
         {
            this.callListenTerminate(param1,param2,_loc3_,_loc4_);
         }
         else
         {
            this.callListenTerminate(param1,param2,_loc3_,"Message");
            this.callListenTerminate(param1,param2,_loc3_,"MessageValidate");
            this.callListenTerminate(param1,param2,_loc3_,"Request");
            this.callListenTerminate(param1,param2,_loc3_,"SetObjectData");
            this.callListenTerminate(param1,param2,_loc3_,"SetObjectDataValidate");
         }
      }
      
      public function onEndpointDisconnected(param1:ICError, param2:String, param3:*) : void
      {
         var _loc4_:PathAndEndpointContext = this.getEndpointContext(param3,param2);
         this.callHandlers(param1,param2,46,null,_loc4_,0);
      }
      
      public function onDebugObserverMessage(param1:ICError, param2:String, param3:*) : void
      {
         this.callHandlers(param1,param2,47,param3,null,0);
      }
      
      private function callListenTerminate(param1:ICError, param2:*, param3:Vector.<Object>, param4:String) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:String = null;
         for each(_loc5_ in param3)
         {
            _loc6_ = String(_loc5_);
            this.callHandlersByString(param1,_loc6_,param4 + "_" + Connector2EpsMessageType.toString(42),param2,this.getEndpointContext(null,_loc6_),0);
         }
      }
      
      public function addHandler(param1:String, param2:IPath, param3:Function) : void
      {
         var _loc4_:PathHandlerContainer = this.ensureMessageHandlerBag(param1,param2);
         _loc4_.addHandler(param1,param3);
      }
      
      public function removeHandlers(param1:String, param2:String) : Boolean
      {
         var _loc4_:PathHandlerContainer = null;
         var _loc3_:Boolean = false;
         if(DictionaryExtensions.containsKey(this._handlerMap,param2))
         {
            _loc4_ = this._handlerMap[param2];
            if(_loc4_ != null)
            {
               if(_loc4_.removeHandler(param1))
               {
                  _loc3_ = true;
               }
               if(_loc4_.isEmpty())
               {
                  DictionaryExtensions.remove(this._handlerMap,param2);
               }
            }
         }
         return _loc3_;
      }
      
      public function destroy() : void
      {
         DictionaryExtensions.clear(this._handlerMap);
         this.handlerPool.Destroy();
      }
      
      public function addResponseHandler(param1:int, param2:String, param3:Function) : void
      {
         var _loc4_:String = Connector2EpsMessageType.toString(param1);
         var _loc5_:PathHandlerContainer = this.ensureMessageHandlerBag(_loc4_ + "_" + param2,null);
         _loc5_.addHandler(_loc4_,param3);
      }
      
      public function receive(param1:APlayStringMessage) : void
      {
         var msg:APlayStringMessage = param1;
         if(this._logger.isDebugEnabled)
         {
            this._logger.debug("received " + msg.DataAsString);
         }
         try
         {
            this._receiveProtocol.decodeStringMessage(msg,this);
         }
         catch(ex:Error)
         {
            this._logger.error("Exception in decode message " + msg.DataAsString + " " + InfinicastExceptionHelper.ExceptionToString(ex));
         }
      }
      
      public function setConnector(param1:IConnector) : void
      {
         this._connector = param1;
      }
      
      private function ensureMessageHandlerBag(param1:String, param2:IPath) : PathHandlerContainer
      {
         if(param2 != null)
         {
            param1 = param2.toString();
         }
         var _loc3_:PathHandlerContainer = new PathHandlerContainer(param2);
         return DictionaryExtensions.getOrAdd(this._handlerMap,param1,_loc3_);
      }
      
      private function getMessageHandlerBags(param1:String, param2:String) : Vector.<PathHandlerContainer>
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:PathHandlerContainer = null;
         var _loc3_:Vector.<PathHandlerContainer> = new Vector.<PathHandlerContainer>();
         for each(_loc4_ in PathUtils.getWildCardedPaths(param2))
         {
            _loc5_ = param1;
            if(!StringExtensions.IsNullOrEmpty(_loc4_))
            {
               _loc5_ = _loc4_;
            }
            _loc6_ = DictionaryExtensions.getValue(this._handlerMap,_loc5_);
            if(_loc6_ != null)
            {
               _loc3_.push(_loc6_);
            }
         }
         return _loc3_;
      }
      
      private function callHandlersLimitedByString(param1:ICError, param2:String, param3:String, param4:*, param5:IPathAndEndpointContext, param6:int, param7:int) : void
      {
         var bags:Vector.<PathHandlerContainer> = null;
         var bag:PathHandlerContainer = null;
         var icError:ICError = null;
         var error:ICError = param1;
         var path:String = param2;
         var type:String = param3;
         var data:* = param4;
         var context:IPathAndEndpointContext = param5;
         var requestId:int = param6;
         var handlerCount:int = param7;
         var callCount:int = 0;
         if(requestId != 0 && StringExtensions.IsNullOrEmpty(path))
         {
            bags = this.getMessageHandlerBags(type + "_" + requestId,"");
            DictionaryExtensions.remove(this._handlerMap,type + "_" + requestId);
         }
         else
         {
            bags = this.getMessageHandlerBags(ObjectExtensions.toString(type),path);
         }
         for each(bag in bags)
         {
            if(handlerCount == 0 || callCount < handlerCount)
            {
               callCount++;
               try
               {
                  this.queueInHandlerPool(error,bag,type,data,context,requestId);
               }
               catch(ex:Error)
               {
                  icError = ICError.fromException(ex,path);
                  this._connector.unhandeledErrorInfo(null,icError);
               }
            }
         }
         if(bags.length == 0)
         {
            this._logger.warn("request without handler " + path + " \'" + type + "\'");
         }
      }
      
      private function queueInHandlerPool(param1:ICError, param2:PathHandlerContainer, param3:String, param4:*, param5:IPathAndEndpointContext, param6:int) : void
      {
         var error:ICError = param1;
         var bag:PathHandlerContainer = param2;
         var type:String = param3;
         var data:* = param4;
         var context:IPathAndEndpointContext = param5;
         var requestId:int = param6;
         var self:ConnectorMessageReceiver = this;
         this.handlerPool.QueueHandlerCall(function():void
         {
            bag.callHandlers(error,type,data,context,requestId);
         });
      }
      
      private function callHandlersLimited(param1:ICError, param2:String, param3:int, param4:*, param5:IPathAndEndpointContext, param6:int, param7:int) : void
      {
         this.callHandlersLimitedByString(param1,param2,Connector2EpsMessageType.toString(param3),param4,param5,param6,param7);
      }
      
      private function callHandlers(param1:ICError, param2:String, param3:int, param4:*, param5:IPathAndEndpointContext, param6:int) : void
      {
         this.callHandlersLimited(param1,param2,param3,param4,param5,param6,0);
      }
      
      private function callHandlersByString(param1:ICError, param2:String, param3:String, param4:*, param5:IPathAndEndpointContext, param6:int) : void
      {
         this.callHandlersLimitedByString(param1,param2,param3,param4,param5,param6,0);
      }
      
      private function getEndpointContext(param1:*, param2:String) : PathAndEndpointContext
      {
         var _loc3_:Endpoint = null;
         if(param1 != null)
         {
            _loc3_ = new Endpoint(String(param1["path"]),String(param1["endpoint"]),this._connector.getRootPath());
         }
         var _loc4_:* = null;
         if(param1 != null && param1["data"] != null)
         {
            _loc4_ = param1["data"];
         }
         var _loc5_:IPath = null;
         if(!StringExtensions.IsNullOrEmpty(param2))
         {
            _loc5_ = this.getConnector().path(param2);
         }
         return new PathAndEndpointContext(_loc5_,_loc3_,_loc4_);
      }
      
      public function getConnector() : IConnector
      {
         return this._connector;
      }
   }
}

