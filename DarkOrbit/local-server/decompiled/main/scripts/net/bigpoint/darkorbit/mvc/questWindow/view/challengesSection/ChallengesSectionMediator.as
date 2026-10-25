package net.bigpoint.darkorbit.mvc.questWindow.view.challengesSection
{
   import mx.collections.ArrayList;
   import mx.events.FlexEvent;
   import net.bigpoint.darkorbit.com.module.QuestTypeModule;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.questWindow.QuestGiverWindowNotification;
   import net.bigpoint.darkorbit.mvc.questWindow.model.QuestProxy;
   import net.bigpoint.darkorbit.mvc.questWindow.model.vo.QuestListItemVO;
   import net.bigpoint.darkorbit.mvc.questWindow.view.challengesSection.components.ChallengesSectionView;
   import net.bigpoint.darkorbit.mvc.questWindow.view.events.QuestGiverWindowEvent;
   import net.bigpoint.darkorbit.questfm.Quest;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class ChallengesSectionMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "ChallangesSectionMediator";
      
      public function ChallengesSectionMediator(param1:ChallengesSectionView)
      {
         super(NAME,param1);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.view.addEventListener(FlexEvent.CREATION_COMPLETE,this.viewCreationCompleteHandler);
      }
      
      private function viewCreationCompleteHandler(param1:FlexEvent) : void
      {
      }
      
      override public function listNotificationInterests() : Array
      {
         return [QuestGiverWindowNotification.SHOW_DETAILED_QUEST_INFO,QuestGiverWindowNotification.REFRESH_OBJECTIVE_TREE,QuestGiverWindowNotification.REFRESH_VIEW_AFTER_QUEST_ACTIVE_STATUS_CHANGE];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:QuestListItemVO = null;
         var _loc3_:Array = null;
         var _loc4_:Quest = null;
         var _loc5_:Boolean = false;
         var _loc6_:Quest = null;
         switch(param1.getName())
         {
            case QuestGiverWindowNotification.SHOW_DETAILED_QUEST_INFO:
               _loc3_ = param1.getBody() as Array;
               _loc4_ = _loc3_[0] as Quest;
               _loc2_ = _loc3_[1] as QuestListItemVO;
               _loc5_ = _loc3_[2] as Boolean;
               this.view.updateChallengesSectionView(_loc4_,_loc2_);
               this.view.selectedChallengeObjectives.objectiveList.dataProvider = new ArrayList([_loc4_]);
               this.view.selectedChallengeObjectives.objectiveListScrollerGroup.verticalScrollPosition = 0;
               if(_loc2_.acceptable && !_loc5_)
               {
                  this.view.addEventListener(QuestGiverWindowEvent.ACCEPT_QUEST,this.handleQuestAccepted);
                  this.view.acceptButton.enabled = true;
               }
               else
               {
                  this.view.acceptButton.enabled = false;
               }
               this.view.addEventListener(QuestGiverWindowEvent.ABORT_QUEST,this.handleQuestAborted);
               if(_loc2_.type.hasQuestType(QuestTypeModule.QUESTTYPE_CHALLENGE))
               {
                  this.view.highscoreDataGrid.dataProvider = _loc2_.ratings as ArrayList;
               }
               break;
            case QuestGiverWindowNotification.REFRESH_OBJECTIVE_TREE:
               _loc6_ = param1.getBody() as Quest;
               this.view.selectedChallengeObjectives.objectiveList.dataProvider = new ArrayList([_loc6_]);
               break;
            case QuestGiverWindowNotification.REFRESH_VIEW_AFTER_QUEST_ACTIVE_STATUS_CHANGE:
               _loc2_ = param1.getBody() as QuestListItemVO;
               this.view.refreshQuestActiveStatus(_loc2_);
         }
      }
      
      protected function get view() : ChallengesSectionView
      {
         return viewComponent as ChallengesSectionView;
      }
      
      public function get questProxy() : QuestProxy
      {
         return facade.retrieveProxy(QuestProxy.NAME) as QuestProxy;
      }
      
      private function handleQuestAccepted(param1:QuestGiverWindowEvent) : void
      {
         sendNotification(QuestGiverWindowNotification.ACCEPT_QUEST,[param1.questID,param1.rootCaseID]);
      }
      
      private function handleQuestAborted(param1:QuestGiverWindowEvent) : void
      {
         sendNotification(GuiNotifications.CLOSE_QUEST_WINDOW);
      }
   }
}

