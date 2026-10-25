package net.bigpoint.darkorbit.net.netty.handlers.traininggrounds
{
   import net.bigpoint.darkorbit.com.module.TrainingArenaSeasonInfoCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TrainingArenaSeasonInfoHandler extends DOAbstractSimpleCommand
   {
      
      public function TrainingArenaSeasonInfoHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:TrainingArenaSeasonInfoCommand = param1.getBody() as TrainingArenaSeasonInfoCommand;
         tgProxy.setSeasonInfo(_loc2_);
      }
   }
}

