package com.bigpoint.utils.ui.panels
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class VPanel extends MovieClip
   {
      
      private var _currPos:int = 0;
      
      private var _margin:int = 0;
      
      private var _items:Array = [];
      
      public function VPanel()
      {
         super();
      }
      
      public function addItem(param1:DisplayObject, param2:Number = 0, param3:Number = 0) : DisplayObject
      {
         this._margin = param2 + param3;
         addChild(param1);
         this._items.push(param1);
         param1.y = this._currPos + param2;
         this._currPos = param1.y + param1.height + param3;
         return param1;
      }
      
      public function removeItems() : void
      {
         this._currPos = 0;
         this._items = [];
         while(numChildren)
         {
            removeChildAt(numChildren - 1);
         }
      }
      
      public function upadte() : void
      {
         var _loc2_:DisplayObject = null;
         this._currPos = 0;
         var _loc1_:int = 0;
         while(_loc1_ != numChildren)
         {
            _loc2_ = getChildAt(_loc1_);
            _loc2_.y = this._currPos;
            this._currPos = this._currPos + _loc2_.height + this._margin * _loc2_.scaleY;
            _loc1_++;
         }
      }
      
      public function get items() : Array
      {
         return this._items;
      }
   }
}

