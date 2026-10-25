package Infinicast.Client.Impl.Messaging.sender
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
   import Infinicast.Client.Impl.ObjectState.*;
   import Infinicast.Client.Impl.PathAccess.*;
   import Infinicast.Client.Impl.Query.*;
   import Infinicast.Client.Impl.Responder.*;
   import Infinicast.Client.Protocol.*;
   import Infinicast.Client.Protocol.Messages.*;
   import Infinicast.Client.Utils.*;
   import Infinicast.Runtime.*;
   
   public class MessageSender implements IMessageSender
   {
      
      private var _connection:IEndpoint2ServerNetLayer;
      
      private var _logger:Logger = LoggerFactory.getLogger("MessageSender");
      
      public function MessageSender(param1:IEndpoint2ServerNetLayer)
      {
         super();
         this._connection = param1;
      }
      
      public function sendMessage(param1:Connector2EpsMessage) : void
      {
         var messageAsString:String = null;
         var data:Connector2EpsMessage = param1;
         var convertedMsg:APlayStringMessage = data.buildStringMessage();
         if(this._logger.isDebugEnabled)
         {
            messageAsString = convertedMsg.DataAsString;
            this._logger.debug("Send Message " + messageAsString);
         }
         try
         {
            this._connection.SendToServer(convertedMsg);
         }
         catch(ex:Error)
         {
            this._logger.error("Could not send ",ex);
         }
      }
      
      public function destroy() : void
      {
      }
   }
}

