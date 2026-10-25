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
   
   public class ICError
   {
      
      private var _customJson:*;
      
      private var _message:String;
      
      private var _path:String;
      
      private var _errorType:int;
      
      public function ICError(param1:int, param2:String, param3:String, param4:*)
      {
         super();
         this.message = param2;
         this.errorType = param1;
         this.path = param3;
         this.customJson = param4;
      }
      
      public static function create1(param1:int, param2:String, param3:String) : ICError
      {
         return new ICError(param1,param2,param3,null);
      }
      
      public static function create2(param1:int, param2:String, param3:String, param4:*) : ICError
      {
         return new ICError(param1,param2,param3,param4);
      }
      
      public static function fromJson(param1:*) : ICError
      {
         return new ICError(ICErrorType.parse(String(param1["reason"])),String(param1["error"]),String(param1["path"]),null);
      }
      
      public static function fromException(param1:Error, param2:String) : ICError
      {
         return new ICError(6,InfinicastExceptionHelper.ExceptionToString(param1),param2,null);
      }
      
      public static function create(param1:*, param2:*, param3:*, param4:* = undefined) : ICError
      {
         if(param1 is ICErrorType && param2 is String && param3 is String && undefined === param4)
         {
            return ICError.create1(int(param1),String(param2),String(param3));
         }
         if(param1 is ICErrorType && param2 is String && param3 is String && param4 is Object)
         {
            return ICError.create2(int(param1),String(param2),String(param3),param4);
         }
         throw new ArgumentError("Bad combination of parameter types");
      }
      
      public function toString() : String
      {
         return ICErrorType.toString(this.errorType) + " " + this.message;
      }
      
      public function append(param1:ICError) : void
      {
         this.message += param1.message;
      }
      
      public function toJson() : *
      {
         var _loc1_:* = new Object();
         _loc1_["reason"] = ICErrorType.toString(this.errorType);
         if(!StringExtensions.IsNullOrEmpty(this.message))
         {
            _loc1_["error"] = this.message;
         }
         if(!StringExtensions.IsNullOrEmpty(this.path))
         {
            _loc1_["path"] = this.path;
         }
         if(this.customJson != null)
         {
            _loc1_["customJson"] = this.customJson;
         }
         return _loc1_;
      }
      
      public function get customJson() : *
      {
         return this._customJson;
      }
      
      public function set customJson(param1:*) : void
      {
         this._customJson = param1;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function set message(param1:String) : void
      {
         this._message = param1;
      }
      
      public function get path() : String
      {
         return this._path;
      }
      
      public function set path(param1:String) : void
      {
         this._path = param1;
      }
      
      public function get errorType() : int
      {
         return this._errorType;
      }
      
      public function set errorType(param1:int) : void
      {
         this._errorType = param1;
      }
   }
}

