package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class PetSpawnEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function PetSpawnEffect2D(param1:MapView2D, param2:MapObjectEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         this.playAnimation(false,1,true,true);
      }
   }
}

