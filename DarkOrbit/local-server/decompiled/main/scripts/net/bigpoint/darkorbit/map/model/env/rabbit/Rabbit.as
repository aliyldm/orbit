package net.bigpoint.darkorbit.map.model.env.rabbit
{
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.model.traits.weapons.LaserCannon;
   import net.bigpoint.darkorbit.map.model.traits.weapons.RocketLauncher;
   
   public class Rabbit extends Ship
   {
      
      public static const RABBIT_TYPE:String = "RABBIT_TYPE";
      
      public function Rabbit(param1:int, param2:int, param3:int)
      {
         super(param1,null,null);
         position.setTo(param2,param3,0);
         addTrait(new AttackTargetTrait());
         addTrait(new AttackerTrait(new LaserCannon(),new RocketLauncher()));
      }
   }
}

