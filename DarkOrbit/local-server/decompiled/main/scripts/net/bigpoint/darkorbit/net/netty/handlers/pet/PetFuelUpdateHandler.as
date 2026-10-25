package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetFuelUpdateCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetFuelUpdateHandler extends BaseHandler
   {
      
      public function PetFuelUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:PetFuelUpdateCommand) : void
      {
         var _loc2_:int = param1.petFuelNow;
         var _loc3_:int = param1.petFuelMax;
         _main.getConnectionManager().getPetAssembly().assemblePetFuelInfo(_loc2_,_loc3_);
      }
   }
}

