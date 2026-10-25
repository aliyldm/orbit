package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.FrostFieldEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractShipEffect2D;
   
   public class FrostFieldEffect2D extends AbstractShipEffect2D
   {
      
      public function FrostFieldEffect2D(param1:MapView2D, param2:FrostFieldEffect)
      {
         super(param1,param2);
         fps = 24;
      }
      
      override protected function initEffectVisuals() : void
      {
         start();
         this.clip.scaleX = this.clip.scaleY = this.clip.scaleZ = 8;
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

