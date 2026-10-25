package net.bigpoint.darkorbit.net.netty.handlers.questfm
{
   import net.bigpoint.darkorbit.com.module.QuestCompletedCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.battlePass.model.BattlePassWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.model.SeasonPassUIMissionsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions.model.TabSpaceSearchMissionsProxy;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class QuestCompletedHandler extends BaseHandler
   {
      
      private static var _seasonPassMissionProxy:SeasonPassUIMissionsProxy;
      
      public function QuestCompletedHandler()
      {
         super();
      }
      
      public static function run(param1:QuestCompletedCommand) : void
      {
         _main.getConnectionManager().questAssembly.assembleQuestAccomplished(param1.id);
         if(battlePassProxy)
         {
            battlePassProxy.completeObjectiveCondition(param1.id);
         }
         if(seasonPassMissionProxy)
         {
            seasonPassMissionProxy.completeMission(param1.id);
         }
         TabSpaceSearchMissionsProxy.getOrCreateProxy(_facade).completedQuest(param1.id);
      }
      
      private static function get battlePassProxy() : BattlePassWindowProxy
      {
         return _facade.retrieveProxy(GuiConstants.BATTLE_PASS) as BattlePassWindowProxy;
      }
      
      public static function get seasonPassMissionProxy() : SeasonPassUIMissionsProxy
      {
         if(_seasonPassMissionProxy == null)
         {
            _seasonPassMissionProxy = _facade.retrieveProxy(GuiConstants.SEASON_PASS_MISSIONS) as SeasonPassUIMissionsProxy;
         }
         return _seasonPassMissionProxy;
      }
   }
}

