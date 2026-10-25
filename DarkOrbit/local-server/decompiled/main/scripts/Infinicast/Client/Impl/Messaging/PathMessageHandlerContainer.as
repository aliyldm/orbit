package Infinicast.Client.Impl.Messaging
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
   
   public class PathMessageHandlerContainer
   {
      
      private static var logger:Logger = LoggerFactory.getLogger("PathMessageHandlerContainer");
      
      private var _handlers:Vector.<Function>;
      
      private var _path:IPath;
      
      public function PathMessageHandlerContainer(param1:IPath)
      {
         super();
         this._path = param1;
         this._handlers = new Vector.<Function>();
      }
      
      public function addHandler(param1:Function) : void
      {
         this._handlers.push(param1);
      }
      
      public function callHandlers(param1:ICError, param2:*, param3:IPathAndEndpointContext, param4:int) : void
      {
         var _loc6_:Function = null;
         var _loc5_:* = null;
         if(param2 != null)
         {
            _loc5_ = ObjectExtensions.clone(param2);
         }
         for each(_loc6_ in this._handlers)
         {
            if(_loc6_ != null)
            {
               _loc6_(_loc5_,param1,param3,param4);
            }
            else
            {
               PathMessageHandlerContainer.logger.error("null handler for request " + param4);
            }
         }
      }
      
      public function getPath() : IPath
      {
         return this._path;
      }
   }
}

