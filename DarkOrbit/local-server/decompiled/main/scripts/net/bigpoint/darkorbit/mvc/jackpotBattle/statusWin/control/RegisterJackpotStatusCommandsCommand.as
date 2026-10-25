package net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.control
{
   import net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.JackpotBattleNotification;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class RegisterJackpotStatusCommandsCommand extends SimpleCommand
   {
      
      public function RegisterJackpotStatusCommandsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         if(!facade.hasCommand(JackpotBattleNotification.START_UP))
         {
            facade.registerCommand(JackpotBattleNotification.START_UP,JackpotStatusStartupCommand);
         }
         if(!facade.hasCommand(JackpotBattleNotification.CLEAN_UP))
         {
            facade.registerCommand(JackpotBattleNotification.CLEAN_UP,JackpotStatusCleanupCommand);
         }
      }
   }
}

