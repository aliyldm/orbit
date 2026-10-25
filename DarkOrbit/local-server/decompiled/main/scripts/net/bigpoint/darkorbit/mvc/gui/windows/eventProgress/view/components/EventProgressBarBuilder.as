package net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.view.components
{
   import net.bigpoint.darkorbit.fui.builder.xml.creators.AbstractCreator;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   
   public class EventProgressBarBuilder extends AbstractCreator
   {
      
      public function EventProgressBarBuilder()
      {
         super();
      }
      
      public function create(param1:XML) : ICoreponent
      {
         var _loc2_:ICoreponent = new EventProgressBar();
         mapXMLNodeAttributes(_loc2_,param1);
         return _loc2_;
      }
   }
}

