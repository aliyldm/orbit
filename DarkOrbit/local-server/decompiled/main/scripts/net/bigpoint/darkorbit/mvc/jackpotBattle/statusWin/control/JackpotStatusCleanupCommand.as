package net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.control
{
   import net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.JackpotBattleNotification;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.model.JackpotStatusProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class JackpotStatusCleanupCommand extends SimpleCommand
   {
      
      public function JackpotStatusCleanupCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         facade.removeProxy(JackpotStatusProxy.NAME);
         facade.removeCommand(JackpotBattleNotification.CLEAN_UP);
         facade.removeCommand(JackpotBattleNotification.START_UP);
      }
   }
}

