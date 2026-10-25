package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteShipVO;
   
   public class RogueLiteShipSelectionView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      private var _shipListView:RogueLiteShipListView;
      
      private var _shipDescriptionView:RogueLiteShipDescriptionView;
      
      private var _shipEquipmentView:RogueLiteShipInventoryView;
      
      private var _selectLoadoutButton:Button;
      
      public function RogueLiteShipSelectionView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("root.ship_select_body") as Coreponent;
         this._shipListView = new RogueLiteShipListView(this._view);
         this._shipListView.addSelectionChangeListener(this.onShipSelectChange);
         this._shipDescriptionView = new RogueLiteShipDescriptionView(this._view);
         this._shipEquipmentView = new RogueLiteShipInventoryView(this._view);
      }
      
      public function get title() : String
      {
         return "astral_ascension_tab_spaceship_select";
      }
      
      public function get view() : Coreponent
      {
         return this._view;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._view.visible = param1;
      }
      
      public function get visible() : Boolean
      {
         return this._view.visible;
      }
      
      public function set active(param1:Boolean) : void
      {
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      public function get selectLoadoutButton() : Button
      {
         if(!this._selectLoadoutButton)
         {
            this._selectLoadoutButton = this._cache.selectComponent("root.ship_select_body.describe_ship.equipment_body.bottom.select_button") as Button;
         }
         return this._selectLoadoutButton;
      }
      
      public function get selectedLoadoutId() : String
      {
         return (this._shipListView.selectedItem as RogueLiteShipVO).loadoutId;
      }
      
      public function set shipChoices(param1:Vector.<RogueLiteShipVO>) : void
      {
         this._shipListView.list = param1;
         this._shipListView.selectedIndex = 0;
         this.displayShip(this._shipListView.selectedItem as RogueLiteShipVO);
         this._shipEquipmentView.resetTab();
      }
      
      private function onShipSelectChange(param1:ItemListEvent) : void
      {
         var _loc2_:RogueLiteShipVO = param1.itemVO as RogueLiteShipVO;
         if(_loc2_ == null)
         {
            return;
         }
         this.displayShip(_loc2_);
      }
      
      private function displayShip(param1:RogueLiteShipVO) : *
      {
         this._shipDescriptionView.shipVO = param1;
         this._shipEquipmentView.shipVO = param1;
      }
   }
}

