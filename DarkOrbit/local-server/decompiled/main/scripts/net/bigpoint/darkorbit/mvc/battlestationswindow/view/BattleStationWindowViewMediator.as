package net.bigpoint.darkorbit.mvc.battlestationswindow.view
{
   import com.greensock.TweenLite;
   import mx.collections.ArrayCollection;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationConstants;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationNotification;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationProxy;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationVO;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.DeflectorStatusVO;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.ModuleVO;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.events.BattleStationWindowEvent;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.inventoryFilter.InventoryFilterMediator;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.inventoryFilter.components.PopUpWithInventoryFilter;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class BattleStationWindowViewMediator extends Mediator implements IBattleStationWindowMediator
   {
      
      public static const NAME:String = "BattleStationWindowViewMediator";
      
      public function BattleStationWindowViewMediator(param1:Object = null)
      {
         super(NAME,param1);
         mediatorName = NAME;
         this.setViewComponent(param1);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.view.moduleInventoryView.addEventListener(BattleStationWindowEvent.SHOW_INVENTORY_FILTER_POPUP,this.showInventoryPopupHandler);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [BattleStationNotification.INIT_BATTLE_STATION_BUILD_WINDOW,BattleStationNotification.INIT_BATTLE_STATION_MANAGEMENT_WINDOW,BattleStationNotification.EQUIP_MODULE_TO_ASTEROID_SLOT,BattleStationNotification.UNEQUIP_MODULE_FROM_ASTEROID_SLOT,BattleStationNotification.DISPLAY_ERROR_MESSAGE,BattleStationNotification.UPDATE_USER_INVENTORY,BattleStationNotification.UPDATE_DEFLECTOR_TIME_PROGRESS,BattleStationNotification.UPDATE_MODULE_HITPOINTS_AND_SHIELD,BattleStationNotification.UPDATE_INSTALLED_MODULES,BattleStationNotification.FILTER_INVENTORY];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Array = null;
         var _loc5_:BattleStationVO = null;
         var _loc6_:ArrayCollection = null;
         var _loc7_:DeflectorStatusVO = null;
         var _loc8_:ModuleVO = null;
         var _loc3_:String = param1.getName();
         var _loc4_:Object = param1.getBody();
         switch(_loc3_)
         {
            case BattleStationNotification.INIT_BATTLE_STATION_BUILD_WINDOW:
               _loc5_ = param1.getBody() as BattleStationVO;
               this.view.initBuildView(_loc5_,this.battleStationProxy.availableModules,this.battleStationProxy.buildMinMaxIncrement);
               this.updateFilterButtonState();
               break;
            case BattleStationNotification.INIT_BATTLE_STATION_MANAGEMENT_WINDOW:
               _loc5_ = param1.getBody() as BattleStationVO;
               this.view.initManagementView(_loc5_,this.battleStationProxy.availableModules,this.battleStationProxy.deflectorMinMaxIncrement);
               this.updateFilterButtonState();
               break;
            case BattleStationNotification.UPDATE_INSTALLED_MODULES:
               _loc5_ = param1.getBody() as BattleStationVO;
               this.view.initManagementView(_loc5_,this.battleStationProxy.availableModules,this.battleStationProxy.deflectorMinMaxIncrement,false);
               break;
            case BattleStationNotification.EQUIP_MODULE_TO_ASTEROID_SLOT:
               _loc2_ = _loc4_ as Array;
               this.view.addModuleToAsteroid(_loc2_[1]);
               break;
            case BattleStationNotification.UNEQUIP_MODULE_FROM_ASTEROID_SLOT:
               _loc2_ = _loc4_ as Array;
               this.view.removeModuleFromAsteroid(_loc2_[1]);
               break;
            case BattleStationNotification.UPDATE_USER_INVENTORY:
               if(param1.getType() == BattleStationConstants.FILTER_CHANGE)
               {
                  TweenLite.killTweensOf(this.view.moduleInventoryView.moduleItemList);
                  this.view.moduleInventoryView.moduleItemList.alpha = 0;
                  TweenLite.to(this.view.moduleInventoryView.moduleItemList,0.3,{
                     "delay":0.3,
                     "alpha":1
                  });
               }
               _loc6_ = param1.getBody() as ArrayCollection;
               this.view.moduleInventoryView.setPlayerModules(_loc6_);
               break;
            case BattleStationNotification.DISPLAY_ERROR_MESSAGE:
               this.view.displayErrorMessage(_loc4_ as int);
               break;
            case BattleStationNotification.UPDATE_DEFLECTOR_TIME_PROGRESS:
               _loc7_ = param1.getBody() as DeflectorStatusVO;
               this.view.ratingsView.updateDeflectorTimeProgress(_loc7_.deflectorShieldActive,_loc7_.deflectorShieldSeconds,_loc7_.deflectorShieldSecondsMax,_loc7_.deflectorShieldRate);
               break;
            case BattleStationNotification.UPDATE_MODULE_HITPOINTS_AND_SHIELD:
               _loc8_ = param1.getBody() as ModuleVO;
               this.view.moduleInstallationView.updateInstalledModule(_loc8_);
               break;
            case BattleStationNotification.FILTER_INVENTORY:
               this.updateFilterButtonState();
         }
      }
      
      private function updateFilterButtonState() : void
      {
         var _loc1_:Boolean = this.battleStationProxy.isAnyFilterOptionUnselected;
         this.view.moduleInventoryView.filterBtnNormal.visible = !_loc1_;
         this.view.moduleInventoryView.filterBtnActive.visible = _loc1_;
      }
      
      private function showInventoryPopupHandler(param1:BattleStationWindowEvent) : void
      {
         var _loc2_:PopUpWithInventoryFilter = PopUpWithInventoryFilter(FlexWindowManager.getInstance().createWindow(FlexWindowManager.BS_POP_UP_WITH_INVENTORY_FILTER,FlexWindowManager.WINDOW_RIGHT_ALIGNED));
         _loc2_.y = this.view.y;
         _loc2_.x = this.view.x < this.view.stage.width / 2 ? this.view.x - this.view.width - 17 : this.view.x + this.view.width + 17;
         if(!facade.hasMediator(InventoryFilterMediator.NAME))
         {
            facade.registerMediator(new InventoryFilterMediator(_loc2_));
         }
      }
      
      override public function setViewComponent(param1:Object) : void
      {
         this.view.handler = this;
      }
      
      private function get battleStationProxy() : BattleStationProxy
      {
         return facade.retrieveProxy(BattleStationProxy.NAME) as BattleStationProxy;
      }
      
      protected function get view() : BattleStationBuildWindowView
      {
         return viewComponent as BattleStationBuildWindowView;
      }
      
      public function equipModuleToSlot(param1:int, param2:int, param3:int, param4:Boolean = false) : void
      {
         sendNotification(BattleStationNotification.REQUEST_EQUIP_MODULE_TO_ASTEROID_SLOT,[param1,param2,param3,param4]);
      }
      
      public function removeEquippedModule(param1:int, param2:int) : void
      {
         sendNotification(BattleStationNotification.REQUEST_UNEQUIP_MODULE_FROM_ASTEROID_SLOT,[param1,param2]);
      }
      
      public function requestBuildBattleStation(param1:int, param2:int) : void
      {
         sendNotification(BattleStationNotification.REQUEST_BEGIN_BATTLE_STATION_CONSTRUCTION,[param1,param2]);
      }
      
      public function requestDeactivationDeflector(param1:int, param2:int) : void
      {
         sendNotification(BattleStationNotification.REQUEST_DEACTIVATE_DEFLECTOR,[param1,param2]);
      }
      
      public function sendRepairModuleRequest(param1:int, param2:int) : void
      {
         sendNotification(BattleStationNotification.REQUEST_REPAIR_MODULE,[param1,param2]);
      }
   }
}

