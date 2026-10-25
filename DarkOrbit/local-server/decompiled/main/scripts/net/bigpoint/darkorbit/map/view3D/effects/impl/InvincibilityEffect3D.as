package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.InvincibilityEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class InvincibilityEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "invincibility.zip";
      
      public function InvincibilityEffect3D(param1:MapView3D, param2:InvincibilityEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
      }
   }
}

