package net.bigpoint.darkorbit.mvc.battlestationswindow.controller
{
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class UnEquipModuleFromBattleStationCommand extends SimpleCommand
   {
      
      public function UnEquipModuleFromBattleStationCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:BattleStationProxy = facade.retrieveProxy(BattleStationProxy.NAME) as BattleStationProxy;
         var _loc3_:Array = param1.getBody() as Array;
         _loc2_.requestUnEquipModuleFromAsteroid(_loc3_);
      }
   }
}

