package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenLite;
   import net.bigpoint.darkorbit.map.model.effects.impl.PhaseOutEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class PhaseOutEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function PhaseOutEffect2D(param1:MapView2D, param2:PhaseOutEffect)
      {
         super(param1,param2);
         TweenLite.to(mapObjectView,0.2,{"autoAlpha":0});
      }
      
      override protected function initEffectVisuals() : void
      {
         playAnimation(false,1,true,false);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         TweenLite.killTweensOf(mapObjectView);
         playAnimation(false,1,true,false);
         TweenLite.to(mapObjectView,0.2,{
            "autoAlpha":1,
            "onComplete":this.removeView
         });
      }
      
      public function removeView() : void
      {
         super.disposeView(true);
      }
   }
}

