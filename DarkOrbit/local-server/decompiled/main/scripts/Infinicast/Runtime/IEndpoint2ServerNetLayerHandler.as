package Infinicast.Runtime
{
   public interface IEndpoint2ServerNetLayerHandler
   {
      
      function onReceiveFromServer(param1:APlayStringMessage) : void;
      
      function onConnect() : void;
      
      function onDisconnect() : void;
   }
}

