package net.bigpoint.darkorbit.mvc.gui.featuresMenu.controller.updates
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.ui.lists.layoutedList.ListLayoutFactory;
   import com.bigpoint.utils.ui.lists.layoutedList.layouts.HorizontalListLayout;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.controller.MenuPositionsAbstractCommand;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.AbstractMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.view.AbstractMenuMediator;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.FeaturesMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.FeaturesMenuMediator;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.components.FeaturesMenu;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UpdateFeaturesMenuPositionCommand extends MenuPositionsAbstractCommand
   {
      
      public function UpdateFeaturesMenuPositionCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:String = null;
         if(this.menuProxy.menuBars)
         {
            _loc2_ = String(param1.getBody());
            switch(_loc2_)
            {
               case GuiConstants.SET_MENUS_INIT_POSITION:
                  setInitBarPosition(this.featuresMenu.gameFeatureBar);
                  setInitBarPosition(this.featuresMenu.genericFeatureBar);
                  sendNotification(FeaturesMenuNotifications.UPDATE_WINDOWS_MINIMIZED_POSITIONS);
                  break;
               case GuiConstants.CONFIG_RESET_AND_EXIT:
                  this.resetAllBarsPositions();
                  break;
               default:
                  updateBarPosition(this.featuresMenu.gameFeatureBar);
                  updateBarPosition(this.featuresMenu.genericFeatureBar);
            }
         }
      }
      
      private function resetAllBarsPositions() : void
      {
         var _loc1_:PointLite = new PointLite(FeaturesMenuConstants.MENU_LEFT_MARGIN,FeaturesMenuConstants.MENU_TOP_MARGIN);
         resetBarPosition(this.featuresMenu.gameFeatureBar,_loc1_);
         this.featuresMenu.genericFeatureBar.layoutedList.setLayout(ListLayoutFactory.getLayout(HorizontalListLayout.ID));
         var _loc2_:PointLite = new PointLite(screenManager.stageWidth - this.featuresMenu.genericFeatureBar.layoutedList.listWidth - FeaturesMenuConstants.MENU_RIGHT_MARGIN,FeaturesMenuConstants.MENU_TOP_MARGIN);
         resetBarPosition(this.featuresMenu.genericFeatureBar,_loc2_);
      }
      
      override protected function get menuProxy() : AbstractMenuProxy
      {
         return retrieveProxy(FeaturesMenuProxy.NAME) as AbstractMenuProxy;
      }
      
      private function get featuresMenu() : FeaturesMenu
      {
         return (this.menuMediator as FeaturesMenuMediator).view;
      }
      
      override protected function get menuMediator() : AbstractMenuMediator
      {
         return retrieveMediator(FeaturesMenuMediator.NAME) as AbstractMenuMediator;
      }
   }
}

