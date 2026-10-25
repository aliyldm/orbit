package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.PetSpawnEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class PetSpawnEffect3D extends StandaloneParticle3D
   {
      
      private static const URL:String = "spawn_pet.zip";
      
      public function PetSpawnEffect3D(param1:MapView3D, param2:PetSpawnEffect)
      {
         super(param2,URL,param2.source.position);
      }
   }
}

