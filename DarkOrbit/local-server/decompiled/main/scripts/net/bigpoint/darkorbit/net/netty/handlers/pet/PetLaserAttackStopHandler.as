package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetLaserAttackStopCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetLaserAttackStopHandler extends BaseHandler
   {
      
      public function PetLaserAttackStopHandler()
      {
         super();
      }
      
      public static function run(param1:PetLaserAttackStopCommand) : void
      {
         var _loc2_:int = param1.petId;
         _main.getConnectionManager().getPetAssembly().assembleStopLaserAttack(_loc2_);
      }
   }
}

