package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetPurchasedCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetPurchasedHandler extends BaseHandler
   {
      
      public function PetPurchasedHandler()
      {
         super();
      }
      
      public static function run(param1:PetPurchasedCommand) : void
      {
         _main.getConnectionManager().getPetAssembly().assembleRemoveBanner();
      }
   }
}

