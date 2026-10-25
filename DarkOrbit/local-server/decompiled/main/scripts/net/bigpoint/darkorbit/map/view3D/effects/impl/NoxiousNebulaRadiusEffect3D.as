package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import net.bigpoint.darkorbit.map.model.effects.impl.NoxiousNebulaRadiusEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class NoxiousNebulaRadiusEffect3D extends StandaloneParticle3D
   {
      
      private static const URL:String = "ability_noxious-nebula-radius.zip";
      
      private static const SCALE_FACTOR:Number = 0.68 / NoxiousNebulaRadiusEffect.MIN_RADIUS;
      
      public function NoxiousNebulaRadiusEffect3D(param1:MapView3D, param2:NoxiousNebulaRadiusEffect)
      {
         super(param2,URL,new BindablePointLite(param2.position.x,param2.position.y,param2.position.z));
         this.scale = param2.radius * SCALE_FACTOR;
      }
   }
}

