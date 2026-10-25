package net.bigpoint.darkorbit.mvc.gui.featuresMenu.controller.init
{
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.controller.logic.CheckFeaturesMenuBoundsCommand;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.controller.logic.FeatureMenuActionCommand;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.controller.updates.UpdateFeaturesMenuPositionCommand;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.controller.updates.UpdateMenuItemsVisibilityCommand;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.controller.updates.UpdateWindowsMinimizedPositionsCommand;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.FeaturesMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.FeaturesMenuMediator;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.components.FeaturesMenu;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.ItemsControlMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitFeatureMenuCommand extends DOAbstractSimpleCommand
   {
      
      public function InitFeatureMenuCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         this.initModel();
         this.initView();
         this.initController();
         WarpControlsProxy.getProxy(GameFacade.getInstance()).sendListRequest();
      }
      
      private function initModel() : void
      {
         registerProxy(new FeaturesMenuProxy());
      }
      
      private function initController() : void
      {
         registerCommand(FeaturesMenuNotifications.UPDATE_POSITION,UpdateFeaturesMenuPositionCommand);
         registerCommand(FeaturesMenuNotifications.UPDATE_ITEMS_VISIBILITY,UpdateMenuItemsVisibilityCommand);
         registerCommand(FeaturesMenuNotifications.UPDATE_WINDOWS_MINIMIZED_POSITIONS,UpdateWindowsMinimizedPositionsCommand);
         registerCommand(FeaturesMenuNotifications.CHECK_BOUNDS_AND_SAVE_POS,CheckFeaturesMenuBoundsCommand);
         registerCommand(FeaturesMenuNotifications.ACTION_TRIGERRED,FeatureMenuActionCommand);
      }
      
      private function initView() : void
      {
         var _loc1_:SWFFinisher = ResourceManager.fileCollection.getFinisher(FeaturesMenuConstants.MENU_ID) as SWFFinisher;
         var _loc2_:FeaturesMenu = new FeaturesMenu(_loc1_);
         ScreenManager.getInstance().mainmenuLayer.addChild(_loc2_);
         registerMediator(new FeaturesMenuMediator(_loc2_,_loc1_));
      }
      
      protected function get featuresMenuProxy() : ItemsControlMenuProxy
      {
         return facade.retrieveProxy(ItemsControlMenuProxy.NAME) as ItemsControlMenuProxy;
      }
   }
}

