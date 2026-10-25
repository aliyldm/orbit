package Infinicast.Client.Impl
{
   import Infinicast.Client.Api.Errors.ICError;
   import Infinicast.Client.Api.IPath;
   import Infinicast.Client.Impl.ObjectState.ObjectStateManager;
   import Infinicast.Client.Impl.PathAccess.PathImpl;
   
   public interface IConnector
   {
      
      function getRootPath() : PathImpl;
      
      function path(param1:String) : IPath;
      
      function getObjectStateManager() : ObjectStateManager;
      
      function onInitConnector(param1:ICError, param2:*, param3:*) : void;
      
      function getRole() : String;
      
      function getSpace() : String;
      
      function triggerDisconnect() : void;
      
      function unhandeledError(param1:IPath, param2:*) : void;
      
      function unhandeledErrorInfo(param1:IPath, param2:ICError) : void;
      
      function getCredentials() : *;
      
      function receivedPing(param1:int, param2:int) : void;
   }
}

