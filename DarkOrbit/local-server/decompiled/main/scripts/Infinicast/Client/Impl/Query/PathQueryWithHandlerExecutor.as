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
   
   public class PathQueryWithHandlerExecutor extends BaseQueryExecutor
   {
      
      private var _logger:Logger = LoggerFactory.getLogger("PathQueryWithHandlerExecutor");
      
      public function PathQueryWithHandlerExecutor(param1:IConnector, param2:IPath, param3:ConnectorMessageManager)
      {
         super(param1,param2,param3);
      }
      
      public function onDataChange(param1:Function, param2:HandlerRegistrationOptions = null, param3:Function = null) : void
      {
         var callback:Function = param1;
         var options:HandlerRegistrationOptions = param2;
         var completeCallback:Function = param3;
         var self:PathQueryWithHandlerExecutor = this;
         super._messageManager.addHandler(false,5,super._path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
         {
            var _loc5_:* = null;
            var _loc6_:* = null;
            if(param1["new"])
            {
               _loc5_ = param1["new"];
            }
            if(param1["old"])
            {
               _loc6_ = param1["old"];
            }
            callback(_loc5_,_loc6_,param3);
         },completeCallback,options);
      }
      
      public function onValidateDataChange(param1:Function, param2:HandlerRegistrationOptions = null, param3:Function = null) : void
      {
         var self:PathQueryWithHandlerExecutor = null;
         var callback:Function = param1;
         var options:HandlerRegistrationOptions = param2;
         var completeCallback:Function = param3;
         self = this;
         super._messageManager.addHandler(callback == null,44,super._path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
         {
            var _loc5_:* = null;
            var _loc6_:* = null;
            if(param1["new"])
            {
               _loc5_ = param1["new"];
            }
            if(param1["old"])
            {
               _loc6_ = param1["old"];
            }
            callback(_loc5_,_loc6_,new ValidationResponder(45,self._messageManager,_loc5_,param3.path,param3.endpoint),param3);
         },completeCallback,options);
      }
      
      public function onValidateMessage(param1:Function, param2:HandlerRegistrationOptions = null, param3:Function = null) : void
      {
         var self:PathQueryWithHandlerExecutor = null;
         var callback:Function = param1;
         var options:HandlerRegistrationOptions = param2;
         var completeCallback:Function = param3;
         self = this;
         super._messageManager.addHandler(callback == null,8,super._path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
         {
            callback(param1,new ValidationResponder(9,self._messageManager,param1,param3.path,param3.endpoint),param3);
         },completeCallback,options);
      }
      
      public function onMessage(param1:Function, param2:HandlerRegistrationOptions = null, param3:Function = null, param4:Function = null) : void
      {
         var callback:Function = param1;
         var options:HandlerRegistrationOptions = param2;
         var completeCallback:Function = param3;
         var listenTerminationHandler:Function = param4;
         var self:PathQueryWithHandlerExecutor = this;
         super._messageManager.addHandler(callback == null,7,super._path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
         {
            callback(param1,param3);
         },completeCallback,options,listenTerminationHandler);
      }
      
      public function onRequest(param1:Function, param2:HandlerRegistrationOptions = null, param3:Function = null) : void
      {
         var self:PathQueryWithHandlerExecutor = null;
         var callback:Function = param1;
         var options:HandlerRegistrationOptions = param2;
         var completeCallback:Function = param3;
         self = this;
         super._messageManager.addHandler(callback == null,1,super._path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
         {
            callback(param1,new RequestResponder(self._messageManager,param3.path,param3.endpoint.endpointId,param4),param3);
         },completeCallback,options);
      }
      
      public function onReminder(param1:Function, param2:HandlerRegistrationOptions = null, param3:Function = null) : void
      {
         var callback:Function = param1;
         var options:HandlerRegistrationOptions = param2;
         var completeCallback:Function = param3;
         var self:PathQueryWithHandlerExecutor = this;
         super._messageManager.addHandler(callback == null,35,super._path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
         {
            callback(param1,param3);
         },completeCallback,options);
      }
      
      public function onIntroduce(param1:Function, param2:Function = null) : void
      {
         var callback:Function = param1;
         var completeCallback:Function = param2;
         var self:PathQueryWithHandlerExecutor = this;
         super._messageManager.addHandler(callback == null,6,super._path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
         {
            callback(param1,param3);
         },completeCallback,null);
      }
   }
}

