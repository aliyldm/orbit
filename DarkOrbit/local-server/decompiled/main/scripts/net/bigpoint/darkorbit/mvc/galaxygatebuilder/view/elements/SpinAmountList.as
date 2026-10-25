package net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.elements
{
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.mvc.galaxygatebuilder.view.events.SpinAmountEvent;
   
   public class SpinAmountList extends Sprite
   {
      
      private var isVisible:Boolean = false;
      
      private var bgColor:uint = 0;
      
      private var bgWidth:int = 0;
      
      private var bgHeight:int = 0;
      
      private var bgAlpha:Number = 0.8;
      
      private var borderColor:uint = 6710886;
      
      private var borderThickness:Number = 1;
      
      private var topOffset:int = 6;
      
      private var _selectedItem:SpinAmountListItem;
      
      private var items:Vector.<SpinAmountListItem> = new Vector.<SpinAmountListItem>();
      
      public function SpinAmountList()
      {
         super();
         addEventListener(Event.RESIZE,this.handleResize);
         scaleY = 0;
      }
      
      private function handleResize(param1:Event = null) : void
      {
         graphics.clear();
         graphics.lineStyle(this.borderThickness,this.borderColor);
         graphics.beginFill(this.bgColor,this.bgAlpha);
         graphics.drawRect(0,0,this.bgWidth,this.bgHeight);
         graphics.endFill();
      }
      
      public function addItem(param1:int, param2:String) : void
      {
         var _loc3_:SpinAmountListItem = new SpinAmountListItem(param1,param2);
         var _loc4_:int = this.items.length * _loc3_.height;
         _loc3_.y = _loc4_ + this.topOffset;
         this.bgHeight = _loc3_.y + _loc3_.height;
         this.bgWidth = this.bgWidth < _loc3_.width ? int(_loc3_.width) : this.bgWidth;
         _loc3_.addEventListener(MouseEvent.CLICK,this.handleItemMouseClick);
         addChild(_loc3_);
         this.items.push(_loc3_);
         this.handleResize();
      }
      
      private function handleItemMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:SpinAmountListItem = param1.target as SpinAmountListItem;
         this._selectedItem = _loc2_;
         var _loc3_:SpinAmountEvent = new SpinAmountEvent(SpinAmountEvent.ITEM_SELECT);
         _loc3_.value = _loc2_.value;
         _loc3_.text = _loc2_.text;
         dispatchEvent(_loc3_);
         if(this.isVisible)
         {
            this.toggleVisibility();
         }
      }
      
      public function toggleVisibility() : void
      {
         this.isVisible = !this.isVisible;
         var _loc1_:int = this.isVisible ? 1 : 0;
         TweenLite.to(this,0.2,{"scaleY":_loc1_});
      }
      
      public function get selectedItem() : SpinAmountListItem
      {
         return this._selectedItem;
      }
      
      public function setSelectedValue(param1:int) : void
      {
         var _loc2_:SpinAmountListItem = null;
         var _loc3_:SpinAmountEvent = null;
         for each(_loc2_ in this.items)
         {
            if(_loc2_.value == param1)
            {
               break;
            }
            _loc2_ = null;
         }
         if(_loc2_ != null)
         {
            this._selectedItem = _loc2_;
            _loc3_ = new SpinAmountEvent(SpinAmountEvent.ITEM_SELECT);
            _loc3_.value = _loc2_.value;
            _loc3_.text = _loc2_.text;
            dispatchEvent(_loc3_);
         }
      }
   }
}

