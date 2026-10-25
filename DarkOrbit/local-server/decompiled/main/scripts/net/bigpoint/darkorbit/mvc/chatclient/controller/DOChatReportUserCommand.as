package net.bigpoint.darkorbit.mvc.chatclient.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProxy;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatReportVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DOChatReportUserCommand extends DOAbstractSimpleCommand
   {
      
      public function DOChatReportUserCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:DOChatProxy = retrieveProxy(DOChatProxy.NAME) as DOChatProxy;
         var _loc3_:DOChatReportVO = param1.getBody() as DOChatReportVO;
         if(_loc2_)
         {
            _loc2_.report(_loc3_);
         }
      }
   }
}

