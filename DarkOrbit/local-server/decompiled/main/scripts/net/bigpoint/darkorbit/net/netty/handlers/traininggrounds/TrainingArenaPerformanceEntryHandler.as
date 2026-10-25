package net.bigpoint.darkorbit.net.netty.handlers.traininggrounds
{
   import net.bigpoint.darkorbit.com.module.TrainingArenaPerformanceEntryCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TrainingArenaPerformanceEntryHandler extends DOAbstractSimpleCommand
   {
      
      public function TrainingArenaPerformanceEntryHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:TrainingArenaPerformanceEntryCommand = param1.getBody() as TrainingArenaPerformanceEntryCommand;
         tgProxy.setPerformanceEntry(_loc2_);
      }
   }
}

