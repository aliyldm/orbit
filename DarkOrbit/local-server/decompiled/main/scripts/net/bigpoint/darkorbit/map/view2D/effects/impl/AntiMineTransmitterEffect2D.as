package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.AntiMineTransmitterEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractShipEffect2D;
   
   public class AntiMineTransmitterEffect2D extends AbstractShipEffect2D
   {
      
      public function AntiMineTransmitterEffect2D(param1:MapView2D, param2:AntiMineTransmitterEffect)
      {
         super(param1,param2);
         fps = 24;
      }
      
      override protected function initEffectVisuals() : void
      {
         start();
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         super.disposeView(param1);
      }
   }
}

