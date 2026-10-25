package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.PetGearActivationChangeCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetGearActivationChangeHandler extends BaseHandler
   {
      
      public function PetGearActivationChangeHandler()
      {
         super();
      }
      
      public static function run(param1:PetGearActivationChangeCommand) : void
      {
         _main.getConnectionManager().getPetAssembly().assemblePetGearActivationChange(param1.active,param1.gearType);
      }
   }
}

