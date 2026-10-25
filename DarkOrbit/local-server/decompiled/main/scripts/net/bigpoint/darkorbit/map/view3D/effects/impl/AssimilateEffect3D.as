package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.AssimilateEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class AssimilateEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "assimilate.zip";
      
      public function AssimilateEffect3D(param1:MapView3D, param2:AssimilateEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
      }
      
      override public function updateObj(param1:Number) : void
      {
         super.updateObj(param1);
         fixedScale = 0.5;
      }
   }
}

