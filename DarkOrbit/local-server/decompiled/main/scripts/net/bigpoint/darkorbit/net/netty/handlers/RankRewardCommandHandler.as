package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.RankRewardCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.model.EternalBlacklightUIWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.model.EternalGateUIWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.payloadEscort.model.PayloadEscortUIWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.plutus.model.PlutusUIWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.model.PvpSummerUIWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.RogueLiteUIWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.model.TieredArenaUIWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.rankingRewards.model.TitleFrenzyUIRankingRewardsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RankRewardCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function RankRewardCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:PlutusUIWindowProxy = null;
         var _loc4_:PvpSummerUIWindowProxy = null;
         var _loc5_:PayloadEscortUIWindowProxy = null;
         var _loc6_:EternalGateUIWindowProxy = null;
         var _loc7_:EternalBlacklightUIWindowProxy = null;
         var _loc8_:TieredArenaUIWindowProxy = null;
         var _loc9_:RogueLiteUIWindowProxy = null;
         var _loc10_:TitleFrenzyUIRankingRewardsProxy = null;
         var _loc11_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:RankRewardCommand = param1.getBody() as RankRewardCommand;
         switch(_loc2_.rankType)
         {
            case RankRewardCommand.RANKTYPE_GAUNTLET_OF_PLUTUS:
               _loc3_ = retrieveProxy(GuiConstants.GAUNTLET_OF_PLUTUS) as PlutusUIWindowProxy;
               if(!_loc3_)
               {
                  _loc11_ = SimpleWindowCreationMap.getById(GuiConstants.GAUNTLET_OF_PLUTUS);
                  facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc11_);
                  _loc3_ = retrieveProxy(GuiConstants.GAUNTLET_OF_PLUTUS) as PlutusUIWindowProxy;
               }
               _loc3_.updateRewards(_loc2_);
               break;
            case RankRewardCommand.RANKTYPE_PVP_SUMMER_EVENT_REPUTATION:
            case RankRewardCommand.RANKTYPE_PVP_SUMMER_EVENT_REPUTATION_PER_KILL:
               _loc4_ = retrieveProxy(GuiConstants.PVP_SUMMER) as PvpSummerUIWindowProxy;
               if(!_loc4_)
               {
                  _loc11_ = SimpleWindowCreationMap.getById(GuiConstants.PVP_SUMMER);
                  facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc11_);
                  _loc4_ = retrieveProxy(GuiConstants.PVP_SUMMER) as PvpSummerUIWindowProxy;
               }
               _loc4_.updateRewards(_loc2_);
               break;
            case RankRewardCommand.RANKTYPE_PAYLOAD_ESCORT:
               _loc5_ = retrieveProxy(GuiConstants.PAYLOAD_ESCORT) as PayloadEscortUIWindowProxy;
               if(!_loc5_)
               {
                  _loc11_ = SimpleWindowCreationMap.getById(GuiConstants.PAYLOAD_ESCORT);
                  facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc11_);
                  _loc5_ = retrieveProxy(GuiConstants.PAYLOAD_ESCORT) as PayloadEscortUIWindowProxy;
               }
               _loc5_.updateRewards(_loc2_);
               break;
            case RankRewardCommand.RANKTYPE_ETERNAL_GATE:
               _loc6_ = retrieveProxy(GuiConstants.ETERNAL_GATE) as EternalGateUIWindowProxy;
               if(!_loc6_)
               {
                  _loc11_ = SimpleWindowCreationMap.getById(GuiConstants.ETERNAL_GATE);
                  facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc11_);
                  _loc6_ = retrieveProxy(GuiConstants.ETERNAL_GATE) as EternalGateUIWindowProxy;
               }
               _loc6_.updateRewards(_loc2_);
               break;
            case RankRewardCommand.RANKTYPE_ETERNAL_BLACKLIGHT:
               _loc7_ = retrieveProxy(GuiConstants.ETERNAL_BLACKLIGHT) as EternalBlacklightUIWindowProxy;
               if(!_loc7_)
               {
                  _loc11_ = SimpleWindowCreationMap.getById(GuiConstants.ETERNAL_BLACKLIGHT);
                  facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc11_);
                  _loc7_ = retrieveProxy(GuiConstants.ETERNAL_BLACKLIGHT) as EternalBlacklightUIWindowProxy;
               }
               _loc7_.updateRewards(_loc2_);
               break;
            case RankRewardCommand.RANKTYPE_TIERED_ARENA_EVENT_REPUTATION:
               _loc8_ = retrieveProxy(GuiConstants.TIERED_ARENA) as TieredArenaUIWindowProxy;
               if(!_loc8_)
               {
                  _loc11_ = SimpleWindowCreationMap.getById(GuiConstants.TIERED_ARENA);
                  facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc11_);
                  _loc8_ = retrieveProxy(GuiConstants.TIERED_ARENA) as TieredArenaUIWindowProxy;
               }
               _loc8_.updateRewards(_loc2_);
               break;
            case RankRewardCommand.RANKTYPE_ROGUE_LITE:
               _loc9_ = retrieveProxy(GuiConstants.ROGUE_LITE) as RogueLiteUIWindowProxy;
               if(!_loc9_)
               {
                  _loc11_ = SimpleWindowCreationMap.getById(GuiConstants.ROGUE_LITE);
                  facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc11_);
                  _loc9_ = retrieveProxy(GuiConstants.ROGUE_LITE) as RogueLiteUIWindowProxy;
               }
               _loc9_.updateRankingRewards(_loc2_);
               break;
            case RankRewardCommand.RANKTYPE_TITLE_FRENZY:
               _loc10_ = retrieveProxy(GuiConstants.TITLE_FRENZY_RANKING_REWARDS) as TitleFrenzyUIRankingRewardsProxy;
               if(!_loc10_)
               {
                  _loc11_ = SimpleWindowCreationMap.getById(GuiConstants.TITLE_FRENZY);
                  sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc11_);
                  _loc10_ = retrieveProxy(GuiConstants.TITLE_FRENZY_RANKING_REWARDS) as TitleFrenzyUIRankingRewardsProxy;
               }
               _loc10_.updateRankingRewardsPackage(_loc2_);
         }
      }
   }
}

