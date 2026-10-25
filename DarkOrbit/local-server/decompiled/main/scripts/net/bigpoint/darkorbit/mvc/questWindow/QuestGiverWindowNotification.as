package net.bigpoint.darkorbit.mvc.questWindow
{
   public class QuestGiverWindowNotification
   {
      
      public static const NAME:String = "QuestGiverNotification";
      
      public static const QUESTS_RECIEVED:String = NAME + "QuestsRecieved";
      
      public static const UPDATE_QUEST_LIST:String = NAME + "UpdateQuestList";
      
      public static const REQUEST_DETAILED_QUEST_INFO:String = NAME + "RequestDetailedQuestInfo";
      
      public static const INIT:String = NAME + "Init";
      
      public static const SHOW_DETAILED_QUEST_INFO:String = NAME + "ShowDetailedQuestInfo";
      
      public static const ACCEPT_QUEST:String = NAME + "AcceptQuest";
      
      public static const ABORT_QUEST:String = NAME + "AbortQuest";
      
      public static const SET_QUEST_ACTIVE:String = NAME + "SetQuestActive";
      
      public static const SET_QUEST_INACTIVE:String = NAME + "SetQuestInactive";
      
      public static const REFRESH_VIEW_AFTER_QUEST_ACTIVE_STATUS_CHANGE:String = NAME + "RefreshViewAfterQuestActiveStatusChange";
      
      public static const REFRESH_OBJECTIVE_TREE:String = NAME + "refreshObjectiveTree";
      
      public static const QUESTS_AVAILABILITY_UPDATE:String = NAME + "QuestAvailabilityUpdate";
      
      public static const QUEST_ACCOMPLISED:String = NAME + "questAccomplished";
      
      public static const EMPTY_QUEST_DETAILS:String = NAME + "emptyQuestDetails";
      
      public static const UPDATE_TAB_REQUEST:String = NAME + "updateTabRequest";
      
      public static const UPDATE_FILTERS_REQUEST:String = NAME + "UpdateFiltersRequest";
      
      public static const UPDATE_FILTER_BUTTONS:String = NAME + "UpdateFilterButtons";
      
      public static const REFRESH_CURRENTLY_SELECTED_QUEST_DETAILS:String = NAME + "refreshCurrentlySelectedQuestDetails";
      
      public static const UPDATE_QUEST_ORDER:String = NAME + "UpdateQuestOrder";
      
      public function QuestGiverWindowNotification()
      {
         super();
      }
   }
}

