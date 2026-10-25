package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import flash.media.SoundChannel;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.ProtectionEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class ProtectionEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "protection.zip";
      
      private var _soundChannel:SoundChannel = null;
      
      private var _effect:ProtectionEffect;
      
      public function ProtectionEffect3D(param1:MapView3D, param2:ProtectionEffect)
      {
         this._effect = param2;
         super(param2,PARTICLES_FILE,param2.source.position);
      }
      
      override protected function initAndPlay() : void
      {
         this._soundChannel = AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_CITADEL_PROTECTION,false,false,this._effect.source.position.x,this._effect.source.position.y);
         super.initAndPlay();
      }
      
      override protected function cleanUpView() : void
      {
         if(this._soundChannel != null)
         {
            AudioManager.removeLoop(this._soundChannel);
         }
         super.cleanUpView();
      }
   }
}

