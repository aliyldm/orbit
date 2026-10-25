package net.bigpoint.darkorbit.net.netty.handlers.traininggrounds
{
   import net.bigpoint.darkorbit.com.module.TrainingArenaRankInfoCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TrainingArenaRankInfoHandler extends DOAbstractSimpleCommand
   {
      
      public function TrainingArenaRankInfoHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:TrainingArenaRankInfoCommand = param1.getBody() as TrainingArenaRankInfoCommand;
         tgProxy.setRankInfo(_loc2_);
      }
   }
}

