package net.bigpoint.darkorbit.mvc.display.impl.flash
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.mvc.display.IDOBitmap;
   import net.bigpoint.darkorbit.mvc.display.filter.IFlashFilter;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class DOFlashBitmap extends Bitmap implements IDOBitmap
   {
      
      public function DOFlashBitmap()
      {
         super();
      }
      
      public function set texture(param1:Object) : void
      {
         bitmapData = param1 as BitmapData;
      }
      
      public function get untypedParent() : Object
      {
         return parent;
      }
      
      public function get untypedRoot() : Object
      {
         return root;
      }
      
      public function get untypedStage() : Object
      {
         return stage;
      }
      
      public function get transformationMatrix() : Matrix
      {
         return transform.matrix;
      }
      
      public function set transformationMatrix(param1:Matrix) : void
      {
         transform.matrix = param1;
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
      
      public function setSubtexture(param1:Object, param2:Rectangle) : void
      {
         var _loc3_:BitmapData = null;
         if(bitmapData)
         {
            bitmapData.dispose();
         }
         if(param1 is BitmapData)
         {
            _loc3_ = new BitmapData(param2.width,param2.height);
            _loc3_.copyPixels(param1 as BitmapData,param2,new Point(0,0));
            bitmapData = _loc3_;
         }
      }
      
      public function dispose() : void
      {
         if(bitmapData)
         {
            bitmapData = null;
         }
      }
      
      public function untypedLocalToGlobal(param1:Point) : Point
      {
         return localToGlobal(param1);
      }
      
      public function untypedGlobalToLocal(param1:Point) : Point
      {
         return globalToLocal(param1);
      }
      
      public function getUntypedBounds(param1:Object, param2:Rectangle = null) : Rectangle
      {
         return getBounds(param1 as DisplayObject);
      }
   }
}

