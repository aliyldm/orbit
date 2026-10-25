package net.bigpoint.darkorbit.mvc.display
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public interface IDODisplayObject
   {
      
      function get x() : Number;
      
      function set x(param1:Number) : void;
      
      function get y() : Number;
      
      function set y(param1:Number) : void;
      
      function get alpha() : Number;
      
      function set alpha(param1:Number) : void;
      
      function get visible() : Boolean;
      
      function set visible(param1:Boolean) : void;
      
      function get scaleX() : Number;
      
      function set scaleX(param1:Number) : void;
      
      function get scaleY() : Number;
      
      function set scaleY(param1:Number) : void;
      
      function get width() : Number;
      
      function set width(param1:Number) : void;
      
      function get height() : Number;
      
      function set height(param1:Number) : void;
      
      function get rotationDeg() : Number;
      
      function set rotationDeg(param1:Number) : void;
      
      function get rotationRad() : Number;
      
      function set rotationRad(param1:Number) : void;
      
      function dispose() : void;
      
      function get untypedParent() : Object;
      
      function untypedLocalToGlobal(param1:Point) : Point;
      
      function untypedGlobalToLocal(param1:Point) : Point;
      
      function get untypedRoot() : Object;
      
      function get untypedStage() : Object;
      
      function getUntypedBounds(param1:Object, param2:Rectangle = null) : Rectangle;
      
      function get transformationMatrix() : Matrix;
      
      function set transformationMatrix(param1:Matrix) : void;
      
      function set untypedFilter(param1:Object) : void;
      
      function get untypedFilter() : Object;
   }
}

