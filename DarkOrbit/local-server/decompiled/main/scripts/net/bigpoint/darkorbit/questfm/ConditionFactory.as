package net.bigpoint.darkorbit.questfm
{
   import net.bigpoint.darkorbit.com.module.QuestConditionModule;
   import net.bigpoint.darkorbit.questfm.conditions.ActivateCPUCondition;
   import net.bigpoint.darkorbit.questfm.conditions.ActivateMapAssetCondition;
   import net.bigpoint.darkorbit.questfm.conditions.AmmunitionCondition;
   import net.bigpoint.darkorbit.questfm.conditions.AvoidDamageCondition;
   import net.bigpoint.darkorbit.questfm.conditions.AvoidDamageNPCsCondition;
   import net.bigpoint.darkorbit.questfm.conditions.AvoidDamagePlayersCondition;
   import net.bigpoint.darkorbit.questfm.conditions.AvoidDeathCondition;
   import net.bigpoint.darkorbit.questfm.conditions.AvoidJumpCondition;
   import net.bigpoint.darkorbit.questfm.conditions.AvoidKillNPCCondition;
   import net.bigpoint.darkorbit.questfm.conditions.AvoidKillNPCsCondition;
   import net.bigpoint.darkorbit.questfm.conditions.AvoidKillPlayersCondition;
   import net.bigpoint.darkorbit.questfm.conditions.BeaconTakeoverCondition;
   import net.bigpoint.darkorbit.questfm.conditions.BoosterAmountCondition;
   import net.bigpoint.darkorbit.questfm.conditions.CargoCondition;
   import net.bigpoint.darkorbit.questfm.conditions.ClearGalaxyGateWaveCondition;
   import net.bigpoint.darkorbit.questfm.conditions.ClientCondition;
   import net.bigpoint.darkorbit.questfm.conditions.CollectBonusBoxCondition;
   import net.bigpoint.darkorbit.questfm.conditions.CollectBonusBoxTypeCondition;
   import net.bigpoint.darkorbit.questfm.conditions.CollectBootyBoxTypeCondition;
   import net.bigpoint.darkorbit.questfm.conditions.CollectCondition;
   import net.bigpoint.darkorbit.questfm.conditions.CollectLootCondition;
   import net.bigpoint.darkorbit.questfm.conditions.CollectShipCondition;
   import net.bigpoint.darkorbit.questfm.conditions.CollectShipDesignCondition;
   import net.bigpoint.darkorbit.questfm.conditions.CompleteObjectivesCondition;
   import net.bigpoint.darkorbit.questfm.conditions.CompleteSeasonPassQuestsCondition;
   import net.bigpoint.darkorbit.questfm.conditions.Condition;
   import net.bigpoint.darkorbit.questfm.conditions.ConditionTypeDefinition;
   import net.bigpoint.darkorbit.questfm.conditions.CoordinatesCondition;
   import net.bigpoint.darkorbit.questfm.conditions.CountDownCondition;
   import net.bigpoint.darkorbit.questfm.conditions.DamageCondition;
   import net.bigpoint.darkorbit.questfm.conditions.DamageEnemyPlayersCondition;
   import net.bigpoint.darkorbit.questfm.conditions.DamageMapAssetsCondition;
   import net.bigpoint.darkorbit.questfm.conditions.DamageNPCsCondition;
   import net.bigpoint.darkorbit.questfm.conditions.DamagePlayersCondition;
   import net.bigpoint.darkorbit.questfm.conditions.DieCondition;
   import net.bigpoint.darkorbit.questfm.conditions.DistanceCondition;
   import net.bigpoint.darkorbit.questfm.conditions.DuringEventCondition;
   import net.bigpoint.darkorbit.questfm.conditions.EmptyCondition;
   import net.bigpoint.darkorbit.questfm.conditions.EnduranceCondition;
   import net.bigpoint.darkorbit.questfm.conditions.EnterGroupCondition;
   import net.bigpoint.darkorbit.questfm.conditions.FinishGalaxyGateCondition;
   import net.bigpoint.darkorbit.questfm.conditions.FinishGalaxyGatesCondition;
   import net.bigpoint.darkorbit.questfm.conditions.FinishStarterGateCondition;
   import net.bigpoint.darkorbit.questfm.conditions.FuelShortageCondition;
   import net.bigpoint.darkorbit.questfm.conditions.GainInfluenceCondition;
   import net.bigpoint.darkorbit.questfm.conditions.GenericTextCondition;
   import net.bigpoint.darkorbit.questfm.conditions.HasteCondition;
   import net.bigpoint.darkorbit.questfm.conditions.HonorNegativeCondition;
   import net.bigpoint.darkorbit.questfm.conditions.InClanCondition;
   import net.bigpoint.darkorbit.questfm.conditions.InGroupCondition;
   import net.bigpoint.darkorbit.questfm.conditions.JumpCondition;
   import net.bigpoint.darkorbit.questfm.conditions.KillAnyCondition;
   import net.bigpoint.darkorbit.questfm.conditions.KillNPCCondition;
   import net.bigpoint.darkorbit.questfm.conditions.KillNPCsCondition;
   import net.bigpoint.darkorbit.questfm.conditions.KillPlayersCondition;
   import net.bigpoint.darkorbit.questfm.conditions.LevelCondition;
   import net.bigpoint.darkorbit.questfm.conditions.LoginCondition;
   import net.bigpoint.darkorbit.questfm.conditions.MapCondition;
   import net.bigpoint.darkorbit.questfm.conditions.MapDiverseCondition;
   import net.bigpoint.darkorbit.questfm.conditions.MiscellaneousCondition;
   import net.bigpoint.darkorbit.questfm.conditions.MultiplierCondition;
   import net.bigpoint.darkorbit.questfm.conditions.PreventCondition;
   import net.bigpoint.darkorbit.questfm.conditions.ProximityCondition;
   import net.bigpoint.darkorbit.questfm.conditions.PutItemInSlotBarCondition;
   import net.bigpoint.darkorbit.questfm.conditions.QuickBuyCondition;
   import net.bigpoint.darkorbit.questfm.conditions.RealTimeHasteCondition;
   import net.bigpoint.darkorbit.questfm.conditions.RechargeAmountCondition;
   import net.bigpoint.darkorbit.questfm.conditions.RefineOreCondition;
   import net.bigpoint.darkorbit.questfm.conditions.RestrictAmmunitionKillNPCCondition;
   import net.bigpoint.darkorbit.questfm.conditions.RestrictAmmunitionKillPlayerCondition;
   import net.bigpoint.darkorbit.questfm.conditions.SalvageCondition;
   import net.bigpoint.darkorbit.questfm.conditions.SaveAmmunitionCondition;
   import net.bigpoint.darkorbit.questfm.conditions.ScoreRogueLiteCondition;
   import net.bigpoint.darkorbit.questfm.conditions.SellOreCondition;
   import net.bigpoint.darkorbit.questfm.conditions.SpendAmmunitionCondition;
   import net.bigpoint.darkorbit.questfm.conditions.SpendItemCondition;
   import net.bigpoint.darkorbit.questfm.conditions.SpendRecipeIngredientsCondition;
   import net.bigpoint.darkorbit.questfm.conditions.StayAwayCondition;
   import net.bigpoint.darkorbit.questfm.conditions.SteadinessCondition;
   import net.bigpoint.darkorbit.questfm.conditions.StealCondition;
   import net.bigpoint.darkorbit.questfm.conditions.TakeDamageCondition;
   import net.bigpoint.darkorbit.questfm.conditions.TimerCondition;
   import net.bigpoint.darkorbit.questfm.conditions.TravelCondition;
   import net.bigpoint.darkorbit.questfm.conditions.UpdateSkylabToLevelCondition;
   import net.bigpoint.darkorbit.questfm.conditions.UseOreUpdateCondition;
   import net.bigpoint.darkorbit.questfm.conditions.VisitDisruptionZoneCondition;
   import net.bigpoint.darkorbit.questfm.conditions.VisitJumpGateToMapCondition;
   import net.bigpoint.darkorbit.questfm.conditions.VisitMapAssetCondition;
   import net.bigpoint.darkorbit.questfm.conditions.VisitMapCondition;
   import net.bigpoint.darkorbit.questfm.conditions.VisitMultipleMapsCondition;
   import net.bigpoint.darkorbit.questfm.conditions.VisitQuestGiverCondition;
   import net.bigpoint.darkorbit.questfm.conditions.WebCondition;
   
   public class ConditionFactory
   {
      
      private static const DEBUG_CONDITION:int = -1;
      
      private var conditionDefinitions:Array;
      
      public function ConditionFactory()
      {
         super();
         this.initConditionDefinitions();
      }
      
      public function createCondition(param1:int, param2:int, param3:Number, param4:Number, param5:Boolean, param6:Boolean, param7:Boolean, param8:Vector.<String> = null) : ICondition
      {
         if(!this.conditionDefinitions[param1])
         {
            param1 = DEBUG_CONDITION;
         }
         var _loc9_:Class = (this.conditionDefinitions[param1] as ConditionTypeDefinition).CLASS;
         var _loc10_:ICondition = new _loc9_();
         _loc10_.definition = this.conditionDefinitions[param1];
         _loc10_.init(param2,param3,param4,param5,param6,param7,param8);
         return _loc10_;
      }
      
      private function initConditionDefinitions() : void
      {
         this.conditionDefinitions = [];
         this.conditionDefinitions[DEBUG_CONDITION] = new ConditionTypeDefinition(DEBUG_CONDITION,"UNKNOWN",net.bigpoint.darkorbit.questfm.conditions.Condition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_TIMER] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_TIMER,"TIMER",TimerCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_HASTE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_HASTE,"HASTE",HasteCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_ENDURANCE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_ENDURANCE,"ENDURANCE",EnduranceCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_COUNTDOWN] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_COUNTDOWN,"COUNTDOWN",CountDownCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_COLLECT] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_COLLECT,"COLLECT",CollectCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_KILL_NPC] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_KILL_NPC,"KILL_NPC",KillNPCCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_DAMAGE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_DAMAGE,"DAMAGE",DamageCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_AVOID_DAMAGE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_AVOID_DAMAGE,"AVOID_DAMAGE",AvoidDamageCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_TAKE_DAMAGE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_TAKE_DAMAGE,"TAKE_DAMAGE",TakeDamageCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_AVOID_DEATH] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_AVOID_DEATH,"AVOID_DEATH",AvoidDeathCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_COORDINATES] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_COORDINATES,"COORDINATES",CoordinatesCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_DISTANCE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_DISTANCE,"DISTANCE",DistanceCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_TRAVEL] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_TRAVEL,"TRAVEL",TravelCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_FUEL_SHORTAGE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_FUEL_SHORTAGE,"FUEL_SHORTAGE",FuelShortageCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_PROXIMITY] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_PROXIMITY,"PROXIMITY",ProximityCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_MAP] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_MAP,"MAP",MapCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_MAP_DIVERSE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_MAP_DIVERSE,"MAP_DIVERSE",MapDiverseCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_EMPTY] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_EMPTY,"EMPTY",EmptyCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_MISCELLANEOUS] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_MISCELLANEOUS,"MISCELLANEOUS",MiscellaneousCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_AMMUNITION] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_AMMUNITION,"AMMUNITION",AmmunitionCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_SAVE_AMMUNITION] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_SAVE_AMMUNITION,"SAVE_AMMUNITION",SaveAmmunitionCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_SPEND_AMMUNITION] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_SPEND_AMMUNITION,"SPEND_AMMUNITION",SpendAmmunitionCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_SALVAGE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_SALVAGE,"SALVAGE",SalvageCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_STEAL] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_STEAL,"STEAL",StealCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_KILL_NPCS] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_KILL_NPCS,"KILL_NPCS",KillNPCsCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_KILL_PLAYERS] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_KILL_PLAYERS,"KILL_PLAYERS",KillPlayersCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_DAMAGE_NPCS] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_DAMAGE_NPCS,"DAMAGE_NPCS",DamageNPCsCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_DAMAGE_PLAYERS] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_DAMAGE_PLAYERS,"DAMAGE_PLAYERS",DamagePlayersCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_DAMAGE_ENEMY_PLAYERS] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_DAMAGE_PLAYERS,"DAMAGE_ENEMY_PLAYERS",DamageEnemyPlayersCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_VISIT_MAP] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_VISIT_MAP,"VISIT_MAP",VisitMapCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_DIE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_DIE,"DIE",DieCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_AVOID_KILL_NPC] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_AVOID_KILL_NPC,"AVOID_KILL_NPC",AvoidKillNPCCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_AVOID_KILL_NPCS] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_AVOID_KILL_NPCS,"AVOID_KILL_NPCS",AvoidKillNPCsCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_AVOID_KILL_PLAYERS] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_AVOID_KILL_PLAYERS,"AVOID_KILL_PLAYERS",AvoidKillPlayersCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_AVOID_DAMAGE_NPCS] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_AVOID_DAMAGE_NPCS,"AVOID_DAMAGE_NPCS",AvoidDamageNPCsCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_AVOID_DAMAGE_PLAYERS] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_AVOID_DAMAGE_PLAYERS,"AVOID_DAMAGE_PLAYERS",AvoidDamagePlayersCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_PREVENT] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_PREVENT,"PREVENT",PreventCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_JUMP] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_JUMP,"JUMP",JumpCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_AVOID_JUMP] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_AVOID_JUMP,"AVOID_JUMP",AvoidJumpCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_STEADINESS] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_STEADINESS,"STEADINESS",SteadinessCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_MULTIPLIER] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_MULTIPLIER,"MULTIPLIER",MultiplierCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_STAY_AWAY] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_STAY_AWAY,"STAY_AWAY",StayAwayCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_IN_GROUP] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_IN_GROUP,"IN_GROUP",InGroupCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_KILL_ANY] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_KILL_ANY,"KILL_ANY",KillAnyCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_WEB] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_WEB,"WEB",WebCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_CLIENT] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_CLIENT,"CLIENT",ClientCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_CARGO] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_CARGO,"CARGO",CargoCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_SELL_ORE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_SELL_ORE,"SELL_ORE",SellOreCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_LEVEL] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_LEVEL,"LEVEL",LevelCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_GAIN_INFLUENCE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_GAIN_INFLUENCE,"GAIN_INFLUENCE",GainInfluenceCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_RESTRICT_AMMUNITION_KILL_NPC] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_RESTRICT_AMMUNITION_KILL_NPC,"RESTRICT_AMMUNITION_KILL_NPC",RestrictAmmunitionKillNPCCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_RESTRICT_AMMUNITION_KILL_PLAYER] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_RESTRICT_AMMUNITION_KILL_PLAYER,"RESTRICT_AMMUNITION_KILL_PLAYER",RestrictAmmunitionKillPlayerCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_BELOW_HONOUR] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_BELOW_HONOUR,"HONOR_NEGATIVE",HonorNegativeCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_VISIT_QUEST_GIVER] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_VISIT_QUEST_GIVER,"VISIT_QUEST_GIVER",VisitQuestGiverCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_COLLECT_BONUS_BOX] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_COLLECT_BONUS_BOX,"COLLECT_BONUS_BOX",CollectBonusBoxCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_QUICK_BUY] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_QUICK_BUY,"QUICK_BUY",QuickBuyCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_ENTER_GROUP] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_ENTER_GROUP,"ENTER_GROUP",EnterGroupCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_REAL_TIME_HASTE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_REAL_TIME_HASTE,"REAL_TIME_HASTE",RealTimeHasteCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_ACTIVATE_MAP_ASSET_TYPE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_ACTIVATE_MAP_ASSET_TYPE,"ACTIVATE_MAP_ASSET_TYPE",ActivateMapAssetCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_VISIT_JUMP_GATE_TO_MAP_TYPE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_VISIT_JUMP_GATE_TO_MAP_TYPE,"VISIT_JUMP_GATE_TO_MAP_TYPE",VisitJumpGateToMapCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_VISIT_MAP_TYPE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_VISIT_MAP_TYPE,"VISIT_MULTIPLE_MAPS",VisitMultipleMapsCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_COLLECT_LOOT] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_COLLECT_LOOT,"COLLECT_LOOT",CollectLootCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_FINISH_STARTER_GATE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_FINISH_STARTER_GATE,"FINISH_STARTER_GATE",FinishStarterGateCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_FINISH_GALAXY_GATE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_FINISH_GALAXY_GATE,"FINISH_GALAXY_GATE",FinishGalaxyGateCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_FINISH_GALAXY_GATES] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_FINISH_GALAXY_GATES,"FINISH_GALAXY_GATES",FinishGalaxyGatesCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_IN_CLAN] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_IN_CLAN,"IN_CLAN",InClanCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_REFINE_ORE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_REFINE_ORE,"REFINE_ORE",RefineOreCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_PUT_ITEM_IN_SLOT_BAR] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_PUT_ITEM_IN_SLOT_BAR,"PUT_ITEM_IN_SLOT_BAR",PutItemInSlotBarCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_USE_ORE_UPDATE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_USE_ORE_UPDATE,"USE_ORE_UPDATE",UseOreUpdateCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_VISIT_MAP_ASSET] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_VISIT_MAP_ASSET,"VISIT_MAP_ASSET",VisitMapAssetCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_UPDATE_SKYLAB_TO_LEVEL] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_UPDATE_SKYLAB_TO_LEVEL,"UPDATE_SKYLAB_TO_LEVEL",UpdateSkylabToLevelCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_ON_MAP] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_ON_MAP,"MAP",MapCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_BEACON_TAKEOVER] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_ON_MAP,"BEACON_TAKEOVER",BeaconTakeoverCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_COLLECT_BUILT_RECIPE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_COLLECT_BUILT_RECIPE,"COLLECT_BUILT_RECIPE",CollectBuildRecipeCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_GENERIC_TEXT] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_GENERIC_TEXT,"",GenericTextCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_DISRUPTED] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_DISRUPTED,"VISIT_DISRUPTION_ZONE",VisitDisruptionZoneCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_REAL_TIME_DATE_HASTE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_REAL_TIME_HASTE,"REAL_TIME_DATE_HASTE",RealTimeHasteCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_COLLECT_BONUS_BOX_TYPE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_COLLECT_BONUS_BOX_TYPE,"COLLECT_BONUS_BOX_TYPE",CollectBonusBoxTypeCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_DAMAGE_MAPASSETS] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_DAMAGE_MAPASSETS,"DAMAGE_MAPASSETS",DamageMapAssetsCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_COMPLETED_OBJECTIVES] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_COMPLETED_OBJECTIVES,"COMPLETED_OBJECTIVES",CompleteObjectivesCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_ACTIVATE_CPU] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_ACTIVATE_CPU,"ACTIVATE_CPU",ActivateCPUCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_SPEND_ITEM] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_SPEND_ITEM,"SPEND_ITEM",SpendItemCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_CLEAR_GALAXY_GATE_WAVE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_CLEAR_GALAXY_GATE_WAVE,"CLEAR_GALAXY_GATE_WAVE",ClearGalaxyGateWaveCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_SCORE_ROGUE_LITE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_SCORE_ROGUE_LITE,"SCORE_ASTRAL_ASCENSION",ScoreRogueLiteCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_COLLECT_BOOTY_BOX_TYPE] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_COLLECT_BOOTY_BOX_TYPE,"COLLECT_BONUS_BOX_TYPE",CollectBootyBoxTypeCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_SPEND_RECIPE_INGREDIENTS] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_SPEND_RECIPE_INGREDIENTS,"SPEND_RECIPE_INGREDIENTS",SpendRecipeIngredientsCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_COMPLETE_SEASON_PASS_QUESTS] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_COMPLETE_SEASON_PASS_QUESTS,"COMPLETE_SEASON_PASS_QUESTS",CompleteSeasonPassQuestsCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_LOGIN] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_LOGIN,"LOGIN_CONDITION",LoginCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_DURING_EVENT] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_DURING_EVENT,"DURING_EVENT",DuringEventCondition,false);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_COLLECT_SHIP_LOOT] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_COLLECT_SHIP_LOOT,"COLLECT_SHIP_LOOT",CollectShipCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_COLLECT_SHIP_DESIGN_LOOT] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_COLLECT_SHIP_DESIGN_LOOT,"COLLECT_SHIP_DESIGN_LOOT",CollectShipDesignCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_RECHARGE_AMOUNT] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_RECHARGE_AMOUNT,"RECHARGE_AMOUNT",RechargeAmountCondition,true);
         this.conditionDefinitions[QuestConditionModule.CONDITIONTYPE_BOOSTER_AMOUNT] = new ConditionTypeDefinition(QuestConditionModule.CONDITIONTYPE_BOOSTER_AMOUNT,"BOOSTER_AMOUNT",BoosterAmountCondition,true);
      }
   }
}

