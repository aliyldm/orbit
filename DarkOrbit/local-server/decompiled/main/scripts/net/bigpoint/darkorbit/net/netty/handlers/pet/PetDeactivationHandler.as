package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetDeactivationCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetDeactivationHandler extends BaseHandler
   {
      
      public function PetDeactivationHandler()
      {
         super();
      }
      
      public static function run(param1:PetDeactivationCommand) : void
      {
         _main.getConnectionManager().getPetAssembly().assemblePetDeactivation(true);
      }
   }
}

