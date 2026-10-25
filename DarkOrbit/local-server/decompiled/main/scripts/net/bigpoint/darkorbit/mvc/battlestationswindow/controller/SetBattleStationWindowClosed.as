package net.bigpoint.darkorbit.mvc.battlestationswindow.controller
{
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class SetBattleStationWindowClosed extends SimpleCommand
   {
      
      public function SetBattleStationWindowClosed()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:BattleStationProxy = facade.retrieveProxy(BattleStationProxy.NAME) as BattleStationProxy;
         _loc2_.setBattleStationUIClosed();
      }
   }
}

