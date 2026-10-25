package net.bigpoint.darkorbit.mvc.application.controller.bootup
{
   import net.bigpoint.darkorbit.managers.ObjectPoolManager;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class InitObjectPoolManagerCommand extends AsyncCommand
   {
      
      public function InitObjectPoolManagerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         ObjectPoolManager.precache();
         ObjectPoolManager.init();
         commandComplete();
      }
   }
}

