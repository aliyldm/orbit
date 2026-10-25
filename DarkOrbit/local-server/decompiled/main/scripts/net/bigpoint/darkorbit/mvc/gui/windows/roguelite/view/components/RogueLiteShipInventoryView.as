package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.items.item.attributes.ShipAttributes;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ExtendedTabView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteShipVO;
   
   public class RogueLiteShipInventoryView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _shipVO:RogueLiteShipVO;
      
      private var _tabView:ExtendedTabView;
      
      private var _shipEquip:RogueLiteShipEquipmentView;
      
      private var _dronesEquip:RogueLiteDronesEquipmentView;
      
      public function RogueLiteShipInventoryView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._tabView = new ExtendedTabView(this.root,RogueLiteShipTabAssigner);
         this._tabView.tabItems = new <ITabItem>[this._shipEquip = new RogueLiteShipEquipmentView(this.root),this._dronesEquip = new RogueLiteDronesEquipmentView(this.root)];
      }
      
      public function set shipVO(param1:RogueLiteShipVO) : void
      {
         this._shipVO = param1;
         this._shipEquip.hp = param1.hp;
         this._shipEquip.shield = param1.shield;
         this._shipEquip.spread = param1.spread;
         this._shipEquip.speed = param1.speed;
         this._shipEquip.shipAttributes = param1.shipVO.item.attributes as ShipAttributes;
         this._shipEquip.equipments = param1.shipEquipmentVO;
         this._dronesEquip.dronesVO = param1.dronesVO;
      }
      
      public function get root() : Coreponent
      {
         return this._cache.selectComponent("describe_ship.equipment_body") as Coreponent;
      }
      
      public function resetTab() : void
      {
         this._tabView.tabbar.selectedIndex = 0;
      }
   }
}

