package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AbsorbationBeamEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class AbsorptionBeamEffect3D extends BeamEffect3D
   {
      
      public function AbsorptionBeamEffect3D(param1:MapView3D, param2:AbsorbationBeamEffect)
      {
         var _loc3_:String = param2.isElite ? "beam_absorbtion_elite.zip" : "beam_absorbtion.zip";
         super(param2,_loc3_,param2.source.position,param2.target.position);
      }
   }
}

