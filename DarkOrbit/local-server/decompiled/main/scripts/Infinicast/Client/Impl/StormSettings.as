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
   
   public class StormSettings implements IStormSettings
   {
      
      private var _messageManager:ConnectorMessageManager;
      
      public function StormSettings(param1:ConnectorMessageManager)
      {
         super();
         this._messageManager = param1;
      }
      
      public function createOrUpdateRole(param1:String, param2:RoleSettings, param3:Function = null) : void
      {
         var self:StormSettings = null;
         var name:String = param1;
         var data:RoleSettings = param2;
         var completeCallback:Function = param3;
         self = this;
         var message:* = new Object();
         message["data"] = data.toJson();
         message["name"] = name;
         this._messageManager.sendMessageWithResponse(15,null,message,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            if(!ErrorHandlingHelper.checkIfHasErrorsAndCallHandlersNew(self._messageManager.getConnector(),param2,completeCallback,param3.path))
            {
               if(completeCallback != null)
               {
                  completeCallback(null);
               }
            }
         });
      }
      
      public function destroyRole(param1:String, param2:Function = null) : void
      {
         var self:StormSettings = null;
         var name:String = param1;
         var completeCallback:Function = param2;
         self = this;
         var message:* = new Object();
         message["name"] = name;
         this._messageManager.sendMessageWithResponse(16,null,message,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            if(!ErrorHandlingHelper.checkIfHasErrorsAndCallHandlersNew(self._messageManager.getConnector(),param2,completeCallback,param3.path))
            {
               if(completeCallback != null)
               {
                  completeCallback(null);
               }
            }
         });
      }
   }
}

