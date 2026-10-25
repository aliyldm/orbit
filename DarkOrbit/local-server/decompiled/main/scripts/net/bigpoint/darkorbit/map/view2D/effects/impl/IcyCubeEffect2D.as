package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.IcyCubeEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class IcyCubeEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function IcyCubeEffect2D(param1:MapView2D, param2:IcyCubeEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         if(Boolean(mapObjectView) && Boolean(effectMc))
         {
            mapObjectView.addChild(effectMc);
            start();
         }
      }
   }
}

