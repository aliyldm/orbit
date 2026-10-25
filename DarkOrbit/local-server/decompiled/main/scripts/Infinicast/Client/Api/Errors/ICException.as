package Infinicast.Client.Api.Errors
{
   import Infinicast.*;
   import Infinicast.Client.Api.*;
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
   import Infinicast.Client.Impl.Query.*;
   import Infinicast.Client.Impl.Responder.*;
   import Infinicast.Client.Protocol.*;
   import Infinicast.Client.Protocol.Messages.*;
   import Infinicast.Client.Utils.*;
   import Infinicast.Runtime.*;
   
   public class ICException extends Error
   {
      
      private var _error:ICError;
      
      public function ICException(param1:ICError)
      {
         super(param1.toString());
         this.error = param1;
      }
      
      public function toString() : String
      {
         return super.Message;
      }
      
      public function get error() : ICError
      {
         return this._error;
      }
      
      public function set error(param1:ICError) : void
      {
         this._error = param1;
      }
   }
}

