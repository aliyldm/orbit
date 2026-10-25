package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.MarkTargetEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class MarkTargetEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:Object = {};
      
      PARTICLES_FILE[MarkTargetEffect.IN_RANGE] = "abstract_ui_marked_purple.zip";
      PARTICLES_FILE[MarkTargetEffect.OUT_OF_RANGE] = "abstract_ui_marked_blue.zip";
      
      private var _effect:MarkTargetEffect;
      
      public function MarkTargetEffect3D(param1:MapView3D, param2:MarkTargetEffect)
      {
         this._effect = param2;
         super(param2,PARTICLES_FILE[param2.targetState],param2.source.position);
      }
   }
}

