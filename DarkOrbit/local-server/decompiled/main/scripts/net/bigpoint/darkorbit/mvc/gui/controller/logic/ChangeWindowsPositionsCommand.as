package net.bigpoint.darkorbit.mvc.gui.controller.logic
{
   import com.bigpoint.utils.PointLite;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.utils.ScreenScaleUtils;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ChangeWindowsPositionsCommand extends DOAbstractSimpleCommand
   {
      
      public function ChangeWindowsPositionsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Object = null;
         var _loc3_:SimpleWindow = null;
         var _loc4_:FeatureWindowVO = null;
         var _loc5_:PointLite = null;
         var _loc6_:PointLite = null;
         var _loc7_:PointLite = null;
         var _loc8_:PointLite = null;
         for(_loc2_ in guiManager.windows)
         {
            _loc3_ = guiManager.windows[_loc2_] as SimpleWindow;
            _loc4_ = guiProxy.getFeatureWindowById(_loc3_.id);
            _loc5_ = screenManager.stageSize;
            _loc6_ = _loc4_.size;
            _loc7_ = _loc4_.position;
            _loc8_ = ScreenScaleUtils.getRealPosFromPercentagePos(_loc5_,_loc6_,_loc7_);
            if(_loc3_.maximized)
            {
               _loc3_.x = _loc8_.x;
               _loc3_.y = _loc8_.y;
            }
         }
         sendNotification(GuiNotifications.SAVE_BARS_SETTINGS);
      }
      
      protected function get stageRectangle() : Rectangle
      {
         return new Rectangle(0,0,screenManager.stageWidth,screenManager.stageHeight);
      }
   }
}

