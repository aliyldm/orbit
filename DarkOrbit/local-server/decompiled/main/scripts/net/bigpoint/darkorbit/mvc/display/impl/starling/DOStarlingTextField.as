package net.bigpoint.darkorbit.mvc.display.impl.starling
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.mvc.display.IDOTextField;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   import starling.display.DisplayObject;
   import starling.filters.FragmentFilter;
   import starling.text.TextField;
   
   public class DOStarlingTextField extends TextField implements IDOTextField
   {
      
      public function DOStarlingTextField()
      {
         super(100,100,"");
      }
      
      public function get font() : String
      {
         return fontName;
      }
      
      public function set font(param1:String) : void
      {
         fontName = param1;
      }
      
      public function get htmlText() : String
      {
         return text;
      }
      
      public function set htmlText(param1:String) : void
      {
         super.text = param1;
      }
      
      public function get align() : String
      {
         return hAlign;
      }
      
      public function set align(param1:String) : void
      {
         hAlign = param1;
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

