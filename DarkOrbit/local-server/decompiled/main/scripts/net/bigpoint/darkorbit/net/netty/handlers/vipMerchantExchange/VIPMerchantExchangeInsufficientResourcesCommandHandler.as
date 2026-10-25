package net.bigpoint.darkorbit.net.netty.handlers.vipMerchantExchange
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
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class VIPMerchantExchangeInsufficientResourcesCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function VIPMerchantExchangeInsufficientResourcesCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:GuiManager = GuiManager.instance;
         var _loc3_:SimpleWindow = (_loc2_.getWindow(GuiConstants.VIP_MERCHANT_EXCHANGE_POPUP) ? _loc2_.getWindow(GuiConstants.VIP_MERCHANT_EXCHANGE_POPUP) : _loc2_.createWindow(GuiConstants.VIP_MERCHANT_EXCHANGE_POPUP,new SimpleWindowCreationVO(GuiConstants.VIP_MERCHANT_EXCHANGE_POPUP,ScreenManager.getInstance().getWindowLayer2(),SimpleWindow.OPEN_STRATEGY_LAYER_2))) as SimpleWindow;
         var _loc4_:SimpleContainer = _loc3_.getContainer(0);
         _loc4_.removeAllElements();
         var _loc5_:DisplayObjectContainer = new Sprite();
         _loc4_.addElement(_loc5_);
         _loc3_.setTitle("title_error");
         UISystem.getInstance().loadAndBuildWithResKey("confirmationPopup_ok",_loc5_,this.popupCreated,[_loc3_,_loc5_,null,BPLocale.getItem("window_vip-exchange_not-enough-resources")]);
      }
      
      private function popupCreated(param1:SimpleWindow, param2:DisplayObjectContainer, param3:Function, param4:String) : void
      {
         param1.maximize();
         param1.autoSize();
         new PopupWindow(param1,param2,param3,null,param4,null);
      }
   }
}

