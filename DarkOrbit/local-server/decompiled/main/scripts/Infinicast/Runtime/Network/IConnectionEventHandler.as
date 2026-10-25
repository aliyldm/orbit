package Infinicast.Runtime.Network
{
   import flash.utils.ByteArray;
   
   public interface IConnectionEventHandler
   {
      
      function onConnect() : void;
      
      function onConnectError(param1:String) : void;
      
      function onDisconnect() : void;
      
      function onReceive(param1:ByteArray) : void;
   }
}

