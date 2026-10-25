package net.bigpoint.darkorbit.net.netty.handlers.capture
{
   import net.bigpoint.darkorbit.com.module.CTBSetHomeZonesCommand;
   import net.bigpoint.darkorbit.ctb.CTBHomeZone;
   import net.bigpoint.darkorbit.map.model.Map;
   
   public class CTBSetHomeZonesHandler extends AbstractCTBHandler
   {
      
      public function CTBSetHomeZonesHandler()
      {
         super();
      }
      
      public static function run(param1:CTBSetHomeZonesCommand) : void
      {
         map.addEntity(new CTBHomeZone(Map.NEXT_FREE_ID,param1.beaconId,param1.x,param1.y));
      }
   }
}

