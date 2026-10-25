package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetRepairCompleteCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetRepairCompleteHandler extends BaseHandler
   {
      
      public function PetRepairCompleteHandler()
      {
         super();
      }
      
      public static function run(param1:PetRepairCompleteCommand) : void
      {
         _main.getConnectionManager().getPetAssembly().assemblePetRepair();
      }
   }
}

