package net.bigpoint.darkorbit.net.netty.handlers.captain
{
   import net.bigpoint.darkorbit.com.module.EnergyUpdateCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class EnergyUpdateHandler extends BaseHandler
   {
      
      public function EnergyUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:EnergyUpdateCommand) : void
      {
         _main.getConnectionManager().getAttributeAssembly().assembleCaptainEnergyUpdate(param1.currentCaptainEnergy,param1.maxCaptainEnergy,param1.captainEnergyDrain);
      }
   }
}

