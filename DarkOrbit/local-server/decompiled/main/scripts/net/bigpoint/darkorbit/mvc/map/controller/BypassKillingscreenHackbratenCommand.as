package net.bigpoint.darkorbit.mvc.map.controller
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.gui.windows.components.Killscreen;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class BypassKillingscreenHackbratenCommand extends SimpleCommand
   {
      
      public function BypassKillingscreenHackbratenCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         if(Hero.isKilled)
         {
            Killscreen.getInstance().setShowRepairWindow(true);
         }
      }
   }
}

