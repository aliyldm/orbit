package Infinicast.Client.Impl.Messaging.sender
{
   import Infinicast.Client.Protocol.Messages.Connector2EpsMessage;
   
   public interface IMessageSender
   {
      
      function sendMessage(param1:Connector2EpsMessage) : void;
      
      function destroy() : void;
   }
}

