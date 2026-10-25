package net.bigpoint.darkorbit.mvc.display.filter
{
   public interface IGlowFilter extends IBlurFilter
   {
      
      function set color(param1:uint) : void;
      
      function get color() : uint;
      
      function set alpha(param1:Number) : void;
      
      function get alpha() : Number;
      
      function set strength(param1:Number) : void;
      
      function get strength() : Number;
   }
}

