package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetHeatUpdateCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetHeatUpdateHandler extends BaseHandler
   {
      
      public function PetHeatUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:PetHeatUpdateCommand) : void
      {
         var _loc2_:int = param1.heatLevel;
         var _loc3_:Number = param1.petHeatAmountMax;
         var _loc4_:Number = param1.petHeatAmount;
         var _loc5_:int = param1.heatState;
         _main.getConnectionManager().getPetAssembly().assemblePetHeatInfo(_loc2_,_loc4_,_loc3_,_loc5_);
      }
   }
}

