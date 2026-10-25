package com.bigpoint.utils.ui.panels
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   
   public class HPanel extends MovieClip
   {
      
      private var _currPos:int = 0;
      
      private var _margin:int = 0;
      
      private var _items:Array = [];
      
      private var _align:String;
      
      private var _last:DisplayObject;
      
      private var _first:DisplayObject;
      
      public function HPanel()
      {
         super();
         this._align = TextFieldAutoSize.LEFT;
      }
      
      public function addItem(param1:DisplayObject, param2:Number = 0, param3:Number = 0) : DisplayObject
      {
         this._margin = param2 + Math.max(0,param3 || param2);
         addChild(param1);
         if(this._align == TextFieldAutoSize.LEFT)
         {
            param1.x = param2 + this._currPos;
         }
         else
         {
            param1.x = -param3 - this._currPos - param1.width;
         }
         this._currPos = this._currPos + param1.width + this._margin;
         this._items.push(param1);
         if(!this._first)
         {
            this._first = param1;
         }
         this._last = param1;
         return param1;
      }
      
      public function removeItems() : void
      {
         this._currPos = 0;
         while(numChildren)
         {
            removeChildAt(numChildren - 1);
         }
         this._items = [];
      }
      
      public function centerItems(param1:Number) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Number = NaN;
         var _loc5_:DisplayObject = null;
         var _loc2_:Number = 0;
         for each(_loc3_ in this._items)
         {
            _loc2_ += _loc3_.width;
         }
         _loc2_ += (this._items.length - 1) * this._margin;
         if(param1 > _loc2_)
         {
            _loc4_ = (param1 - _loc2_) / 2;
            for each(_loc5_ in this._items)
            {
               _loc5_.x = _loc4_;
               _loc4_ += _loc5_.width + this._margin;
            }
         }
      }
      
      public function set align(param1:String) : void
      {
         this._align = param1;
      }
      
      public function get last() : DisplayObject
      {
         return this._last;
      }
      
      public function get first() : DisplayObject
      {
         return this._first;
      }
      
      public function get items() : Array
      {
         return this._items;
      }
   }
}

