package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetGearResetCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetGearResetHandler extends BaseHandler
   {
      
      public function PetGearResetHandler()
      {
         super();
      }
      
      public static function run(param1:PetGearResetCommand) : void
      {
         _main.getConnectionManager().getPetAssembly().assembleGearReset();
      }
   }
}

