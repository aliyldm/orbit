package net.bigpoint.darkorbit.mvc.display.impl.starling
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.mvc.display.IDODisplayObject;
   import net.bigpoint.darkorbit.mvc.display.IDOSprite;
   import net.bigpoint.darkorbit.mvc.display.StarlingSprite;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   import starling.display.DisplayObject;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.events.TouchPhase;
   import starling.filters.FragmentFilter;
   
   public class DOStarlingSprite extends StarlingSprite implements IDOSprite
   {
      
      private var _mouseX:Number = 0;
      
      private var _mouseY:Number = 0;
      
      public function DOStarlingSprite()
      {
         super();
         this.mouseEnabled = touchable;
      }
      
      override public function get mouseX() : Number
      {
         return this._mouseX;
      }
      
      override public function get mouseY() : Number
      {
         return this._mouseY;
      }
      
      public function get mouseEnabled() : Boolean
      {
         return touchable;
      }
      
      override public function set mouseEnabled(param1:Boolean) : void
      {
         touchable = param1;
         if(param1)
         {
            addEventListener(TouchEvent.TOUCH,this.touchHandler);
         }
         else
         {
            removeEventListener(TouchEvent.TOUCH,this.touchHandler);
         }
      }
      
      public function get untypedFilter() : Object
      {
         return this.filter;
      }
      
      public function set untypedFilter(param1:Object) : void
      {
         this.filter = param1 as FragmentFilter;
      }
      
      public function get rotationDeg() : Number
      {
         return rotation * FastMath.RADTODEG;
      }
      
      public function set rotationDeg(param1:Number) : void
      {
         rotation = param1 * FastMath.DEGTORAD;
      }
      
      public function get rotationRad() : Number
      {
         return rotation;
      }
      
      public function set rotationRad(param1:Number) : void
      {
         rotation = param1;
      }
      
      public function do_addChild(param1:IDODisplayObject) : void
      {
         if(param1 is DisplayObject)
         {
            super.addChild(param1 as DisplayObject);
            return;
         }
         throw new ArgumentError("child must be flash.display.Sprite");
      }
      
      public function do_addChildAt(param1:IDODisplayObject, param2:int) : void
      {
         if(param1 is DisplayObject)
         {
            super.addChildAt(param1 as DisplayObject,param2);
            return;
         }
         throw new ArgumentError("child must be flash.display.Sprite");
      }
      
      public function do_removeChild(param1:IDODisplayObject) : IDODisplayObject
      {
         return super.removeChild(param1 as DisplayObject) as IDODisplayObject;
      }
      
      public function do_removeChildAt(param1:int) : IDODisplayObject
      {
         return super.removeChildAt(param1) as IDODisplayObject;
      }
      
      public function do_getBounds(param1:IDODisplayObject) : Rectangle
      {
         return super.getBounds(param1 as DisplayObject);
      }
      
      public function do_contains(param1:IDODisplayObject) : Boolean
      {
         return super.contains(param1 as DisplayObject);
      }
      
      public function removeAndDisposeChildren() : void
      {
         var _loc1_:int = numChildren;
         while(--_loc1_ >= 0)
         {
            IDODisplayObject(getChildAt(_loc1_)).dispose();
         }
      }
      
      private function touchHandler(param1:TouchEvent) : void
      {
         var _loc3_:Touch = null;
         var _loc4_:Point = null;
         var _loc2_:Vector.<Touch> = param1.getTouches(this);
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.phase == TouchPhase.HOVER)
            {
               _loc4_ = _loc3_.getLocation(this);
               this._mouseX = _loc4_.x;
               this._mouseY = _loc4_.y;
            }
         }
      }
   }
}

