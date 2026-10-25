package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetGearLocatorUpdate;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetGearLocatorUpdateHandler extends BaseHandler
   {
      
      public function PetGearLocatorUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:PetGearLocatorUpdate) : void
      {
         var _loc2_:int = param1.x;
         var _loc3_:int = param1.y;
         _main.getConnectionManager().getPetAssembly().assembleLocatorGearInfo(_loc2_,_loc3_);
      }
   }
}

