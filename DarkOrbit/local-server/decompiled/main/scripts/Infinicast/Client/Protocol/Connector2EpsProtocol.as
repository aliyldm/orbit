package Infinicast.Client.Protocol
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
   import Infinicast.Client.Impl.Query.*;
   import Infinicast.Client.Impl.Responder.*;
   import Infinicast.Client.Protocol.Messages.*;
   import Infinicast.Client.Utils.*;
   import Infinicast.Runtime.*;
   
   public class Connector2EpsProtocol
   {
      
      public function Connector2EpsProtocol()
      {
         super();
      }
      
      public function encodeInitConnector(param1:String, param2:String, param3:*) : Connector2EpsMessage
      {
         var _loc4_:Connector2EpsMessage = new Connector2EpsMessage();
         _loc4_.type = 2;
         _loc4_.role = param2;
         _loc4_.space = param1;
         if(param3 != null)
         {
            _loc4_.data = new Object();
            _loc4_.data["credentials"] = param3;
         }
         _loc4_.version = VersionHelper.clientVersion;
         return _loc4_;
      }
      
      public function encodeRegisterHandlerMessage(param1:int, param2:String, param3:int, param4:*, param5:*, param6:int, param7:String, param8:Boolean) : Connector2EpsMessage
      {
         var _loc9_:Connector2EpsMessage = new Connector2EpsMessage();
         _loc9_.type = 14;
         _loc9_.requestId = param3;
         _loc9_.handlerType = param1;
         _loc9_.path = param2;
         var _loc10_:* = null;
         if(param4 != null && param4 == true)
         {
            if(_loc10_ == null)
            {
               _loc10_ = new Object();
            }
            _loc10_["once"] = true;
            if(param5 != null && param5 == true)
            {
               _loc10_["sticky"] = true;
            }
         }
         if(param6 != 0)
         {
            if(_loc10_ == null)
            {
               _loc10_ = new Object();
            }
            _loc10_["listenerType"] = ListeningType.toString(param6);
         }
         if(!StringExtensions.IsNullOrEmpty(param7))
         {
            if(_loc10_ == null)
            {
               _loc10_ = new Object();
            }
            _loc10_["role"] = param7;
         }
         if(param8)
         {
            if(_loc10_ == null)
            {
               _loc10_ = new Object();
            }
            _loc10_["terminationHandler"] = true;
         }
         _loc9_.data = _loc10_;
         return _loc9_;
      }
      
      public function encodeMessage(param1:int, param2:String, param3:*) : Connector2EpsMessage
      {
         var _loc4_:Connector2EpsMessage = new Connector2EpsMessage();
         _loc4_.type = param1;
         if(!StringExtensions.IsNullOrEmpty(param2))
         {
            _loc4_.path = param2;
         }
         _loc4_.data = param3;
         return _loc4_;
      }
      
      public function encodeValidatedMessage(param1:int, param2:String, param3:*, param4:String) : Connector2EpsMessage
      {
         var _loc5_:Connector2EpsMessage = new Connector2EpsMessage();
         _loc5_.type = param1;
         if(!StringExtensions.IsNullOrEmpty(param2))
         {
            _loc5_.path = param2;
         }
         _loc5_.data = param3;
         _loc5_.originalEndpoint = param4;
         return _loc5_;
      }
      
      public function encodeMessageWithRequestId(param1:int, param2:String, param3:*, param4:String, param5:int) : Connector2EpsMessage
      {
         var _loc6_:Connector2EpsMessage = new Connector2EpsMessage();
         _loc6_.type = param1;
         if(!StringExtensions.IsNullOrEmpty(param2))
         {
            _loc6_.path = param2;
         }
         _loc6_.data = param3;
         _loc6_.requestId = param5;
         _loc6_.answerTarget = param4;
         return _loc6_;
      }
      
      public function encodeRemoveHandlerMessage(param1:String, param2:int, param3:int, param4:String) : Connector2EpsMessage
      {
         var _loc5_:Connector2EpsMessage = new Connector2EpsMessage();
         _loc5_.type = 13;
         _loc5_.path = param1;
         _loc5_.requestId = param3;
         _loc5_.handlerType = param2;
         _loc5_.endpoint = param4;
         return _loc5_;
      }
      
      public function encodeMessageWithResponse(param1:int, param2:String, param3:*, param4:int) : Connector2EpsMessage
      {
         var _loc5_:Connector2EpsMessage = new Connector2EpsMessage();
         _loc5_.type = param1;
         if(!StringExtensions.IsNullOrEmpty(param2))
         {
            _loc5_.path = param2;
         }
         _loc5_.data = param3;
         _loc5_.requestId = param4;
         return _loc5_;
      }
      
      public function encodeDebugPingInfo(param1:String, param2:int) : Connector2EpsMessage
      {
         var _loc3_:Connector2EpsMessage = new Connector2EpsMessage();
         _loc3_.type = 23;
         var _loc4_:* = new Object();
         _loc4_["ping"] = param2;
         _loc3_.path = param1;
         _loc3_.data = _loc4_;
         return _loc3_;
      }
      
      public function encodeDebugMesssageInfo(param1:String, param2:int, param3:*) : Connector2EpsMessage
      {
         var _loc4_:Connector2EpsMessage = new Connector2EpsMessage();
         _loc4_.type = 24;
         var _loc5_:* = new Object();
         _loc5_["level"] = param2;
         _loc5_["info"] = param3;
         _loc4_.path = param1;
         _loc4_.data = _loc5_;
         return _loc4_;
      }
   }
}

