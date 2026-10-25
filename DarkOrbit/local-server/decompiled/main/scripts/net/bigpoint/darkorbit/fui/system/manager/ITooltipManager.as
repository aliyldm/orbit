package net.bigpoint.darkorbit.fui.system.manager
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   
   public interface ITooltipManager
   {
      
      function assignTooltipTemplateID(param1:String, param2:Coreponent = null, param3:int = 1000) : void;
      
      function attemptToRemoveTooltip() : void;
      
      function hasToolTip(param1:Coreponent) : Boolean;
      
      function get tooltipLayer() : DisplayObjectContainer;
   }
}

