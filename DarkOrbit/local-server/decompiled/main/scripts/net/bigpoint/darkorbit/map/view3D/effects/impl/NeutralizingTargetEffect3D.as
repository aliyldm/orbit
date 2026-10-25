package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class NeutralizingTargetEffect3D extends StandaloneParticle3D
   {
      
      private static const URL:String = "ability_neutralizing-target.zip";
      
      public function NeutralizingTargetEffect3D(param1:MapView3D, param2:MapObjectEffect)
      {
         super(param2,URL,param2.source.position);
         fixedScale = 0.6;
      }
   }
}

