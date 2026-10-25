package Infinicast.Client.Api
{
   public interface IEndpoint extends IPath
   {
      
      function get endpointId() : String;
      
      function addRole(param1:IPath, param2:String, param3:Function = null) : void;
      
      function addRoleToStringPath(param1:String, param2:String, param3:Function = null) : void;
      
      function removeRole(param1:IPath, param2:String, param3:Function = null) : void;
      
      function removeRoleFromStringPath(param1:String, param2:String, param3:Function = null) : void;
      
      function getRoles(param1:IPath, param2:Function) : void;
      
      function getRolesForStringPath(param1:String, param2:Function) : void;
      
      function getEndpointConnectionInfo(param1:Function) : void;
      
      function getSubscribedPaths(param1:String, param2:String, param3:Function) : void;
      
      function setDebugName(param1:String) : void;
      
      function introduce(param1:IPath, param2:* = null) : void;
   }
}

