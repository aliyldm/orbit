package net.bigpoint.darkorbit.mvc.display.filter.impl.flash
{
   import flash.filters.ColorMatrixFilter;
   import net.bigpoint.darkorbit.mvc.display.filter.IColorMatrixFilter;
   import net.bigpoint.darkorbit.mvc.display.filter.IFlashFilter;
   
   public class DOFlashColorMatrixFilter implements IColorMatrixFilter, IFlashFilter
   {
      
      private var _realFilter:ColorMatrixFilter;
      
      public function DOFlashColorMatrixFilter(param1:Vector.<Number> = null)
      {
         super();
         this._realFilter = new ColorMatrixFilter();
         if(param1)
         {
            param1 = param1;
         }
      }
      
      public function get matrix() : Vector.<Number>
      {
         return Vector.<Number>(this._realFilter.matrix);
      }
      
      public function set matrix(param1:Vector.<Number>) : void
      {
         var _loc2_:Array = this._realFilter.matrix ? this._realFilter.matrix : [];
         this.copyFromVector(_loc2_,param1);
         this._realFilter.matrix = _loc2_;
      }
      
      private function copyFromVector(param1:Array, param2:Vector.<Number>) : void
      {
         var _loc3_:int = int(param2.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            param1[_loc4_] = param2[_loc4_];
            _loc4_++;
         }
      }
      
      public function get filter() : Object
      {
         return this._realFilter;
      }
   }
}

