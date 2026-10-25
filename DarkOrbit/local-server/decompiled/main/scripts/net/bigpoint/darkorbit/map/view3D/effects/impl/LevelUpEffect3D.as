package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.LevelUpEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class LevelUpEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "abstract_ui_level_up.zip";
      
      public function LevelUpEffect3D(param1:MapView3D, param2:LevelUpEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
      }
      
      override protected function initAndPlay() : void
      {
         super.initAndPlay();
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_LEVEL_UP,false,false);
      }
   }
}

