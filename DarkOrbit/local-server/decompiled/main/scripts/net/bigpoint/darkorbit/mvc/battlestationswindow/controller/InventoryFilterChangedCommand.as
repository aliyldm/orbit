package net.bigpoint.darkorbit.mvc.battlestationswindow.controller
{
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationConstants;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationNotification;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationProxy;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.InventoryFilterOptionVO;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.ModuleVO;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.BattleStationWindowViewMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class InventoryFilterChangedCommand extends SimpleCommand
   {
      
      public function InventoryFilterChangedCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         this.bsProxy.availableModules.filterFunction = this.filter;
         this.bsProxy.availableModules.refresh();
         sendNotification(BattleStationNotification.UPDATE_USER_INVENTORY,this.bsProxy.availableModules,BattleStationConstants.FILTER_CHANGE);
      }
      
      private function filter(param1:ModuleVO) : Boolean
      {
         return this.isCategorySelected(param1.category);
      }
      
      private function isCategorySelected(param1:String) : Boolean
      {
         var _loc2_:InventoryFilterOptionVO = null;
         for each(_loc2_ in this.bsProxy.inventoryFilterOptions)
         {
            if(_loc2_.category == param1)
            {
               return _loc2_.selected;
            }
         }
         return false;
      }
      
      protected function get bsProxy() : BattleStationProxy
      {
         return facade.retrieveProxy(BattleStationProxy.NAME) as BattleStationProxy;
      }
      
      private function get bsWindowMediator() : BattleStationWindowViewMediator
      {
         return facade.retrieveProxy(BattleStationWindowViewMediator.NAME) as BattleStationWindowViewMediator;
      }
   }
}

