package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class ShipWarpEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function ShipWarpEffect2D(param1:MapView2D, param2:MapObjectEffect)
      {
         super(param1,param2,true,false,true);
      }
      
      override protected function initEffectVisuals() : void
      {
         start();
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_PORTAL_JUMP);
      }
   }
}

