package net.bigpoint.darkorbit.mvc.gui.controller.requests
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.UIWindowUpdateRequest;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.utils.ScreenScaleUtils;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SendWindowUpdateRequest extends DOAbstractSimpleCommand
   {
      
      public function SendWindowUpdateRequest()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc5_:UIWindowUpdateRequest = null;
         var _loc2_:IWindow = param1.getBody() as IWindow;
         var _loc3_:PointLite = ScreenScaleUtils.getPercentagePosFromRealPos(screenManager.stageSize,_loc2_.position,_loc2_.size);
         var _loc4_:FeatureWindowVO = guiProxy.getFeatureWindowById(_loc2_.id);
         if(_loc4_)
         {
            _loc4_.update(_loc3_,_loc2_.size,_loc2_.maximized);
            sendNotification(GuiNotifications.TOGGLE_ALL_WINDOWS,_loc4_);
            if(_loc4_.saveSettingsOnServer)
            {
               _loc5_ = new UIWindowUpdateRequest(_loc4_.id,_loc4_.position.x,_loc4_.position.y,_loc4_.size.x,_loc4_.size.y,_loc4_.maximized);
               connectionProxy.sendNettyRequest(_loc5_);
            }
         }
      }
   }
}

