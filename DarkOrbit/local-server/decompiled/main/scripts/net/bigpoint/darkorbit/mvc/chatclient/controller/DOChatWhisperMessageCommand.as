package net.bigpoint.darkorbit.mvc.chatclient.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProxy;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatWhisperMessageVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DOChatWhisperMessageCommand extends DOAbstractSimpleCommand
   {
      
      public function DOChatWhisperMessageCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:DOChatProxy = facade.retrieveProxy(DOChatProxy.NAME) as DOChatProxy;
         _loc2_.whisperMessage(param1.getBody() as DOChatWhisperMessageVO);
      }
   }
}

