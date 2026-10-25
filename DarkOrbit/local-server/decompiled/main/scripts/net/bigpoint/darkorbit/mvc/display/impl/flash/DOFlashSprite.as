package net.bigpoint.darkorbit.mvc.display.impl.flash
{
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.mvc.display.FlashSprite;
   import net.bigpoint.darkorbit.mvc.display.IDODisplayObject;
   import net.bigpoint.darkorbit.mvc.display.IDOSprite;
   import net.bigpoint.darkorbit.mvc.display.filter.IFlashFilter;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class DOFlashSprite extends FlashSprite implements IDOSprite
   {
      
      public function DOFlashSprite()
      {
         super();
      }
      
      public function get untypedFilter() : Object
      {
         return Boolean(filters) && filters.length > 0 ? filters[0] : null;
      }
      
      public function set untypedFilter(param1:Object) : void
      {
         if(param1 is IFlashFilter)
         {
            filters = [(param1 as IFlashFilter).filter];
         }
         else
         {
            filters = [param1];
         }
      }
      
      public function set transformationMatrix(param1:Matrix) : void
      {
         transform.matrix = param1;
      }
      
      public function get rotationDeg() : Number
      {
         return rotation;
      }
      
      public function set rotationDeg(param1:Number) : void
      {
         rotation = param1;
      }
      
      public function get rotationRad() : Number
      {
         return rotation * FastMath.DEGTORAD;
      }
      
      public function set rotationRad(param1:Number) : void
      {
         rotation = param1 * FastMath.RADTODEG;
      }
      
      public function do_addChild(param1:IDODisplayObject) : void
      {
         if(param1 is DisplayObject)
         {
            super.addChild(param1 as DisplayObject);
            return;
         }
         throw new ArgumentError("child must be flash.display.DisplayObject");
      }
      
      public function do_addChildAt(param1:IDODisplayObject, param2:int) : void
      {
         if(param1 is DisplayObject)
         {
            super.addChildAt(param1 as DisplayObject,param2);
            return;
         }
         throw new ArgumentError("child must be flash.display.DisplayObject");
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
      
      public function dispose() : void
      {
      }
      
      public function removeAndDisposeChildren() : void
      {
         var _loc1_:int = numChildren;
         while(--_loc1_ >= 0)
         {
            this.do_removeChildAt(_loc1_).dispose();
         }
      }
   }
}

