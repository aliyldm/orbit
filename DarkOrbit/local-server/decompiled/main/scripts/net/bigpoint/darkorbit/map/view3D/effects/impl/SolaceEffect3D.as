package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class SolaceEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "solace.zip";
      
      private static const PARTICLES_FILE_PLUS:String = "solace_plus_striker_skill.zip";
      
      public function SolaceEffect3D(param1:MapView3D, param2:MapObjectEffect)
      {
         var _loc3_:Ship = param2.source as Ship;
         var _loc4_:String = PARTICLES_FILE;
         if(Boolean(_loc3_) && _loc3_.is_solace_plus_striker())
         {
            _loc4_ = PARTICLES_FILE_PLUS;
            this._aniSpeed = 0.3;
         }
         super(param2,_loc4_,param2.source.position);
      }
   }
}

