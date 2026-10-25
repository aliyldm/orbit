package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.ShieldDisarrayEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class ShieldDisarrayEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function ShieldDisarrayEffect2D(param1:MapView2D, param2:ShieldDisarrayEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         setClip(ResourceManager.getMovieClip("ui","shieldDisarray"));
         fps = 60;
         playAnimation(true,1,true);
      }
   }
}

