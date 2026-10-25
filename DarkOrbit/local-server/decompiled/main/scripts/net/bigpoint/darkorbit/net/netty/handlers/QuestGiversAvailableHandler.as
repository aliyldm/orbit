package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.QuestGiverModule;
   import net.bigpoint.darkorbit.com.module.QuestGiversAvailableCommand;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitContainer;
   import net.bigpoint.darkorbit.map.model.env.homebase.QuestGiver;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.ClickIconTrait;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.questWindow.QuestGiverWindowNotification;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.QuestAccomplishedCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.QuestGiverAbortQuestCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.QuestGiverAcceptQuestCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.QuestGiverRequestQuestInfo;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.SelectedFiltersChangedCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.SelectedTabChangedCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.SetQuestActiveCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.SetQuestGiverWindowClosed;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.SetQuestInactiveCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.controller.UpdateQuestOrderCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.model.QuestProxy;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class QuestGiversAvailableHandler extends BaseHandler
   {
      
      public function QuestGiversAvailableHandler()
      {
         super();
      }
      
      public static function run(param1:IModule) : void
      {
         var _loc4_:ClickIconTrait = null;
         var _loc5_:QuestGiverModule = null;
         var _loc6_:QuestProxy = null;
         var _loc7_:ClickIconTrait = null;
         var _loc2_:QuestGiversAvailableCommand = param1 as QuestGiversAvailableCommand;
         var _loc3_:EntityTraitContainer = ScreenManager.getInstance().map.getTraitsList(ClickIconTrait);
         for each(_loc4_ in _loc3_.traits)
         {
            if(_loc4_.owner is QuestGiver)
            {
               _loc4_.enabled.value = false;
            }
         }
         for each(_loc5_ in _loc2_.questGivers)
         {
            _loc7_ = map.getTraitById(_loc5_.mapObjectId,ClickIconTrait) as ClickIconTrait;
            if(_loc7_)
            {
               _loc7_.handleActionAvailableCommand(true,TextUtils.getTooltipText(_loc5_.toolTip,true));
            }
         }
         _loc6_ = _facade.retrieveProxy(QuestProxy.NAME) as QuestProxy;
         if(!_loc6_)
         {
            _facade.registerProxy(new QuestProxy(QuestProxy.NAME));
            _loc6_ = _facade.retrieveProxy(QuestProxy.NAME) as QuestProxy;
            _loc6_.setConnectionManager(_main.getConnectionManager());
            _loc6_.setQuestManager(_main.getQuestManager());
            _facade.registerCommand(QuestGiverWindowNotification.REQUEST_DETAILED_QUEST_INFO,QuestGiverRequestQuestInfo);
            _facade.registerCommand(QuestGiverWindowNotification.ACCEPT_QUEST,QuestGiverAcceptQuestCommand);
            _facade.registerCommand(QuestGiverWindowNotification.ABORT_QUEST,QuestGiverAbortQuestCommand);
            _facade.registerCommand(QuestGiverWindowNotification.SET_QUEST_ACTIVE,SetQuestActiveCommand);
            _facade.registerCommand(QuestGiverWindowNotification.SET_QUEST_INACTIVE,SetQuestInactiveCommand);
            _facade.registerCommand(QuestGiverWindowNotification.QUEST_ACCOMPLISED,QuestAccomplishedCommand);
            _facade.registerCommand(QuestGiverWindowNotification.UPDATE_TAB_REQUEST,SelectedTabChangedCommand);
            _facade.registerCommand(QuestGiverWindowNotification.UPDATE_FILTERS_REQUEST,SelectedFiltersChangedCommand);
            _facade.registerCommand(QuestGiverWindowNotification.UPDATE_QUEST_ORDER,UpdateQuestOrderCommand);
            _facade.registerCommand(GuiNotifications.NOTIFY_WINDOW_TYPE_CLOSED + FlexWindowManager.QUEST_GIVER_WINDOW,SetQuestGiverWindowClosed);
         }
      }
   }
}

