package Infinicast.Runtime
{
   public interface IEndpoint2ServerNetLayer
   {
      
      function Open(param1:Endpoint2ServerNetSettings) : String;
      
      function Close() : void;
      
      function SendToServer(param1:APlayStringMessage) : void;
   }
}

