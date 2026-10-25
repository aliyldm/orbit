package net.bigpoint.darkorbit.mvc.traininggrounds.controller
{
   import net.bigpoint.darkorbit.mvc.epicMessages.model.EpicFightMessageProxy;
   import net.bigpoint.darkorbit.mvc.epicMessages.view.EpicFightMessageContainer;
   import net.bigpoint.darkorbit.mvc.epicMessages.view.EpicFightMessageMediator;
   import net.bigpoint.darkorbit.mvc.traininggrounds.TraininggroundsResultsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.traininggrounds.TraininggroundsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.TraininggroundsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class InitTraininggroundsSystemCommand extends SimpleCommand
   {
      
      public function InitTraininggroundsSystemCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         facade.registerProxy(new TraininggroundsProxy());
         facade.registerProxy(new EpicFightMessageProxy());
         facade.registerMediator(new EpicFightMessageMediator(EpicFightMessageMediator.NAME,new EpicFightMessageContainer()));
         facade.registerCommand(TraininggroundsWindowNotifications.UPDATE_FIGHT_PHASE_INFO,UpdateFightStateCommand);
         facade.registerCommand(TraininggroundsWindowNotifications.CREATE_WINDOW,CreateTraininggroundsWindowCommand);
         facade.registerCommand(TraininggroundsResultsWindowNotifications.CREATE_WINDOW,CreateTraininggroundsResultsWindowCommand);
      }
   }
}

