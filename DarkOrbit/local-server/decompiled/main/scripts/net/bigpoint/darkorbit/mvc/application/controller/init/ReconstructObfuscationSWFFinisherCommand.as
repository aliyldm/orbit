package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import net.bigpoint.darkorbit.net.netty.utils.InjectedObfuscationWrapper;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class ReconstructObfuscationSWFFinisherCommand extends AsyncCommand
   {
      
      public function ReconstructObfuscationSWFFinisherCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         this.reconstructFinisher();
         this.commandComplete();
      }
      
      private function reconstructFinisher() : void
      {
         InjectedObfuscationWrapper.FINISHER_op[6] = 97;
         InjectedObfuscationWrapper.FINISHER_op[7] = 98;
         InjectedObfuscationWrapper.FINISHER_op[8] = 99;
         InjectedObfuscationWrapper.FINISHER_op[9] = 46;
         InjectedObfuscationWrapper.FINISHER_op[10] = 65;
      }
   }
}

