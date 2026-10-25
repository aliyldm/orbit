package net.bigpoint.darkorbit.map.hud.ship
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class HorizontalGroup extends Sprite
   {
      
      public static const CENTER:String = "CENTER";
      
      public static const LEFT:String = "LEFT";
      
      public static const RIGHT:String = "RIGHT";
      
      public static const BOTTOM:String = "BOTTOM";
      
      public static const TOP:String = "TOP";
      
      public static const CUSTOM:String = "CUSTOM";
      
      private var layouter:Object = {};
      
      private var _elements:Vector.<DisplayObject> = new Vector.<DisplayObject>();
      
      private var _redrawNextFrame:Boolean;
      
      private var _alignment:String = "TOP";
      
      private var _childLayout:String = "LEFT";
      
      private var _gap:Number = 0;
      
      public function HorizontalGroup()
      {
         super();
         this.layouter[LEFT] = this.updateLayoutLeft;
         this.layouter[RIGHT] = this.updateLayoutRight;
         this.layouter[CENTER] = this.updateLayoutCenter;
      }
      
      public function redraw() : void
      {
         var listener:Function = null;
         if(this._redrawNextFrame)
         {
            if(hasEventListener(Event.ENTER_FRAME))
            {
               return;
            }
            listener = function(param1:Event):void
            {
               removeEventListener(Event.ENTER_FRAME,listener);
               handleChange();
            };
            addEventListener(Event.ENTER_FRAME,listener);
         }
         else
         {
            this.handleChange();
         }
      }
      
      private function handleChange() : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this);
         var _loc1_:uint = this._elements.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            addChild(this._elements[_loc2_]);
            _loc2_++;
         }
         this.updateLayout();
      }
      
      public function updateLayout() : void
      {
         this.layouter[this._childLayout]();
      }
      
      private function updateLayoutLeft() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc1_:uint = this._elements.length;
         var _loc2_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            _loc3_ = this._elements[_loc4_];
            if(_loc3_.visible)
            {
               _loc3_.x = _loc2_;
               if(this._alignment != CUSTOM)
               {
                  _loc3_.y = this.getYPosition(_loc3_);
               }
               _loc2_ += _loc3_.width + this._gap;
            }
            _loc4_++;
         }
      }
      
      private function updateLayoutRight() : void
      {
         var _loc3_:DisplayObject = null;
         var _loc1_:uint = this._elements.length;
         var _loc2_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            _loc3_ = this._elements[_loc4_];
            if(_loc3_.visible)
            {
               _loc3_.x = _loc2_;
               if(this._alignment != CUSTOM)
               {
                  _loc3_.y = this.getYPosition(_loc3_);
               }
               _loc2_ += _loc3_.width + this._gap;
            }
            _loc4_++;
         }
      }
      
      public function reset() : void
      {
         this._elements.length = 0;
         this.redraw();
      }
      
      public function addElement(param1:DisplayObject) : void
      {
         this._elements.push(param1);
         this.redraw();
      }
      
      public function removeElement(param1:DisplayObject) : void
      {
         var _loc2_:int = this._elements.indexOf(param1);
         while(_loc2_ != -1)
         {
            this._elements.splice(_loc2_,1);
            _loc2_ = this._elements.indexOf(param1);
         }
         this.redraw();
      }
      
      public function removeAllElements() : void
      {
         this.elements.length = 0;
         this.redraw();
      }
      
      public function setElements(param1:Vector.<DisplayObject>) : void
      {
         this._elements = param1;
         this.handleChange();
      }
      
      public function get redrawNextFrame() : Boolean
      {
         return this._redrawNextFrame;
      }
      
      public function set redrawNextFrame(param1:Boolean) : void
      {
         this._redrawNextFrame = param1;
      }
      
      public function get alignment() : String
      {
         return this._alignment;
      }
      
      public function set alignment(param1:String) : void
      {
         if(this._alignment != param1)
         {
            this._alignment = param1;
            this.redraw();
         }
      }
      
      private function getYPosition(param1:DisplayObject) : Number
      {
         switch(this._alignment)
         {
            case TOP:
               return 0;
            case CENTER:
               return -param1.height * 0.5;
            case BOTTOM:
               return -param1.height;
            default:
               return 0;
         }
      }
      
      public function get elements() : Vector.<DisplayObject>
      {
         return this._elements;
      }
      
      public function get gap() : Number
      {
         return this._gap;
      }
      
      public function set gap(param1:Number) : void
      {
         if(param1 != this._gap)
         {
            this._gap = param1;
            this.updateLayout();
         }
      }
      
      private function updateLayoutCenter() : void
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:Rectangle = null;
         var _loc1_:int = int(this._elements.length);
         var _loc2_:int = this.calcTotalWidth();
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < _loc1_)
         {
            _loc4_ = this._elements[_loc6_];
            if(_loc4_.visible)
            {
               _loc5_ = _loc4_.getBounds(_loc4_);
               _loc4_.x = _loc3_ - _loc5_.x - _loc2_ * 0.5;
               if(this._alignment != CUSTOM)
               {
                  _loc4_.y = -_loc5_.y - _loc5_.height;
               }
               _loc3_ += _loc5_.width + this.gap;
            }
            _loc6_++;
         }
      }
      
      private function calcTotalWidth() : int
      {
         var _loc1_:int = int(this._elements.length);
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ += this._elements[_loc3_].width;
            _loc3_++;
         }
         return _loc2_ + this.gap * (_loc1_ - 1);
      }
      
      public function set childLayout(param1:String) : void
      {
         if(param1 != this._childLayout)
         {
            this._childLayout = param1;
            this.updateLayout();
         }
      }
   }
}

