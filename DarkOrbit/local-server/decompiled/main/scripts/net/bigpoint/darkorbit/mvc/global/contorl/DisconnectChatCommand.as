package net.bigpoint.darkorbit.mvc.global.contorl
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DisconnectChatCommand extends DOAbstractSimpleCommand
   {
      
      public function DisconnectChatCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:DOChatProxy = null;
         super.execute(param1);
         if(!param1.getBody())
         {
            _loc2_ = GameFacade.getInstance().retrieveProxy(DOChatProxy.NAME) as DOChatProxy;
            if(_loc2_)
            {
               _loc2_.disconnect();
            }
         }
      }
   }
}

