package net.bigpoint.darkorbit.map.view3D.effects.impl.cannon
{
   import net.bigpoint.darkorbit.map.model.effects.impl.cannon.CannonPositionAreaEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   
   public class CannonPositionAreaEffect3D extends StandaloneParticle3D
   {
      
      public function CannonPositionAreaEffect3D(param1:MapView3D, param2:CannonPositionAreaEffect)
      {
         super(param2,"cannon_position_area.zip",param2.source.position);
      }
   }
}

