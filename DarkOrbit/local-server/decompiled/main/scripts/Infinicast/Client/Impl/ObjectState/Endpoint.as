package Infinicast.Client.Impl.ObjectState
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
   import Infinicast.Client.Impl.PathAccess.*;
   import Infinicast.Client.Impl.Query.*;
   import Infinicast.Client.Impl.Responder.*;
   import Infinicast.Client.Protocol.*;
   import Infinicast.Client.Protocol.Messages.*;
   import Infinicast.Client.Utils.*;
   import Infinicast.Runtime.*;
   
   public class Endpoint extends PathImpl implements IEndpoint
   {
      
      private var _endpointId:String;
      
      public function Endpoint(param1:String, param2:String, param3:PathImpl)
      {
         super(param1);
         super.setRoot(param3);
         this.endpointId = param2;
      }
      
      public function introduce(param1:IPath, param2:* = null) : void
      {
         var _loc3_:* = new Object();
         _loc3_["target"] = this.endpointId;
         super.messageManager.sendMessage(6,param1,_loc3_);
      }
      
      public function addRole(param1:IPath, param2:String, param3:Function = null) : void
      {
         this.addRoleToStringPath(param1.toString(),param2,param3);
      }
      
      public function addRoleToStringPath(param1:String, param2:String, param3:Function = null) : void
      {
         this.sendModifyRole("add",param1,param2,param3);
      }
      
      public function removeRole(param1:IPath, param2:String, param3:Function = null) : void
      {
         this.removeRoleFromStringPath(param1.toString(),param2,param3);
      }
      
      public function removeRoleFromStringPath(param1:String, param2:String, param3:Function = null) : void
      {
         this.sendModifyRole("remove",param1,param2,param3);
      }
      
      public function getRoles(param1:IPath, param2:Function) : void
      {
         this.getRolesForStringPath(param1.toString(),param2);
      }
      
      public function getRolesForStringPath(param1:String, param2:Function) : void
      {
         var self:Endpoint = null;
         var pathString:String = param1;
         var roleListHandler:Function = param2;
         self = this;
         var message:* = new Object();
         message["target"] = this.endpointId;
         super.messageManager.sendMessageWithResponseString(18,pathString,message,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            var list:Vector.<String> = null;
            var json:* = param1;
            var err:ICError = param2;
            var context:IPathAndEndpointContext = param3;
            if(!self.checkIfHasErrorsAndCallHandlersNew(err,function(param1:ICError):void
            {
               roleListHandler(param1,null);
            }))
            {
               list = ObjectExtensions.getStringArray(json,"list");
               roleListHandler(null,list);
            }
         });
      }
      
      public function setDebugName(param1:String) : void
      {
         var _loc2_:* = new Object();
         _loc2_["target"] = this.endpointId;
         _loc2_["name"] = param1;
         super.messageManager.sendMessageString(27,"",_loc2_);
      }
      
      public function getEndpointConnectionInfo(param1:Function) : void
      {
         var self:Endpoint = null;
         var result:Function = param1;
         self = this;
         var message:* = new Object();
         message["target"] = this.endpointId;
         super.messageManager.sendMessageWithResponseString(34,"",message,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            self.onGetEndpointConnectionInfoResponse(param2,result,param1);
         });
      }
      
      private function onGetEndpointConnectionInfoResponse(param1:ICError, param2:Function, param3:*) : void
      {
         var info:EndpointConnectionInfo = null;
         var err:ICError = param1;
         var result:Function = param2;
         var json:* = param3;
         var self:Endpoint = this;
         if(!super.checkIfHasErrorsAndCallHandlersNew(err,function(param1:ICError):void
         {
            result(param1,null);
         }))
         {
            info = new EndpointConnectionInfo();
            info.ipAddress = String(json["ipAddress"]);
            result(null,info);
         }
      }
      
      public function getSubscribedPaths(param1:String, param2:String, param3:Function) : void
      {
         var self:Endpoint = null;
         var pathStartsWith:String = param1;
         var messageFilter:String = param2;
         var result:Function = param3;
         self = this;
         var message:* = new Object();
         message["target"] = this.endpointId;
         message["path"] = pathStartsWith;
         message["typeFilter"] = messageFilter;
         super.messageManager.sendMessageWithResponseString(48,"",message,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            var resultList:Vector.<EndpointSubscription> = null;
            var array:Vector.<Object> = null;
            var jToken:* = undefined;
            var ob:* = undefined;
            var epSubscription:EndpointSubscription = null;
            var roles:Vector.<String> = null;
            var rolesArray:Vector.<Object> = null;
            var role:* = undefined;
            var roleStr:String = null;
            var json:* = param1;
            var err:ICError = param2;
            var context:IPathAndEndpointContext = param3;
            if(!self.checkIfHasErrorsAndCallHandlersNew(err,function(param1:ICError):void
            {
               result(param1,null);
            }))
            {
               resultList = new Vector.<EndpointSubscription>();
               array = Vector.<Object>(json["list"]);
               for each(jToken in array)
               {
                  ob = jToken;
                  epSubscription = new EndpointSubscription();
                  epSubscription.path = String(ob["path"]);
                  if(ob["roles"] != null)
                  {
                     roles = new Vector.<String>();
                     rolesArray = Vector.<Object>(ob["roles"]);
                     for each(role in rolesArray)
                     {
                        roleStr = String(role);
                        roles.push(roleStr);
                     }
                     epSubscription.roles = roles;
                  }
                  resultList.push(epSubscription);
               }
               result(null,resultList);
            }
         });
      }
      
      private function sendModifyRole(param1:String, param2:String, param3:String, param4:Function = null) : void
      {
         var self:Endpoint = null;
         var modifier:String = param1;
         var pathString:String = param2;
         var role:String = param3;
         var onComplete:Function = param4;
         self = this;
         var data:* = new Object();
         data["modifier"] = modifier;
         data["role"] = role;
         data["target"] = this.endpointId;
         super.messageManager.sendMessageWithResponseString(17,pathString,data,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            if(!self.checkIfHasErrorsAndCallHandlersNew(param2,onComplete))
            {
               if(onComplete != null)
               {
                  onComplete(null);
               }
            }
         });
      }
      
      public function get endpointId() : String
      {
         return this._endpointId;
      }
      
      public function set endpointId(param1:String) : void
      {
         this._endpointId = param1;
      }
   }
}

