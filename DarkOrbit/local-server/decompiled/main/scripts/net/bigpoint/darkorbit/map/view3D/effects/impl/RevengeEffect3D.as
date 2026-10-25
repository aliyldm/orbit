package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.RevengeEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class RevengeEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "revenge.zip";
      
      private var _effect:RevengeEffect;
      
      public function RevengeEffect3D(param1:MapView3D, param2:RevengeEffect)
      {
         this._effect = param2;
         super(param2,PARTICLES_FILE,param2.source.position);
         fixedScale = 0.8;
      }
   }
}

