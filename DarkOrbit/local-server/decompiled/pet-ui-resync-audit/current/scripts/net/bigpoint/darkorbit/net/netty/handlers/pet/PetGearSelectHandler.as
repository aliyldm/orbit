package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetGearSelectCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetGearSelectHandler extends BaseHandler
   {
      
      public function PetGearSelectHandler()
      {
         super();
      }
      
      public static function run(param1:PetGearSelectCommand) : void
      {
         var _loc2_:int = param1.gearType.typeValue;
         var _loc3_:Vector.<int> = param1.optionalParams;
         _main.getConnectionManager().getPetAssembly().assembleSelectGear(_loc2_,_loc3_);
      }
   }
}

