package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.PvpProtectionEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class PvPProtectionEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "invincibility_pvp.zip";
      
      public function PvPProtectionEffect3D(param1:MapView3D, param2:PvpProtectionEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
      }
   }
}

