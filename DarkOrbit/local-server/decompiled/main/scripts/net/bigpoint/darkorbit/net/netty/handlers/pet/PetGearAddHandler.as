package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetGearAddCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetGearAddHandler extends BaseHandler
   {
      
      public function PetGearAddHandler()
      {
         super();
      }
      
      public static function run(param1:PetGearAddCommand) : void
      {
         var _loc2_:int = param1.gearType.typeValue;
         var _loc3_:int = param1.level;
         var _loc4_:int = param1.amount;
         var _loc5_:Boolean = param1.enabled;
         _main.getConnectionManager().getPetAssembly().assembleAddGear(_loc2_,_loc3_,_loc4_,_loc5_);
      }
   }
}

