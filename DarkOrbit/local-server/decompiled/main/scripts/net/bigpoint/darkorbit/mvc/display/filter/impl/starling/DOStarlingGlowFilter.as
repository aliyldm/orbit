package net.bigpoint.darkorbit.mvc.display.filter.impl.starling
{
   import net.bigpoint.darkorbit.mvc.display.filter.IGlowFilter;
   import starling.filters.BlurFilter;
   import starling.filters.FragmentFilterMode;
   
   public class DOStarlingGlowFilter extends BlurFilter implements IGlowFilter
   {
      
      private var _color:uint = 16711680;
      
      private var _alpha:Number = 1;
      
      public function DOStarlingGlowFilter(param1:uint = 16711680, param2:Number = 1, param3:Number = 6, param4:Number = 6, param5:Number = 2)
      {
         this._alpha = param2;
         this._color = param1;
         super(param3,param4,param5);
         mode = FragmentFilterMode.BELOW;
         setUniformColor(true,param1,param2);
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function get strength() : Number
      {
         return resolution;
      }
      
      public function set color(param1:uint) : void
      {
         this._color = param1;
         setUniformColor(true,param1,this.alpha);
      }
      
      public function set alpha(param1:Number) : void
      {
         this._alpha = param1;
         setUniformColor(true,this.color,param1);
      }
      
      public function set strength(param1:Number) : void
      {
         resolution = param1;
      }
   }
}

