package net.bigpoint.darkorbit.mvc.chatclient.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DOChatInvalidateEndpointCommand extends DOAbstractSimpleCommand
   {
      
      public function DOChatInvalidateEndpointCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:DOChatProxy = retrieveProxy(DOChatProxy.NAME) as DOChatProxy;
         if(_loc2_)
         {
            _loc2_.invalidateEndpoint();
         }
      }
   }
}

