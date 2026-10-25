package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.ModuleInstallEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class ModuleInstallEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function ModuleInstallEffect2D(param1:MapView2D, param2:ModuleInstallEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         addChild(effectMc);
         start();
      }
   }
}

