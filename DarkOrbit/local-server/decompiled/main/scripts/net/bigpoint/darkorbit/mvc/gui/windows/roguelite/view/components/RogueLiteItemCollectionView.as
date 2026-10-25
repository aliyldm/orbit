package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.Grid;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.GridItemListLayout;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   
   public class RogueLiteItemCollectionView
   {
      
      private var _container:Container;
      
      private var _slots:Label;
      
      private var _equipped:Label;
      
      private var _items:Grid;
      
      private var _collection:VectorCollection;
      
      public function RogueLiteItemCollectionView(param1:Container)
      {
         super();
         this._container = param1;
      }
      
      public function init() : void
      {
         this._slots = FuiComponentSelectorUtil.selectComponent("slots",this._container) as Label;
         this._equipped = FuiComponentSelectorUtil.selectComponent("equipped",this._container) as Label;
         this._items = FuiComponentSelectorUtil.selectComponent("items",this._container) as Grid;
         if(this._items)
         {
            this._collection = new VectorCollection(null);
            this._items.list = this._collection;
            this._items.itemDataAssigner = EquipmentItemAssigner;
         }
      }
      
      public function update(param1:Vector.<ItemVO>) : void
      {
         this._collection.collection = param1;
         this._equipped.text = this._collection.length.toString();
         var _loc2_:GridItemListLayout = this._items.layout as GridItemListLayout;
         var _loc3_:int = Math.ceil(this._collection.length / _loc2_.getVisibleItemsCountX());
         this._items.itemsContainer.dispatchEvent(new Event(Coreponent.EVENT_SIZE_CHANGED));
         this._items.height = this._items.itemHeight + _loc2_.sigmaItemSizeHeight * (_loc3_ - 1);
         var _loc4_:int = 15;
         if(this._slots)
         {
            _loc4_ += this._slots.height;
         }
         if(this._equipped)
         {
            _loc4_ += this._equipped.height;
         }
         if(this._items)
         {
            _loc4_ += this._items.height;
         }
         this._container.height = _loc4_;
      }
      
      public function set slots(param1:int) : void
      {
         if(this._slots)
         {
            this._slots.text = param1.toString();
         }
      }
      
      public function set marginTop(param1:int) : void
      {
         this._container.marginTop = param1;
      }
      
      public function get marginTop() : int
      {
         return this._container.marginTop;
      }
      
      public function set height(param1:int) : void
      {
         this._container.height = param1;
      }
      
      public function get height() : int
      {
         return this._container.height;
      }
   }
}

