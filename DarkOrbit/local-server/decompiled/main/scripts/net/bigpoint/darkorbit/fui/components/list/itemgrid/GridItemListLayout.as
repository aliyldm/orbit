package net.bigpoint.darkorbit.fui.components.list.itemgrid
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.layout.Alignment;
   import net.bigpoint.darkorbit.fui.components.list.layouts.AbstractItemListLayout;
   
   public class GridItemListLayout extends AbstractItemListLayout
   {
      
      protected var _itemSizeWidth:Number;
      
      protected var _itemSizeHeight:Number;
      
      protected var _itemGapX:Number = 0;
      
      protected var _itemGapY:Number = 0;
      
      protected var _itemsCountX:Number;
      
      protected var _itemsCountY:Number;
      
      protected var _itemAlignment:Alignment;
      
      protected var _invalidItemsCountXCalculation:Boolean = true;
      
      protected var _invalidItemsCountYCalculation:Boolean = true;
      
      public function GridItemListLayout(param1:Container = null, param2:Container = null)
      {
         super(param1,param2);
         this._itemAlignment = new Alignment(param1);
         this._itemAlignment.alignmentX = Alignment.CENTER_X;
      }
      
      override public function execute(param1:DisplayObjectContainer = null) : void
      {
         this.layoutItems();
      }
      
      override protected function handleItemsContainerSizeChangedEvent(param1:Event) : void
      {
         this._invalidItemsCountXCalculation = true;
         this._invalidItemsCountYCalculation = true;
      }
      
      protected function layoutItems() : void
      {
         var _loc3_:ICoreponent = null;
         var _loc7_:uint = 0;
         var _loc1_:uint = uint(this.getVisibleItemsCountX());
         var _loc2_:uint = uint(this.getVisibleItemsCountY());
         var _loc4_:int = 0;
         var _loc5_:int = this.calculateOffsetInLastRow();
         var _loc6_:uint = 0;
         while(_loc6_ < _loc2_)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc1_)
            {
               if(!this.doLayoutCondition(_itemsContainer,_loc4_))
               {
                  return;
               }
               _loc3_ = _itemsContainer.getChildAt(_loc4_) as ICoreponent;
               if(!_loc3_)
               {
                  return;
               }
               if(_loc6_ + 1 == this.lastRow)
               {
                  _loc3_.x = this.sigmaItemSizeWidth * (_loc5_ + _loc7_);
               }
               else
               {
                  _loc3_.x = this.sigmaItemSizeWidth * _loc7_;
               }
               _loc3_.y = this.sigmaItemSizeHeight * _loc6_;
               _loc3_.forceRedraw(InvalidationType.POSITION);
               _loc4_++;
               _loc7_++;
            }
            _loc6_++;
         }
      }
      
      protected function doLayoutCondition(... rest) : Boolean
      {
         var _loc2_:Sprite = rest[0] as Sprite;
         var _loc3_:uint = uint(rest[1] as int);
         return _loc3_ < _loc2_.numChildren ? true : false;
      }
      
      protected function calculateOffsetInLastRow() : int
      {
         switch(this._itemAlignment.alignmentX)
         {
            case Alignment.LEFT:
               return 0;
            default:
            case Alignment.CENTER_X:
               return (this.getVisibleItemsCountX() - _target.list.length % this.getVisibleItemsCountX()) / 2;
            case Alignment.RIGHT:
               return this.getVisibleItemsCountX();
         }
      }
      
      protected function get lastRow() : int
      {
         return _target.list.length / this.getVisibleItemsCountX() + 1;
      }
      
      override public function get pageSize() : Number
      {
         var _loc1_:uint = 0;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         _loc2_ = _target.getCalculatedHeight() + this._itemGapY;
         _loc3_ = this.sigmaItemSizeHeight;
         _loc4_ = _target.getCalculatedWidth() + this._itemGapX;
         _loc5_ = this.sigmaItemSizeWidth;
         var _loc6_:Number = Math.floor(_loc2_ / _loc3_);
         var _loc7_:Number = Math.floor(_loc4_ / _loc5_);
         return uint(_loc6_ * _loc7_);
      }
      
      public function get sigmaItemSizeHeight() : Number
      {
         return this._itemGapY + this._itemSizeHeight;
      }
      
      public function get sigmaItemSizeWidth() : Number
      {
         return this._itemGapX + this._itemSizeWidth;
      }
      
      public function getVisibleItemsCountX() : int
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(this._invalidItemsCountXCalculation)
         {
            _loc1_ = _target.getCalculatedWidth() + this._itemGapX;
            _loc2_ = _loc1_ % this.sigmaItemSizeWidth;
            this._itemsCountX = (_loc1_ - _loc2_) / this.sigmaItemSizeWidth;
            this._invalidItemsCountXCalculation = false;
         }
         return this._itemsCountX;
      }
      
      public function getVisibleItemsCountY() : int
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(this._invalidItemsCountYCalculation)
         {
            _loc1_ = _target.getCalculatedHeight() + this._itemGapY;
            _loc2_ = _loc1_ % this.sigmaItemSizeHeight;
            this._itemsCountY = (_loc1_ - _loc2_) / this.sigmaItemSizeHeight;
            this._invalidItemsCountYCalculation = false;
         }
         return this._itemsCountY;
      }
      
      override public function getVisibleItemsCount() : int
      {
         var _loc1_:uint = uint(this.getVisibleItemsCountX());
         var _loc2_:uint = uint(this.getVisibleItemsCountY());
         return _loc1_ * _loc2_;
      }
      
      override public function set itemsContainer(param1:Container) : void
      {
         super.itemsContainer = param1;
         if(_itemsContainer)
         {
            _itemsContainer.autoSizeWidth = true;
            _itemsContainer.autoSizeHeight = true;
         }
      }
      
      override public function assignItemSize(param1:Coreponent) : void
      {
         this._itemSizeWidth = param1.getCalculatedWidth();
         this._itemSizeHeight = param1.getCalculatedHeight();
      }
      
      override public function set gap(param1:uint) : void
      {
         this.gapX = param1;
         this.gapY = param1;
      }
      
      public function set gapX(param1:uint) : void
      {
         this._itemGapX = param1;
      }
      
      public function set gapY(param1:uint) : void
      {
         this._itemGapY = param1;
      }
      
      public function set alignmentX(param1:String) : void
      {
         this._itemAlignment.alignmentX = param1;
      }
      
      override public function get sigmaItemSize() : Number
      {
         return this._itemSizeHeight;
      }
   }
}

