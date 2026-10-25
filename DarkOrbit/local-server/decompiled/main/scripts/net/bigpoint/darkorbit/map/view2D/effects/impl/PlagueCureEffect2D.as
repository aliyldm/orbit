package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractShipEffect2D;
   
   public class PlagueCureEffect2D extends AbstractShipEffect2D
   {
      
      public function PlagueCureEffect2D(param1:MapView2D, param2:MapObjectEffect, param3:Boolean = true, param4:Boolean = true, param5:Boolean = false)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function initEffectVisuals() : void
      {
         playAnimation(false,1,true,true);
      }
   }
}

