package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetIdleModeCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetIdleModeHandler extends BaseHandler
   {
      
      public function PetIdleModeHandler()
      {
         super();
      }
      
      public static function run(param1:PetIdleModeCommand) : void
      {
         var _loc2_:int = param1.petId;
         var _loc3_:Boolean = param1.isIdle;
         _main.getConnectionManager().getPetAssembly().assembleInvisibleMode(_loc2_,_loc3_);
      }
   }
}

