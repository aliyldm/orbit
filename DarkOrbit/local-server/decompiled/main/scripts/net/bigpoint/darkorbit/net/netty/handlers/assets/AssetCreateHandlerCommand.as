package net.bigpoint.darkorbit.net.netty.handlers.assets
{
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.com.module.AssetTypeModule;
   import net.bigpoint.darkorbit.com.module.VisualModifierCommand;
   import net.bigpoint.darkorbit.map.model.env.BuffCapsule;
   import net.bigpoint.darkorbit.map.model.env.BurningTrailEntity;
   import net.bigpoint.darkorbit.map.model.env.HealingPod;
   import net.bigpoint.darkorbit.map.model.env.NoxiousNebula;
   import net.bigpoint.darkorbit.map.model.env.NpcBeacon;
   import net.bigpoint.darkorbit.map.model.env.PayloadBoxNode;
   import net.bigpoint.darkorbit.map.model.env.PetCombatBeacon;
   import net.bigpoint.darkorbit.map.model.env.PetHpBeacon;
   import net.bigpoint.darkorbit.map.model.env.PlagueExplodinRange;
   import net.bigpoint.darkorbit.map.model.env.PlutusGenerator;
   import net.bigpoint.darkorbit.map.model.env.PlutusGeneratorGreen;
   import net.bigpoint.darkorbit.map.model.env.PlutusGeneratorRed;
   import net.bigpoint.darkorbit.map.model.env.Relay;
   import net.bigpoint.darkorbit.map.model.env.homebase.Hangar;
   import net.bigpoint.darkorbit.map.model.env.homebase.Headquarters;
   import net.bigpoint.darkorbit.map.model.env.homebase.HomeBaseLaserTurret;
   import net.bigpoint.darkorbit.map.model.env.homebase.QuestGiver;
   import net.bigpoint.darkorbit.map.model.env.homebase.Refinery;
   import net.bigpoint.darkorbit.map.model.env.homebase.RepairStation;
   import net.bigpoint.darkorbit.map.model.env.mine.MegaMine;
   import net.bigpoint.darkorbit.map.model.env.mine.PlutusMine;
   import net.bigpoint.darkorbit.map.model.env.spray.SprayAsset;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.battleStation.Asteroid;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStation;
   import net.bigpoint.darkorbit.mvc.battleStation.BattleStationModule;
   import net.bigpoint.darkorbit.mvc.boosterstation.view.BoosterStation;
   import net.bigpoint.darkorbit.mvc.sectorControl.map.ControlPoint;
   import net.bigpoint.darkorbit.mvc.sectorControl.map.SectorControlEnterPoint;
   import net.bigpoint.darkorbit.mvc.sectorControl.map.SectorControllExitPoint;
   import net.bigpoint.darkorbit.mvc.tdm.map.TDMEnterPoint;
   import net.bigpoint.darkorbit.mvc.tdm.map.TDMExitPoint;
   import net.bigpoint.darkorbit.mvc.wargame.map.WarGameEnterPoint;
   import net.bigpoint.darkorbit.mvc.wargame.map.WarGameExitPoint;
   import net.bigpoint.darkorbit.net.netty.handlers.VisualModifierHandler;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class AssetCreateHandlerCommand extends DOAbstractSimpleCommand
   {
      
      private static const MAP:Object = {};
      
      MAP[AssetTypeModule.ASSETTYPE_INSTANT_REPAIR_HOME] = RepairStation;
      MAP[AssetTypeModule.ASSETTYPE_INSTANT_REPAIR_OUTPOST] = RepairStation;
      MAP[AssetTypeModule.ASSETTYPE_ORE_TRADE_HOME] = Refinery;
      MAP[AssetTypeModule.ASSETTYPE_ORE_TRADE_OUTPOST] = Refinery;
      MAP[AssetTypeModule.ASSETTYPE_ORE_TRADE_INVISIBLE] = Refinery;
      MAP[AssetTypeModule.ASSETTYPE_HANGAR_HOME] = Hangar;
      MAP[AssetTypeModule.ASSETTYPE_HANGAR_OUTPOST] = Hangar;
      MAP[AssetTypeModule.ASSETTYPE_EXPEDITION_HOME] = Hangar;
      MAP[AssetTypeModule.ASSETTYPE_COMPANY_HQ_HOME] = Headquarters;
      MAP[AssetTypeModule.ASSETTYPE_COMPANY_HQ_OUTPOST] = Headquarters;
      MAP[AssetTypeModule.ASSETTYPE_STATION_TURRET_SMALL_HOME] = HomeBaseLaserTurret;
      MAP[AssetTypeModule.ASSETTYPE_STATION_TURRET_SMALL_OUTPOST] = HomeBaseLaserTurret;
      MAP[AssetTypeModule.ASSETTYPE_STATION_TURRET_LARGE_HOME] = HomeBaseLaserTurret;
      MAP[AssetTypeModule.ASSETTYPE_STATION_TURRET_LARGE_OUTPOST] = HomeBaseLaserTurret;
      MAP[AssetTypeModule.ASSETTYPE_QUESTGIVER] = QuestGiver;
      MAP[AssetTypeModule.ASSETTYPE_SECTOR_CONTROL_BATTLEMASTER] = SectorControlEnterPoint;
      MAP[AssetTypeModule.ASSETTYPE_TEAMDEATHMATCH_BATTLEMASTER] = TDMEnterPoint;
      MAP[AssetTypeModule.ASSETTYPE_WAR_GAME_BATTLEMASTER] = WarGameEnterPoint;
      MAP[AssetTypeModule.ASSETTYPE_BOOSTER_STATION] = BoosterStation;
      MAP[AssetTypeModule.ASSETTYPE_ASTEROID] = Asteroid;
      MAP[AssetTypeModule.ASSETTYPE_SECTOR_CONTROL_EXIT_POINT] = SectorControllExitPoint;
      MAP[AssetTypeModule.ASSETTYPE_TEAMDEATHMATCH_EXIT_POINT] = TDMExitPoint;
      MAP[AssetTypeModule.ASSETTYPE_WAR_GAME_EXIT_POINT] = WarGameExitPoint;
      MAP[AssetTypeModule.ASSETTYPE_SECTOR_CONTROL_SECTOR_ZONE] = ControlPoint;
      MAP[AssetTypeModule.ASSETTYPE_BUFF_CAPSULE] = BuffCapsule;
      MAP[AssetTypeModule.ASSETTYPE_BATTLESTATION] = BattleStation;
      MAP[AssetTypeModule.ASSETTYPE_SATELLITE] = BattleStationModule;
      MAP[AssetTypeModule.ASSETTYPE_RELAY_STATION] = Relay;
      MAP[AssetTypeModule.ASSETTYPE_HEALING_POD] = HealingPod;
      MAP[AssetTypeModule.ASSETTYPE_PLAGUE_EXPLODING_RANGE] = PlagueExplodinRange;
      MAP[AssetTypeModule.ASSETTYPE_NPC_BEACON] = NpcBeacon;
      MAP[AssetTypeModule.ASSETTYPE_BURNING_TRAIL] = BurningTrailEntity;
      MAP[AssetTypeModule.ASSETTYPE_GOP_MINE] = PlutusMine;
      MAP[AssetTypeModule.ASSETTYPE_GOP_GENERATOR] = PlutusGenerator;
      MAP[AssetTypeModule.ASSETTYPE_GOP_GENERATOR_GREEN] = PlutusGeneratorGreen;
      MAP[AssetTypeModule.ASSETTYPE_GOP_GENERATOR_RED] = PlutusGeneratorRed;
      MAP[AssetTypeModule.ASSETTYPE_PAYLOAD_BOX_NODE] = PayloadBoxNode;
      MAP[AssetTypeModule.ASSETTYPE_SPRAY] = SprayAsset;
      MAP[AssetTypeModule.ASSETTYPE_PET_MEGA_MINE] = MegaMine;
      MAP[AssetTypeModule.ASSETTYPE_PET_HP_BEACON] = PetHpBeacon;
      MAP[AssetTypeModule.ASSETTYPE_PET_COMBAT_BEACON] = PetCombatBeacon;
      MAP[AssetTypeModule.ASSETTYPE_NOXIOUS_NEBULA] = NoxiousNebula;
      
      public function AssetCreateHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:VisualModifierCommand = null;
         var _loc2_:AssetCreateCommand = param1.getBody() as AssetCreateCommand;
         if(MAP[_loc2_.type.typeValue] is Class)
         {
            screenManager.map.addEntity(new MAP[_loc2_.type.typeValue](_loc2_));
         }
         for each(_loc3_ in _loc2_.modifier)
         {
            VisualModifierHandler.run(_loc3_);
         }
      }
   }
}

