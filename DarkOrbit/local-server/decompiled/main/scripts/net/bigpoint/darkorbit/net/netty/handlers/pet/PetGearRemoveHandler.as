package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetGearRemoveCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetGearRemoveHandler extends BaseHandler
   {
      
      public function PetGearRemoveHandler()
      {
         super();
      }
      
      public static function run(param1:PetGearRemoveCommand) : void
      {
         var _loc2_:int = param1.gearType.typeValue;
         _main.getConnectionManager().getPetAssembly().assembleRemoveGear(_loc2_);
      }
   }
}

