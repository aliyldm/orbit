package net.bigpoint.darkorbit.mvc.gui.windows.killUI.service
{
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class KillUICloseCommandHandler extends AbstractKillUIMessageCommandHandler
   {
      
      public function KillUICloseCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         GuiManager.instance.destroyWindow(GuiConstants.KILL_UI_WINDOW);
         destroyWindowCreateNotififcation();
      }
   }
}

