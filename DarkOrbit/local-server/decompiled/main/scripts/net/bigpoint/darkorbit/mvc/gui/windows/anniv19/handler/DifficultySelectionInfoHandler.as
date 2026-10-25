package net.bigpoint.darkorbit.mvc.gui.windows.anniv19.handler
{
   import net.bigpoint.darkorbit.com.module.porting.birthday2025.Birthday2025GateWindowCommand;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.anniv19.DifficultySelectionNotification;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class DifficultySelectionInfoHandler extends BaseHandler
   {
      
      public function DifficultySelectionInfoHandler()
      {
         super();
      }
      
      public static function run(param1:Birthday2025GateWindowCommand) : void
      {
         GuiManager.instance.tryCreateAndOpen(GuiConstants.DIFFICULTY_SELECTION);
         GameFacade.getInstance().sendNotification(DifficultySelectionNotification.UPDATE,param1);
      }
   }
}

