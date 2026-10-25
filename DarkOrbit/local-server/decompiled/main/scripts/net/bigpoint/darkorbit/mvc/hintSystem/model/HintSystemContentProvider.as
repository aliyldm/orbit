package net.bigpoint.darkorbit.mvc.hintSystem.model
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.HintWindowModule;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.IHintSystemContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemAttackContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemBetterEquipmentInTheShopContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemBoostingYourEquipmentContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemChangingShipsContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemEquipPLT2021ContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemFullCargoBoxContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemGettingMoreAmmunitionContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemHowToFlyContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemInstallingNewEquipmentContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemJumpGatesContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemJumpGatesDeviceContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemPVPWarningContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemPolicyChangesContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemPrepareTheBattleContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemRequestAMissionContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemSellingResourcesContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemShipRepairContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemSkylabContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemUnknownDangersContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemWealthyFamousContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.gameentry.HintSystemWelcomeContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemAsseblyContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemAuctionHouseContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemClanBattleStationContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemContactlistContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemExtraCPUsContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemGalaxyGatesContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemLookingForGroupsContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemMotivationalSurveyDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemOresTransferContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemPalladiumContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemProActionBarContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemRocketLauncherContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemSecondConfigurationDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemShipdesignContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemSkillTreeContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemTechFactoryContent;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemTrainingGroundsDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.targets.HintSystemUpgradingItemsDescription;
   
   public class HintSystemContentProvider
   {
      
      private static var _window2ContentId:Dictionary = new Dictionary();
      
      private static var _content:Dictionary = new Dictionary();
      
      private static var _initialized:Boolean = false;
      
      public function HintSystemContentProvider()
      {
         super();
      }
      
      public static function init() : void
      {
         if(_initialized)
         {
            return;
         }
         _content[HintWindowModule.HINTTYPE_WELCOME] = new HintSystemWelcomeContentDescription("WELCOME");
         _content[HintWindowModule.HINTTYPE_HOW_TO_FLY] = new HintSystemHowToFlyContentDescription("HOW_TO_FLY");
         _content[HintWindowModule.HINTTYPE_REQUEST_MISSION] = new HintSystemRequestAMissionContentDescription("REQUEST_MISSION");
         _content[HintWindowModule.HINTTYPE_ATTACK] = new HintSystemAttackContentDescription("ATTACK");
         _content[HintWindowModule.HINTTYPE_SHIP_REPAIR] = new HintSystemShipRepairContentDescription("SHIP_REPAIR");
         _content[HintWindowModule.HINTTYPE_SELL_RESOURCE] = new HintSystemSellingResourcesContentDescription("SELL_RESOURCE");
         _content[HintWindowModule.HINTTYPE_WEALTHY_FAMOUS] = new HintSystemWealthyFamousContentDescription("WEALTHY_FAMOUS");
         _content[HintWindowModule.HINTTYPE_BOOST_YOUR_EQUIP] = new HintSystemBoostingYourEquipmentContentDescription("BOOST_YOUR_EQUIP");
         _content[HintWindowModule.HINTTYPE_GET_MORE_AMMO] = new HintSystemGettingMoreAmmunitionContentDescription("GET_MORE_AMMO");
         _content[HintWindowModule.HINTTYPE_PREPARE_BATTLE] = new HintSystemPrepareTheBattleContentDescription("PREPARE_BATTLE");
         _content[HintWindowModule.HINTTYPE_JUMP_GATES] = new HintSystemJumpGatesContentDescription("JUMP_GATES");
         _content[HintWindowModule.HINTTYPE_JUMP_DEVICE] = new HintSystemJumpGatesDeviceContentDescription("JUMP_DEVICE");
         _content[HintWindowModule.HINTTYPE_INSTALLING_NEW_EQUIPMENT] = new HintSystemInstallingNewEquipmentContentDescription("INSTALLING_NEW_EQUIPMENT");
         _content[HintWindowModule.HINTTYPE_THE_SHOP] = new HintSystemBetterEquipmentInTheShopContentDescription("THE_SHOP");
         _content[HintWindowModule.HINTTYPE_CHANGING_SHIPS] = new HintSystemChangingShipsContentDescription("CHANGING_SHIPS");
         _content[HintWindowModule.HINTTYPE_PVP_WARNING] = new HintSystemPVPWarningContentDescription("PVP_WARNING");
         _content[HintWindowModule.HINTTYPE_EQUIP_YOUR_ROCKETS] = new HintSystemEquipPLT2021ContentDescription("EQUIP_YOUR_ROCKETS");
         _content[HintWindowModule.HINTTYPE_UNKOWN_DANGERS] = new HintSystemUnknownDangersContentDescription("UNKOWN_DANGERS");
         _content[HintWindowModule.HINTTYPE_SKYLAB] = new HintSystemSkylabContentDescription("SKYLAB");
         _content[HintWindowModule.HINTTYPE_POLICY_CHANGES] = new HintSystemPolicyChangesContentDescription("POLICY_CHANGES");
         _content[HintWindowModule.HINTTYPE_FULL_CARGO] = new HintSystemFullCargoBoxContentDescription("FULL_CARGO");
         _content[HintWindowModule.HINTTYPE_AUCTION_HOUSE] = new HintSystemAuctionHouseContentDescription("AUCTION_HOUSE");
         _content[HintWindowModule.HINTTYPE_CLAN_BATTLE_STATION] = new HintSystemClanBattleStationContentDescription("CLAN_BATTLE_STATION");
         _content[HintWindowModule.HINTTYPE_CONTACT_LIST] = new HintSystemContactlistContentDescription("CONTACT_LIST");
         _content[HintWindowModule.HINTTYPE_EXTRA_CPU] = new HintSystemExtraCPUsContentDescription("EXTRA_CPU");
         _content[HintWindowModule.HINTTYPE_GALAXY_GATE] = new HintSystemGalaxyGatesContentDescription("GALAXY_GATE");
         _content[HintWindowModule.HINTTYPE_LOOKING_FOR_GROUPS] = new HintSystemLookingForGroupsContentDescription("LOOKING_FOR_GROUPS");
         _content[HintWindowModule.HINTTYPE_ORE_TRANSFER] = new HintSystemOresTransferContentDescription("ORE_TRANSFER");
         _content[HintWindowModule.HINTTYPE_PALLADIUM] = new HintSystemPalladiumContentDescription("PALLADIUM");
         _content[HintWindowModule.HINTTYPE_ROCKET_LAUNCHER] = new HintSystemRocketLauncherContentDescription("ROCKET_LAUNCHER");
         _content[HintWindowModule.HINTTYPE_SECOND_CONFIGURATION] = new HintSystemSecondConfigurationDescription("SECOND_CONFIGURATION");
         _content[HintWindowModule.HINTTYPE_SHIP_DESIGN] = new HintSystemShipdesignContentDescription("SHIP_DESIGN");
         _content[HintWindowModule.HINTTYPE_SKILL_TREE] = new HintSystemSkillTreeContentDescription("SKILL_TREE");
         _content[HintWindowModule.HINTTYPE_TECH_FACTORY] = new HintSystemTechFactoryContent("TECH_FACTORY");
         _content[HintWindowModule.HINTTYPE_PRO_ACTION_BAR_INFO] = new HintSystemProActionBarContentDescription("QUICK_ACCESS_BAR");
         _content[HintWindowModule.HINTTYPE_ASSEMBLY] = new HintSystemAsseblyContentDescription("ASSEMBLY");
         _content[HintWindowModule.HINTTYPE_ITEM_UPGRADE] = new HintSystemUpgradingItemsDescription("ITEM_UPGRADE");
         _content[HintWindowModule.HINTTYPE_TRAINING_GROUNDS] = new HintSystemTrainingGroundsDescription("TRAINING_GROUNDS");
         _content[HintWindowModule.HINTTYPE_MOTIVATIONAL_SURVEY] = new HintSystemMotivationalSurveyDescription("MOTIVATIONAL_SURVEY");
         _window2ContentId[GuiConstants.ASSEMBLY_WINDOW] = HintWindowModule.HINTTYPE_ASSEMBLY;
         _initialized = true;
      }
      
      private static function initFromXML(param1:XML) : void
      {
      }
      
      public static function get(param1:uint) : IHintSystemContentDescription
      {
         init();
         var _loc2_:IHintSystemContentDescription = _content[param1];
         if(_loc2_)
         {
            _loc2_.id = param1;
         }
         return _loc2_;
      }
      
      public static function getByWindowName(param1:String) : int
      {
         return int(_window2ContentId[param1]) || -1;
      }
   }
}

