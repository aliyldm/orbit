package net.bigpoint.darkorbit.mvc.gui.featuresMenu.controller.logic
{
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractLayoutedListBar;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.controller.MenuPositionsAbstractCommand;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.AbstractMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.view.AbstractMenuMediator;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.FeaturesMenuProxy;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.view.FeaturesMenuMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CheckFeaturesMenuBoundsCommand extends MenuPositionsAbstractCommand
   {
      
      public function CheckFeaturesMenuBoundsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         checkBoundsAndSavePositions();
      }
      
      override protected function savePosition(param1:DOAbstractLayoutedListBar, param2:Boolean = false) : void
      {
         super.savePosition(param1,param2);
         sendNotification(FeaturesMenuNotifications.UPDATE_WINDOWS_MINIMIZED_POSITIONS);
      }
      
      override protected function get menuProxy() : AbstractMenuProxy
      {
         return retrieveProxy(FeaturesMenuProxy.NAME) as AbstractMenuProxy;
      }
      
      override protected function get menuMediator() : AbstractMenuMediator
      {
         return retrieveMediator(FeaturesMenuMediator.NAME) as AbstractMenuMediator;
      }
   }
}

