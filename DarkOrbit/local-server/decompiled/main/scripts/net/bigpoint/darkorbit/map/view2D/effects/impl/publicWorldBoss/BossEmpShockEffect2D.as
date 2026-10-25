package net.bigpoint.darkorbit.map.view2D.effects.impl.publicWorldBoss
{
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossEmpShockEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.template.SimpleEffect2D;
   
   public class BossEmpShockEffect2D extends SimpleEffect2D
   {
      
      public function BossEmpShockEffect2D(param1:MapView2D, param2:BossEmpShockEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         this.clip.scaleX = this.clip.scaleY = 2;
         super.initEffectVisuals();
      }
   }
}

