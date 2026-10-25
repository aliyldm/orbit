package net.bigpoint.darkorbit.map.view3D.effects.impl.paladin
{
   import net.bigpoint.darkorbit.map.model.effects.impl.paladin.LastStandEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   
   public class LastStandEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "lastStandEffect.zip";
      
      public function LastStandEffect3D(param1:MapView3D, param2:LastStandEffect)
      {
         var _loc3_:String = param2.pattern.resKey;
         super(param2,_loc3_ == "" ? PARTICLES_FILE : _loc3_ + ".zip",param2.source.position);
      }
   }
}

