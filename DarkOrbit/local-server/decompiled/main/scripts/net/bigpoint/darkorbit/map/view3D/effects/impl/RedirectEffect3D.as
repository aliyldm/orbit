package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.RedirectEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class RedirectEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "redirect.zip";
      
      private var _effect:RedirectEffect;
      
      public function RedirectEffect3D(param1:MapView3D, param2:RedirectEffect)
      {
         this._effect = param2;
         super(param2,PARTICLES_FILE,param2.source.position);
      }
   }
}

