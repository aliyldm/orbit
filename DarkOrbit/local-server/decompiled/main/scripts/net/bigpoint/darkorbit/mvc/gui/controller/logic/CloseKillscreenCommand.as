package net.bigpoint.darkorbit.mvc.gui.controller.logic
{
   import net.bigpoint.darkorbit.gui.windows.components.Killscreen;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class CloseKillscreenCommand extends SimpleCommand
   {
      
      public function CloseKillscreenCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:Killscreen = Killscreen.getInstance();
         if(_loc2_.visibleStatus)
         {
            _loc2_.removeRepairWindow();
         }
      }
   }
}

