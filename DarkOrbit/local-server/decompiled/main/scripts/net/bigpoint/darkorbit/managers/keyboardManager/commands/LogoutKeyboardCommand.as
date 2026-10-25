package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.FeaturesMenuMediator;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.components.FeatureBtn;
   
   public class LogoutKeyboardCommand implements IKeyboardCommand
   {
      
      public static const NAME:String = "logout";
      
      public function LogoutKeyboardCommand()
      {
         super();
      }
      
      public function execute(param1:Map, param2:Vector.<String>) : void
      {
         var _loc3_:SimpleWindow = GuiManager.instance.getWindow(GuiConstants.LOGOUT_WINDOW) as SimpleWindow;
         var _loc4_:FeaturesMenuMediator = this.gameFacade.retrieveMediator(FeaturesMenuMediator.NAME) as FeaturesMenuMediator;
         var _loc5_:FeatureBtn = _loc4_.getGameFeatureBtnById(GuiConstants.LOGOUT_WINDOW);
         if(!_loc3_.isLocked())
         {
            this.gameFacade.sendNotification(FeaturesMenuNotifications.ACTION_TRIGERRED,_loc5_,GuiConstants.LOGOUT_WINDOW);
         }
      }
      
      private function get gameFacade() : GameFacade
      {
         return GameFacade.getInstance();
      }
   }
}

