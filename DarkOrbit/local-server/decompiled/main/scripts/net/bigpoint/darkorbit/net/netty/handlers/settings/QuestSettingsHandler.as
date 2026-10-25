package net.bigpoint.darkorbit.net.netty.handlers.settings
{
   import net.bigpoint.darkorbit.com.module.QuestSettingsModule;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.questWindow.QuestGiverWindowNotification;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class QuestSettingsHandler extends BaseHandler
   {
      
      public function QuestSettingsHandler()
      {
         super();
      }
      
      public static function run(param1:QuestSettingsModule) : void
      {
         Settings.questsAvailableFilter = param1.availableFilter;
         Settings.questsUnavailableFilter = param1.unavailableFilter;
         Settings.questsCompletedFilter = param1.completedFilter;
         Settings.questsLevelOrderDescending = param1.inLevelRangeFilter;
         Settings.challengesUnattemptedFilter = param1.availableFilter;
         Settings.challengesAttemptedFilter = param1.unavailableFilter;
         GameFacade.getInstance().sendNotification(QuestGiverWindowNotification.UPDATE_FILTERS_REQUEST);
         GameFacade.getInstance().sendNotification(QuestGiverWindowNotification.UPDATE_FILTER_BUTTONS);
      }
   }
}

