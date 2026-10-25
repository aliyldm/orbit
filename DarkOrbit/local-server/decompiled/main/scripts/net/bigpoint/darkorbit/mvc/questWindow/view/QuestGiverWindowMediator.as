package net.bigpoint.darkorbit.mvc.questWindow.view
{
   import flash.events.Event;
   import mx.collections.ArrayList;
   import mx.events.FlexEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.QuestGiverWindowClosedRequest;
   import net.bigpoint.darkorbit.com.module.QuestSettingsRequest;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.questWindow.QuestGiverWindowNotification;
   import net.bigpoint.darkorbit.mvc.questWindow.model.QuestProxy;
   import net.bigpoint.darkorbit.mvc.questWindow.view.challengesSection.ChallengesSectionMediator;
   import net.bigpoint.darkorbit.mvc.questWindow.view.components.QuestGiverWindowView;
   import net.bigpoint.darkorbit.mvc.questWindow.view.events.QuestGiverWindowEvent;
   import net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.QuestSectionMediator;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import spark.components.Label;
   
   public class QuestGiverWindowMediator extends DOAbstractMediator implements IMediator
   {
      
      public static const NAME:String = "QuestGiverWindowMediator";
      
      public static const TAB_NONE_OR_INIT:int = -1;
      
      public static const TAB_MISSIONS:int = 0;
      
      public static const TAB_CHALLENGES:int = 1;
      
      public static const TAB_DAILY_MISSIONS:int = 2;
      
      public static const TAB_EVENT_MISSIONS:int = 4;
      
      public static const TAB_WEEKLY_MISSIONS:int = 3;
      
      private var _questGiverID:int = 0;
      
      public function QuestGiverWindowMediator(param1:QuestGiverWindowView)
      {
         super(NAME,param1);
         mapNotificationToMethod(QuestGiverWindowNotification.SHOW_DETAILED_QUEST_INFO,this.updatePortrait);
         mapNotificationToMethod(QuestGiverWindowNotification.EMPTY_QUEST_DETAILS,this.updatePortrait);
         mapNotificationToMethod(QuestGiverWindowNotification.REFRESH_CURRENTLY_SELECTED_QUEST_DETAILS,this.updatePortrait);
      }
      
      override public function listNotificationInterests() : Array
      {
         return super.listNotificationInterests().concat([QuestGiverWindowNotification.UPDATE_QUEST_LIST,GuiNotifications.NOTIFY_WINDOW_TYPE_CLOSED + FlexWindowManager.QUEST_GIVER_WINDOW,QuestGiverWindowNotification.QUESTS_AVAILABILITY_UPDATE,QuestGiverWindowNotification.UPDATE_FILTER_BUTTONS]);
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Label = null;
         super.handleNotification(param1);
         switch(param1.getName())
         {
            case QuestGiverWindowNotification.UPDATE_QUEST_LIST:
               _loc2_ = param1.getBody()[2] as Boolean;
               this.view.questList.dataProvider = param1.getBody()[0] as ArrayList;
               _loc3_ = param1.getBody()[1] as int;
               for each(_loc5_ in this.view.getMaxQuestsLabels())
               {
                  _loc5_.visible = !_loc2_;
                  if(_loc3_ == 1)
                  {
                     _loc5_.text = BPLocale.getItem("label_questslots_free_s").replace("%AMOUNT%",_loc3_);
                  }
                  else
                  {
                     _loc5_.text = BPLocale.getItem("label_questslots_free_p").replace("%AMOUNT%",_loc3_);
                  }
               }
               if(_loc2_)
               {
                  this.view.tabList = this.view.starterTabList;
               }
               else
               {
                  this.view.tabList = this.view.fullTabList;
               }
               break;
            case GuiNotifications.NOTIFY_WINDOW_TYPE_CLOSED + FlexWindowManager.QUEST_GIVER_WINDOW:
               break;
            case QuestGiverWindowNotification.QUESTS_AVAILABILITY_UPDATE:
               _loc4_ = param1.getBody() as Boolean;
               this.view.setQuestAvailableStatus(_loc4_);
               break;
            case QuestGiverWindowNotification.UPDATE_FILTER_BUTTONS:
               this.view.available.selected = Settings.questsAvailableFilter;
               this.view.unavailable.selected = Settings.questsUnavailableFilter;
               this.view.completed.selected = Settings.questsCompletedFilter;
               this.view.levelorder.selected = Settings.questsLevelOrderDescending;
               this.view.notYetDone.selected = Settings.challengesUnattemptedFilter;
               this.view.done.selected = Settings.challengesAttemptedFilter;
         }
      }
      
      private function handleQuestInfoRequest(param1:QuestGiverWindowEvent) : void
      {
         sendNotification(QuestGiverWindowNotification.REQUEST_DETAILED_QUEST_INFO,[param1.questID,param1.rootCaseID]);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         facade.registerMediator(new QuestSectionMediator(this.view.questWindowQuestSection));
         facade.registerMediator(new ChallengesSectionMediator(this.view.questWindowChallengesSection));
         this.view.addEventListener(FlexEvent.CREATION_COMPLETE,this.handleCreationComplete);
         this.view.addEventListener(FlexEvent.REMOVE,this.handleViewRemoveEvent);
         this.view.addEventListener(QuestGiverWindowEvent.GET_DETAILED_QUEST_INFO,this.handleQuestInfoRequest);
         this.view.addEventListener(QuestGiverWindowEvent.TAB_CHANGED,this.handleTabClicked);
         this.view.addEventListener(QuestGiverWindowEvent.FILTERS_CHANGED,this.handleFiltersChanged);
         InGameCatalog.instance.questgiverPortraitsChanged.add(this.updatePortrait);
      }
      
      private function updatePortrait(param1:INotification = null) : void
      {
         this.view.updatePortrait();
      }
      
      private function handleCreationComplete(param1:FlexEvent) : void
      {
         sendNotification(QuestGiverWindowNotification.REFRESH_CURRENTLY_SELECTED_QUEST_DETAILS);
      }
      
      private function handleFiltersChanged(param1:QuestGiverWindowEvent) : void
      {
         facade.sendNotification(QuestGiverWindowNotification.UPDATE_FILTERS_REQUEST);
         facade.sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new QuestSettingsRequest(Settings.questsAvailableFilter,Settings.questsUnavailableFilter,Settings.questsCompletedFilter,Settings.challengesAttemptedFilter,Settings.challengesUnattemptedFilter,Settings.questsLevelOrderDescending));
         facade.sendNotification(QuestGiverWindowNotification.UPDATE_QUEST_ORDER);
      }
      
      private function handleViewRemoveEvent(param1:Event) : void
      {
         var _loc2_:QuestGiverWindowClosedRequest = null;
         if(this._questGiverID > 0)
         {
            _loc2_ = new QuestGiverWindowClosedRequest(this._questGiverID);
            facade.sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc2_);
         }
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         if(this.view)
         {
            this.view.removeEventListener(FlexEvent.CREATION_COMPLETE,this.handleCreationComplete);
            this.view.removeEventListener(FlexEvent.REMOVE,this.handleViewRemoveEvent);
            this.view.removeEventListener(QuestGiverWindowEvent.GET_DETAILED_QUEST_INFO,this.handleQuestInfoRequest);
            this.view.removeEventListener(QuestGiverWindowEvent.TAB_CHANGED,this.handleTabClicked);
            this.view.removeEventListener(QuestGiverWindowEvent.FILTERS_CHANGED,this.handleFiltersChanged);
         }
         facade.removeMediator(QuestSectionMediator.NAME);
         facade.removeMediator(ChallengesSectionMediator.NAME);
         InGameCatalog.instance.questgiverPortraitsChanged.remove(this.updatePortrait);
      }
      
      public function get questProxy() : QuestProxy
      {
         return facade.retrieveProxy(QuestProxy.NAME) as QuestProxy;
      }
      
      protected function get view() : QuestGiverWindowView
      {
         return viewComponent as QuestGiverWindowView;
      }
      
      public function handleTabClicked(param1:QuestGiverWindowEvent) : void
      {
         var _loc2_:int = param1.data as int;
         var _loc3_:Boolean = _loc2_ == TAB_CHALLENGES;
         this.view.questWindowQuestSection.visible = !_loc3_;
         this.view.questWindowChallengesSection.visible = _loc3_;
         facade.sendNotification(QuestGiverWindowNotification.UPDATE_TAB_REQUEST,_loc2_);
      }
      
      public function set questGiverID(param1:int) : void
      {
         this._questGiverID = param1;
      }
   }
}

