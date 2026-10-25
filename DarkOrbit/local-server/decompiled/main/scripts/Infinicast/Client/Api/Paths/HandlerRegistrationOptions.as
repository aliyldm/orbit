package Infinicast.Client.Api.Paths
{
   import Infinicast.*;
   import Infinicast.Client.Api.*;
   import Infinicast.Client.Api.Errors.*;
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
   import Infinicast.Client.Impl.Query.*;
   import Infinicast.Client.Impl.Responder.*;
   import Infinicast.Client.Protocol.*;
   import Infinicast.Client.Protocol.Messages.*;
   import Infinicast.Client.Utils.*;
   import Infinicast.Runtime.*;
   
   public class HandlerRegistrationOptions extends HandlerRegistrationOptionsData
   {
      
      public function HandlerRegistrationOptions()
      {
         super();
      }
      
      public function stickyOncePerRole() : HandlerRegistrationOptions
      {
         super.isOncePerRole = true;
         super.isSticky = true;
         return this;
      }
      
      public function oncePerRole() : HandlerRegistrationOptions
      {
         super.isOncePerRole = true;
         return this;
      }
      
      public function withSendingEndpointDataContext() : HandlerRegistrationOptions
      {
         super.sendingEndpointDataContext = true;
         return this;
      }
      
      public function withDataContext(param1:String, param2:int = 0) : HandlerRegistrationOptions
      {
         if(super.dataContextPaths == null)
         {
            super.dataContextPaths = new Vector.<DataContextRequest>();
         }
         var _loc3_:DataContextRequest = new DataContextRequest();
         _loc3_.path = param1;
         _loc3_.relativeTo = param2;
         super.dataContextPaths.push(_loc3_);
         return this;
      }
   }
}

