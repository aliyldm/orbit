package net.bigpoint.darkorbit.mvc.display.filter.impl.starling
{
   import net.bigpoint.darkorbit.mvc.display.filter.IBlurFilter;
   import starling.filters.BlurFilter;
   
   public class DOStarlingBlurFilter extends BlurFilter implements IBlurFilter
   {
      
      public function DOStarlingBlurFilter(param1:Number = 1, param2:Number = 1, param3:Number = 1)
      {
         super(param1,param2,param3);
      }
   }
}

