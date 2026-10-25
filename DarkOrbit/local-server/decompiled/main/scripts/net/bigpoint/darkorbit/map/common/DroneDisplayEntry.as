package net.bigpoint.darkorbit.map.common
{
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   
   public class DroneDisplayEntry
   {
      
      public var ship:Ship;
      
      public var player:Boolean;
      
      public var allowed:Boolean = false;
      
      public var trails:Boolean = false;
      
      private var changed:Function;
      
      public function DroneDisplayEntry(param1:Ship, param2:Function)
      {
         super();
         this.ship = param1;
         this.changed = param2;
         this.player = !param1.isNPC && !(param1 is Pet);
      }
      
      public function apply(param1:Boolean, param2:Boolean) : void
      {
         param2 = param1 && param2;
         if(this.allowed == param1 && this.trails == param2)
         {
            return;
         }
         this.allowed = param1;
         this.trails = param2;
         if(this.changed != null)
         {
            this.changed(param1,param2);
         }
      }
      
      public function dispose() : void
      {
         this.changed = null;
         this.ship = null;
      }
   }
}

