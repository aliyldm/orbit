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
   import flash.utils.Dictionary;
   
   public class BaseQueryExecutor
   {
      
      public var _path:IPath;
      
      public var _messageManager:ConnectorMessageManager;
      
      public var _connector:IConnector;
      
      public function BaseQueryExecutor(param1:IConnector, param2:IPath, param3:ConnectorMessageManager)
      {
         super();
         this._connector = param1;
         this._path = param2;
         this._messageManager = param3;
      }
      
      public static function getRoleCountDictionary(param1:*) : Dictionary
      {
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc2_:Dictionary = new Dictionary();
         var _loc3_:Vector.<Object> = Vector.<Object>(param1["roleCount"]);
         if(_loc3_ != null)
         {
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = String(_loc4_["role"]);
               _loc6_ = String(_loc4_["handlerType"]);
               _loc7_ = int(_loc4_["count"]);
               if(_loc6_ == "Message")
               {
                  DictionaryExtensions.add(_loc2_,_loc5_,_loc7_);
               }
            }
         }
         return _loc2_;
      }
      
      public function getPathAndEndpointContext(param1:IPathAndEndpointContext) : IAPathContext
      {
         var _loc2_:APathContext = new APathContext();
         _loc2_.path = param1.path;
         return _loc2_;
      }
      
      public function getPathContext(param1:IPath) : IAPathContext
      {
         var _loc2_:APathContext = new APathContext();
         _loc2_.path = param1;
         return _loc2_;
      }
      
      public function checkIfHasErrorsAndCallHandlersNew(param1:ICError, param2:Function) : Boolean
      {
         return ErrorHandlingHelper.checkIfHasErrorsAndCallHandlersNew(this._connector,param1,param2,this._path);
      }
      
      public function checkIfHasErrorsAndCallHandlersFull(param1:ICError, param2:Function) : void
      {
         ErrorHandlingHelper.checkIfHasErrorsAndCallHandlersFull(this._connector,param1,param2,this._path);
      }
      
      public function unhandeledError(param1:ICError) : void
      {
         this._connector.unhandeledErrorInfo(this._path,param1);
      }
   }
}

