package net.bigpoint.darkorbit.mvc.battlestationswindow.controller
{
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class RequestBeginBattleStationBuildCommand extends SimpleCommand
   {
      
      public function RequestBeginBattleStationBuildCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:BattleStationProxy = facade.retrieveProxy(BattleStationProxy.NAME) as BattleStationProxy;
         var _loc3_:Array = param1.getBody() as Array;
         _loc2_.requestBeginBuildBattleStation(_loc3_);
      }
   }
}

