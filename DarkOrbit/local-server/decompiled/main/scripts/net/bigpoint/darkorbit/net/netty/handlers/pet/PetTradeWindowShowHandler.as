package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetTradeWindowShowCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetTradeWindowShowHandler extends BaseHandler
   {
      
      public function PetTradeWindowShowHandler()
      {
         super();
      }
      
      public static function run(param1:PetTradeWindowShowCommand) : void
      {
         _main.getConnectionManager().getPetAssembly().assembleActivateTradeWindow();
      }
   }
}

