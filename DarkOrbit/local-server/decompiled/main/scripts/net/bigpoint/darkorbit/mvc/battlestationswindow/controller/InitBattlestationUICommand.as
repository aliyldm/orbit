package net.bigpoint.darkorbit.mvc.battlestationswindow.controller
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.BattleStationErrorCommand;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationConstants;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationNotification;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationProxy;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationVO;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.BattleStationBuildWindowBase;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.popups.PopUpWithConfirmButton;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.popups.PopUpWithCountdownTimer;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.events.BattleStationWindowEvent;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class InitBattlestationUICommand extends SimpleCommand
   {
      
      public function InitBattlestationUICommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:String = String(param1.getBody());
         if(Hero.isInClan)
         {
            this.bsProxy.battleStationVO.battleStationName = _loc2_;
            if(this.bsProxy.battleStationVO == null)
            {
               return;
            }
            switch(this.bsProxy.battleStationVO.state)
            {
               case BattleStationVO.ASTEROID_STATE:
                  this.bsProxy.uiIsOpen = true;
                  sendNotification(GuiNotifications.OPEN_BATTLE_STATION_WINDOW,BattleStationBuildWindowBase.ASTEROID_MODE);
                  sendNotification(BattleStationNotification.INIT_BATTLE_STATION_BUILD_WINDOW,this.bsProxy.battleStationVO);
                  break;
               case BattleStationVO.BATTLE_STATION_STATE:
                  this.bsProxy.uiIsOpen = true;
                  sendNotification(GuiNotifications.OPEN_BATTLE_STATION_WINDOW,BattleStationBuildWindowBase.BATTLE_STATION_MODE);
                  sendNotification(BattleStationNotification.INIT_BATTLE_STATION_MANAGEMENT_WINDOW,this.bsProxy.battleStationVO);
                  break;
               case BattleStationVO.BUILD_IN_PROGRESS_STATE:
                  this.bsProxy.displayBuildProgressWindow(this.bsProxy.battleStationVO);
            }
         }
         else
         {
            this.showNoClanErrorMsg();
         }
      }
      
      private function showNoClanErrorMsg() : void
      {
         var errorPopUp:PopUpWithConfirmButton = PopUpWithConfirmButton(FlexWindowManager.getInstance().createWindow(FlexWindowManager.BS_POP_UP_WITH_NO_CLAN_MESSAGE));
         errorPopUp.height = 160;
         errorPopUp.title = BPLocale.getItem("popup_bswin_title_error_message");
         errorPopUp.setMessageText(BPLocale.getItem(BattleStationConstants.ERROR_MESSAGE_MAP[BattleStationErrorCommand.ERRORTYPE_NO_CLAN]));
         errorPopUp.setButtonTexts(BPLocale.getItem("error_bswin_no_clan_confirm_btn"),BPLocale.getItem("popup_bswin_btn_cancel_module_removal"));
         errorPopUp.addEventListener(BattleStationWindowEvent.CONFIRM_BTN_CLICKED,function():void
         {
            JavascriptProxy.referToURL("internalNewClan","seo_tittle_clans");
         });
      }
      
      public function displayBuildProgressWindow(param1:BattleStationVO) : void
      {
         var _loc2_:PopUpWithCountdownTimer = PopUpWithCountdownTimer(FlexWindowManager.getInstance().createWindow(FlexWindowManager.BS_POP_UP_WITH_COUNTDOWN_TIMER));
         _loc2_.title = param1.battleStationName;
         _loc2_.setPopupText(BPLocale.getItem("popup_bswin_message_battle_station_build_time"),BPLocale.getItem("popup_bswin_title_battle_station_build_time"),param1.owningClanName);
         _loc2_.setClanImage(param1.owningClanFactionStyle);
         _loc2_.setProgressBarProgress(param1.timeLeft,0);
      }
      
      private function get bsProxy() : BattleStationProxy
      {
         return facade.retrieveProxy(BattleStationProxy.NAME) as BattleStationProxy;
      }
   }
}

