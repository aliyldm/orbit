package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetHitpointsUpdateCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetHitpointsUpdateHandler extends BaseHandler
   {
      
      public function PetHitpointsUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:PetHitpointsUpdateCommand) : void
      {
         var _loc2_:int = param1.hitpointsNow;
         var _loc3_:int = param1.hitpointsMax;
         _main.getConnectionManager().getPetAssembly().assemblePetHPInfo(_loc2_,_loc3_);
      }
   }
}

