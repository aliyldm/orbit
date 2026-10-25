package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetShieldUpdateCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetShieldUpdateHandler extends BaseHandler
   {
      
      public function PetShieldUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:PetShieldUpdateCommand) : void
      {
         var _loc2_:Number = param1.petShieldNow;
         var _loc3_:Number = param1.petShieldMax;
         _main.getConnectionManager().getPetAssembly().assemblePetShieldInfo(_loc2_,_loc3_);
      }
   }
}

