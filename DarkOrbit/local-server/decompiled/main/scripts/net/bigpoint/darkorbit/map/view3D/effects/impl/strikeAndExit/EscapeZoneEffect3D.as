package net.bigpoint.darkorbit.map.view3D.effects.impl.strikeAndExit
{
   import net.bigpoint.darkorbit.map.model.effects.impl.strikeAndExit.EscapeZoneEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   
   public class EscapeZoneEffect3D extends StandaloneParticle3D
   {
      
      public function EscapeZoneEffect3D(param1:MapView3D, param2:EscapeZoneEffect)
      {
         super(param2,"EscapeZone.awp",param2.source.position);
      }
   }
}

