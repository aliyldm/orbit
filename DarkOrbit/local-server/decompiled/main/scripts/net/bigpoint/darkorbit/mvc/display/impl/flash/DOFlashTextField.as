package net.bigpoint.darkorbit.mvc.display.impl.flash
{
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.mvc.display.IDOTextField;
   import net.bigpoint.darkorbit.mvc.display.filter.IFlashFilter;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   import starling.text.TextFieldAutoSize;
   
   public class DOFlashTextField extends TextField implements IDOTextField
   {
      
      private static const ALIGN_MAP:Object = {};
      
      private static const AUTOSIZE_MAP:Object = getAutosizeMap();
      
      public function DOFlashTextField()
      {
         super();
         embedFonts = true;
         multiline = true;
         wordWrap = true;
      }
      
      private static function getAutosizeMap() : Object
      {
         var _loc1_:Object = [];
         _loc1_[starling.text.TextFieldAutoSize.BOTH_DIRECTIONS] = flash.text.TextFieldAutoSize.CENTER;
         return _loc1_;
      }
      
      override public function set autoSize(param1:String) : void
      {
         super.autoSize = AUTOSIZE_MAP[param1] || param1;
      }
      
      public function get color() : uint
      {
         return textColor;
      }
      
      public function set color(param1:uint) : void
      {
         textColor = param1;
      }
      
      public function get align() : String
      {
         var _loc1_:TextFormat = this.getDefaultTextFormat();
         return _loc1_.align;
      }
      
      public function set align(param1:String) : void
      {
         var _loc2_:TextFormat = this.getDefaultTextFormat();
         _loc2_.align = ALIGN_MAP[param1] || param1;
         defaultTextFormat = _loc2_;
         setTextFormat(_loc2_);
      }
      
      public function get font() : String
      {
         var _loc1_:TextFormat = this.getDefaultTextFormat();
         return _loc1_.font;
      }
      
      public function set font(param1:String) : void
      {
         var _loc2_:TextFormat = this.getDefaultTextFormat();
         _loc2_.font = param1;
         defaultTextFormat = _loc2_;
         setTextFormat(_loc2_);
      }
      
      public function get fontSize() : Number
      {
         var _loc1_:TextFormat = defaultTextFormat ? defaultTextFormat : new TextFormat();
         return isNaN(Number(_loc1_.size)) ? 12 : Number(_loc1_.size);
      }
      
      public function set fontSize(param1:Number) : void
      {
         var _loc2_:TextFormat = this.getDefaultTextFormat();
         _loc2_.size = param1;
         defaultTextFormat = _loc2_;
         setTextFormat(_loc2_);
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
      
      public function dispose() : void
      {
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
      
      private function getDefaultTextFormat() : TextFormat
      {
         return this.defaultTextFormat ? this.defaultTextFormat : new TextFormat();
      }
   }
}

