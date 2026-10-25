package Infinicast.Client.Impl.Contexts
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
   import flash.utils.Dictionary;
   
   public class APListeningEndedContext extends APathContext implements IAPathContext, IListeningEndedContext
   {
      
      public var listenerCount:Dictionary = null;
      
      private var _endpoint:IEndpoint;
      
      private var _endpointData:*;
      
      private var _isDisconnected:Boolean;
      
      public function APListeningEndedContext()
      {
         super();
      }
      
      public function getListenerCount(param1:String) : int
      {
         if(this.listenerCount == null || !DictionaryExtensions.containsKey(this.listenerCount,param1))
         {
            return 0;
         }
         return this.listenerCount[param1];
      }
      
      public function wasLastListenerOfRole(param1:String) : Boolean
      {
         return this.getListenerCount(param1) == 0;
      }
      
      public function get endpoint() : IEndpoint
      {
         return this._endpoint;
      }
      
      public function set endpoint(param1:IEndpoint) : void
      {
         this._endpoint = param1;
      }
      
      public function get endpointData() : *
      {
         return this._endpointData;
      }
      
      public function set endpointData(param1:*) : void
      {
         this._endpointData = param1;
      }
      
      public function get isDisconnected() : Boolean
      {
         return this._isDisconnected;
      }
      
      public function set isDisconnected(param1:Boolean) : void
      {
         this._isDisconnected = param1;
      }
   }
}

