package net.bigpoint.darkorbit.mvc.gui.windows.common.view.components
{
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   
   public interface ITabItem
   {
      
      function get title() : String;
      
      function get view() : Coreponent;
      
      function set visible(param1:Boolean) : void;
      
      function get visible() : Boolean;
      
      function set active(param1:Boolean) : void;
      
      function get active() : Boolean;
   }
}

