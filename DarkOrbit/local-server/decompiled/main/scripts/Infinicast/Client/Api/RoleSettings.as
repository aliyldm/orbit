package Infinicast.Client.Api
{
   import Infinicast.*;
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
   import Infinicast.Client.Protocol.Messages.*;
   import Infinicast.Client.Utils.*;
   import Infinicast.Runtime.*;
   
   public class RoleSettings
   {
      
      private var _allowConnectAsRole:*;
      
      private var _allowIps:String;
      
      private var _allowEps:String;
      
      private var _grantDevSetup:*;
      
      private var _grantRoleAssignments:String;
      
      private var _timeoutInMs:*;
      
      public function RoleSettings()
      {
         super();
      }
      
      public function toJson() : *
      {
         var _loc1_:* = new Object();
         if(this.allowConnectAsRole != null)
         {
            _loc1_["allowConnectAsRole"] = this.allowConnectAsRole;
         }
         if(!StringExtensions.IsNullOrEmpty(this.allowEps))
         {
            _loc1_["allowEps"] = this.allowEps;
         }
         if(!StringExtensions.IsNullOrEmpty(this.allowIps))
         {
            _loc1_["allowIps"] = this.allowIps;
         }
         if(!StringExtensions.IsNullOrEmpty(this.grantRoleAssignments))
         {
            _loc1_["grantRoleAssignments"] = this.grantRoleAssignments;
         }
         if(this.grantDevSetup != null)
         {
            _loc1_["grantDevSetup"] = this.grantDevSetup;
         }
         if(this.timeoutInMs != null)
         {
            _loc1_["timeoutInMs"] = this.timeoutInMs;
         }
         return _loc1_;
      }
      
      public function get allowConnectAsRole() : *
      {
         return this._allowConnectAsRole;
      }
      
      public function set allowConnectAsRole(param1:*) : void
      {
         this._allowConnectAsRole = param1;
      }
      
      public function get allowIps() : String
      {
         return this._allowIps;
      }
      
      public function set allowIps(param1:String) : void
      {
         this._allowIps = param1;
      }
      
      public function get allowEps() : String
      {
         return this._allowEps;
      }
      
      public function set allowEps(param1:String) : void
      {
         this._allowEps = param1;
      }
      
      public function get grantDevSetup() : *
      {
         return this._grantDevSetup;
      }
      
      public function set grantDevSetup(param1:*) : void
      {
         this._grantDevSetup = param1;
      }
      
      public function get grantRoleAssignments() : String
      {
         return this._grantRoleAssignments;
      }
      
      public function set grantRoleAssignments(param1:String) : void
      {
         this._grantRoleAssignments = param1;
      }
      
      public function get timeoutInMs() : *
      {
         return this._timeoutInMs;
      }
      
      public function set timeoutInMs(param1:*) : void
      {
         this._timeoutInMs = param1;
      }
   }
}

