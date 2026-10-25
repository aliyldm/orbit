package net.bigpoint.darkorbit.net.netty.handlers.capture
{
   import net.bigpoint.darkorbit.com.module.CTBBeaconReleasedCommand;
   import net.bigpoint.darkorbit.ctb.BeaconTrait;
   
   public class CTBBeaconReleasedHandler extends AbstractCTBHandler
   {
      
      public function CTBBeaconReleasedHandler()
      {
         super();
      }
      
      public static function run(param1:CTBBeaconReleasedCommand) : void
      {
         map.removeTraitById(param1.userId,BeaconTrait);
      }
   }
}

