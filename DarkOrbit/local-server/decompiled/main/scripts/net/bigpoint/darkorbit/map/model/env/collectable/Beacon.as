package net.bigpoint.darkorbit.map.model.env.collectable
{
   public class Beacon extends Collectable
   {
      
      public function Beacon(param1:int, param2:String, param3:int, param4:int)
      {
         super("beacon_" + param1,param2,param3,param4,false);
      }
   }
}

