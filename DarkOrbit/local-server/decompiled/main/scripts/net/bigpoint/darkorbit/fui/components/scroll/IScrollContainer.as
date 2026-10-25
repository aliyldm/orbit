package net.bigpoint.darkorbit.fui.components.scroll
{
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   
   public interface IScrollContainer extends ICoreponent
   {
      
      function setScrollPositionInPercent(param1:Number, param2:uint = 2) : void;
      
      function getScrollPositionInPercent() : Number;
   }
}

