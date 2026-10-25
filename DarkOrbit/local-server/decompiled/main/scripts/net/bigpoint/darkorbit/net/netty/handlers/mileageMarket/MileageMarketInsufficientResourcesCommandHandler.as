package net.bigpoint.darkorbit.net.netty.handlers.mileageMarket
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.system.utils.FuiPopUpUtils;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class MileageMarketInsufficientResourcesCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function MileageMarketInsufficientResourcesCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:String = BPLocale.getItem("window_vip-exchange_not-enough-resources");
         FuiPopUpUtils.createPopupLoadSkin(GuiConstants.POPUP_GENERIC_ICON_OK,null,null,_loc2_,FuiPopUpUtils.POPUP_ICON_SKIN_ERROR);
      }
   }
}

