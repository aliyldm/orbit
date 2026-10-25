package net.bigpoint.darkorbit.net.netty.handlers.capture
{
   import net.bigpoint.darkorbit.com.module.CTBBeaconCapturedCommand;
   import net.bigpoint.darkorbit.ctb.BeaconTrait;
   
   public class CTBBeaconCapturedHandler extends AbstractCTBHandler
   {
      
      public function CTBBeaconCapturedHandler()
      {
         super();
      }
      
      public static function run(param1:CTBBeaconCapturedCommand) : void
      {
         var _loc2_:int = param1.beaconId;
         var _loc3_:int = param1.userId;
         var _loc4_:BeaconTrait = map.getTraitById(_loc3_,BeaconTrait) as BeaconTrait;
         if(_loc4_ == null)
         {
            map.addTraitToId(_loc3_,new BeaconTrait(_loc2_));
         }
         else
         {
            _loc4_.beaconID.value = _loc2_;
         }
      }
   }
}

