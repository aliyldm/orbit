package net.bigpoint.darkorbit.mvc.gui.windows.battlePass.view.components
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollEvent;
   
   public class BattlePassObjectiveList extends ItemList
   {
      
      private static const CONTENT_BOTTOM_PADDING:Number = 2;
      
      private var _contentHeight:Number = 0;
      
      public function BattlePassObjectiveList()
      {
         super();
      }
      
      public static function createFromXML(param1:XML) : BattlePassObjectiveList
      {
         return new BattlePassObjectiveListCreator().create(param1) as BattlePassObjectiveList;
      }
      
      override protected function createItems() : void
      {
         var _loc1_:int = _itemList ? int(_itemList.length) : 0;
         while(_itemsContainer.numChildren < _loc1_)
         {
            _itemsContainer.addChild(getPoolItem());
         }
         while(_itemsContainer.numChildren > _loc1_)
         {
            removePoolItem();
         }
      }
      
      override protected function getOffset() : uint
      {
         return 0;
      }
      
      override protected function drawItems() : void
      {
         this.createItems();
         this.fillItems();
      }
      
      override protected function fillItems() : void
      {
         super.fillItems();
         this.positionRows();
      }
      
      public function requestRowLayout() : void
      {
         addEventListener(Event.ENTER_FRAME,this.handleRowLayout);
      }
      
      private function handleRowLayout(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.handleRowLayout);
         this.positionRows();
         this.calculateViewToContentSizeRatio();
      }
      
      private function positionRows() : void
      {
         var _loc1_:Coreponent = null;
         var _loc2_:int = 0;
         this._contentHeight = 0;
         _loc2_ = 0;
         while(_loc2_ < _itemsContainer.numChildren)
         {
            _loc1_ = _itemsContainer.getChildAt(_loc2_) as Coreponent;
            this._contentHeight += _loc1_.getCalculatedHeight();
            if(_loc2_ > 0)
            {
               this._contentHeight += itemGap;
            }
            _loc2_++;
         }
         if(_itemsContainer.numChildren > 0)
         {
            this._contentHeight += CONTENT_BOTTOM_PADDING;
         }
         var _loc3_:Number = -Math.max(0,this._contentHeight - getCalculatedHeight()) * _scrollPosition;
         _loc2_ = 0;
         while(_loc2_ < _itemsContainer.numChildren)
         {
            _loc1_ = _itemsContainer.getChildAt(_loc2_) as Coreponent;
            _loc1_.y = _loc3_;
            _loc1_.forceRedraw(InvalidationType.POSITION);
            _loc3_ += _loc1_.getCalculatedHeight() + itemGap;
            _loc2_++;
         }
      }
      
      override protected function calculateViewToContentSizeRatio() : void
      {
         var _loc1_:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLLCONTAINER_VERTICAL_SIZE_CHANGED);
         _loc1_.contentSize = this._contentHeight;
         _loc1_.viewSize = getCalculatedHeight();
         dispatchEvent(_loc1_);
      }
      
      override public function setScrollPositionInPercent(param1:Number, param2:uint = 2) : void
      {
         _scrollPosition = isFinite(param1) ? Math.max(0,Math.min(1,param1)) : 0;
         this.positionRows();
         dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_POSITION_CHANGED,_scrollPosition));
      }
      
      override public function allItemsDisplayed() : Boolean
      {
         return this._contentHeight <= getCalculatedHeight();
      }
      
      override public function getScrollOneItemAmount() : Number
      {
         var _loc1_:Number = this._contentHeight - getCalculatedHeight();
         return _loc1_ > 0 ? Math.min(1,80 / _loc1_) : 0;
      }
      
      override public function getScrollOnePageAmount() : Number
      {
         var _loc1_:Number = this._contentHeight - getCalculatedHeight();
         return _loc1_ > 0 ? Math.min(1,getCalculatedHeight() / _loc1_) : 0;
      }
      
      override public function clearList() : void
      {
         super.clearList();
         this._contentHeight = 0;
         this.calculateViewToContentSizeRatio();
      }
      
      override public function dispose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.handleRowLayout);
         super.dispose();
      }
   }
}

import net.bigpoint.darkorbit.fui.builder.xml.creators.list.ItemListCreator;
import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
import net.bigpoint.darkorbit.mvc.gui.windows.battlePass.view.components.BattlePassObjectiveList;

class BattlePassObjectiveListCreator extends ItemListCreator
{
   
   public function BattlePassObjectiveListCreator()
   {
      super();
   }
   
   override public function create(param1:XML) : ICoreponent
   {
      var _loc2_:BattlePassObjectiveList = new BattlePassObjectiveList();
      mapXMLNodeAttributes(_loc2_,param1);
      mapXMLChildrenToMethodHandler(_loc2_,param1);
      return _loc2_;
   }
}
