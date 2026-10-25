package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetOutOfFuelCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetOutOfFuelHandler extends BaseHandler
   {
      
      public function PetOutOfFuelHandler()
      {
         super();
      }
      
      public static function run(param1:PetOutOfFuelCommand) : void
      {
         _main.getConnectionManager().getPetAssembly().assembleFuelMissingMode();
      }
   }
}

