package net.bigpoint.darkorbit.net.netty.handlers.mapEvent
{
   import net.bigpoint.darkorbit.com.module.AddBeaconCommand;
   import net.bigpoint.darkorbit.map.model.env.collectable.Beacon;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AddBeaconHandler extends BaseHandler
   {
      
      public function AddBeaconHandler()
      {
         super();
      }
      
      public static function run(param1:AddBeaconCommand) : void
      {
         map.addEntity(new Beacon(param1.beaconId,param1.hash,param1.x,param1.y));
      }
   }
}

