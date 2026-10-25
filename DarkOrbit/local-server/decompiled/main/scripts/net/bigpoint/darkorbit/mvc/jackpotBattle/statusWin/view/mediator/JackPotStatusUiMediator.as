package net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.view.mediator
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.ArenaStatusCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.JackpotBattleNotification;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.JackpotStatusConstants;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.model.JackpotStatusUiVO;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.view.comps.JackpotBattleAvartar;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.view.decorator.JackpotStatusUiDecorator;
   import net.bigpoint.darkorbit.net.HeroNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class JackPotStatusUiMediator extends Mediator
   {
      
      public static var NAME:String = "JackPotStatusUiMediator";
      
      private var changeRemainingTypeDelegate:Array = [];
      
      private var _viewState:int;
      
      public function JackPotStatusUiMediator(param1:Object = null)
      {
         this.initDelegate();
         super(NAME,param1);
      }
      
      private function initDelegate() : void
      {
         this.changeRemainingTypeDelegate[ArenaStatusCommand.MATCHSTATUS_SCHEDULED] = this.delegateBeforeGame;
         this.changeRemainingTypeDelegate[ArenaStatusCommand.MATCHSTATUS_COUNTDOWN] = this.delegateCountDown;
         this.changeRemainingTypeDelegate[ArenaStatusCommand.MATCHSTATUS_FIGHTING] = this.delegateInFight;
         this.changeRemainingTypeDelegate[ArenaStatusCommand.MATCHSTATUS_RADIATION_ACTIVE] = this.delegateRadiationZoneActive;
         this.changeRemainingTypeDelegate[ArenaStatusCommand.MATCHSTATUS_WAITING_FOR_PLAYERS] = this.delegateBeforeGame;
         this.changeRemainingTypeDelegate[ArenaStatusCommand.MATCHSTATUS_DONE] = this.delegateWaiting;
         this.changeRemainingTypeDelegate[ArenaStatusCommand.MATCHSTATUS_NONE] = this.doNothing;
         this.changeRemainingTypeDelegate[ArenaStatusCommand.MATCHSTATUS_DESTROYABLE] = this.doNothing;
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.addEventListeners();
         sendNotification(JackpotBattleNotification.START_UP);
      }
      
      override public function onRemove() : void
      {
         sendNotification(JackpotBattleNotification.CLEAN_UP);
         super.onRemove();
         this.removeEventListeners();
      }
      
      override public function listNotificationInterests() : Array
      {
         return [HeroNotifications.UPDATE_USERNAME,JackpotBattleNotification.UPDATE_REMAINING_PLAYER,JackpotBattleNotification.SET_LABLES_VISIBILITY,JackpotBattleNotification.UPDATE_REMAINING_TIME,JackpotBattleNotification.SHOW_WARNING,JackpotBattleNotification.HIDE_WARNING];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:PointLite = null;
         super.handleNotification(param1);
         switch(param1.getName())
         {
            case JackpotBattleNotification.SHOW_WARNING:
               this.showWarning();
               break;
            case JackpotBattleNotification.HIDE_WARNING:
               this.hideWarning();
               break;
            case JackpotBattleNotification.UPDATE_REMAINING_TIME:
               this.view.footerDecorator.updateRemainingTime(param1.getBody() as int);
               break;
            case JackpotBattleNotification.SET_LABLES_VISIBILITY:
               _loc2_ = param1.getBody() as Boolean;
               if(_loc2_)
               {
                  this.showText();
               }
               else
               {
                  this.hideText();
               }
               break;
            case JackpotBattleNotification.UPDATE_REMAINING_PLAYER:
               _loc3_ = param1.getBody() as PointLite;
               if(this.view)
               {
                  this.view.headerDecorator.updateRemainingPlayers(_loc3_.x,_loc3_.y);
               }
               break;
            case HeroNotifications.UPDATE_USERNAME:
               this.view.centerDecorator.jackpotBattleHeroAvatar.updateName(param1.getBody() as String);
         }
      }
      
      private function addEventListeners() : void
      {
         this.view.addEventListener(SimpleWindowEvent.ON_CLOSE,this.handleWindowClosed);
      }
      
      private function removeEventListeners() : void
      {
         this.view.removeEventListener(SimpleWindowEvent.ON_CLOSE,this.handleWindowClosed);
      }
      
      private function handleWindowClosed(param1:SimpleWindowEvent = null) : void
      {
         this.removeMediator();
      }
      
      public function set data(param1:JackpotStatusUiVO) : void
      {
         this._viewState = param1.matchType;
         this.changeRemainingTypeDelegate[param1.matchType]();
         this.view.centerDecorator.jackpotBattleHeroAvatar.updateName(param1.leftUserName);
         this.view.centerDecorator.jackpotBattleOpponentAvatar.updateName(param1.rightUserName);
         this.view.footerDecorator.updateRemainingTime(param1.remainingTime);
         this.updateRemainingPlayers(param1);
         this.view.headerDecorator.updateRoundCount(param1.roundCount);
      }
      
      private function updateRemainingPlayers(param1:JackpotStatusUiVO) : void
      {
         this.view.headerDecorator.updateRemainingPlayers(param1.registerdUsersCount,param1.registerdUsersTotal);
         var _loc2_:Boolean = param1.registerdUsersCount >= 0 || param1.registerdUsersTotal >= 0;
         this.view.headerDecorator.remainingOfRegisterdTextfield.visible = _loc2_;
      }
      
      private function setAvatarSize(param1:DisplayObject) : void
      {
         param1.width = JackpotStatusConstants.AVATAR_WIDTH;
         param1.height = JackpotStatusConstants.AVATAR_HEIGHT;
      }
      
      private function removeMediator() : void
      {
         facade.removeMediator(getMediatorName());
      }
      
      private function showWarning() : void
      {
         this.view.footerDecorator.warningTextfield.visible = true;
      }
      
      private function hideWarning() : void
      {
         this.view.footerDecorator.warningTextfield.visible = false;
      }
      
      private function hideText() : void
      {
         this.view.footerDecorator.remainingTimeTextfield.visible = false;
      }
      
      private function showText() : void
      {
         this.view.footerDecorator.remainingTimeTextfield.visible = true;
      }
      
      private function get view() : JackpotStatusUiDecorator
      {
         return viewComponent as JackpotStatusUiDecorator;
      }
      
      private function setAvatarPicture(param1:DisplayObject, param2:JackpotBattleAvartar) : void
      {
         this.setAvatarSize(param1);
         param2.avartar = param1;
         param2.picOffsetX = (param2.width - param1.width) * 0.5;
      }
      
      public function handleFrameLoaded(param1:BitmapData) : void
      {
         this.view.centerDecorator.jackpotBattleHeroAvatar.boarder = new Bitmap(param1);
         this.view.centerDecorator.jackpotBattleOpponentAvatar.boarder = new Bitmap(param1);
      }
      
      public function handleVSLogoLoaded(param1:Bitmap) : void
      {
         this.view.centerDecorator.vsLogo = param1;
      }
      
      public function handleOpponentPicLoaded(param1:DisplayObject) : void
      {
         this.setAvatarPicture(param1,this.view.centerDecorator.jackpotBattleOpponentAvatar);
         var _loc2_:TooltipControl = TooltipControl.getInstance();
         _loc2_.removeToolTip(this.view.centerDecorator.jackpotBattleOpponentAvatar);
         this.view.centerDecorator.vsLogo.visible = true;
      }
      
      public function unknownPicLoaded(param1:DisplayObject) : void
      {
         this.setAvatarPicture(param1,this.view.centerDecorator.jackpotBattleOpponentAvatar);
         var _loc2_:TooltipControl = TooltipControl.getInstance();
         _loc2_.removeToolTip(this.view.centerDecorator.jackpotBattleOpponentAvatar);
         _loc2_.addToolTip(this.view.centerDecorator.jackpotBattleOpponentAvatar,BPLocale.getItem("jackpot_status_window_avatar_unknown_ttip"));
         this.view.centerDecorator.vsLogo.visible = true;
      }
      
      public function wildcardPicLoaded(param1:DisplayObject) : void
      {
         this.setAvatarPicture(param1,this.view.centerDecorator.jackpotBattleOpponentAvatar);
         var _loc2_:TooltipControl = TooltipControl.getInstance();
         _loc2_.removeToolTip(this.view.centerDecorator.jackpotBattleOpponentAvatar);
         _loc2_.addToolTip(this.view.centerDecorator.jackpotBattleOpponentAvatar,BPLocale.getItem("jackpot_status_window_avatar_wildcard_ttip"));
         this.view.centerDecorator.vsLogo.visible = false;
         var _loc3_:int = this._viewState == ArenaStatusCommand.MATCHSTATUS_DONE ? JackpotStatusUiDecorator.WILDCARD : JackpotStatusUiDecorator.WAINTING;
         this.view.footerDecorator.changeRemainingTimeType(_loc3_);
      }
      
      public function handleHeroPicLoaded(param1:DisplayObject) : void
      {
         this.setAvatarPicture(param1,this.view.centerDecorator.jackpotBattleHeroAvatar);
      }
      
      private function delegateBeforeGame() : void
      {
         this.view.footerDecorator.changeRemainingTimeType(JackpotStatusUiDecorator.SCHEDULED);
         this.showText();
         this.hideWarning();
         this.view.flash();
      }
      
      private function delegateInFight() : void
      {
         this.view.footerDecorator.changeRemainingTimeType(JackpotStatusUiDecorator.FIGHTING);
         this.hideWarning();
         this.showText();
         this.view.minimize();
      }
      
      private function delegateCountDown() : void
      {
         this.hideWarning();
         this.hideText();
         this.view.minimize();
      }
      
      private function delegateRadiationZoneActive() : void
      {
         this.view.footerDecorator.changeRemainingTimeType(JackpotStatusUiDecorator.FIGHTING);
         this.showText();
         this.showWarning();
         this.view.minimize();
      }
      
      private function delegateWaiting() : void
      {
         this.view.footerDecorator.changeRemainingTimeType(JackpotStatusUiDecorator.WAINTING);
         this.showText();
         this.hideWarning();
         this.view.flash();
      }
      
      private function doNothing() : void
      {
      }
   }
}

