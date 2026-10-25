package net.bigpoint.darkorbit.net.netty.handlers.traininggrounds
{
   import net.bigpoint.darkorbit.com.module.TrainingArenaPerformanceInfoCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TrainingArenaPerformanceInfoHandler extends DOAbstractSimpleCommand
   {
      
      public function TrainingArenaPerformanceInfoHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:TrainingArenaPerformanceInfoCommand = param1.getBody() as TrainingArenaPerformanceInfoCommand;
         tgProxy.setPerformanceInfo(_loc2_);
      }
   }
}

