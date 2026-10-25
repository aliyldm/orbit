package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import away3d.containers.ObjectContainer3D;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.ShipWarpEffect;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class ShipWarpEffect3D extends StandaloneParticle3D
   {
      
      private static const URL:String = "warp_ship.zip";
      
      private var _ship3D:ObjectContainer3D;
      
      public function ShipWarpEffect3D(param1:MapView3D, param2:ShipWarpEffect)
      {
         this._ship3D = param1.mainContainer.getViewByTrait(param2.source.getFirstTrait(UberDisplayTrait));
         super(param2,URL,param2.source.position);
      }
      
      override protected function initAndPlay() : void
      {
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_PORTAL_JUMP);
         super.initAndPlay();
      }
   }
}

