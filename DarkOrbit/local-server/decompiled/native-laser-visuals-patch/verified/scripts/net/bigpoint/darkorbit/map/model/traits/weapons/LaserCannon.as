package net.bigpoint.darkorbit.map.model.traits.weapons
{
   public class LaserCannon extends AbstractWeapons
   {
      
      public var laserClassID:int;
      
      public var positionsProvider:ILaserPositionProvider;
      
      public function LaserCannon(param1:ILaserPositionProvider = null)
      {
         super();
         this.positionsProvider = param1;
      }
   }
}

