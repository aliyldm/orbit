package net.bigpoint.darkorbit.mvc.display.filter
{
   public interface IDropShadowFilter extends IGlowFilter
   {
      
      function get distance() : Number;
      
      function set distance(param1:Number) : void;
      
      function get angle() : Number;
      
      function set angle(param1:Number) : void;
   }
}

