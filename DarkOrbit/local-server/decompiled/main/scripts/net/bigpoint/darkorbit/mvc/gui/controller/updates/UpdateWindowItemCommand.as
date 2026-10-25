package net.bigpoint.darkorbit.mvc.gui.controller.updates
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.WindowItemCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UpdateWindowItemCommand extends DOAbstractSimpleCommand
   {
      
      public function UpdateWindowItemCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:IWindow = null;
         var _loc2_:WindowItemCommand = param1.getBody() as WindowItemCommand;
         var _loc3_:FeatureWindowVO = guiProxy.getFeatureWindowById(_loc2_.itemId);
         if(_loc3_)
         {
            _loc3_.update(new PointLite(_loc2_.posX,_loc2_.posY),new PointLite(_loc2_.width,_loc2_.height),_loc2_.maximized,_loc2_.windowTitle,_loc2_.helpText,_loc2_.toolTip);
            sendNotification(GuiNotifications.TOGGLE_ALL_WINDOWS,_loc3_);
            _loc4_ = guiManager.getWindow(_loc3_.id);
            if(_loc4_)
            {
               _loc4_.update(_loc3_,_loc2_.visible);
            }
            sendNotification(FeaturesMenuNotifications.UPDATE_ITEMS_VISIBILITY,_loc2_);
            sendNotification(FeaturesMenuNotifications.UPDATE_BTNS_SELECTIONS);
         }
      }
   }
}

