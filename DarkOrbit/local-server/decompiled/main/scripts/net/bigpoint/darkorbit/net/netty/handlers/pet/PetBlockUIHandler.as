package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetBlockUICommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetBlockUIHandler extends BaseHandler
   {
      
      public function PetBlockUIHandler()
      {
         super();
      }
      
      public static function run(param1:PetBlockUICommand) : void
      {
         var _loc2_:Boolean = param1.blocked;
         var _loc3_:Boolean = param1.blockAll;
         _main.getConnectionManager().getPetAssembly().assembleLockWindow(_loc2_,_loc3_);
      }
   }
}

