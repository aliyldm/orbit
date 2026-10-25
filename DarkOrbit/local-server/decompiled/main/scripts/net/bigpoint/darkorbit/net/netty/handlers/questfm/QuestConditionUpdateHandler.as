package net.bigpoint.darkorbit.net.netty.handlers.questfm
{
   import net.bigpoint.darkorbit.com.module.QuestConditionUpdateCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.battlePass.model.BattlePassWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.diminishingQuest.model.DiminishingQuestUIWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.model.SeasonPassUIMissionsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions.model.TabSpaceSearchMissionsProxy;
   import net.bigpoint.darkorbit.mvc.questWindow.model.QuestProxy;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class QuestConditionUpdateHandler extends BaseHandler
   {
      
      private static var _diminishQuestProxy:DiminishingQuestUIWindowProxy;
      
      private static var _seasonPassMissionProxy:SeasonPassUIMissionsProxy;
      
      public function QuestConditionUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:QuestConditionUpdateCommand) : void
      {
         var _loc2_:int = param1.questConditionId;
         var _loc3_:int = _main.getQuestManager().getQuestIDByConditionID(_loc2_);
         var _loc4_:Number = param1.state.currentValue;
         var _loc5_:Boolean = param1.state.active;
         var _loc6_:Boolean = param1.state.completed;
         if(_loc3_ > 0)
         {
            _main.getConnectionManager().questAssembly.assembleQuestUpdate(_loc3_,_loc2_,_loc4_,_loc5_,_loc6_);
            if(questProxy)
            {
               questProxy.updateQuestObjectives(_loc2_,_loc4_,_loc5_,_loc6_);
            }
         }
         if(battlePassProxy)
         {
            battlePassProxy.updateObjectiveCondition(_loc2_,_loc4_,_loc5_,_loc6_);
         }
         if(DiminishQuestProxy)
         {
            DiminishQuestProxy.updateQuestObjectives(_loc2_,_loc4_,_loc5_,_loc6_);
         }
         if(SeasonPassProxy)
         {
            SeasonPassProxy.updateQuestObjectives(_loc2_,_loc4_,_loc5_,_loc6_);
         }
         TabSpaceSearchMissionsProxy.getOrCreateProxy(_facade).updateDataByConditionId(_loc2_,_loc4_,_loc6_);
      }
      
      private static function get questProxy() : QuestProxy
      {
         return _facade.retrieveProxy(QuestProxy.NAME) as QuestProxy;
      }
      
      private static function get battlePassProxy() : BattlePassWindowProxy
      {
         return _facade.retrieveProxy(GuiConstants.BATTLE_PASS) as BattlePassWindowProxy;
      }
      
      private static function get SeasonPassProxy() : SeasonPassUIMissionsProxy
      {
         if(_seasonPassMissionProxy == null)
         {
            _seasonPassMissionProxy = _facade.retrieveProxy(GuiConstants.SEASON_PASS_MISSIONS) as SeasonPassUIMissionsProxy;
         }
         return _seasonPassMissionProxy;
      }
      
      private static function get DiminishQuestProxy() : DiminishingQuestUIWindowProxy
      {
         if(_diminishQuestProxy == null)
         {
            _diminishQuestProxy = _facade.retrieveProxy(GuiConstants.DIMINISH_RETURN_QUEST) as DiminishingQuestUIWindowProxy;
         }
         return _diminishQuestProxy;
      }
   }
}

