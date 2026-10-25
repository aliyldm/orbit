package net.bigpoint.darkorbit.mvc.display.filter.impl.flash
{
   import flash.filters.DropShadowFilter;
   import net.bigpoint.darkorbit.mvc.display.filter.IDropShadowFilter;
   import net.bigpoint.darkorbit.mvc.display.filter.IFlashFilter;
   
   public class DOFlashDropShadowFilter implements IDropShadowFilter, IFlashFilter
   {
      
      private var _realFilter:DropShadowFilter;
      
      public function DOFlashDropShadowFilter(param1:Number = 4, param2:Number = 45, param3:uint = 0, param4:Number = 1, param5:Number = 4, param6:Number = 4, param7:Number = 1)
      {
         super();
         this._realFilter = new DropShadowFilter(param1,param2,param3,param4,param5,param6,param7);
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
      
      public function get distance() : Number
      {
         return this._realFilter.distance;
      }
      
      public function set distance(param1:Number) : void
      {
         this._realFilter.distance = param1;
      }
      
      public function get angle() : Number
      {
         return this._realFilter.angle;
      }
      
      public function set angle(param1:Number) : void
      {
         this._realFilter.angle = param1;
      }
      
      public function get filter() : Object
      {
         return this._realFilter;
      }
   }
}

