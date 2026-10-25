package net.bigpoint.darkorbit.fui.components.core
{
   public interface IDecorator
   {
      
      function decorate(param1:ICoreponent) : void;
      
      function activate() : void;
      
      function deactivate() : void;
   }
}

