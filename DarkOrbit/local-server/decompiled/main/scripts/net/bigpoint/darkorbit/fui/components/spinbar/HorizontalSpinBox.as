package net.bigpoint.darkorbit.fui.components.spinbar
{
   import net.bigpoint.darkorbit.fui.builder.xml.factories.LayoutFactory;
   
   public class HorizontalSpinBox extends AbstractSpinBox
   {
      
      public function HorizontalSpinBox()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         layout = LayoutFactory.create(LayoutFactory.LAYOUT_HORIZONTAL);
         layout.gap = 0;
      }
   }
}

