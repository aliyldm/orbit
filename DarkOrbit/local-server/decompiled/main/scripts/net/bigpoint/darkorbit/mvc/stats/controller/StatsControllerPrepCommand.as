package net.bigpoint.darkorbit.mvc.stats.controller
{
   import net.bigpoint.darkorbit.mvc.stats.StatsNotifications;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class StatsControllerPrepCommand extends SimpleCommand implements ICommand
   {
      
      public function StatsControllerPrepCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         facade.registerCommand(StatsNotifications.SET_PARAM,SetParamCommand);
      }
   }
}

