package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Sprite;
   import flash.events.Event;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.Grid;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.GridItemListLayout;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollContainer;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteDroneVO;
   
   public class RogueLiteDronesEquipmentView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      private var _content:Grid;
      
      private var _scrollbinder:RogueLiteScrollBinder;
      
      private var _dronesVO:Vector.<RogueLiteDroneVO>;
      
      private var _collection:VectorCollection;
      
      public function RogueLiteDronesEquipmentView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("drones") as Coreponent;
         this.init();
      }
      
      public function get title() : String
      {
         return BPLocale.getItemInCategory("inventory","label_tab_drones");
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
      
      public function set dronesVO(param1:Vector.<RogueLiteDroneVO>) : void
      {
         this._dronesVO = param1;
         this._collection.collection = param1;
         var _loc2_:GridItemListLayout = this._content.layout as GridItemListLayout;
         var _loc3_:int = Math.ceil(this._collection.length / _loc2_.getVisibleItemsCountX());
         this._content.itemsContainer.dispatchEvent(new Event(Coreponent.EVENT_SIZE_CHANGED));
         this._content.height = this._content.itemHeight + _loc2_.sigmaItemSizeHeight * (_loc3_ - 1) + 1;
      }
      
      private function init() : void
      {
         this._content = this._cache.selectComponent("drones.attributes.content") as Grid;
         var _loc1_:Scrollbar = this._cache.selectComponent("drones.drones_scrollBar") as Scrollbar;
         var _loc2_:ScrollContainer = this._cache.selectComponent("drones.attributes") as ScrollContainer;
         this._scrollbinder = new RogueLiteScrollBinder(_loc1_,_loc2_);
         this._collection = new VectorCollection(null);
         this._content.list = this._collection;
         this._content.itemDataAssigner = DroneItemAssigner;
      }
   }
}

