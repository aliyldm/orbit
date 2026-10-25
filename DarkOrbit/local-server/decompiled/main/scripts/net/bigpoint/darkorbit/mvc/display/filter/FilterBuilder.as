package net.bigpoint.darkorbit.mvc.display.filter
{
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class FilterBuilder
   {
      
      public static const BLUR_FILTER:String = "";
      
      public static const GLOW_FILTER:String = "";
      
      public static const DROP_SHADOW_FILTER:String = "";
      
      public static const COLOR_MATRIX_FILTER:String = "";
      
      public static const DISPLACEMENT_MAP_FILTER:String = "";
      
      private var _impl:Dictionary;
      
      public function FilterBuilder(param1:Class, param2:Class, param3:Class, param4:Class)
      {
         super();
         this._impl = new Dictionary(true);
         this.setImplementation(IBlurFilter,param1);
         this.setImplementation(IGlowFilter,param2);
         this.setImplementation(IDropShadowFilter,param3);
         this.setImplementation(IColorMatrixFilter,param4);
      }
      
      public function setImplementation(param1:Class, param2:Class) : void
      {
         this._impl[param1] = param2;
      }
      
      public function build(param1:Class) : Object
      {
         var _loc2_:Class = this._impl[param1] as Class;
         if(_loc2_)
         {
            return new _loc2_();
         }
         throw new Error("No implementation for " + getQualifiedClassName(param1) + " interface");
      }
      
      public function buildBlurFilter() : IBlurFilter
      {
         return this.build(IBlurFilter) as IBlurFilter;
      }
      
      public function buildGlowFilter() : IGlowFilter
      {
         return this.build(IGlowFilter) as IGlowFilter;
      }
      
      public function buildDropShadowFilter() : IDropShadowFilter
      {
         return this.build(IDropShadowFilter) as IDropShadowFilter;
      }
      
      public function buildColorMatrixFilter() : IColorMatrixFilter
      {
         return this.build(IColorMatrixFilter) as IColorMatrixFilter;
      }
   }
}

