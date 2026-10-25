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
   import flash.utils.Dictionary;
   
   public class PathHandlerContainer
   {
      
      private var _handlersByType:Dictionary;
      
      private var _path:IPath;
      
      public function PathHandlerContainer(param1:IPath)
      {
         super();
         this._path = param1;
         this._handlersByType = new Dictionary();
      }
      
      public function addHandler(param1:String, param2:Function) : void
      {
         if(!DictionaryExtensions.containsKey(this._handlersByType,param1))
         {
            DictionaryExtensions.add(this._handlersByType,param1,new PathMessageHandlerContainer(this._path));
         }
         this._handlersByType[param1].addHandler(param2);
      }
      
      public function callHandlers(param1:ICError, param2:String, param3:*, param4:IPathAndEndpointContext, param5:int) : void
      {
         if(DictionaryExtensions.containsKey(this._handlersByType,param2))
         {
            this._handlersByType[param2].callHandlers(param1,param3,param4,param5);
         }
      }
      
      public function getPath() : IPath
      {
         return this._path;
      }
      
      public function removeHandler(param1:String) : Boolean
      {
         return DictionaryExtensions.remove(this._handlersByType,param1);
      }
      
      public function isEmpty() : Boolean
      {
         return this._handlersByType.length == 0;
      }
   }
}

