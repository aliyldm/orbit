package Infinicast.Runtime.Network
{
   import Infinicast.Runtime.Network.Protocol.ByteData;
   
   public interface IConnection
   {
      
      function connect(param1:String) : void;
      
      function send(param1:ByteData) : Boolean;
      
      function disconnect() : void;
      
      function getRemoteAddress() : String;
      
      function initConnection() : void;
      
      function setHandler(param1:IConnectionEventHandler) : void;
   }
}

