package net.bigpoint.darkorbit.net.netty.handlers.seasonPass
{
   import com.bigpoint.utils.TextFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.SeasonPassRewardClaimAllRequest;
   import net.bigpoint.darkorbit.com.module.SeasonPassRewardUnclaimedInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.SeasonPassUIPopUpUtils;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SeasonPassRewardUnclaimedInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      private static const SEASON_PASS_WINDOWS:Array = [GuiConstants.SEASON_PASS,GuiConstants.SEASON_PASS_POPUP_PURCHASE_LEVELS,GuiConstants.SEASON_PASS_POPUP_ERROR,GuiConstants.SEASON_PASS_POPUP_BUY_GOLD_PASS,GuiConstants.SEASON_PASS_POPUP_CONFIRM_REFRESH];
      
      public function SeasonPassRewardUnclaimedInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var description:String;
         var data:SeasonPassRewardUnclaimedInfoCommand = null;
         var windowId:String = null;
         var handleOk:Function = null;
         var window:SimpleWindow = null;
         var notification:INotification = param1;
         super.execute(notification);
         data = notification.getBody() as SeasonPassRewardUnclaimedInfoCommand;
         description = "";
         if(data.captainWarning)
         {
            description += BPLocale.getItem("sp_season-has-ended_nova_warning") + "\n\n";
            description += BPLocale.getItem("sp_season-has-ended_current-nova") + "\n";
            description += BPLocale.getItem("sp_season-has-ended_claimable-nova");
            description = description.replace("%ROSTER%",TextFormatter.roundInteger(data.captainOwned));
            description = description.replace("%COUNT%",TextFormatter.roundInteger(data.captainLimit));
            description = description.replace("%VALUE%",TextFormatter.roundInteger(data.captainPending));
         }
         for each(windowId in SEASON_PASS_WINDOWS)
         {
            window = guiManager.getWindow(windowId);
            if(window)
            {
               window.minimize(true,true);
            }
         }
         handleOk = function():void
         {
            sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new SeasonPassRewardClaimAllRequest(data.spcId));
         };
         SeasonPassUIPopUpUtils.createPopupBanner(GuiConstants.SEASON_PASS_POPUP_SEASON_END,handleOk,description,data.marketingImage,data.seasonName);
      }
   }
}

