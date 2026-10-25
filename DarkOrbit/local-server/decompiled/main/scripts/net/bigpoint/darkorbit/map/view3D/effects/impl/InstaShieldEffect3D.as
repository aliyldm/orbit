package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.InstaShieldEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class InstaShieldEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "shield_instant.zip";
      
      public function InstaShieldEffect3D(param1:MapView3D, param2:InstaShieldEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position,null,true,0,true,3.4);
      }
   }
}

