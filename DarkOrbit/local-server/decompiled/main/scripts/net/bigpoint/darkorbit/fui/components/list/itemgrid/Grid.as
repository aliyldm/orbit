package net.bigpoint.darkorbit.fui.components.list.itemgrid
{
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.list.IList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollDirection;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollEvent;
   
   public class Grid extends ItemList implements IList
   {
      
      private var _scrollDir:uint = 1;
      
      public function Grid()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
      }
      
      override protected function initializeItemsLayout() : void
      {
         _itemsLayout = new GridItemListLayout(this,_itemsContainer);
      }
      
      override protected function calcScrollOffset(param1:Number) : uint
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc2_:uint = super.calcScrollOffset(param1);
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(this.scrollDirection == ScrollDirection.DIRECTION_VERTICAL)
         {
            _loc5_ = uint(this.__layout.getVisibleItemsCountX());
            _loc6_ = Math.floor(_loc2_ / _loc5_) * _loc5_;
            _loc7_ = Math.ceil(_loc2_ / _loc5_) * _loc5_;
            _loc3_ = _loc2_ - _loc7_;
            if(_loc3_ > 0)
            {
               _loc4_ = _loc7_;
            }
            else
            {
               _loc4_ = _loc6_;
            }
         }
         if(this.scrollDirection == ScrollDirection.DIRECTION_HORIZONTAL)
         {
            _loc8_ = uint(this.__layout.getVisibleItemsCountX());
            _loc9_ = Math.floor(_loc2_ / _loc8_) * _loc8_;
            _loc3_ = _loc2_ - _loc9_;
            _loc10_ = Math.ceil(_loc2_ / _loc8_) * _loc8_;
            _loc11_ = _loc10_ - _loc2_;
            if(_loc3_ > 0)
            {
               _loc4_ = _loc10_;
            }
            else
            {
               _loc4_ = _loc9_;
            }
         }
         return _loc4_;
      }
      
      override protected function calculateViewToContentSizeRatio() : void
      {
         var _loc1_:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLLCONTAINER_VERTICAL_SIZE_CHANGED);
         _loc1_.contentSize = _itemList.length;
         _loc1_.viewSize = this.__layout.getVisibleItemsCountX() * this.__layout.getVisibleItemsCountY();
         dispatchEvent(_loc1_);
      }
      
      public function set itemGapX(param1:uint) : void
      {
         this.__layout.gapX = param1;
         invalidate(InvalidationType.LAYOUT);
      }
      
      public function set itemGapY(param1:uint) : void
      {
         this.__layout.gapY = param1;
         invalidate(InvalidationType.LAYOUT);
      }
      
      public function set itemAlignX(param1:String) : void
      {
         this.__layout.alignmentX = param1;
         invalidate(InvalidationType.LAYOUT);
      }
      
      public function get __layout() : GridItemListLayout
      {
         return _itemsLayout as GridItemListLayout;
      }
      
      public function get totalPage() : Number
      {
         if(_itemList == null || _itemsLayout == null)
         {
            return 0;
         }
         return Math.ceil(_itemList.length / _itemsLayout.pageSize);
      }
      
      public function get currentPage() : Number
      {
         if(_itemList == null || _itemsLayout == null)
         {
            return 0;
         }
         return Math.ceil(getOffset() / _itemsLayout.pageSize) + 1;
      }
      
      public function set scrollDirection(param1:uint) : void
      {
         this._scrollDir = param1;
      }
      
      public function get scrollDirection() : uint
      {
         return this._scrollDir;
      }
   }
}

