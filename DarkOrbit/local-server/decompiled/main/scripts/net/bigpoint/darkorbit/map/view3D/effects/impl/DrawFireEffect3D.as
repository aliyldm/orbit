package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.DrawFireEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class DrawFireEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "draw_fire.zip";
      
      private var _effect:DrawFireEffect;
      
      public function DrawFireEffect3D(param1:MapView3D, param2:DrawFireEffect)
      {
         this._effect = param2;
         super(param2,PARTICLES_FILE,param2.source.position);
      }
      
      override protected function initAndPlay() : void
      {
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_CITADEL_DRAW_FIRE,false,false,this._effect.source.position.x,this._effect.source.position.y);
         super.initAndPlay();
      }
   }
}

