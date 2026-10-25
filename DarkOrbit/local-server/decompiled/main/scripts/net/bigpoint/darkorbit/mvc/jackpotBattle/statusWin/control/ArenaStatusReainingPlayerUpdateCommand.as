package net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.control
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.ArenaSurvivorsUpdateCommand;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.JackpotBattleNotification;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class ArenaStatusReainingPlayerUpdateCommand extends SimpleCommand
   {
      
      public function ArenaStatusReainingPlayerUpdateCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:ArenaSurvivorsUpdateCommand = param1.getBody() as ArenaSurvivorsUpdateCommand;
         var _loc3_:PointLite = new PointLite(_loc2_.survivors,_loc2_.participants);
         sendNotification(JackpotBattleNotification.UPDATE_REMAINING_PLAYER,_loc3_);
      }
   }
}

