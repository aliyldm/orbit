package net.bigpoint.darkorbit.mvc.gui.windows.expedition.handler
{
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionJumpLevelInfoCommand;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.ExpeditionNotification;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ExpeditionJumpLevelInfoHandler extends BaseHandler
   {
      
      public function ExpeditionJumpLevelInfoHandler()
      {
         super();
      }
      
      public static function run(param1:ExpeditionJumpLevelInfoCommand) : void
      {
         GuiManager.instance.tryCreateAndOpen(GuiConstants.EXPEDITION_SELECT);
         GameFacade.getInstance().sendNotification(ExpeditionNotification.SHOW_SELECT,param1);
      }
   }
}

