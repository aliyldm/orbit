package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import net.bigpoint.darkorbit.net.netty.utils.InjectedObfuscationWrapper;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class ReconstructObfuscationSWFHeaderCommand extends AsyncCommand
   {
      
      public function ReconstructObfuscationSWFHeaderCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         this.reconstructHeader();
         this.commandComplete();
      }
      
      private function reconstructHeader() : void
      {
         InjectedObfuscationWrapper.HEADER_op[0] = 70;
         InjectedObfuscationWrapper.HEADER_op[5] = 2;
      }
   }
}

