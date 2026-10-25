package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.SpawnEffectWithFadeIn;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class SpawnEffectWithFadeIn2D extends AbstractMapObjectEffect2D
   {
      
      public function SpawnEffectWithFadeIn2D(param1:MapView2D, param2:SpawnEffectWithFadeIn)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         super.initEffectVisuals();
         playAnimation(false,1,true,true);
      }
   }
}

