package net.bigpoint.darkorbit.net.netty.handlers.traininggrounds
{
   import net.bigpoint.darkorbit.com.module.EpicFightMessageCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.epicMessages.model.EpicFightMessageProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class EpicFightMessageHandler extends DOAbstractSimpleCommand
   {
      
      public function EpicFightMessageHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:EpicFightMessageProxy = facade.retrieveProxy(EpicFightMessageProxy.NAME) as EpicFightMessageProxy;
         _loc2_.addMessage(param1.getBody() as EpicFightMessageCommand);
      }
   }
}

