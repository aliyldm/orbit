package Infinicast.Client.Impl.Query
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
   import Infinicast.Client.Impl.Messaging.Receiver.*;
   import Infinicast.Client.Impl.Messaging.sender.*;
   import Infinicast.Client.Impl.ObjectState.*;
   import Infinicast.Client.Impl.PathAccess.*;
   import Infinicast.Client.Impl.Responder.*;
   import Infinicast.Client.Protocol.*;
   import Infinicast.Client.Protocol.Messages.*;
   import Infinicast.Client.Utils.*;
   import Infinicast.Runtime.*;
   
   public class ListenerQueryExecutor extends BaseQueryExecutor
   {
      
      public function ListenerQueryExecutor(param1:IConnector, param2:IPath, param3:ConnectorMessageManager)
      {
         super(param1,param2,param3);
      }
      
      private static function getListeningStartedContext(param1:*, param2:IPathAndEndpointContext) : APListeningStartedContext
      {
         var _loc3_:APListeningStartedContext = new APListeningStartedContext();
         if(param1 != null)
         {
            _loc3_.listenerCount = BaseQueryExecutor.getRoleCountDictionary(param1);
         }
         _loc3_.path = param2.path;
         _loc3_.endpoint = param2.endpoint;
         _loc3_.endpointData = param2.endpointData;
         return _loc3_;
      }
      
      private static function getListeningEndedContext(param1:*, param2:IPathAndEndpointContext) : APListeningEndedContext
      {
         var _loc3_:APListeningEndedContext = new APListeningEndedContext();
         if(param1 != null)
         {
            _loc3_.listenerCount = BaseQueryExecutor.getRoleCountDictionary(param1);
         }
         _loc3_.path = param2.path;
         _loc3_.endpoint = param2.endpoint;
         _loc3_.endpointData = param2.endpointData;
         _loc3_.isDisconnected = Boolean(param1["disconnected"]);
         return _loc3_;
      }
      
      private static function forwardListeningEndedMessages(param1:Function, param2:*, param3:IPathAndEndpointContext) : void
      {
         var _loc4_:APListeningEndedContext = ListenerQueryExecutor.getListeningEndedContext(param2,param3);
         param1(_loc4_);
      }
      
      private static function forwardListeningChangedMessages(param1:Function, param2:*, param3:IPathAndEndpointContext) : void
      {
         var _loc4_:APListeningChangedContext = ListenerQueryExecutor.getListeningChangedContext(param2,param3);
         param1(_loc4_);
      }
      
      private static function getListeningChangedContext(param1:*, param2:IPathAndEndpointContext) : APListeningChangedContext
      {
         var _loc3_:APListeningChangedContext = new APListeningChangedContext();
         _loc3_.path = param2.path;
         _loc3_.endpoint = param2.endpoint;
         _loc3_.endpointData = param2.endpointData;
         return _loc3_;
      }
      
      public function getListenerList(param1:Function, param2:String, param3:int) : void
      {
         var self:ListenerQueryExecutor = null;
         var callback:Function = param1;
         var roleFilter:String = param2;
         var listeningType:int = param3;
         self = this;
         var settings:* = new Object();
         if(!StringExtensions.IsNullOrEmpty(roleFilter))
         {
            settings["role"] = roleFilter;
         }
         if(listeningType != 0)
         {
            settings["messageType"] = ListeningType.toString(listeningType);
         }
         super._messageManager.sendMessageWithResponse(29,super._path,settings,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            var array:Vector.<Object> = null;
            var resultList:Vector.<IEndpointAndData> = null;
            var ob:* = undefined;
            var endpointObject:Endpoint = null;
            var endpointData:EndpointAndData = null;
            var json:* = param1;
            var err:ICError = param2;
            var context:IPathAndEndpointContext = param3;
            if(!self.checkIfHasErrorsAndCallHandlersNew(err,function(param1:ICError):void
            {
               callback(param1,null,null);
            }))
            {
               array = Vector.<Object>(json["list"]);
               if(array == null)
               {
                  throw new Error("GetListeningList should always contain a list, even if it is empty");
               }
               resultList = new Vector.<IEndpointAndData>();
               for each(ob in array)
               {
                  endpointObject = new Endpoint(String(ob["path"]),String(ob["endpoint"]),self._connector.getRootPath());
                  endpointData = new EndpointAndData();
                  if(ob["data"])
                  {
                     endpointData.data = ob["data"];
                  }
                  endpointData.endpoint = endpointObject;
                  resultList.push(endpointData);
               }
               callback(null,resultList,self.getPathContext(self._path));
            }
         });
      }
      
      public function onListeningStarted(param1:Function, param2:ListeningHandlerRegistrationOptions = null, param3:Function = null) : void
      {
         var handler:Function = param1;
         var options:ListeningHandlerRegistrationOptions = param2;
         var completeCallback:Function = param3;
         var self:ListenerQueryExecutor = this;
         super._messageManager.addHandler(handler == null,21,super._path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
         {
            var _loc5_:APListeningStartedContext = ListenerQueryExecutor.getListeningStartedContext(param1,param3);
            handler(_loc5_);
         },completeCallback,options);
      }
      
      public function onListeningChanged(param1:Function, param2:ListeningHandlerRegistrationOptions = null, param3:Function = null) : void
      {
         var handler:Function = param1;
         var options:ListeningHandlerRegistrationOptions = param2;
         var completeCallback:Function = param3;
         var self:ListenerQueryExecutor = this;
         super._messageManager.addHandler(handler == null,40,super._path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
         {
            ListenerQueryExecutor.forwardListeningChangedMessages(handler,param1,param3);
         },completeCallback,options);
      }
      
      private function getCustomOptionsJson(param1:ListeningHandlerRegistrationOptions) : *
      {
         var _loc2_:* = null;
         if(param1 != null && !StringExtensions.IsNullOrEmpty(param1.roleFilter))
         {
            if(_loc2_ == null)
            {
               _loc2_ = new Object();
            }
            _loc2_["role"] = param1.roleFilter;
         }
         if(param1 != null && param1.listenerType != 0)
         {
            if(_loc2_ == null)
            {
               _loc2_ = new Object();
            }
            _loc2_["listenerType"] = ListeningType.toString(param1.listenerType);
         }
         return _loc2_;
      }
      
      public function onListeningEnded(param1:Function, param2:ListeningHandlerRegistrationOptions = null, param3:Function = null) : void
      {
         var handler:Function = param1;
         var options:ListeningHandlerRegistrationOptions = param2;
         var completeCallback:Function = param3;
         var self:ListenerQueryExecutor = this;
         super._messageManager.addHandler(handler == null,20,super._path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
         {
            ListenerQueryExecutor.forwardListeningEndedMessages(handler,param1,param3);
         },completeCallback,options);
      }
      
      public function getAndListenOnListeners(param1:Function, param2:Function, param3:Function, param4:ListeningHandlerRegistrationOptions, param5:Function) : void
      {
         var self:ListenerQueryExecutor = null;
         var onStart:Function = param1;
         var onChange:Function = param2;
         var onEnd:Function = param3;
         var options:ListeningHandlerRegistrationOptions = param4;
         var registrationCompleteCallback:Function = param5;
         self = this;
         var parameters:* = this.getCustomOptionsJson(options);
         if(parameters == null)
         {
            parameters = new Object();
         }
         if(onStart == null && onEnd == null && onChange == null)
         {
            parameters["remove"] = true;
         }
         if(options != null && options.isOncePerRole)
         {
            parameters["once"] = true;
         }
         if(options != null && options.isSticky)
         {
            parameters["sticky"] = true;
         }
         if(onChange == null)
         {
            parameters["noChange"] = true;
         }
         super._messageManager.sendMessageWithResponse(41,super._path,parameters,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            var array:Vector.<Object> = null;
            var rootPath:PathImpl = null;
            var ob:* = undefined;
            var endpointObject:Endpoint = null;
            var endpointData:EndpointAndData = null;
            var listeningStartedContext:APListeningStartedContext = null;
            var json:* = param1;
            var err:ICError = param2;
            var context:IPathAndEndpointContext = param3;
            if(!self.checkIfHasErrorsAndCallHandlersNew(err,function(param1:ICError):void
            {
               if(registrationCompleteCallback != null)
               {
                  registrationCompleteCallback(param1);
               }
            }))
            {
               array = Vector.<Object>(json["list"]);
               if(array != null)
               {
                  rootPath = self._connector.getRootPath();
                  for each(ob in array)
                  {
                     endpointObject = new Endpoint(String(ob["path"]),String(ob["endpoint"]),rootPath);
                     endpointData = new EndpointAndData();
                     endpointData.data = ob["data"];
                     endpointData.endpoint = endpointObject;
                     listeningStartedContext = new APListeningStartedContext();
                     listeningStartedContext.endpoint = endpointObject;
                     listeningStartedContext.endpointData = endpointData.data;
                     if(onStart != null)
                     {
                        onStart(listeningStartedContext);
                     }
                  }
               }
               if(registrationCompleteCallback != null)
               {
                  registrationCompleteCallback(null);
               }
            }
         });
         if(onStart != null || onChange != null || onEnd != null)
         {
            super._messageManager.registerHandler(21,super._path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
            {
               var _loc5_:APListeningStartedContext = ListenerQueryExecutor.getListeningStartedContext(param1,param3);
               if(onStart != null)
               {
                  onStart(_loc5_);
               }
            });
            if(onChange != null)
            {
               super._messageManager.registerHandler(40,super._path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
               {
                  onChange(ListenerQueryExecutor.getListeningChangedContext(param1,param3));
               });
            }
            super._messageManager.registerHandler(20,super._path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
            {
               var _loc5_:APListeningEndedContext = ListenerQueryExecutor.getListeningEndedContext(param1,param3);
               if(onEnd != null)
               {
                  onEnd(_loc5_);
               }
            });
         }
         else
         {
            super._messageManager.registerHandler(21,super._path,null);
            super._messageManager.registerHandler(40,super._path,null);
            super._messageManager.registerHandler(20,super._path,null);
         }
      }
   }
}

