package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class JAMXCreedDamageEffect3D extends StandaloneParticle3D
   {
      
      private static const URL:String = "ability_jamx-creed_damage.zip";
      
      public function JAMXCreedDamageEffect3D(param1:MapView3D, param2:MapObjectEffect)
      {
         super(param2,URL,param2.source.position);
      }
   }
}

