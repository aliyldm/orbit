package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetEvasionCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetEvasionHandler extends BaseHandler
   {
      
      public function PetEvasionHandler()
      {
         super();
      }
      
      public static function run(param1:PetEvasionCommand) : void
      {
         var _loc2_:int = param1.petId;
         var _loc3_:Boolean = param1.evasionActive;
         _main.getConnectionManager().getPetAssembly().assembleEvasionProtocolInfo(_loc2_,_loc3_);
      }
   }
}

