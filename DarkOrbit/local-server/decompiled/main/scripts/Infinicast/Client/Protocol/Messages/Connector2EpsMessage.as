package Infinicast.Client.Protocol.Messages
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
   import Infinicast.Client.Protocol.*;
   import Infinicast.Client.Utils.*;
   import Infinicast.Runtime.*;
   
   public class Connector2EpsMessage extends BaseMessage
   {
      
      private var _space:String;
      
      private var _type:int;
      
      private var _handlerType:*;
      
      private var _version:String;
      
      public function Connector2EpsMessage()
      {
         super();
      }
      
      public static function parseString(param1:APlayStringMessage) : Connector2EpsMessage
      {
         var _loc2_:* = JSON.parse(param1.DataAsString);
         return Connector2EpsMessage.parseInternal(_loc2_);
      }
      
      private static function parseInternal(param1:*) : Connector2EpsMessage
      {
         var _loc2_:Connector2EpsMessage = new Connector2EpsMessage();
         _loc2_._setDataByMessage(param1);
         _loc2_.type = Connector2EpsMessageType.parse(String(param1["type"]));
         if(param1["handlerType"] != null)
         {
            _loc2_.handlerType = Connector2EpsMessageType.parse(String(param1["handlerType"]));
         }
         return _loc2_;
      }
      
      public static function clone(param1:Connector2EpsMessage) : Connector2EpsMessage
      {
         var _loc2_:Connector2EpsMessage = new Connector2EpsMessage();
         _loc2_._setDataByClone(param1);
         _loc2_.type = param1.type;
         _loc2_.handlerType = param1.handlerType;
         return _loc2_;
      }
      
      public static function parseInner(param1:*) : Connector2EpsMessage
      {
         return Connector2EpsMessage.parseInternal(param1);
      }
      
      public function buildStringMessage() : APlayStringMessage
      {
         var _loc1_:* = new Object();
         if(!StringExtensions.IsNullOrEmpty(this.space))
         {
            _loc1_["space"] = ObjectExtensions.toString(this.space);
         }
         _loc1_["t"] = Connector2EpsMessageTypeConverter.messageTypeToInt(this.type);
         if(this.handlerType != null)
         {
            _loc1_["handlerType"] = Connector2EpsMessageType.toString(this.handlerType);
         }
         if(!StringExtensions.IsNullOrEmpty(this.version))
         {
            if(super.data == null)
            {
               super.data = new Object();
            }
            super.data["version"] = this.version;
         }
         super._fillJson(_loc1_);
         var _loc2_:APlayStringMessage = new APlayStringMessage();
         _loc2_.DataAsJson = _loc1_;
         return _loc2_;
      }
      
      public function get space() : String
      {
         return this._space;
      }
      
      public function set space(param1:String) : void
      {
         this._space = param1;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
      
      public function get handlerType() : *
      {
         return this._handlerType;
      }
      
      public function set handlerType(param1:*) : void
      {
         this._handlerType = param1;
      }
      
      public function get version() : String
      {
         return this._version;
      }
      
      public function set version(param1:String) : void
      {
         this._version = param1;
      }
   }
}

