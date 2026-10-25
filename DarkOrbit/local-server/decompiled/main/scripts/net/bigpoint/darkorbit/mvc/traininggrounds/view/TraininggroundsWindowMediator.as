package net.bigpoint.darkorbit.mvc.traininggrounds.view
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.TrainingGroundCancelRequest;
   import net.bigpoint.darkorbit.com.module.TrainingGroundConfirmRequest;
   import net.bigpoint.darkorbit.com.module.TrainingGroundSignUpRequest;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.external.ExternalLoadVo;
   import net.bigpoint.darkorbit.mvc.traininggrounds.TraininggroundsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.TASRegistrationData;
   import net.bigpoint.darkorbit.mvc.traininggrounds.model.TraininggroundsFightInfoVO;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.WebsiteAssetUtils;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TraininggroundsWindowMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "TrainingGroundsWindowMediator";
      
      private var opponentUID:int = -1;
      
      private var heroPicLoaded:Boolean = false;
      
      public function TraininggroundsWindowMediator(param1:String, param2:Object)
      {
         super(param1,param2);
         mapNotificationToMethod(TraininggroundsWindowNotifications.CHANGE_STATE,this.changeWindowState);
         mapNotificationToMethod(TraininggroundsWindowNotifications.UPDATE_REGISTRATION_PHASE_INFO,this.updateRegistrationPhaseInfo);
         mapNotificationToMethod(TraininggroundsWindowNotifications.UPDATE_SEASON_TIME,this.updateSeasonTime);
         mapNotificationToMethod(TraininggroundsWindowNotifications.UPDATE_CONFIRMATION_PHASE_INFO,this.updateConfirmationPhaseInfo);
         mapNotificationToMethod(TraininggroundsWindowNotifications.UPDATE_PREPARATION_PHASE_INFO,this.updatePreparationPhaseInfo);
         mapNotificationToMethod(TraininggroundsWindowNotifications.UPDATE_FIGHT_PHASE_INFO,this.updateFightPhaseInfo);
         mapNotificationToMethod(TraininggroundsWindowNotifications.UPDATE_ROUND_NUMBER,this.updateRoundNumber);
         mapNotificationToMethod(TraininggroundsWindowNotifications.UPDATE_PARTICIPANT_IN_COMBAT,this.updateParticipantInCombat);
         mapNotificationToMethod(TraininggroundsWindowNotifications.UPDATE_DISABLED_REASON,this.updateDisabledReason);
         mapNotificationToMethod(TraininggroundsWindowNotifications.UPDATE_FIGHT_PHASE_COUNTDOWN,this.updateFightCountdown);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.addListenersToView();
      }
      
      private function addListenersToView() : void
      {
         this.view.addEventListener(TraininggroundsWindowEvent.MATCH_CLICKED,this.handleMatchRequested);
         this.view.addEventListener(TraininggroundsWindowEvent.CANCEL_CLICKED,this.handleCancelRequested);
         this.view.addEventListener(TraininggroundsWindowEvent.FIGHT_CLICKED,this.handleFightRequested);
      }
      
      private function get view() : TraininggroundsWindow
      {
         return viewComponent as TraininggroundsWindow;
      }
      
      private function handleMatchRequested(param1:TraininggroundsWindowEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new TrainingGroundSignUpRequest());
      }
      
      private function handleCancelRequested(param1:TraininggroundsWindowEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new TrainingGroundCancelRequest());
      }
      
      private function handleFightRequested(param1:TraininggroundsWindowEvent) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new TrainingGroundConfirmRequest());
      }
      
      private function changeWindowState(param1:INotification) : void
      {
         var _loc2_:int = param1.getBody() as int;
         this.view.changeStateTo(_loc2_);
      }
      
      private function updateSeasonTime(param1:INotification) : void
      {
         this.view.updateTime(param1.getBody() as TASRegistrationData);
      }
      
      private function updateRegistrationPhaseInfo(param1:INotification) : void
      {
         this.view.updateRegistrationPhaseInfo(param1.getBody() as TASRegistrationData);
      }
      
      private function updateConfirmationPhaseInfo(param1:INotification) : void
      {
         this.view.updateConfirmationPhaseInfo(param1.getBody()[0],param1.getBody()[1] as Boolean);
      }
      
      private function updatePreparationPhaseInfo(param1:INotification) : void
      {
         this.view.updatePreparationPhaseInfo(param1.getBody()[0],param1.getBody()[1] as Boolean);
      }
      
      private function updateRoundNumber(param1:INotification) : void
      {
         this.view.updateRoundNumber(param1.getBody() as int);
      }
      
      private function updateFightPhaseInfo(param1:INotification) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:TraininggroundsFightInfoVO = param1.getBody() as TraininggroundsFightInfoVO;
         this.view.updateFightPhaseInfo(_loc2_);
         if(_loc2_.opponentUid != -1)
         {
            if(_loc2_.opponentUid != this.opponentUID)
            {
               _loc3_ = WebsiteAssetUtils.generateUserPicLoadUrl(_loc2_.opponentUid,_loc2_.opponentInstanceid,Settings.dynamicHost);
               sendNotification(AssetNotifications.LOAD_EXTERNAL,new ExternalLoadVo(_loc3_,this.view.handleOpponentPicLoaded));
            }
            this.opponentUID = _loc2_.opponentUid;
         }
         if(!this.heroPicLoaded)
         {
            _loc4_ = WebsiteAssetUtils.generateUserPicLoadUrl(Hero.userID,Settings.instanceID,Settings.dynamicHost);
            sendNotification(AssetNotifications.LOAD_EXTERNAL,new ExternalLoadVo(_loc4_,this.view.handleHeroPicLoaded));
            this.heroPicLoaded = true;
         }
         if(_loc2_.roundNumber != -1)
         {
            this.view.updateRoundNumber(_loc2_.roundNumber);
         }
         if(this.view.fightStateAlreadyReceived())
         {
         }
      }
      
      private function updateParticipantInCombat(param1:INotification) : void
      {
         this.view.updateParticipantInCombat(param1.getBody() as Boolean);
      }
      
      private function updateDisabledReason(param1:INotification) : void
      {
         this.view.updateDisabledReasonText(param1.getBody() as String);
      }
      
      private function updateFightCountdown(param1:INotification) : void
      {
         this.view.updateFightCountDown(param1.getBody() as int);
      }
   }
}

