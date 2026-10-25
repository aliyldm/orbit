package net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.inventoryFilter
{
   import flash.events.Event;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationConstants;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationNotification;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationProxy;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.InventoryFilterOptionVO;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.inventoryFilter.components.FilterOptionButton;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.inventoryFilter.components.FilterOptionButtonBase;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.inventoryFilter.components.PopUpWithInventoryFilter;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class InventoryFilterMediator extends Mediator
   {
      
      public static const NAME:String = "InventoryFilterMediator";
      
      private var _optionsMap:Dictionary;
      
      public function InventoryFilterMediator(param1:PopUpWithInventoryFilter)
      {
         super(NAME,param1);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this._optionsMap = new Dictionary(true);
         this.view.addEventListener(DOWindow.CLOSE_WINDOW_CLICKED,this.closeWindowClickHandler);
         this.initFilterOptions();
      }
      
      override public function listNotificationInterests() : Array
      {
         return [GuiNotifications.CLOSE_WINDOW_BY_TYPE];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case GuiNotifications.CLOSE_WINDOW_BY_TYPE:
               if(param1.getBody() == FlexWindowManager.BATTLE_STATION_BUILD_WINDOW)
               {
                  this.closeWindowClickHandler();
                  sendNotification(GuiNotifications.CLOSE_WINDOW_BY_TYPE,FlexWindowManager.BS_POP_UP_WITH_INVENTORY_FILTER);
               }
         }
      }
      
      private function initFilterOptions() : void
      {
         var _loc3_:InventoryFilterOptionVO = null;
         var _loc4_:FilterOptionButton = null;
         var _loc1_:int = int(this.bsProxy.inventoryFilterOptions.length);
         var _loc2_:int = 0;
         while(_loc2_ != _loc1_)
         {
            _loc3_ = this.bsProxy.inventoryFilterOptions[_loc2_];
            _loc4_ = new FilterOptionButton();
            _loc4_.label = BPLocale.getItem("popup_bswin_module_filter_" + _loc3_.category);
            _loc4_.selected = _loc3_.selected;
            _loc4_.evenRow = _loc2_ % 2 == 1;
            _loc4_.addEventListener(FilterOptionButtonBase.FILTER_OPTION_CLICKED,this.filterOptionClickHandler);
            this.view.optionsContainer.addElement(_loc4_);
            this._optionsMap[_loc4_] = _loc3_;
            _loc2_++;
         }
      }
      
      private function filterOptionClickHandler(param1:Event) : void
      {
         var _loc3_:InventoryFilterOptionVO = null;
         var _loc2_:FilterOptionButton = param1.target as FilterOptionButton;
         if(_loc2_)
         {
            _loc3_ = this._optionsMap[_loc2_];
            if(_loc3_.category == BattleStationConstants.SHOW_ALL)
            {
               this.toogleAllButtons(!_loc3_.selected);
            }
            else
            {
               _loc2_.selected = _loc3_.selected = !_loc3_.selected;
            }
            sendNotification(BattleStationNotification.FILTER_INVENTORY);
         }
      }
      
      private function toogleAllButtons(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         var _loc3_:InventoryFilterOptionVO = null;
         for(_loc2_ in this._optionsMap)
         {
            _loc3_ = this._optionsMap[_loc2_];
            FilterOptionButton(_loc2_).selected = _loc3_.selected = param1;
         }
      }
      
      private function closeWindowClickHandler(param1:Event = null) : void
      {
         facade.removeMediator(NAME);
      }
      
      protected function get bsProxy() : BattleStationProxy
      {
         return facade.retrieveProxy(BattleStationProxy.NAME) as BattleStationProxy;
      }
      
      protected function get view() : PopUpWithInventoryFilter
      {
         return viewComponent as PopUpWithInventoryFilter;
      }
   }
}

