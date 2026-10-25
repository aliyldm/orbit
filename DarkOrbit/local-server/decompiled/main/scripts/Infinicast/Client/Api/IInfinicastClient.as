package Infinicast.Client.Api
{
   public interface IInfinicastClient
   {
      
      function path(param1:String) : IPath;
      
      function connectWithCredentials(param1:String, param2:String, param3:String, param4:*, param5:Function) : void;
      
      function connect(param1:String, param2:String, param3:String, param4:Function) : void;
      
      function disconnect() : void;
      
      function onDisconnect(param1:Function) : void;
      
      function onUnhandeledError(param1:Function) : void;
      
      function getOwnEndpoint() : IEndpoint;
      
      function getEndpointById(param1:String) : IEndpoint;
      
      function getEndpointByPath(param1:IPath) : IEndpoint;
      
      function getEndpointByPathString(param1:String) : IEndpoint;
      
      function getEndpointListPath() : IPath;
      
      function onOtherEndpointDisconnected(param1:String, param2:Function, param3:Function = null) : void;
      
      function setLogLevel(param1:int) : void;
      
      function systemCommand(param1:String, param2:*, param3:Function) : void;
      
      function introduceObjectToEndpoint(param1:String, param2:IPath) : void;
      
      function updateDebugStatistics(param1:*, param2:Function) : void;
   }
}

