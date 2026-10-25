package net.bigpoint.darkorbit.net.netty.handlers.seasonPass
{
   import net.bigpoint.darkorbit.com.module.SeasonPassLevelPurchaseCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.SeasonPassUIPopUpUtils;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SeasonPassLevelPurchaseCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function SeasonPassLevelPurchaseCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:SeasonPassLevelPurchaseCommand = param1.getBody() as SeasonPassLevelPurchaseCommand;
         if(!_loc2_.success)
         {
            SeasonPassUIPopUpUtils.createPopup(GuiConstants.SEASON_PASS_POPUP_ERROR,null,null,"window_purchaselevel_sp_tab_uridium-error");
         }
      }
   }
}

