package net.bigpoint.darkorbit.mvc.gui.windows
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.window.PopupWindow;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   
   public class CreatePopupView
   {
      
      private static var instance:CreatePopupView;
      
      public function CreatePopupView()
      {
         super();
         if(instance)
         {
            throw new Error("CreatePopupView is a singleton and cannot be instantiated multiple times.");
         }
         instance = this;
      }
      
      public static function getInstance() : CreatePopupView
      {
         if(!instance)
         {
            instance = new CreatePopupView();
         }
         return instance;
      }
      
      public function createPopup(param1:Function, param2:String) : void
      {
         var _loc3_:GuiManager = GuiManager.instance;
         var _loc4_:SimpleWindow = (_loc3_.getWindow(GuiConstants.VIP_MERCHANT_EXCHANGE_POPUP) ? _loc3_.getWindow(GuiConstants.VIP_MERCHANT_EXCHANGE_POPUP) : _loc3_.createWindow(GuiConstants.VIP_MERCHANT_EXCHANGE_POPUP,new SimpleWindowCreationVO(GuiConstants.VIP_MERCHANT_EXCHANGE_POPUP,ScreenManager.getInstance().getWindowLayer2(),SimpleWindow.OPEN_STRATEGY_LAYER_2))) as SimpleWindow;
         var _loc5_:SimpleContainer = _loc4_.getContainer(0);
         _loc5_.removeAllElements();
         var _loc6_:DisplayObjectContainer = new Sprite();
         _loc5_.addElement(_loc6_);
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
         if(param1 == null)
         {
            _loc4_.setTitle("title_error");
            UISystem.getInstance().loadAndBuildWithResKey("confirmationPopup_ok",_loc6_,this.popupCreated,[_loc4_,_loc6_,param1,BPLocale.getItem("window_vip-exchange_not-enough-resources")]);
         }
         else
         {
            _loc4_.setTitle("title_alert");
            UISystem.getInstance().loadAndBuildWithResKey("confirmationPopup",_loc6_,this.popupCreated,[_loc4_,_loc6_,param1,param2]);
         }
      }
      
      private function popupCreated(param1:SimpleWindow, param2:DisplayObjectContainer, param3:Function, param4:String) : void
      {
         param1.maximize();
         param1.autoSize();
         new PopupWindow(param1,param2,param3,null,param4,null);
      }
   }
}

