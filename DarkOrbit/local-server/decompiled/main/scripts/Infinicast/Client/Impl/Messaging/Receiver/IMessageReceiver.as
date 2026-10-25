package Infinicast.Client.Impl.Messaging.Receiver
{
   import Infinicast.Client.Api.IPath;
   import Infinicast.Client.Impl.IConnector;
   import Infinicast.Runtime.APlayStringMessage;
   
   public interface IMessageReceiver
   {
      
      function addHandler(param1:String, param2:IPath, param3:Function) : void;
      
      function addResponseHandler(param1:int, param2:String, param3:Function) : void;
      
      function receive(param1:APlayStringMessage) : void;
      
      function setConnector(param1:IConnector) : void;
      
      function removeHandlers(param1:String, param2:String) : Boolean;
      
      function destroy() : void;
   }
}

