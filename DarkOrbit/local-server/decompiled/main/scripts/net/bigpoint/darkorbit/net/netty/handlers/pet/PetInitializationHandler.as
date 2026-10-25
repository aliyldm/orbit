package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetInitializationCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetInitializationHandler extends BaseHandler
   {
      
      public function PetInitializationHandler()
      {
         super();
      }
      
      public static function run(param1:PetInitializationCommand) : void
      {
         var _loc2_:Boolean = param1.hasPet;
         var _loc3_:Boolean = param1.hasFuel;
         var _loc4_:Boolean = param1.petIsAlive;
         _main.getConnectionManager().getPetAssembly().assemblePetInitilization(_loc2_,_loc3_,_loc4_);
      }
   }
}

