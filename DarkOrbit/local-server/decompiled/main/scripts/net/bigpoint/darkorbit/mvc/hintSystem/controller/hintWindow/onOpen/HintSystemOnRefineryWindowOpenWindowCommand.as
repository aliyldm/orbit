package net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow.onOpen
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.common.utils.ScreenScaleUtils;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.common.view.GuiMediator;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemHintWindowOnActionVO;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintWindow.HintSystemHintWindowMediator;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintWindow.HintWindow;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class HintSystemOnRefineryWindowOpenWindowCommand extends SimpleCommand
   {
      
      public function HintSystemOnRefineryWindowOpenWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc5_:HintSystemHintWindowMediator = null;
         var _loc6_:HintWindow = null;
         var _loc7_:GuiMediator = null;
         var _loc8_:SimpleWindow = null;
         var _loc9_:PointLite = null;
         var _loc10_:PointLite = null;
         var _loc11_:PointLite = null;
         var _loc12_:PointLite = null;
         super.execute(param1);
         var _loc2_:HintSystemHintWindowOnActionVO = param1.getBody() as HintSystemHintWindowOnActionVO;
         var _loc3_:Boolean = _loc2_.contentVO.wasOpenedFromArchive;
         if(!_loc3_)
         {
            _loc5_ = facade.retrieveMediator(HintSystemHintWindowMediator.NAME) as HintSystemHintWindowMediator;
            _loc6_ = _loc5_.getHintWindow();
            _loc7_ = facade.retrieveMediator(GuiMediator.NAME) as GuiMediator;
            _loc8_ = _loc7_.getWindowById(GuiConstants.REFINEMENT_WINDOW) as SimpleWindow;
            _loc9_ = ScreenManager.getInstance().stageSize;
            _loc10_ = _loc8_.size;
            _loc11_ = new PointLite(ScreenManager.getHalfScreenWidth() + (_loc6_.width >> 1),100);
            _loc12_ = ScreenScaleUtils.getPercentagePosFromRealPos(_loc9_,_loc11_,_loc10_);
            _loc8_.position.x = _loc12_.x;
            _loc8_.position.y = _loc12_.y;
            if(!_loc8_.maximized)
            {
               _loc8_.maximize(false);
            }
         }
         var _loc4_:HintSystemHintWindowOnActionVO = param1.getBody() as HintSystemHintWindowOnActionVO;
         this.facade.removeCommand(_loc4_.notificationName);
      }
   }
}

