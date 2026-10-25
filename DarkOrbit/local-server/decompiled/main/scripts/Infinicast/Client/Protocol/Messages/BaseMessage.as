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
   
   public class BaseMessage
   {
      
      private var _role:String;
      
      private var _path:String;
      
      private var _data:*;
      
      private var _originalEndpoint:String;
      
      private var _requestId:*;
      
      private var _answerTarget:String;
      
      private var _endpoint:String;
      
      public function BaseMessage()
      {
         super();
      }
      
      public function _setDataByMessage(param1:*) : void
      {
         if(param1["role"] != null)
         {
            this.role = String(param1["role"]);
         }
         if(param1["path"] != null)
         {
            this.path = String(param1["path"]);
         }
         if(param1["data"] != null)
         {
            this.data = param1["data"];
         }
         if(param1["originalEndpoint"] != null)
         {
            this.originalEndpoint = String(param1["originalEndpoint"]);
         }
         if(param1["requestId"] != null)
         {
            this.requestId = int(param1["requestId"]);
         }
         else
         {
            this.requestId = null;
         }
         if(param1["answerTarget"] != null)
         {
            this.answerTarget = String(param1["answerTarget"]);
         }
         if(param1["endpoint"] != null)
         {
            this.endpoint = String(param1["endpoint"]);
         }
      }
      
      public function _setDataByClone(param1:BaseMessage) : void
      {
         this.role = param1.role;
         this.path = param1.path;
         this.data = param1.data;
         this.originalEndpoint = param1.originalEndpoint;
         this.requestId = param1.requestId;
         this.answerTarget = param1.answerTarget;
         this.endpoint = param1.endpoint;
      }
      
      public function _fillJson(param1:*) : void
      {
         if(!StringExtensions.IsNullOrEmpty(this.role))
         {
            param1["role"] = this.role;
         }
         if(!StringExtensions.IsNullOrEmpty(this.path))
         {
            param1["path"] = this.path;
         }
         if(this.data != null)
         {
            param1["data"] = this.data;
         }
         if(!StringExtensions.IsNullOrEmpty(this.originalEndpoint))
         {
            param1["originalEndpoint"] = this.originalEndpoint;
         }
         if(this.requestId != null)
         {
            param1["requestId"] = this.requestId;
         }
         if(!StringExtensions.IsNullOrEmpty(this.answerTarget))
         {
            param1["answerTarget"] = this.answerTarget;
         }
         if(!StringExtensions.IsNullOrEmpty(this.endpoint))
         {
            param1["endpoint"] = this.endpoint;
         }
      }
      
      public function get role() : String
      {
         return this._role;
      }
      
      public function set role(param1:String) : void
      {
         this._role = param1;
      }
      
      public function get path() : String
      {
         return this._path;
      }
      
      public function set path(param1:String) : void
      {
         this._path = param1;
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set data(param1:*) : void
      {
         this._data = param1;
      }
      
      public function get originalEndpoint() : String
      {
         return this._originalEndpoint;
      }
      
      public function set originalEndpoint(param1:String) : void
      {
         this._originalEndpoint = param1;
      }
      
      public function get requestId() : *
      {
         return this._requestId;
      }
      
      public function set requestId(param1:*) : void
      {
         this._requestId = param1;
      }
      
      public function get answerTarget() : String
      {
         return this._answerTarget;
      }
      
      public function set answerTarget(param1:String) : void
      {
         this._answerTarget = param1;
      }
      
      public function get endpoint() : String
      {
         return this._endpoint;
      }
      
      public function set endpoint(param1:String) : void
      {
         this._endpoint = param1;
      }
   }
}

