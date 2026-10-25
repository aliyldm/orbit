package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.AccountStatusChangeCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class AccountStatusChangeHandlerCommand extends SimpleCommand
   {
      
      public function AccountStatusChangeHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:AccountStatusChangeCommand = param1.getBody() as AccountStatusChangeCommand;
         Hero.premium.value = _loc2_.premium;
      }
   }
}

