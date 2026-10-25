package net.bigpoint.darkorbit.map.view2D.display.ship.drones
{
   public class DroneMotionPolicy2D
   {
      
      public var dense:Boolean = false;
      
      public var nearby:int = 0;
      
      public var transitions:int = 0;
      
      private var belowSince:int = -1;
      
      public function DroneMotionPolicy2D()
      {
         super();
      }
      
      public function update(param1:int, param2:int) : Boolean
      {
         this.nearby = param1;
         if(param1 > 20)
         {
            this.belowSince = -1;
            if(!this.dense)
            {
               this.dense = true;
            }
         }
         else if(param1 < 20 && this.dense)
         {
            if(this.belowSince < 0)
            {
               this.belowSince = param2;
            }
            else if(param2 - this.belowSince >= 5000)
            {
               this.dense = false;
               this.belowSince = -1;
            }
         }
         else
         {
            this.belowSince = -1;
         }
         return this.dense;
      }
   }
}

