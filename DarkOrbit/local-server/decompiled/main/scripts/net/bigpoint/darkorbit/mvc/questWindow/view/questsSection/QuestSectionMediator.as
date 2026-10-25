package net.bigpoint.darkorbit.mvc.questWindow.view.questsSection
{
   import mx.collections.ArrayList;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.questWindow.QuestGiverWindowNotification;
   import net.bigpoint.darkorbit.mvc.questWindow.model.QuestProxy;
   import net.bigpoint.darkorbit.mvc.questWindow.model.vo.QuestListItemVO;
   import net.bigpoint.darkorbit.mvc.questWindow.view.events.QuestGiverWindowEvent;
   import net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.components.QuestSectionView;
   import net.bigpoint.darkorbit.questfm.Quest;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class QuestSectionMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "QuestSectionMediator";
      
      public function QuestSectionMediator(param1:QuestSectionView)
      {
         super(NAME,param1);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      override public function listNotificationInterests() : Array
      {
         return [QuestGiverWindowNotification.SHOW_DETAILED_QUEST_INFO,QuestGiverWindowNotification.REFRESH_VIEW_AFTER_QUEST_ACTIVE_STATUS_CHANGE,QuestGiverWindowNotification.REFRESH_OBJECTIVE_TREE,QuestGiverWindowNotification.EMPTY_QUEST_DETAILS];
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
               this.view.updateQuestSectionView(_loc4_,_loc2_);
               this.view.selectedQuestObjectives.objectiveList.dataProvider = new ArrayList([_loc4_]);
               this.view.selectedQuestObjectives.objectiveListScrollerGroup.verticalScrollPosition = 0;
               this.view.selectedQuestRewards.rewardsList.dataProvider = new ArrayList(_loc4_.rewards);
               if(_loc2_.acceptable && !_loc5_)
               {
                  this.view.addEventListener(QuestGiverWindowEvent.ACCEPT_QUEST,this.handleQuestAccepted);
                  this.view.acceptButton.enabled = true;
                  this.view.acceptButtonTooltipGroup.toolTip = "";
               }
               else
               {
                  this.view.acceptButton.enabled = false;
                  this.view.acceptButtonTooltipGroup.toolTip = _loc2_.notAcceptableReasons;
               }
               this.view.addEventListener(QuestGiverWindowEvent.ABORT_QUEST,this.handleQuestAborted);
               break;
            case QuestGiverWindowNotification.REFRESH_VIEW_AFTER_QUEST_ACTIVE_STATUS_CHANGE:
               _loc2_ = param1.getBody() as QuestListItemVO;
               this.view.refreshQuestActiveStatus(_loc2_);
               break;
            case QuestGiverWindowNotification.REFRESH_OBJECTIVE_TREE:
               _loc6_ = param1.getBody() as Quest;
               this.view.selectedQuestObjectives.objectiveList.dataProvider = new ArrayList([_loc6_]);
               break;
            case QuestGiverWindowNotification.EMPTY_QUEST_DETAILS:
               this.view.questDesc.text = "";
               this.view.questTitle.text = "";
               this.view.selectedQuestObjectives.objectiveList.dataProvider = null;
               this.view.selectedQuestRewards.rewardsList.dataProvider = null;
               this.view.currentlyDisplayedQuestID = -1;
               this.view.currentlyDisplayedRootCaseID = -1;
               this.view.acceptButton.enabled = false;
         }
      }
      
      private function handleQuestAborted(param1:QuestGiverWindowEvent) : void
      {
         sendNotification(GuiNotifications.CLOSE_QUEST_WINDOW);
      }
      
      private function handleQuestAccepted(param1:QuestGiverWindowEvent) : void
      {
         sendNotification(QuestGiverWindowNotification.ACCEPT_QUEST,[param1.questID,param1.rootCaseID]);
      }
      
      protected function get view() : QuestSectionView
      {
         return viewComponent as QuestSectionView;
      }
      
      public function get questProxy() : QuestProxy
      {
         return facade.retrieveProxy(QuestProxy.NAME) as QuestProxy;
      }
   }
}

