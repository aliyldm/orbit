package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import flash.media.SoundChannel;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.DecloakEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class DecloakEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "decloak.zip";
      
      private var _soundChannel:SoundChannel = null;
      
      public function DecloakEffect3D(param1:MapView3D, param2:DecloakEffect)
      {
         this._soundChannel = AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_CITADEL_PROTECTION,true,false,param2.source.position.x,param2.source.position.y);
         super(param2,PARTICLES_FILE,param2.source.position);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         super.disposeView(param1);
         if(this._soundChannel != null)
         {
            AudioManager.removeLoop(this._soundChannel);
         }
      }
   }
}

