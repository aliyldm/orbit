package net.bigpoint.darkorbit.net.netty.handlers.questfm
{
   import net.bigpoint.darkorbit.com.module.QuestListCommand;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.questWindow.QuestGiverWindowNotification;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.QuestAccomplishedCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.QuestGiverAbortQuestCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.QuestGiverAcceptQuestCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.QuestGiverRequestQuestInfo;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.RefreshSelectedQuestDetailsCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.SelectedFiltersChangedCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.SelectedTabChangedCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.SetQuestActiveCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.SetQuestGiverWindowClosed;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.SetQuestInactiveCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.UpdateQuestOrderCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.model.QuestProxy;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class QuestListHandler extends BaseHandler
   {
      
      public function QuestListHandler()
      {
         super();
      }
      
      public static function run(param1:QuestListCommand) : void
      {
         var _loc2_:QuestProxy = _facade.retrieveProxy(QuestProxy.NAME) as QuestProxy;
         if(!_loc2_)
         {
            _facade.registerProxy(new QuestProxy(QuestProxy.NAME));
            _loc2_ = _facade.retrieveProxy(QuestProxy.NAME) as QuestProxy;
            _loc2_.setConnectionManager(_main.getConnectionManager());
            _loc2_.setQuestManager(_main.getQuestManager());
            _facade.registerCommand(QuestGiverWindowNotification.REQUEST_DETAILED_QUEST_INFO,QuestGiverRequestQuestInfo);
            _facade.registerCommand(QuestGiverWindowNotification.ACCEPT_QUEST,QuestGiverAcceptQuestCommand);
            _facade.registerCommand(QuestGiverWindowNotification.ABORT_QUEST,QuestGiverAbortQuestCommand);
            _facade.registerCommand(QuestGiverWindowNotification.SET_QUEST_ACTIVE,SetQuestActiveCommand);
            _facade.registerCommand(QuestGiverWindowNotification.SET_QUEST_INACTIVE,SetQuestInactiveCommand);
            _facade.registerCommand(QuestGiverWindowNotification.QUEST_ACCOMPLISED,QuestAccomplishedCommand);
            _facade.registerCommand(QuestGiverWindowNotification.REFRESH_CURRENTLY_SELECTED_QUEST_DETAILS,RefreshSelectedQuestDetailsCommand);
            _facade.registerCommand(QuestGiverWindowNotification.UPDATE_TAB_REQUEST,SelectedTabChangedCommand);
            _facade.registerCommand(QuestGiverWindowNotification.UPDATE_FILTERS_REQUEST,SelectedFiltersChangedCommand);
            _facade.registerCommand(QuestGiverWindowNotification.UPDATE_QUEST_ORDER,UpdateQuestOrderCommand);
            _facade.registerCommand(GuiNotifications.NOTIFY_WINDOW_TYPE_CLOSED + FlexWindowManager.QUEST_GIVER_WINDOW,SetQuestGiverWindowClosed);
         }
         _loc2_.createQuestLists(param1);
      }
   }
}

