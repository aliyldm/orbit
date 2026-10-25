package net.bigpoint.darkorbit.mvc.chatclient.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ResendChatInfoCommand extends DOAbstractSimpleCommand
   {
      
      public function ResendChatInfoCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:DOChatProxy = retrieveProxy(DOChatProxy.NAME) as DOChatProxy;
         if(_loc2_)
         {
            _loc2_.resendGameSeverAuth();
         }
      }
   }
}

