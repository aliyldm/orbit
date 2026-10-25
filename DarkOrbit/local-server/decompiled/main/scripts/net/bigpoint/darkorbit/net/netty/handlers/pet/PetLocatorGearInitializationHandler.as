package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetLocatorGearInitializationCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetLocatorGearInitializationHandler extends BaseHandler
   {
      
      public function PetLocatorGearInitializationHandler()
      {
         super();
      }
      
      public static function run(param1:PetLocatorGearInitializationCommand) : void
      {
         var _loc2_:int = param1.locatorType.typeValue;
         var _loc3_:Vector.<int> = param1.possibleTargetValues;
         _main.getConnectionManager().getPetAssembly().assembleGearTargetsList(_loc2_,_loc3_);
      }
   }
}

