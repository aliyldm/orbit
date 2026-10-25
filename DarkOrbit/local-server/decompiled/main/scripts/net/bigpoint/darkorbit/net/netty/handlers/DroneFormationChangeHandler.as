package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.DroneFormationChangeCommand;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class DroneFormationChangeHandler extends BaseHandler
   {
      
      public function DroneFormationChangeHandler()
      {
         super();
      }
      
      public static function run(param1:DroneFormationChangeCommand) : void
      {
         var _loc2_:Ship = _main.screenManager.map.getShipManager().getShip(param1.uid);
         if(_loc2_)
         {
            _loc2_.drones.droneFormationId.value = param1.selectedFormationId;
         }
      }
   }
}

