package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.MarkedByReconEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class MarkedByReconEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "abstract_ui_marked_red.zip";
      
      private var _effect:MarkedByReconEffect;
      
      public function MarkedByReconEffect3D(param1:MapView3D, param2:MarkedByReconEffect)
      {
         this._effect = param2;
         super(param2,PARTICLES_FILE,param2.source.position);
      }
   }
}

