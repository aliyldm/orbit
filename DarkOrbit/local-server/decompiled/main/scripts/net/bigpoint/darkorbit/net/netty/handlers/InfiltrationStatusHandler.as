package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.InfiltrationStatusCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class InfiltrationStatusHandler extends BaseHandler
   {
      
      public function InfiltrationStatusHandler()
      {
         super();
      }
      
      public static function run(param1:InfiltrationStatusCommand) : void
      {
         _main.getInfiltrationGameManager().updateInfiltrationGameWindow(param1.secondsRemaining,param1.maxNpcs - param1.currentNpcs,param1.maxNpcs);
      }
   }
}

