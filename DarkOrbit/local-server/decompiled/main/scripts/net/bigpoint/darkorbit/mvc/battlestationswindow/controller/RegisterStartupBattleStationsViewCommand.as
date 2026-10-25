package net.bigpoint.darkorbit.mvc.battlestationswindow.controller
{
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationNotification;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class RegisterStartupBattleStationsViewCommand extends SimpleCommand
   {
      
      public function RegisterStartupBattleStationsViewCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         facade.registerCommand(BattleStationNotification.REQUEST_EQUIP_MODULE_TO_ASTEROID_SLOT,EquipModuleToBattleStationCommand);
         facade.registerCommand(BattleStationNotification.REQUEST_UNEQUIP_MODULE_FROM_ASTEROID_SLOT,UnEquipModuleFromBattleStationCommand);
         facade.registerCommand(BattleStationNotification.REQUEST_BEGIN_BATTLE_STATION_CONSTRUCTION,RequestBeginBattleStationBuildCommand);
         facade.registerCommand(BattleStationNotification.REQUEST_DEACTIVATE_DEFLECTOR,RequestDeactivateDeflectorCommand);
         facade.registerCommand(BattleStationNotification.REQUEST_REPAIR_MODULE,RequestRepairModuleCommand);
         facade.registerCommand(BattleStationNotification.BATTLE_STATION_ASSET_CLICKED,HandleBattleStationAssetClicked);
         facade.registerCommand(BattleStationNotification.INIT_BATTLESTATION_UI,InitBattlestationUICommand);
         facade.registerCommand(BattleStationNotification.FILTER_INVENTORY,InventoryFilterChangedCommand);
         facade.registerCommand(GuiNotifications.NOTIFY_WINDOW_TYPE_CLOSED + FlexWindowManager.BATTLE_STATION_BUILD_WINDOW,SetBattleStationWindowClosed);
      }
   }
}

