package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.ShieldDisarrayEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class ShieldDisarrayEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "shield_disarray.zip";
      
      private var _effect:ShieldDisarrayEffect;
      
      public function ShieldDisarrayEffect3D(param1:MapView3D, param2:ShieldDisarrayEffect)
      {
         this._effect = param2;
         super(param2,PARTICLES_FILE,param2.source.position);
      }
   }
}

