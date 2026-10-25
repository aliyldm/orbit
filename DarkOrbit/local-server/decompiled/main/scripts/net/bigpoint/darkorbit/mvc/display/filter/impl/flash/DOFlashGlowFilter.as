package net.bigpoint.darkorbit.mvc.display.filter.impl.flash
{
   import flash.filters.GlowFilter;
   import net.bigpoint.darkorbit.mvc.display.filter.IFlashFilter;
   import net.bigpoint.darkorbit.mvc.display.filter.IGlowFilter;
   
   public class DOFlashGlowFilter implements IGlowFilter, IFlashFilter
   {
      
      private var _realFilter:GlowFilter;
      
      public function DOFlashGlowFilter(param1:uint = 16711680, param2:Number = 1, param3:Number = 6, param4:Number = 6, param5:Number = 2, param6:int = 1, param7:Boolean = false, param8:Boolean = false)
      {
         super();
         this._realFilter = new GlowFilter(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      public function set blurX(param1:Number) : void
      {
         this._realFilter.blurX = param1;
      }
      
      public function set blurY(param1:Number) : void
      {
         this._realFilter.blurY = param1;
      }
      
      public function get blurX() : Number
      {
         return this._realFilter.blurX;
      }
      
      public function get blurY() : Number
      {
         return this._realFilter.blurY;
      }
      
      public function set color(param1:uint) : void
      {
         this._realFilter.color = param1;
      }
      
      public function get color() : uint
      {
         return this._realFilter.color;
      }
      
      public function set alpha(param1:Number) : void
      {
         this._realFilter.alpha = param1;
      }
      
      public function get alpha() : Number
      {
         return this._realFilter.alpha;
      }
      
      public function set strength(param1:Number) : void
      {
         this._realFilter.strength = param1;
      }
      
      public function get strength() : Number
      {
         return this._realFilter.strength;
      }
      
      public function get filter() : Object
      {
         return this._realFilter;
      }
   }
}

