package net.bigpoint.darkorbit.mvc.display.filter.impl.flash
{
   import flash.filters.BlurFilter;
   import net.bigpoint.darkorbit.mvc.display.filter.IBlurFilter;
   import net.bigpoint.darkorbit.mvc.display.filter.IFlashFilter;
   
   public class DOFlashBlurFilter implements IBlurFilter, IFlashFilter
   {
      
      protected var _realFilter:BlurFilter;
      
      public function DOFlashBlurFilter(param1:Number = 4, param2:Number = 4, param3:int = 1)
      {
         super();
         this._realFilter = new BlurFilter(param1,param2,param3);
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
      
      public function get filter() : Object
      {
         return this._realFilter;
      }
   }
}

