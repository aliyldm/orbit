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
   
   public class Eps2ConnectorMessage extends BaseMessage
   {
      
      private var _type:int;
      
      private var _endpointObject:*;
      
      private var _fullCount:*;
      
      private var _newlyCreated:*;
      
      private var _errorCode:*;
      
      private var _errorData:*;
      
      private var _disconnected:*;
      
      private var _list:Vector.<Object>;
      
      private var _error:ICError;
      
      public function Eps2ConnectorMessage()
      {
         super();
      }
      
      public static function parseString(param1:APlayStringMessage) : Eps2ConnectorMessage
      {
         var _loc2_:Object = param1.DataAsJson;
         if(!_loc2_)
         {
            _loc2_ = JSON.parse(param1.DataAsString);
         }
         return Eps2ConnectorMessage.parseFromJson(_loc2_);
      }
      
      private static function parseFromJson(param1:*) : Eps2ConnectorMessage
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:ICError = null;
         var _loc2_:Eps2ConnectorMessage = new Eps2ConnectorMessage();
         _loc2_._setDataByMessage(param1);
         if(param1["t"] != null)
         {
            _loc2_.type = Eps2ConnectorMessageTypeConverter.intToMessageType(int(param1["t"]));
         }
         else
         {
            _loc2_.type = Eps2ConnectorMessageType.parse(String(param1["type"]));
         }
         if(param1["errorReason"] != null)
         {
            _loc3_ = String(param1["errorReason"]);
            _loc4_ = String(param1["errorMsg"]);
            _loc5_ = String(param1["errorPath"]);
            _loc6_ = new ICError(ICErrorType.parse(_loc3_),_loc4_,_loc5_,null);
            _loc2_.error = _loc6_;
         }
         if(param1["endpointObject"] != null)
         {
            _loc2_.endpointObject = param1["endpointObject"];
         }
         if(param1["fullCount"] != null)
         {
            _loc2_.fullCount = int(param1["fullCount"]);
         }
         if(param1["newlyCreated"] != null)
         {
            _loc2_.newlyCreated = Boolean(param1["newlyCreated"]);
         }
         if(param1["errorCode"] != null)
         {
            _loc2_.errorCode = int(param1["errorCode"]);
         }
         if(param1["errorData"] != null)
         {
            _loc2_.errorData = param1["errorData"];
         }
         if(param1["disconnected"] != null)
         {
            _loc2_.disconnected = Boolean(param1["disconnected"]);
         }
         if(param1["list"] != null)
         {
            _loc2_.list = Vector.<Object>(param1["list"]);
         }
         return _loc2_;
      }
      
      public static function mapFromConnectorMessage(param1:Connector2EpsMessage) : Eps2ConnectorMessage
      {
         return Eps2ConnectorMessage.parseString(param1.buildStringMessage());
      }
      
      public static function parseInner(param1:*) : Eps2ConnectorMessage
      {
         return Eps2ConnectorMessage.parseFromJson(param1);
      }
      
      public function buildStringMessage() : APlayStringMessage
      {
         var _loc1_:* = new Object();
         super._fillJson(_loc1_);
         _loc1_["type"] = Eps2ConnectorMessageType.toString(this.type);
         if(this.endpointObject != null)
         {
            _loc1_["Endpoint"] = this.endpointObject;
         }
         if(this.fullCount != null)
         {
            _loc1_["fullCount"] = this.fullCount;
         }
         if(this.newlyCreated != null)
         {
            _loc1_["newlyCreated"] = this.newlyCreated;
         }
         if(this.errorCode != null)
         {
            _loc1_["errorCode"] = this.errorCode;
         }
         if(this.errorData != null)
         {
            _loc1_["errorData"] = this.errorData;
         }
         if(this.disconnected != null)
         {
            _loc1_["disconnected"] = this.disconnected;
         }
         if(this.list != null)
         {
            _loc1_["list"] = this.list;
         }
         var _loc2_:APlayStringMessage = new APlayStringMessage();
         _loc2_.DataAsJson = _loc1_;
         return _loc2_;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
      }
      
      public function get endpointObject() : *
      {
         return this._endpointObject;
      }
      
      public function set endpointObject(param1:*) : void
      {
         this._endpointObject = param1;
      }
      
      public function get fullCount() : *
      {
         return this._fullCount;
      }
      
      public function set fullCount(param1:*) : void
      {
         this._fullCount = param1;
      }
      
      public function get newlyCreated() : *
      {
         return this._newlyCreated;
      }
      
      public function set newlyCreated(param1:*) : void
      {
         this._newlyCreated = param1;
      }
      
      public function get errorCode() : *
      {
         return this._errorCode;
      }
      
      public function set errorCode(param1:*) : void
      {
         this._errorCode = param1;
      }
      
      public function get errorData() : *
      {
         return this._errorData;
      }
      
      public function set errorData(param1:*) : void
      {
         this._errorData = param1;
      }
      
      public function get disconnected() : *
      {
         return this._disconnected;
      }
      
      public function set disconnected(param1:*) : void
      {
         this._disconnected = param1;
      }
      
      public function get list() : Vector.<Object>
      {
         return this._list;
      }
      
      public function set list(param1:Vector.<Object>) : void
      {
         this._list = param1;
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

