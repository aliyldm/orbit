package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetUIRepairButtonCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetUIRepairButtonHandler extends BaseHandler
   {
      
      public function PetUIRepairButtonHandler()
      {
         super();
      }
      
      public static function run(param1:PetUIRepairButtonCommand) : void
      {
         var _loc2_:Boolean = param1.enabled;
         var _loc3_:int = param1.repairCosts;
         _main.getConnectionManager().getPetAssembly().assembleSetRepairButtonState(_loc2_,_loc3_);
      }
   }
}

