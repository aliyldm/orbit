package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetIsDestroyedCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetIsDestroyedHandler extends BaseHandler
   {
      
      public function PetIsDestroyedHandler()
      {
         super();
      }
      
      public static function run(param1:PetIsDestroyedCommand) : void
      {
         var _loc2_:int = param1.destroyedType;
         _main.getConnectionManager().getPetAssembly().assemblePetDestroyed(_loc2_);
      }
   }
}

