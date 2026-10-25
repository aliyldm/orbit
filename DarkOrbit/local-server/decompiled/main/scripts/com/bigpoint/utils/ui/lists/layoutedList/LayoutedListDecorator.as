package com.bigpoint.utils.ui.lists.layoutedList
{
   import com.bigpoint.utils.ui.buttons.StatesButtonDecorator;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.HorizontalGridLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.HorizontalListLayout;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.VerticallListLayout;
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractComponentDecorator;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.components.FeatureBtn;
   
   public class LayoutedListDecorator extends DOAbstractComponentDecorator
   {
      
      private static const MOVE_RIGHT:String = "moveRight";
      
      private static const MOVE_LEFT:String = "moveLeft";
      
      public static const LAYOUT_CHANGE_COMPLETE:String = "layoutChangeComplete";
      
      public var rightArrow:StatesButtonDecorator;
      
      public var leftArrow:StatesButtonDecorator;
      
      public var listMask:Sprite;
      
      public var listContainer:Sprite;
      
      private var _itemSize:int = 0;
      
      private var _poxY:int = 0;
      
      private var _containerIndex:int = 0;
      
      private var _items:Array;
      
      private var _pageItemsNum:int;
      
      private var _layout:IListLayout;
      
      public function LayoutedListDecorator(param1:DisplayObjectContainer)
      {
         super(param1);
         this.rightArrow.addEventListener(MouseEvent.CLICK,this.moveItems);
         this.leftArrow.addEventListener(MouseEvent.CLICK,this.moveItems);
         this.rightArrow.enable = false;
         this.leftArrow.enable = false;
         this.checkArrowsVisibility();
         visible = false;
      }
      
      override public function decorate() : void
      {
         addViewChild(this.rightArrow = new StatesButtonDecorator(getSpriteChild("rightArrow")));
         addViewChild(this.leftArrow = new StatesButtonDecorator(getSpriteChild("leftArrow")));
         addViewChild(this.listMask = getSpriteChild("listMask"));
         addViewChild(this.listContainer = getSpriteChild("listContainer"));
      }
      
      public function showItems(param1:Array, param2:int, param3:int, param4:IListLayout = null, param5:Boolean = true, param6:int = 0) : void
      {
         this._items = param1;
         this._pageItemsNum = param2;
         this._itemSize = param3;
         this._poxY = param6;
         this._layout = param4 || this._layout || new HorizontalListLayout();
         this._containerIndex = 0;
         this.listContainer.x = 0;
         this.setLayout(this._layout,true);
         this.checkArrowsVisibility();
         visible = true;
         if(param5)
         {
            this.listContainer.mask = this.listMask;
         }
         else
         {
            this.listMask.visible = false;
         }
         this.leftArrow.visible = this.rightArrow.visible = param5;
      }
      
      public function setLayout(param1:IListLayout, param2:Boolean = false, param3:Boolean = false, param4:int = -1) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc9_:Point = null;
         var _loc10_:Boolean = false;
         var _loc11_:Function = null;
         var _loc12_:FeatureBtn = null;
         var _loc13_:* = undefined;
         if(param2)
         {
            clear(this.listContainer);
         }
         if(this._items)
         {
            _loc5_ = 0;
            _loc6_ = 0;
            _loc7_ = 0;
            while(_loc7_ != this._items.length)
            {
               _loc8_ = this._items[_loc7_] as DisplayObject;
               if(this._items[_loc7_] is FeatureBtn)
               {
                  _loc12_ = this._items[_loc7_] as FeatureBtn;
                  if(param1 is HorizontalGridLayout)
                  {
                     _loc13_ = param1 as HorizontalGridLayout;
                     if(Boolean(_loc12_.barId) && _loc12_.barId == FeaturesMenuConstants.GENERIC_FEATURE_BAR)
                     {
                        _loc13_.columnsNum = HorizontalGridLayout.Three_columns;
                     }
                     else
                     {
                        _loc13_.columnsNum = HorizontalGridLayout.Four_columns;
                     }
                     _loc9_ = _loc13_.getItemPosition(this._itemSize,_loc6_);
                     _loc6_++;
                  }
                  else if(param1 is HorizontalListLayout || param1 is VerticallListLayout)
                  {
                     if(Boolean(_loc12_.barId) && _loc12_.barId == FeaturesMenuConstants.GAME_NEW_FEATURE_BAR)
                     {
                        _loc9_ = param1.getFixItemPosition(this._itemSize,_loc5_,this._poxY);
                        _loc5_++;
                     }
                     else
                     {
                        _loc9_ = param1.getItemPosition(this._itemSize,_loc6_);
                        _loc6_++;
                     }
                  }
                  else
                  {
                     _loc9_ = param1.getItemPosition(this._itemSize,_loc6_);
                     _loc6_++;
                  }
               }
               else
               {
                  _loc9_ = param1.getItemPosition(this._itemSize,_loc6_);
                  _loc6_++;
               }
               _loc10_ = param4 != -1;
               _loc11_ = _loc7_ == this._items.length - 1 && param3 ? this.setLayoutOnComplete : null;
               TweenLite.to(_loc8_,param3 ? 0.4 : 0,{
                  "delay":(param3 ? 0.05 * _loc7_ : 0),
                  "x":_loc9_.x,
                  "y":_loc9_.y,
                  "onStart":(_loc10_ ? this.playSoundOnMoveStart : null),
                  "onStartParams":[param4],
                  "onComplete":_loc11_
               });
               if(param2)
               {
                  this.listContainer.addChild(_loc8_);
               }
               _loc7_++;
            }
         }
         this._layout = param1;
      }
      
      private function setLayoutOnComplete() : void
      {
         dispatchEvent(new Event(LAYOUT_CHANGE_COMPLETE,true));
      }
      
      private function playSoundOnMoveStart(param1:int) : void
      {
         AudioManager.playSoundEffect(param1);
      }
      
      private function moveItems(param1:MouseEvent) : void
      {
         if(param1.target == this.rightArrow)
         {
            if(this.canMoveRight)
            {
               --this._containerIndex;
               TweenLite.to(this.listContainer,0.5,{"x":this._containerIndex * this._itemSize});
               dispatchEvent(new Event(MOVE_RIGHT));
            }
         }
         else if(this.canMoveLeft)
         {
            ++this._containerIndex;
            TweenLite.to(this.listContainer,0.5,{"x":this._containerIndex * this._itemSize});
            dispatchEvent(new Event(MOVE_LEFT));
         }
         this.checkArrowsVisibility();
      }
      
      public function checkArrowsVisibility() : void
      {
         this.rightArrow.enable = this.canMoveRight;
         this.leftArrow.enable = this.canMoveLeft;
      }
      
      private function get canMoveRight() : Boolean
      {
         if(this._items)
         {
            return this._items.length - this._containerIndex > this._pageItemsNum && this._items.length + this._containerIndex > this._pageItemsNum;
         }
         return false;
      }
      
      private function get canMoveLeft() : Boolean
      {
         return this._containerIndex < 0;
      }
      
      public function get index() : int
      {
         return this._containerIndex;
      }
      
      public function visibleItemPos(param1:DisplayObject) : int
      {
         if(this._items.indexOf(param1) >= 0)
         {
            return this._containerIndex % 4 + this._items.indexOf(param1) + 1;
         }
         return 0;
      }
      
      public function get listWidth() : int
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this._layout.id == HorizontalListLayout.ID)
         {
            _loc2_ = this._items.length * this._itemSize;
            _loc3_ = this.rightArrow.visible ? this.leftArrow.width : 0;
            if(this.listMask.visible)
            {
               return Math.min(this.listMask.width,_loc2_) + _loc3_;
            }
            _loc1_ = _loc2_ + _loc3_;
         }
         else
         {
            _loc1_ = this.listContainer.width;
         }
         return _loc1_;
      }
      
      public function get listHeight() : int
      {
         var _loc1_:Number = this._items.length * this._itemSize;
         var _loc2_:Number = this.rightArrow.visible ? this.leftArrow.width : 0;
         if(this.listMask.visible)
         {
            return Math.min(this.listMask.width,_loc1_) + _loc2_;
         }
         return _loc1_ + _loc2_;
      }
      
      public function get items() : Array
      {
         return this._items;
      }
      
      public function get layout() : IListLayout
      {
         return this._layout;
      }
   }
}

