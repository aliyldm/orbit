package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class RogueLiteShipListView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function RogueLiteShipListView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this.itemList.itemDataAssigner = RogueLiteShipDataAssigner;
      }
      
      public function get itemList() : ItemList
      {
         return this._cache.selectComponent("select_ship.shiplist") as ItemList;
      }
      
      public function addSelectionChangeListener(param1:Function) : void
      {
         this.itemList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,param1);
         this.itemList.addEventListener(ItemListEvent.ITEMS_SELECTION_CHANGED,param1);
      }
      
      public function set selectedIndex(param1:int) : void
      {
         this.itemList.selectedIndex = param1;
      }
      
      public function get selectedItem() : Object
      {
         return this.itemList.selectedItemData;
      }
      
      public function set list(param1:Object) : void
      {
         this.itemList.list = new VectorCollection(param1);
         this.itemList.width = this.itemList.list.length * 100 + (this.itemList.list.length - 1) * this.itemList.itemGap;
      }
   }
}

