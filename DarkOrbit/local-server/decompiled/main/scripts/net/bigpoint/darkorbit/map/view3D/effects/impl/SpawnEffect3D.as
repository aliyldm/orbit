package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpawnEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class SpawnEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "spawn.zip";
      
      public function SpawnEffect3D(param1:MapView3D, param2:SpawnEffect)
      {
         super(param2,PARTICLES_FILE,new BindablePointLite(param2.x,param2.y));
         if(param2.playSound)
         {
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_PIRATE_SPAWN,false,false,param2.x,param2.y,true);
         }
      }
   }
}

