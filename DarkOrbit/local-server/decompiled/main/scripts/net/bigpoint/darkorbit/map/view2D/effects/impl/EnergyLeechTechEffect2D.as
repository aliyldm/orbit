package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.map.model.effects.impl.TechEnergyLeechEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class EnergyLeechTechEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function EnergyLeechTechEffect2D(param1:MapView2D, param2:TechEnergyLeechEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         this.handleEnergyLeechContinueAnimating();
         playAnimation();
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         TweenMax.killTweensOf(this.handleEnergyLeechContinueAnimating);
         TweenMax.killTweensOf(this.handleEnergyLeechPause);
         super.disposeView(param1);
      }
      
      private function handleEnergyLeechPause() : void
      {
         TweenMax.to(effectMc,1,{"alpha":0});
         TweenMax.delayedCall(7,this.handleEnergyLeechContinueAnimating);
      }
      
      private function handleEnergyLeechContinueAnimating() : void
      {
         TweenMax.to(effectMc,1,{"alpha":1});
         TweenMax.delayedCall(2,this.handleEnergyLeechPause);
      }
   }
}

