package net.bigpoint.darkorbit
{
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.catalog.SysItem;
   import net.bigpoint.darkorbit.com.module.AssetTypeModule;
   import net.bigpoint.darkorbit.com.module.BoostedAttributeTypeModule;
   import net.bigpoint.darkorbit.com.module.EpicFightMessageTypeModule;
   import net.bigpoint.darkorbit.com.module.EpicNumberedFightMessageTypeModule;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.com.module.InvitationErrorCommand;
   import net.bigpoint.darkorbit.com.module.MapAddPOICommand;
   import net.bigpoint.darkorbit.com.module.OreTypeModule;
   import net.bigpoint.darkorbit.com.module.POIDesignModule;
   import net.bigpoint.darkorbit.com.module.POITypeModule;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.com.module.ShipIconModule;
   import net.bigpoint.darkorbit.com.module.TrainingGroundRegistrationUnavailableStatusCommand;
   import net.bigpoint.darkorbit.com.module.VideoWindowCreateCommand;
   import net.bigpoint.darkorbit.gui.elements.VideoElement;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.RaidGateConstants;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.RocketPattern;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class InGameCatalog
   {
      
      private static var _instance:InGameCatalog;
      
      private static const PVP:String = "PVP";
      
      private static const UBER:String = "UBER";
      
      public static const FACTION_OTHER:int = 1000;
      
      public static const POD_TYPE_NONE:int = 0;
      
      public static const POD_TYPE_HEAL:int = 1;
      
      public static const POD_TYPE_PROTECT:int = 2;
      
      public static const EXPLOSION_MINE_STICKYBOMB:int = 0;
      
      public static const SHIP_ABILITY_SOLACE_INSTANT_HEAL:int = 1;
      
      public static const SHIP_ABILITY_DIMINISHER_WEAKEN_SHIELDS:int = 2;
      
      public static const SHIP_ABILITY_SPECTRUM_PRISMATIC_SHIELDING:int = 3;
      
      public static const SHIP_ABILITY_SENTINEL_FORTRESS:int = 4;
      
      public static const SHIP_ABILITY_VENOM_SINGULARITY:int = 5;
      
      public static const SHIP_ABILITY_LIGHTNING_AFTERBURNER:int = 6;
      
      public static const SHIP_ABILITY_SPEED_DEBUFF:int = 7;
      
      public static const SHIP_ABILITY_AEGIS_HEALING_BEAM:int = 101;
      
      public static const SHIP_ABILITY_AEGIS_SHIELD_RECHARGE:int = 104;
      
      public static const SHIP_ABILITY_AEGIS_HEALING_POD:int = 105;
      
      public static const SHIP_ABILITY_CITADEL_DRAW_FIRE:int = 102;
      
      public static const SHIP_ABILITY_CITADEL_TRAVEL_MODE:int = 107;
      
      public static const SHIP_ABILITY_CITADEL_PROTECTION:int = 108;
      
      public static const SHIP_ABILITY_CITADEL_FORTIFY:int = 109;
      
      public static const SHIP_ABILITY_SPEARHEAD_ULTIMATE_CLOAKING:int = 103;
      
      public static const SHIP_ABILITY_SPEARHEAD_MARK_TARGET:int = 106;
      
      public static const SHIP_ABILITY_SPEARHEAD_JAMX:int = 110;
      
      public static const SHIP_ABILITY_SPEARHEAD_DOUBLE_MINIMAP_REVEAL:int = 111;
      
      public static const SHIP_ABILITY_SOLACE_PLUS_INSTANT_HEAL_PLUS:int = 140;
      
      public static const SHIP_ABILITY_HAMMERCLAW_PLUS_INSTANT_HEAL:int = 145;
      
      public static const SHIP_ABILITY_SPEARHEAD_PLUS_JAMX_CREED:int = 146;
      
      public static const SHIP_ABILITY_SPEARHEAD_PLUS_NEUTRALIZING_MARKER:int = 147;
      
      public static const SHIP_ABILITY_TEMPEST_VOLTAGE_LINK:int = 146;
      
      public static const SHIP_ABILITY_TEMPEST_VOLT_DISCHARGE:int = 147;
      
      public static const SHIP_ABILITY_TEMPEST_VOLT_BACKUP:int = 148;
      
      public static const SHIP_ABILITY_TARTARUS_PLUS_SPEED_BOOST_PLUS:int = 149;
      
      public static const SHIP_ABILITY_TARTARUS_PLUS_RAPID_FIRE_PLUS:int = 150;
      
      public static const SHIP_ABILITY_SPECTRUM_PLUS_REFLECTING:int = 156;
      
      public static const NPC_ABILITY_HALLOWEEN_STICKYBOMB:int = 1000;
      
      public static const NPC_ABILITY_EMPEROR_STICKYBOMB:int = 1001;
      
      public static const HALLOWEEN_STICKYBOMB_SHOW_EXPLOSION:int = 0;
      
      public static const HALLOWEEN_STICKYBOMB_SHOW_NO_EXPLOSION:int = 1;
      
      public static const SOUND_ID_ENGINE:int = 4;
      
      public static const SOUND_ID_PORTAL_JUMP:int = 5;
      
      public static const SOUND_ID_PORTAL_DONE:int = 6;
      
      public static const SOUND_ID_ATMOSPHERE_0:int = 14;
      
      public static const SOUND_ID_EXPLOSION_2:int = 18;
      
      public static const SOUND_ID_VOICE_READY:int = 20;
      
      public static const SOUND_ID_VOICE_ACTIVATE:int = 21;
      
      public static const SOUND_ID_VOICE_STANDBY:int = 22;
      
      public static const SOUND_ID_VOICE_WARNING:int = 23;
      
      public static const SOUND_ID_SELECT_0:int = 24;
      
      public static const SOUND_ID_SELECT_1:int = 25;
      
      public static const SOUND_ID_TDM_INTRO:int = 26;
      
      public static const SOUND_ID_TDM_COUNTER:int = 27;
      
      public static const SOUND_ID_TDM_START:int = 28;
      
      public static const SOUND_ID_VOICE_ACCESS_DENIED:int = 29;
      
      public static const SOUND_ID_SMARTBOMB_0:int = 30;
      
      public static const SOUND_ID_INSTASHIELD_0:int = 31;
      
      public static const SOUND_ID_UI_SLOT_MOVE:int = 33;
      
      public static const SOUND_ID_FIREWORK:int = 34;
      
      public static const SOUND_ID_REPAIR_BOT:int = 35;
      
      public static const SOUND_ID_SHOCKWAVE_2:int = 36;
      
      public static const SOUND_ID_SHIELD_SELECTED:int = 37;
      
      public static const SOUND_ID_PULSE:int = 38;
      
      public static const SOUND_ID_AIRSTRIKE:int = 40;
      
      public static const SOUND_ID_ATMOSPHERE_1:int = 41;
      
      public static const SOUND_ID_NOISE:int = 42;
      
      public static const SOUND_ID_EMP:int = 43;
      
      public static const SOUND_ID_ROCKET_LOAD:int = 46;
      
      public static const SOUND_ID_ROCKETS_LOADED:int = 47;
      
      public static const SOUND_ID_SIGNAL_0:int = 48;
      
      public static const SOUND_ID_NEW_ACHIEVEMENT:int = 51;
      
      public static const SOUND_ID_PET_ACTIVATION:int = 67;
      
      public static const SOUND_ID_PET_DEACTIVATION:int = 68;
      
      public static const SOUND_ID_PET_DESTRUCTION:int = 69;
      
      public static const SOUND_ID_PET_LEVELUP:int = 70;
      
      public static const SOUND_ID_PET_HEALING:int = 71;
      
      public static const SOUND_ID_PET_ACCEPTED:int = 72;
      
      public static const SOUND_ID_PET_ERROR:int = 73;
      
      public static const SOUND_ID_PIRATE_KAMIKAZE:int = 75;
      
      public static const SOUND_ID_PIRATE_CHASING_SHOT:int = 76;
      
      public static const SOUND_ID_PIRATE_BATTLERAY_HEAL:int = 77;
      
      public static const SOUND_ID_PIRATE_RAGE:int = 78;
      
      public static const SOUND_ID_PIRATE_SPAWN:int = 79;
      
      public static const SOUND_ID_PIRATE_INVINCIBILITY:int = 80;
      
      public static const SOUND_ID_LIGHTNING_AFTERBURNER_START:int = 81;
      
      public static const SOUND_ID_LIGHTNING_AFTERBURNER_LOOP:int = 82;
      
      public static const SOUND_ID_KILLSTREAK_TRIPLE_KILL:int = 83;
      
      public static const SOUND_ID_KILLSTREAK_UNSTOPPABLE:int = 84;
      
      public static const SOUND_ID_KILLSTREAK_GODLIKE:int = 85;
      
      public static const SOUND_ID_KILLSTREAK_LIKE_A_BOSS:int = 86;
      
      public static const SOUND_ID_AEGIS_HEALING_BEAM:int = 90;
      
      public static const SOUND_ID_AEGIS_SHIELD_RECHARGE:int = 91;
      
      public static const SOUND_ID_AEGIS_HEALING_POD:int = 92;
      
      public static const SOUND_ID_CITADEL_DRAW_FIRE:int = 93;
      
      public static const SOUND_ID_CITADEL_TRAVEL_MODE_LOOP:int = 95;
      
      public static const SOUND_ID_CITADEL_FORTIFY_START:int = 96;
      
      public static const SOUND_ID_CITADEL_FORTIFY_STOP:int = 97;
      
      public static const SOUND_ID_CITADEL_PROTECTION:int = 98;
      
      public static const SOUND_ID_SPEARHEAD_ULTIMATE_CLOAKING:int = 99;
      
      public static const SOUND_ID_SPEARHEAD_JAMX:int = 100;
      
      public static const SOUND_ID_SPEARHEAD_MARK_TARGET:int = 101;
      
      public static const SOUND_ID_SPEARHEAD_DOUBLE_MINIMAP_REVEAL:int = 102;
      
      public static const SOUND_ID_ICON_APPEARS_SOUND:int = 103;
      
      public static const SOUND_ID_QUEST_WINDOW_OPEN_SOUND:int = 104;
      
      public static const SOUND_ID_UNDOCK:int = 110;
      
      public static const SOUND_ID_DOCK:int = 111;
      
      public static const SOUND_ID_STICKYBOMB_BEEP:int = 113;
      
      public static const SOUND_ID_REPAIR_START:int = 115;
      
      public static const SOUND_ID_ROCKETS_LOAD_START:int = 116;
      
      public static const SOUND_ID_AMBIENT:int = 117;
      
      public static const SOUND_ID_SAIMON_SHOT:int = 118;
      
      public static const SOUND_ID_SECTOR_CAPTURED:int = 119;
      
      public static const SOUND_ID_SECTOR_NEUTRALIZED:int = 120;
      
      public static const SOUND_ID_TICKET_WARNING:int = 121;
      
      public static const SOUND_ID_SECTOR_HEALED:int = 122;
      
      public static const SOUND_ID_PLOEPP:int = 123;
      
      public static const SOUND_ID_OUT_OF_RANGE:int = 124;
      
      public static const SOUND_ID_COOLDOWN_FINISHED:int = 125;
      
      public static const SOUND_ID_BUBBLE_CLICKED_HQ_MMO:int = SOUND_ID_QUEST_WINDOW_OPEN_SOUND;
      
      public static const SOUND_ID_BUBBLE_CLICKED_HQ_EIC:int = SOUND_ID_QUEST_WINDOW_OPEN_SOUND;
      
      public static const SOUND_ID_BUBBLE_CLICKED_HQ_VRU:int = SOUND_ID_QUEST_WINDOW_OPEN_SOUND;
      
      public static const SOUND_ID_BUBBLE_CLICKED_HANGAR:int = 129;
      
      public static const SOUND_ID_BUBBLE_CLICKED_REFINERY:int = 130;
      
      public static const SOUND_ID_BUBBLE_CLICKED_INSTANT_REP:int = 131;
      
      public static const SOUND_ID_SHOW_HINT:int = 132;
      
      public static const SOUND_ID_LEVEL_UP:int = 134;
      
      public static const NPC_SLENDER_ATTACK:int = 140;
      
      public static const NPC_SLENDER_MENACE:int = 141;
      
      public static const NPC_SLENDER_REVEAL:int = 142;
      
      public static const NPC_SLENDER_VANISH:int = 143;
      
      public static const MUSIC_ID_COMBAT:int = 1000001;
      
      public static const abilityIDs:Array = [SHIP_ABILITY_SOLACE_INSTANT_HEAL,SHIP_ABILITY_DIMINISHER_WEAKEN_SHIELDS,SHIP_ABILITY_SPECTRUM_PRISMATIC_SHIELDING,SHIP_ABILITY_SENTINEL_FORTRESS,SHIP_ABILITY_VENOM_SINGULARITY,SHIP_ABILITY_LIGHTNING_AFTERBURNER,SHIP_ABILITY_SPEED_DEBUFF,SHIP_ABILITY_AEGIS_HEALING_BEAM,SHIP_ABILITY_AEGIS_SHIELD_RECHARGE,SHIP_ABILITY_AEGIS_HEALING_POD,SHIP_ABILITY_CITADEL_DRAW_FIRE,SHIP_ABILITY_CITADEL_FORTIFY,SHIP_ABILITY_CITADEL_PROTECTION,SHIP_ABILITY_CITADEL_TRAVEL_MODE,SHIP_ABILITY_SPEARHEAD_ULTIMATE_CLOAKING,SHIP_ABILITY_SPEARHEAD_MARK_TARGET,SHIP_ABILITY_SPEARHEAD_JAMX,SHIP_ABILITY_SPEARHEAD_DOUBLE_MINIMAP_REVEAL];
      
      public static const ggSingleplayerMapIDs:Vector.<int> = new <int>[51,52,53,54,55,56,57,58,70,71,72,73,74,75,76,77,78,223];
      
      private static var _factionIds:Array = new Array();
      
      private static const PORTRAITS_DEFINITION:Class = InGameCatalog_PORTRAITS_DEFINITION;
      
      private static const _questgiverPortraitsSets:Object = initQuestgiverPortraitsSets();
      
      public const questgiverPortraitsChanged:ISignal = new Signal();
      
      public var rocketNames:Array;
      
      public var batteryNames:Array;
      
      public var dronerepair_cpu_names:Array;
      
      public var cloak_cpu_names:Array;
      
      public var boosterTypeToBarId:Array;
      
      public var ship_groupsystem_icon_ids:Array;
      
      public var rocketLauncherNames:Array = [];
      
      public var advancedJumpCPUNames:Array = [];
      
      public var sysItems:Dictionary;
      
      public var epicMessages:Dictionary = new Dictionary();
      
      public var epicNumberedMessages:Dictionary = new Dictionary();
      
      public var trainingGroundDisabledReasons:Dictionary = new Dictionary();
      
      private var _questgiver_names:Array;
      
      private var _title_colours:Array;
      
      private var _npc_names:Array;
      
      private var _ore_names:Array;
      
      private var _factions_names:Array;
      
      private var _factions_colours:Array;
      
      private var _damage_types:Array;
      
      private var _explosive_names:Array;
      
      private var _robot_names:Array;
      
      private var _jump_cpu_names:Array;
      
      private var _trade_cpu_names:Array;
      
      private var _aim_cpu_names:Array;
      
      private var _arol_cpu_names:Array;
      
      private var _asset_names:Array;
      
      private var _asset_icons:Array;
      
      private var _poizonePOITypeToZoneType:Dictionary;
      
      private var _poizoneShapeTypeIdToShapeString:Dictionary;
      
      private var _poizoneDesingSimple:Object = {};
      
      private var _rllbCpuNames:Array;
      
      private var _npc_icons:Array;
      
      private var _ship_icons:Array;
      
      private var _drone_formations_icons:Array;
      
      private var _rankedHunt_categories:Array;
      
      private var _ore_icons:Array;
      
      private var _ore_oldIDtoNewID:Array;
      
      private var _titleKeyToTitleIdKey:Dictionary;
      
      private var _factions_resKeys:Array;
      
      private var _nettyShipIcons:Array;
      
      private var _factions_names_by_FactionModule:Array;
      
      private var _raidgateIconColors:Array;
      
      private var _videoTypeMapping:Array;
      
      private var _invitationErrorHashmap:Dictionary;
      
      private var _raidgateTooltipKeys:Array;
      
      private var _collectable_icons:Array = new Array();
      
      private var _mapAssetLocakeys:Array = new Array();
      
      private var _bootyBoxNames:Dictionary;
      
      private var _portraitSetId:String = "default";
      
      public function InGameCatalog(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("IngameCatalog is a Singleton and can only be accessed through ingameCatalog.getInstance()");
         }
         this._damage_types = [];
         this._damage_types[0] = "any";
         this._damage_types[1] = "laser";
         this._damage_types[2] = "rocket";
         this._damage_types[3] = "mine";
         this._damage_types[4] = "radiation";
         this._damage_types[5] = "direct";
         this.rocketLauncherNames[1] = "HST-1";
         this.rocketLauncherNames[2] = "HST-2";
         this.advancedJumpCPUNames[1] = "AJP-01";
         this._ore_oldIDtoNewID = [];
         this._ore_oldIDtoNewID[1] = OreTypeModule.ORETYPE_PROMETIUM;
         this._ore_oldIDtoNewID[2] = OreTypeModule.ORETYPE_ENDURIUM;
         this._ore_oldIDtoNewID[3] = OreTypeModule.ORETYPE_TERBIUM;
         this._ore_oldIDtoNewID[4] = OreTypeModule.ORETYPE_XENOMIT;
         this._ore_oldIDtoNewID[11] = OreTypeModule.ORETYPE_PROMETID;
         this._ore_oldIDtoNewID[12] = OreTypeModule.ORETYPE_DURANIUM;
         this._ore_oldIDtoNewID[13] = OreTypeModule.ORETYPE_PROMERIUM;
         this._ore_oldIDtoNewID[14] = OreTypeModule.ORETYPE_SEPROM;
         this._ore_oldIDtoNewID[15] = OreTypeModule.ORETYPE_PALLADIUM;
         this._ore_oldIDtoNewID[42] = OreTypeModule.ORETYPE_OSMIUM;
         this._ore_names = [];
         this._ore_names[OreTypeModule.ORETYPE_PROMETIUM] = BPLocale.getItem("ore_prometium");
         this._ore_names[OreTypeModule.ORETYPE_ENDURIUM] = BPLocale.getItem("ore_endurium");
         this._ore_names[OreTypeModule.ORETYPE_TERBIUM] = BPLocale.getItem("ore_terbium");
         this._ore_names[OreTypeModule.ORETYPE_XENOMIT] = BPLocale.getItem("ore_xenomit");
         this._ore_names[OreTypeModule.ORETYPE_PROMETID] = BPLocale.getItem("ore_prometid");
         this._ore_names[OreTypeModule.ORETYPE_DURANIUM] = BPLocale.getItem("ore_duranium");
         this._ore_names[OreTypeModule.ORETYPE_PROMERIUM] = BPLocale.getItem("ore_promerium");
         this._ore_names[OreTypeModule.ORETYPE_SEPROM] = BPLocale.getItem("ore_seprom");
         this._ore_names[OreTypeModule.ORETYPE_PALLADIUM] = BPLocale.getItem("ore_palladium");
         this._ore_names[OreTypeModule.ORETYPE_MUCOSUM] = BPLocale.getItem("ore_mucosum");
         this._ore_names[OreTypeModule.ORETYPE_BOLTRUM] = BPLocale.getItem("ore_boltrum");
         this._ore_names[OreTypeModule.ORETYPE_SCRAPIUM] = BPLocale.getItem("ore_scrapium");
         this._ore_names[OreTypeModule.ORETYPE_PRISMATIUM] = BPLocale.getItem("ore_prismatium");
         this._ore_names[OreTypeModule.ORETYPE_OSMIUM] = BPLocale.getItem("ore_osmium");
         this._ore_icons = [];
         this._ore_icons[OreTypeModule.ORETYPE_PROMETIUM] = "ore_1.png";
         this._ore_icons[OreTypeModule.ORETYPE_ENDURIUM] = "ore_2.png";
         this._ore_icons[OreTypeModule.ORETYPE_TERBIUM] = "ore_3.png";
         this._ore_icons[OreTypeModule.ORETYPE_PALLADIUM] = "ore_15.png";
         this._ore_icons[OreTypeModule.ORETYPE_MUCOSUM] = "mucosum";
         this._ore_icons[OreTypeModule.ORETYPE_BOLTRUM] = "boltrum";
         this._ore_icons[OreTypeModule.ORETYPE_SCRAPIUM] = "scrap";
         this._ore_icons[OreTypeModule.ORETYPE_PRISMATIUM] = "prismalter";
         this._ore_icons[OreTypeModule.ORETYPE_DURANIUM] = "ore_12.png";
         this._factions_names = [];
         this._factions_names[0] = "ALL";
         this._factions_names[1] = "MMO";
         this._factions_names[2] = "EIC";
         this._factions_names[3] = "VRU";
         this._factions_names[4] = "SAT";
         this._factions_names_by_FactionModule = [];
         this._factions_names_by_FactionModule[FactionModule.FACTION_NONE] = "NONE";
         this._factions_names_by_FactionModule[FactionModule.FACTION_MMO] = "MMO";
         this._factions_names_by_FactionModule[FactionModule.FACTION_EIC] = "EIC";
         this._factions_names_by_FactionModule[FactionModule.FACTION_VRU] = "VRU";
         _factionIds["mmo"] = FactionModule.FACTION_MMO;
         _factionIds["eic"] = FactionModule.FACTION_EIC;
         _factionIds["vru"] = FactionModule.FACTION_VRU;
         this._factions_colours = [];
         this._factions_colours[FactionModule.FACTION_NONE] = 4294967295;
         this._factions_colours[FactionModule.FACTION_MMO] = 4294911269;
         this._factions_colours[FactionModule.FACTION_EIC] = 4284994303;
         this._factions_colours[FactionModule.FACTION_VRU] = 4288282402;
         this._factions_colours[4] = 16776960;
         this._factions_resKeys = [];
         this._factions_resKeys[1] = "mmo";
         this._factions_resKeys[2] = "eic";
         this._factions_resKeys[3] = "vru";
         this._factions_resKeys[4] = "sat";
         this._ship_icons = [];
         this._ship_icons[0] = "ship_0";
         this._ship_icons[49] = "ship_49";
         this._ship_icons[50] = "ship_9";
         this._ship_icons[69] = "ship_69";
         this._ship_icons[70] = "ship_70";
         this._npc_names = [];
         this._npc_names[27] = "Aggro-Streuner";
         this._npc_names[52] = "Cubikon";
         this._npc_names[53] = "UberProtegit";
         this._npc_names[64] = "Scorcher";
         this._npc_names[65] = "Melter";
         this._npc_names[66] = "Devourer";
         this._npc_names[67] = "Vagrant";
         this._npc_names[68] = "Marauder";
         this._npc_names[69] = "Outcast";
         this._npc_names[70] = "Corsair";
         this._npc_names[71] = "Hooligan";
         this._npc_names[72] = "Ravager";
         this._npc_names[73] = "Convict";
         this._npc_names[75] = "Referee-Bot";
         this._npc_names[77] = "Saturn Phoenix";
         this._npc_names[78] = "Saturn Yamato";
         this._npc_names[79] = "Saturn Defcom";
         this._npc_names[80] = "Saturn Liberator";
         this._npc_names[81] = "Saturn Nostromo";
         this._npc_names[82] = "Saturn Piranha";
         this._npc_names[83] = "Saturn Bigboy";
         this._npc_names[84] = "Saturn Vengeance";
         this._npc_names[85] = "Saturn Goliath";
         this._npc_names[86] = "Saturn Leonov";
         this._npc_names[87] = "Saturn Venom";
         this._npc_names[88] = "Saturn Sentinel";
         this._npc_names[89] = "Saturn Spectrum";
         this._npc_names[90] = "Saturn Diminisher";
         this._npc_names[91] = "Saturn Solace";
         this._npc_names[92] = "Saturn Revenge";
         this._npc_names[93] = "Saturn Lightning";
         this._npc_names[94] = "Saturn Avenger";
         this._npc_names[95] = "Saturn Bastion";
         this._npc_names[96] = "Saturn Enforcer";
         this._npc_names[97] = "Saturn Spearhead";
         this._npc_names[98] = "Saturn Citadel";
         this._npc_names[99] = "Saturn Aegis";
         this._npc_names[100] = "Saturn Crimson";
         this._npc_names[101] = "Saturn Jade";
         this._npc_names[102] = "Saturn Sapphire";
         this._npc_names[103] = "Evil You";
         this._npc_names[104] = "Evil Iris";
         this._npc_names[107] = "Crazy Ufo";
         this._npc_names[111] = "Protekid";
         this._npc_names[112] = "Cubikid";
         this._npc_names[117] = "Demaner Escort";
         this._npc_names[120] = "Century Falcon";
         this._npc_names[121] = "Deadly Battleray";
         this._npc_names[124] = "Demaner Freighter";
         this._npc_names[271] = "PVP Saturn Spearhead";
         this._npc_names[272] = "PVP Saturn Aegis";
         this._npc_names[273] = "PVP Saturn Citadel";
         this._npc_names[274] = "PVP Saturn Goliath";
         this._npc_names[275] = "PVP Saturn Spectrum";
         this._npc_names[276] = "PVP Saturn Sentinel";
         this._npc_names[277] = "PVP Saturn Solace";
         this._npc_names[278] = "PVP Saturn Venom";
         this._npc_names[279] = "PVP Saturn Diminisher";
         this._npc_names[299] = "Hitac Underling";
         this._npc_names[300] = "Hitac Underboss";
         this._npc_icons = [];
         this._npc_icons[27] = "npc_84";
         this._npc_icons[34] = "";
         this._npc_icons[52] = "npc_80";
         this._npc_icons[53] = "npc_81";
         this._npc_icons[63] = "npc_100";
         this._npc_icons[64] = "npc_99";
         this._npc_icons[65] = "npc_102";
         this._npc_icons[66] = "npc_105";
         this._npc_icons[67] = "npc_94";
         this._npc_icons[68] = "npc_93";
         this._npc_icons[69] = "npc_92";
         this._npc_icons[70] = "npc_91";
         this._npc_icons[71] = "npc_96";
         this._npc_icons[72] = "npc_97";
         this._npc_icons[73] = "npc_95";
         this._npc_icons[74] = "npc_32";
         this._npc_icons[75] = "npc_89";
         this._npc_icons[76] = "npc_107";
         this._npc_icons[77] = "ship_1";
         this._npc_icons[78] = "ship_2";
         this._npc_icons[79] = "ship_4";
         this._npc_icons[80] = "ship_5";
         this._npc_icons[81] = "ship_7";
         this._npc_icons[82] = "ship_6";
         this._npc_icons[83] = "ship_9";
         this._npc_icons[84] = "ship_8";
         this._npc_icons[85] = "ship_10";
         this._npc_icons[86] = "ship_3";
         this._npc_icons[87] = "ship_67";
         this._npc_icons[88] = "ship_66";
         this._npc_icons[89] = "ship_65";
         this._npc_icons[90] = "ship_64";
         this._npc_icons[91] = "ship_63";
         this._npc_icons[92] = "ship_58";
         this._npc_icons[93] = "ship_18";
         this._npc_icons[94] = "ship_60";
         this._npc_icons[95] = "ship_59";
         this._npc_icons[96] = "ship_56";
         this._npc_icons[97] = "ship_70";
         this._npc_icons[98] = "ship_69";
         this._npc_icons[99] = "ship_49";
         this._npc_icons[100] = "ship_53";
         this._npc_icons[101] = "ship_19";
         this._npc_icons[102] = "ship_54";
         this._npc_icons[103] = "ship_103";
         this._npc_icons[104] = "npc_108";
         this._npc_icons[107] = "ship_0";
         this._npc_icons[111] = "npc_81";
         this._npc_icons[112] = "npc_80";
         this._npc_icons[117] = "npc_11";
         this._npc_icons[118] = "npc_127";
         this._npc_icons[120] = this._npc_icons[49];
         this._npc_icons[121] = "npc_115";
         this._npc_icons[124] = "npc_116";
         this._npc_icons[271] = "ship_70";
         this._npc_icons[272] = "ship_49";
         this._npc_icons[273] = "ship_69";
         this._npc_icons[274] = "ship_10";
         this._npc_icons[275] = "ship_65";
         this._npc_icons[276] = "ship_66";
         this._npc_icons[277] = "ship_63";
         this._npc_icons[278] = "ship_67";
         this._npc_icons[279] = "ship_64";
         this._npc_icons[299] = "npc_hitac-underling";
         this._npc_icons[300] = "npc_hitac-underboss";
         this._asset_names = [];
         this._asset_names["NPC_BEACON_LOW"] = "Aberration Beacon";
         this._asset_names["NPC_BEACON_MEDIUM"] = "Oddity Beacon";
         this._asset_names["NPC_BEACON_HIGH"] = "Awakened Beacon";
         this._asset_icons = [];
         this._asset_icons["NPC_BEACON_LOW"] = "beacon_low";
         this._asset_icons["NPC_BEACON_MEDIUM"] = "beacon_medium";
         this._asset_icons["NPC_BEACON_HIGH"] = "beacon_high";
         this._titleKeyToTitleIdKey = new Dictionary();
         this._titleKeyToTitleIdKey["master_of_the_orbit"] = "title_1";
         this._titleKeyToTitleIdKey["space_cleaner"] = "title_2";
         this._titleKeyToTitleIdKey["dark_pilot"] = "title_3";
         this._titleKeyToTitleIdKey["imperator"] = "title_4";
         this._titleKeyToTitleIdKey["beginner"] = "title_5";
         this._titleKeyToTitleIdKey["goli_hunter"] = "title_6";
         this._titleKeyToTitleIdKey["boss"] = "title_7";
         this._titleKeyToTitleIdKey["alien_hunter"] = "title_8";
         this._titleKeyToTitleIdKey["champion_rifleman"] = "title_9";
         this._titleKeyToTitleIdKey["ace_of_space"] = "title_10";
         this._titleKeyToTitleIdKey["orbit_king"] = "title_11";
         this._titleKeyToTitleIdKey["phoenix_frightener"] = "title_12";
         this._titleKeyToTitleIdKey["chaos_pilot"] = "title_13";
         this._titleKeyToTitleIdKey["most_wanted"] = "title_14";
         this._titleKeyToTitleIdKey["portal_guard"] = "title_15";
         this._titleKeyToTitleIdKey["battlemaster"] = "title_16";
         this._titleKeyToTitleIdKey["system_lord"] = "title_17";
         this._titleKeyToTitleIdKey["the_legend"] = "title_18";
         this._titleKeyToTitleIdKey["hunter_of_the_day"] = "title_19";
         this._titleKeyToTitleIdKey["bounty_hunter"] = "title_20";
         this._titleKeyToTitleIdKey["spring_mmo_2"] = "title_21";
         this._titleKeyToTitleIdKey["spring_eic_2"] = "title_22";
         this._titleKeyToTitleIdKey["spring_vru_2"] = "title_23";
         this._titleKeyToTitleIdKey["spring_mmo"] = "title_100";
         this._titleKeyToTitleIdKey["spring_vru"] = "title_101";
         this._titleKeyToTitleIdKey["spring_eic"] = "title_102";
         this._titleKeyToTitleIdKey["spring_mmo_2"] = "title_104";
         this._titleKeyToTitleIdKey["spring_vru_2"] = "title_105";
         this._titleKeyToTitleIdKey["spring_eic_2"] = "title_106";
         this._titleKeyToTitleIdKey["spring_mmo_3"] = "title_107";
         this._titleKeyToTitleIdKey["spring_eic_3"] = "title_108";
         this._titleKeyToTitleIdKey["spring_vru_3"] = "title_109";
         this._titleKeyToTitleIdKey["pirate_hunt_champion"] = "title_200";
         this._titleKeyToTitleIdKey["pirate_hunters"] = "title_201";
         this._titleKeyToTitleIdKey["pirate_destroyer"] = "title_202";
         this._titleKeyToTitleIdKey["pirate_slayers"] = "title_203";
         this._titleKeyToTitleIdKey["gg-kappa"] = "title_204";
         this._titleKeyToTitleIdKey["gg-lambda"] = "title_205";
         this._titleKeyToTitleIdKey["lord_of_like"] = "title_222";
         this._titleKeyToTitleIdKey["football_official"] = "title_410";
         this.createCollectableLookup();
         this._title_colours = [];
         this._title_colours["title_222"] = 3889560;
         this._title_colours["title_achievement_event_solarclash-2012-completegold-3"] = 11184640;
         this._title_colours["title_achievement_event_solarclash-2012-completesilver-2"] = 13421772;
         this._title_colours["title_achievement_event_solarclash-2012-completebronze-1"] = 13467442;
         this._title_colours["pirate_hunt_champion"] = 13467442;
         this._title_colours["title_200"] = 13467442;
         this._title_colours["pirate_hunters"] = 13467442;
         this._title_colours["title_201"] = 13467442;
         this._title_colours["title_202"] = 8407295;
         this._title_colours["pirate_destroyer"] = 8407295;
         this._title_colours["pirate_slayers"] = 8407295;
         this._title_colours["title_203"] = 8407295;
         this._title_colours["title_achievement_event_domination_reoccurring-cubikon-gravekeeper"] = 3889560;
         this._title_colours["title_achievement_event_domination_reoccurring-unstoppable-force"] = 3889560;
         this._title_colours["title_achievement_event_domination_reoccurring-immoveable-object"] = 3889560;
         this._title_colours["title_achievement_event_domination_reoccurring-hidden-hunter"] = 13421813;
         this._title_colours["title_achievement_event_domination_reoccurring-lord-of-dead"] = 16711680;
         this._title_colours["title_pirateRaid-raider"] = 5639854;
         this._title_colours["title_pirateRaid-champion"] = 5639854;
         this._title_colours["title_achievement_misc_legacy_galacticfleetadmiral"] = 16719246;
         this._title_colours["title_achievement_misc_legacy_cosmicadmiral"] = 16719246;
         this._title_colours["title_achievement_misc_legacy_stellarcaptain"] = 16719246;
         this._title_colours["title_achievement_misc_legacy_starbornecommander"] = 16719246;
         this._title_colours["title_achievement_event_gauntletofplutus-champion"] = 13869055;
         this._title_colours["title_achievement_event_gauntletofplutus-luck"] = 13869055;
         this._title_colours["title_achievement_event_gauntletofplutus-kill-plutus-30"] = 13869055;
         this._title_colours["title_blacklightSurge-champion"] = 9266175;
         this._title_colours["title_blacklightSurge-defiant"] = 9266175;
         this._title_colours["title_galacticStrife-repPerKill"] = 16724736;
         this._title_colours["title_galacticStrife-reputation"] = 16724736;
         this._title_colours["title_achievement_event_synk-kill"] = 11400703;
         this._title_colours["title_frozenLabyrinth-marksman"] = 11400703;
         this._title_colours["title_mimesisMutiny-points-1"] = 14352906;
         this._title_colours["title_mimesisMutiny-points-10"] = 14352906;
         this._title_colours["title_achievement_event_eternalgate-champion"] = 14352906;
         this._title_colours["title_eternalGate-waves-10"] = 14352906;
         this._title_colours["title_achievement_event_eternalblacklight-champion"] = 14352906;
         this._title_colours["title_eternalBlacklight-waves-10"] = 14352906;
         this._title_colours["title_monthlyranking-general"] = 4653279;
         this._title_colours["title_monthlyranking-pilot"] = 4653279;
         this._title_colours["title_5000days"] = 1356203;
         this._title_colours["title_mimesisMutiny2023-points-1"] = 14352906;
         this._title_colours["title_mimesisMutiny2023-points-2"] = 14352906;
         this._title_colours["title_mimesisMutiny2024-points-1"] = 14352906;
         this._title_colours["title_mimesisMutiny2024-points-2"] = 14352906;
         this._title_colours["title_blacklightRankings-defensiveShip"] = 706807;
         this._title_colours["title_blacklightRankings-aggressiveShip"] = 14033429;
         this._title_colours["title_blacklightRankings-abilityShip"] = 14722317;
         this._title_colours["title_achievement_event_prosperous-gg_1"] = 16737588;
         this._title_colours["title_seasonpass_q1_1"] = 16308540;
         this._title_colours["title_seasonpass_202307_1"] = 16308540;
         this._title_colours["title_seasonpass_202311_1"] = 16308540;
         this._title_colours["title_seasonpass_202402_1"] = 16308540;
         this._title_colours["title_seasonpass_202405_1"] = 16308540;
         this._title_colours["title_seasonpass_202405_2"] = 5639854;
         this._title_colours["title_seasonpass_202408_1"] = 16308540;
         this._title_colours["title_seasonpass_202408_2"] = 5639854;
         this._title_colours["title_seasonpass_202411_1"] = 16308540;
         this._title_colours["title_seasonpass_202411_2"] = 5639854;
         this._title_colours["title_seasonpass_202502_1"] = 16308540;
         this._title_colours["title_seasonpass_202502_2"] = 5639854;
         this._title_colours["title_empyrianMarch-craft-fwx-com"] = 16174332;
         this._title_colours["title_mimesisMutiny2025-points-1"] = 14352906;
         this._title_colours["title_mimesisMutiny2025-points-2"] = 14352906;
         this._title_colours["title_mimesisMutiny202603-points-1"] = 14352906;
         this._title_colours["title_mimesisMutiny202603-points-2"] = 14352906;
         this._title_colours["title_titan-202504-1"] = 16719246;
         this._title_colours["title_titan-202504-2"] = 16308540;
         this._title_colours["title_astralRankings-apr2025set1"] = 16308540;
         this._title_colours["title_astralRankings-apr2025set2"] = 16308540;
         this._title_colours["title_expedition_202505_01"] = 14352906;
         this._title_colours["title_expedition_202505_02"] = 4653279;
         this._title_colours["title_expedition_202505_03"] = 16308540;
         this._title_colours["title_goalrush-2025"] = 13467442;
         this._title_colours["title_spanishchampion-202506"] = 16719246;
         this._title_colours["title_seasonpass_202508_1"] = 16308540;
         this._title_colours["title_seasonpass_202508_2"] = 5639854;
         this._title_colours["title_SpaceSearch-2025set1"] = 13421772;
         this._title_colours["title_SpaceSearch-2025set2"] = 11184640;
         this._title_colours["title_seasonpass_202602_1"] = 16308540;
         this._title_colours["title_seasonpass_202602_2"] = 7076863;
         this._title_colours["title_seasonpass_202605_1"] = 16308540;
         this._title_colours["title_seasonpass_202605_2"] = 13869055;
         this._title_colours["title_seasonpass_202608_1"] = 16308540;
         this._title_colours["title_seasonpass_202608_2"] = 13869055;
         this.ship_groupsystem_icon_ids = [];
         this.ship_groupsystem_icon_ids[11] = 69;
         this.ship_groupsystem_icon_ids[12] = 49;
         this.ship_groupsystem_icon_ids[13] = 70;
         this._drone_formations_icons = [];
         this._drone_formations_icons[0] = "drone_formation0_simple.png";
         this._drone_formations_icons[1] = "drone_formation1_simple.png";
         this._drone_formations_icons[2] = "drone_formation2_simple.png";
         this._drone_formations_icons[3] = "drone_formation3_simple.png";
         this._drone_formations_icons[4] = "drone_formation4_simple.png";
         this._drone_formations_icons[5] = "drone_formation5_simple.png";
         this._drone_formations_icons[6] = "drone_formation6_simple.png";
         this._drone_formations_icons[7] = "drone_formation7_simple.png";
         this._drone_formations_icons[8] = "drone_formation8_simple.png";
         this._drone_formations_icons[9] = "drone_formation9_simple.png";
         this._drone_formations_icons[10] = "drone_formation10_simple.png";
         this._drone_formations_icons[11] = "drone_formation11_simple.png";
         this._drone_formations_icons[12] = "drone_formation12_simple.png";
         this._drone_formations_icons[13] = "drone_formation13_simple.png";
         this._drone_formations_icons[14] = "drone_formation14_simple.png";
         this._drone_formations_icons[15] = "drone_formation15_simple.png";
         this._drone_formations_icons[16] = "drone_formation16_simple.png";
         this._drone_formations_icons[17] = "drone_formation17_simple.png";
         this._drone_formations_icons[18] = "drone_formation18_simple.png";
         this._drone_formations_icons[19] = "drone_formation19_simple.png";
         this._drone_formations_icons[20] = "drone_formation20_simple.png";
         this._drone_formations_icons[21] = "drone_formation21_simple.png";
         this._drone_formations_icons[42] = "drone_formation42_simple.png";
         this.batteryNames = [];
         this.batteryNames[1] = "LCB-10";
         this.batteryNames[2] = "MCB-25";
         this.batteryNames[3] = "MCB-50";
         this.batteryNames[4] = "UCB-100";
         this.batteryNames[5] = "SAB-50";
         this.batteryNames[6] = "RSB-75";
         this.batteryNames[7] = "CBO-100";
         this.batteryNames[8] = "JOB-100";
         this.batteryNames[9] = "JOB-100";
         this.batteryNames[10] = "RB-214";
         this.batteryNames[109] = "PIB-100";
         this.batteryNames[114] = "EMAA-20";
         this.rocketNames = [];
         this.rocketNames[RocketPattern.R310] = "R-310";
         this.rocketNames[RocketPattern.PLT_2026] = "PLT-2026";
         this.rocketNames[RocketPattern.PLT_2021] = "PLT-2021";
         this.rocketNames[RocketPattern.PLT_3030] = "PLT-3030";
         this.rocketNames[RocketPattern.PLD_8] = "PLD-8";
         this.rocketNames[RocketPattern.DCR_250] = "DCR-250";
         this.rocketNames[RocketPattern.WIZ] = "WIZ-X";
         this.rocketNames[RocketPattern.R_IC3] = "R-IC3";
         this.rocketNames[RocketPattern.HSTRM01] = "HSTRM-01";
         this.rocketNames[RocketPattern.UBR100] = "UBR-100";
         this.rocketNames[RocketPattern.ECO10] = "ECO-10";
         this.rocketNames[RocketPattern.ECO10_CPU] = "ECO-10";
         this.rocketNames[RocketPattern.BDR_1211] = "BDR-1211";
         this.rocketNames[RocketPattern.SAR_01] = "SAR-01";
         this.rocketNames[RocketPattern.SAR_02] = "SAR-02";
         this.rocketNames[RocketPattern.CBR] = "CBR";
         this.rocketNames[RocketPattern.BDR_1212] = "BDR-1212";
         this.rocketNames[RocketPattern.EMP_01] = "EMP-01";
         this.rocketNames[RocketPattern.PIR_100] = "PIR-100";
         this._explosive_names = [];
         this._explosive_names[1] = "ACM-01";
         this._explosive_names[2] = "SMB-01";
         this._explosive_names[3] = "ISH-01";
         this._explosive_names[4] = "EMP-01";
         this._explosive_names[5] = "FWX-S";
         this._explosive_names[6] = "FWX-M";
         this._explosive_names[7] = "FWX-L";
         this._explosive_names[8] = "FWX-COM";
         this._explosive_names[9] = "FWX-RZ";
         this._explosive_names[10] = "EMPM-01";
         this._explosive_names[11] = "SABM-01";
         this._explosive_names[12] = "DDM-01";
         this._explosive_names[13] = "SL-M01";
         this._robot_names = [];
         this._robot_names[1] = "REP-1";
         this._robot_names[2] = "REP-2";
         this._robot_names[3] = "REP-3";
         this._robot_names[4] = "REP-4";
         this._robot_names[9] = "REP-S";
         this._jump_cpu_names = [];
         this._jump_cpu_names[1] = "JP-01";
         this._jump_cpu_names[2] = "JP-02";
         this._arol_cpu_names = [];
         this._arol_cpu_names[1] = "AROL-X";
         this._rllbCpuNames = [];
         this._rllbCpuNames[1] = "RL-LB1";
         this.cloak_cpu_names = [];
         this.cloak_cpu_names[1] = "CL04K";
         this.cloak_cpu_names[2] = "CL04K XL";
         this._aim_cpu_names = [];
         this._aim_cpu_names[1] = "AIM-01";
         this._aim_cpu_names[2] = "AIM-02";
         this._trade_cpu_names = [];
         this._trade_cpu_names[1] = "HM7";
         this.dronerepair_cpu_names = [];
         this.dronerepair_cpu_names[1] = "DR001";
         this.dronerepair_cpu_names[2] = "DR002";
         this.boosterTypeToBarId = [];
         this.boosterTypeToBarId[BoostedAttributeTypeModule.ATTRIBUTETYPE_EP] = 1;
         this.boosterTypeToBarId[BoostedAttributeTypeModule.ATTRIBUTETYPE_HONOUR] = 2;
         this.boosterTypeToBarId[BoostedAttributeTypeModule.ATTRIBUTETYPE_DAMAGE] = 3;
         this.boosterTypeToBarId[BoostedAttributeTypeModule.ATTRIBUTETYPE_SHIELD] = 4;
         this.boosterTypeToBarId[BoostedAttributeTypeModule.ATTRIBUTETYPE_REPAIR] = 5;
         this.boosterTypeToBarId[BoostedAttributeTypeModule.ATTRIBUTETYPE_SHIELDRECHARGE] = 6;
         this.boosterTypeToBarId[BoostedAttributeTypeModule.ATTRIBUTETYPE_RESOURCE] = 7;
         this.boosterTypeToBarId[BoostedAttributeTypeModule.ATTRIBUTETYPE_MAXHP] = 8;
         this.boosterTypeToBarId[BoostedAttributeTypeModule.ATTRIBUTETYPE_QUESTREWARD] = 9;
         this.boosterTypeToBarId[BoostedAttributeTypeModule.ATTRIBUTETYPE_BONUSBOXES] = 10;
         this.boosterTypeToBarId[BoostedAttributeTypeModule.ATTRIBUTETYPE_ABILITY_COOLDOWN] = 21;
         this.boosterTypeToBarId[BoostedAttributeTypeModule.ATTRIBUTETYPE_CHANCE] = 26;
         this.boosterTypeToBarId[BoostedAttributeTypeModule.ATTRIBUTETYPE_NEWRESOURCE] = 27;
         this._rankedHunt_categories = [];
         this._rankedHunt_categories[0] = "npc";
         this._rankedHunt_categories[1] = "pirate";
         this._questgiver_names = [];
         this._questgiver_names[0] = "Nyx";
         this._questgiver_names[1] = "Morgus Petterson";
         this._questgiver_names[2] = "Reginald Crowley";
         this._questgiver_names[3] = "Vanessa Arkadium";
         this.sysItems = new Dictionary();
         this.sysItems["ammunition_rocketlauncher_sar-01"] = new SysItem("sar-01","SAR-01","ammunition.rocketlauncher","rocketlauncher");
         this.sysItems["ammunition_rocketlauncher_sar-02"] = new SysItem("sar-02","SAR-02","ammunition.rocketlauncher","rocketlauncher");
         this.sysItems["ammunition_mine_acm-01"] = new SysItem("acm-01","ACM-01","ammunition.mine","acm");
         this.sysItems["ammunition_mine_empm-01"] = new SysItem("empm-01","EMP-M01","ammunition.mine","empm");
         this.sysItems["ammunition_specialammo_emp-01"] = new SysItem("emp-01","EMP-01","ammunition.specialammo","emp");
         this.sysItems["ammunition_laser_cbo-100"] = new SysItem("cbo-100","CBO-100","ammunition.laser","laserammo");
         this.sysItems["ammunition_laser_lcb-10"] = new SysItem("lcb-10","LCB-10","ammunition.laser","laserammo");
         this.sysItems["ammunition_laser_mcb-25"] = new SysItem("mcb-25","MCB-25","ammunition.laser","laserammo");
         this.sysItems["ammunition_laser_mcb-50"] = new SysItem("mcb-50","MCB-50","ammunition.laser","laserammo");
         this.sysItems["ammunition_laser_sab-50"] = new SysItem("sab-50","SAB-50","ammunition.laser","laserammo");
         this.sysItems["ammunition_rocket_plt-2021"] = new SysItem("plt-2021","PLT-2021","ammunition.rocket","rocket");
         this.sysItems["ammunition_rocket_plt-2026"] = new SysItem("plt-2026","PLT-2026","ammunition.rocket","rocket");
         this.sysItems["ammunition_rocket_plt-2030"] = new SysItem("plt-3030","PLT-3030","ammunition.rocket","rocket");
         this.sysItems["ammunition_specialammo_dcr-250"] = new SysItem("dcr-250","DCR-250","ammunition.specialammo","rocket");
         this.sysItems["ammunition_specialammo_wiz-x"] = new SysItem("wiz-x","WIZ-X","ammunition.specialammo","rocket");
         this.sysItems["ammunition_laser_ucb-100"] = new SysItem("ucb-100","UCB-100","ammunition.laser","laserammo");
         this.sysItems["ammunition_laser_rb-214"] = new SysItem("rb-214","RB-214","ammunition.laser","laserammo");
         this.sysItems["ammunition_laser_pib-100"] = new SysItem("pib-100","PIB-100","ammunition.laser","laserammo");
         this.sysItems["ammunition_specialammo_frozen-portal"] = new SysItem("","FROZEN-PORTAL","","laserammo");
         this.sysItems["equipment_extra_cpu_ajp-01"] = new SysItem("ajp-01","AJP-01","equipment.extra.cpu","jump-cpu");
         this.sysItems["equipment_extra_cpu_dr-01"] = new SysItem("dr-01","DR-01","equipment.extra.cpu","drone-repair-cpu");
         this.sysItems["equipment_extra_cpu_cl04k-m"] = new SysItem("cl04k-m","CL04K-M","equipment.extra.cpu","cloak-cpu");
         this.sysItems["equipment_extra_cpu_cl04k-xl"] = new SysItem("cl04k-xl","CL04K-XL","equipment.extra.cpu","cloak-cpu");
         this.sysItems["equipment_extra_cpu_fb-x"] = new SysItem("fb-x","FB-X","equipment.extra.cpu","cpu");
         this.sysItems["equipment_extra_cpu_nc-rrb-x"] = new SysItem("nc-rrb-x","NC-RRB","equipment.extra.cpu","auto-cpu");
         this.sysItems["equipment_extra_cpu_nc-awr-x"] = new SysItem("nc-awr-x","NC-AWR","equipment.extra.cpu","auto-cpu");
         this.sysItems["equipment_extra_cpu_jp-01"] = new SysItem("jp-01","JP-01","equipment.extra.cpu","jump-cpu");
         this.sysItems["equipment_extra_cpu_sle-01"] = new SysItem("sle-01","SLE-01","equipment.extra.cpu","cpu");
         this.sysItems["equipment_extra_cpu_min-t01"] = new SysItem("min-t01","MIN-T01","equipment.extra.cpu","cpu");
         this.sysItems["equipment_generator_shield_sg3n-a02"] = new SysItem("sg3n-a02","SG3N-A02","equipment.generator.shield","shield-generator");
         this.sysItems["equipment_generator_speed_g3n-3310"] = new SysItem("g3n-3310","G3N-3310","equipment.generator.speed","speed-generator");
         this.sysItems["equipment_generator_speed_g3n-6900"] = new SysItem("g3n-6900","G3N-6900","equipment.generator.speed","speed-generator");
         this.sysItems["equipment_generator_speed_g3n-7900"] = new SysItem("g3n-7900","G3N-7900","equipment.generator.speed","speed-generator");
         this.sysItems["equipment_generator_shield_sg3n-b01"] = new SysItem("sg3n-b01","SG3N-B01","equipment.generator.shield","shield-generator");
         this.sysItems["equipment_generator_shield_sg3n-b02"] = new SysItem("sg3n-b02","SG3N-B02","equipment.generator.shield","shield-generator");
         this.sysItems["equipment_weapon_laser_lf-2"] = new SysItem("lf-2","LF-2","equipment.weapons.laser","laser");
         this.sysItems["equipment_weapon_laser_lf-3"] = new SysItem("lf-3","LF-3","equipment.weapons.laser","laser");
         this.sysItems["equipment_weapon_laser_lf-4"] = new SysItem("lf-4","LF-4","equipment.weapons.laser","laser");
         this.sysItems["ship_goliath_design_venom"] = new SysItem("venom","VENOM","ship.goliath.design","skill-design");
         this.sysItems["ship_goliath_design_solace"] = new SysItem("solace","SOLACE","ship.goliath.design","skill-design");
         this.sysItems["ship_goliath_design_spectrum"] = new SysItem("spectrum","SPECTRUM","ship.goliath.design","skill-design");
         this.sysItems["ship_goliath_design_diminisher"] = new SysItem("diminsher","DIMINISHER","ship.goliath.design","skill-design");
         this.sysItems["ship_goliath_design_sentinel"] = new SysItem("sentinel","SENTINEL","ship.goliath.design","skill-design");
         this.sysItems["ship_vengeance_design_adept"] = new SysItem("adept","ADEPT","ship.vengeance.design","vengeance-design");
         this.sysItems["ship_vengeance_design_avenger"] = new SysItem("avenger","AVENGER","ship.vengeance.design","vengeance-design");
         this.sysItems["ship_vengeance_design_corsair"] = new SysItem("corsair","CORSAIR","ship.vengeance.design","vengeance-design");
         this.sysItems["ship_vengeance_design_lightning"] = new SysItem("lightning","LIGHTNING","ship.vengeance.design","vengeance-design");
         this.sysItems["ship_vengeance_design_revenge"] = new SysItem("revenge","REVENGE","ship.vengeance.design","vengeance-design");
         this.sysItems["ship_goliath_design_bastion"] = new SysItem("bastion","BASTION","ship.goliath.design","goliath-design");
         this.sysItems["ship_goliath_design_enforcer"] = new SysItem("enforcer","ENFORCER","ship.goliath.design","goliath-design");
         this.sysItems["ship_goliath_design_exalted"] = new SysItem("exalted","EXALTED","ship.goliath.design","goliath-design");
         this.sysItems["ship_goliath_design_veteran"] = new SysItem("veteran","VETERAN","ship.goliath.design","goliath-design");
         this.sysItems["ship_goliath_design_saturn"] = new SysItem("saturn","SATURN","ship.goliath.design","goliath-design");
         this.sysItems["ship_goliath_design_centaur"] = new SysItem("centaur","CENTAUR","ship.goliath.design","goliath-design");
         this.sysItems["ship_goliath_design_bronze"] = new SysItem("bronze","BRONZE","ship.goliath.design","goliath-design");
         this.sysItems["ship_goliath_design_silver"] = new SysItem("silver","SILVER","ship.goliath.design","goliath-design");
         this.sysItems["ship_goliath_design_gold"] = new SysItem("gold","GOLD","ship.goliath.design","goliath-design");
         this.sysItems["ship_aegis"] = new SysItem("aegis","AEGIS","ship","ship");
         this.sysItems["ship_citadel"] = new SysItem("citadel","CITADEL","ship","ship");
         this.sysItems["ship_spearhead"] = new SysItem("spearhead","SPEARHEAD","ship","ship");
         this.sysItems["ship_liberator"] = new SysItem("liberator","LIBERATOR","ship","ship");
         this.sysItems["ship_spearhead_design_spearhead-elite"] = new SysItem("spearhead-elite","SPEARHEAD-VETERAN","ship.spearhead.design","ship-design");
         this.sysItems["ship_aegis_design_aegis-elite"] = new SysItem("aegis-elite","AEGIS-VETERAN","ship.aegis.design","ship-design");
         this.sysItems["ship_citadel_design_citadel-elite"] = new SysItem("citadel-elite","CITADEL-VETERAN","ship.citadel.design","ship-design");
         this.sysItems["ship_goliath_design_goliath-frost"] = new SysItem("goliath-frost","GOLIATH_FROST","ship.goliath.design","ship-design");
         this.sysItems["ship_aegis_design_aegis-frost"] = new SysItem("aegis-frost","AEGIS_FROST","ship.aegis.design","ship-design");
         this.sysItems["ship_spearhead_design_spearhead-frost"] = new SysItem("spearhead-frost","SPEARHEAD_FROST","ship.spearhead.design","ship-design");
         this.sysItems["ship_citadel_design_citadel-frost"] = new SysItem("citadel-frost","CITADEL_FROST","ship.citadel.design","ship-design");
         this.sysItems["resource_ore_seprom"] = new SysItem("seprom","SEPROM","resource.ore","ore");
         this.sysItems["resource_ore_palladium"] = new SysItem("palladium","PALLADIUM","resource.ore","ore");
         this.sysItems["resource_logfile"] = new SysItem("logfile","LOGFILE","resource.logfile","log-file");
         this.sysItems["ship_spearhead_design_spearhead-superelite"] = new SysItem("spearhead-superelite","SPEARHEAD-ELITE","ship.spearhead.design","ship-design");
         this.sysItems["ship_aegis_design_aegis-superelite"] = new SysItem("aegis-superelite","AEGIS-ELITE","ship.aegis.design","ship-design");
         this.sysItems["ship_citadel_design_citadel-superelite"] = new SysItem("citadel-superelite","CITADEL-ELITE","ship.citadel.design","ship-design");
         this.sysItems["resource_key_access-hsg"] = new SysItem("access-hsg","ACCESS-HSG","resource.key","key-access-hsg");
         this.sysItems["resource_key_access-scg"] = new SysItem("access-hsg","ACCESS-HSG","resource.key","key-access-hsg");
         this.sysItems["resource_blueprint_apis-part"] = new SysItem("apis-part","03A-P01","resource.blueprint","drone-apis-part");
         this.sysItems["resource_blueprint_zeus-part"] = new SysItem("zeus-part","04Z-P02","resource.blueprint","drone-zeus-part");
         this.sysItems["resource_ore_promerium"] = new SysItem("promerium","PROMERIUM","resource.ore","ore");
         this.sysItems["resource_lottery-capsule"] = new SysItem("lottery-capsule","LOTTERY-CAPSULE","resource.lottery-capsule","capsule");
         this.sysItems["resource_repairvoucher"] = new SysItem("repair-voucher","REPAIR-VOUCHER","resource.voucher","repairvoucher");
         this.sysItems["resource_extra-energy"] = new SysItem("extra-energy","EXTRA-ENERGY","resource.extra-energy","extra energy");
         this.sysItems["drone_apis"] = new SysItem("apis","ED-03A","drone","drone-apis");
         this.sysItems["drone_flax"] = new SysItem("flax","FLAX","drone","drone");
         this.sysItems["drone_zeus"] = new SysItem("zeus","ED-04Z","drone","drone-zeus");
         this.sysItems["drone_designs_havoc"] = new SysItem("havoc","HAVOC","drone_designs","drone-design");
         this.sysItems["drone_designs_hercules"] = new SysItem("hercules","HERCULES","drone_designs","drone-design");
         this.sysItems["drone_designs_spartan"] = new SysItem("spartan","SPARTAN","drone_designs","drone-design");
         this.sysItems["drone_designs_hermes"] = new SysItem("hermes","HERMES","drone_designs","drone-design");
         this.sysItems["drone_designs_cerberus"] = new SysItem("cerberus","CERBERUS","drone_designs","drone-design");
         this.sysItems["drone_designs_reaper-silver"] = new SysItem("","REAPER","drone_designs","drone-design");
         this.sysItems["drone_designs_reaper-blue"] = new SysItem("","REAPER","drone_designs","drone-design");
         this.sysItems["drone_designs_reaper-green"] = new SysItem("","REAPER","drone_designs","drone-design");
         this.sysItems["drone_designs_reaper-red"] = new SysItem("","REAPER","drone_designs","drone-design");
         this.sysItems["drone_designs_skull-silver"] = new SysItem("","SKULL","drone_designs","drone-design");
         this.sysItems["drone_designs_skull-blue"] = new SysItem("","SKULL","drone_designs","drone-design");
         this.sysItems["drone_designs_skull-green"] = new SysItem("","SKULL","drone_designs","drone-design");
         this.sysItems["drone_designs_skull-red"] = new SysItem("","SKULL","drone_designs","drone-design");
         this.sysItems["drone_designs_bat-silver"] = new SysItem("","BAT","drone_designs","drone-design");
         this.sysItems["drone_designs_bat-blue"] = new SysItem("","BAT","drone_designs","drone-design");
         this.sysItems["drone_designs_bat-green"] = new SysItem("","BAT","drone_designs","drone-design");
         this.sysItems["drone_designs_bat-red"] = new SysItem("","BAT","drone_designs","drone-design");
         this.sysItems["drone_designs_demon-epic"] = new SysItem("","EPIC DEMON","drone_designs","drone-design");
         this.sysItems["drone_designs_demon-silver"] = new SysItem("","SILVER DEMON","drone_designs","drone-design");
         this.sysItems["drone_designs_beacon"] = new SysItem("","BEACON","drone_designs","drone-design");
         this.sysItems["drone_designs_frost"] = new SysItem("","FROST","drone_designs","drone-design");
         this.sysItems["drone_designs_enigma-green"] = new SysItem("","ENIGMA GREEN","drone_designs","drone-design");
         this.sysItems["drone_designs_enigma-red"] = new SysItem("","ENIGMA RED","drone_designs","drone-design");
         this.sysItems["drone_designs_enigma-orange"] = new SysItem("","ENIGMA ORANGE","drone_designs","drone-design");
         this.sysItems["drone_designs_phantom-green"] = new SysItem("","PHANTOM GREEN","drone_designs","drone-design");
         this.sysItems["drone_designs_phantom-red"] = new SysItem("","PHANTOM RED","drone_designs","drone-design");
         this.sysItems["drone_designs_phantom-orange"] = new SysItem("","PHANTOM ORANGE","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-pusat-lava"] = new SysItem("","PUSAT LAVA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-pusat-poison"] = new SysItem("","PUSAT POISON","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-pusat-sandstorm"] = new SysItem("","PUSAT SANDSTORM","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-spectrum-lava"] = new SysItem("","SPECTRUM LAVA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-spectrum-poison"] = new SysItem("","SPECTRUM POISON","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-spectrum-sandstorm"] = new SysItem("","SPECTRUM SANDSTORM","drone_designs","drone-design");
         this.sysItems["drone_designs_champion"] = new SysItem("","CHAMPION","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-a-elite-blaze"] = new SysItem("","BLAZE A ELITE","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-a-elite-lava"] = new SysItem("","LAVA A ELITE","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-a-elite-ocean"] = new SysItem("","OCEAN A ELITE","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-a-elite-poison"] = new SysItem("","POISON A ELITE","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-a-elite-sandstorm"] = new SysItem("","SANDSTORM A ELITE","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-pusat-blaze"] = new SysItem("","PUSAT BLAZE","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-pusat-ocean"] = new SysItem("","PUSAT OCEAN","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-drone-spectrum-blaze"] = new SysItem("","SPECTRUM BLAZE","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-spectrum-ocean"] = new SysItem("","SPECTRUM OCEAN","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-phantom-argon"] = new SysItem("","PHANTOM ARGON","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-phantom-lava"] = new SysItem("","PHANTOM LAVA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-phantom-legend"] = new SysItem("","PHANTOM LEGEND","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-phantom-poison"] = new SysItem("","PHANTOM POISON","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-phantom-ocean"] = new SysItem("","PHANTOM OCEAN","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-goliath-x-regular"] = new SysItem("","GOLIATH X REGULAR","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-goliath-x-sandstorm"] = new SysItem("","GOLIATH X SANDSTORM","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-goliath-x-borealis"] = new SysItem("","GOLIATH X BOREALIS","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-goliath-x-ocean"] = new SysItem("","GOLIATH X OCEAN","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-inferno"] = new SysItem("","INFERNO","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-mimesis"] = new SysItem("","MIMESIS","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-cyborg"] = new SysItem("","CYBORG","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-hammerclaw"] = new SysItem("","HAMMERCLAW","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-enigma-ocean"] = new SysItem("","ENGIMA OCEAN","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-enigma-argon"] = new SysItem("","ENIGMA ARGON","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-hammerclaw-argon"] = new SysItem("","HAMMERCLAW ARGON","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-cyborg-argon"] = new SysItem("","CYBORG ARGON","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-enigma-poison"] = new SysItem("","ENIGMA POISON","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-enigma-legend"] = new SysItem("","ENIGMA LEGEND","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-enigma-lava"] = new SysItem("","ENIGMA LAVA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-hammerclaw-lava"] = new SysItem("","HAMMERCLAW LAVA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-cyborg-lava"] = new SysItem("","CYBORG LAVA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-g-champion-legend"] = new SysItem("","G CHAMPION LEGEND","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-g-champion-argon"] = new SysItem("","G CHAMPION ARGON","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-g-champion-lava"] = new SysItem("","G CHAMPION LAVA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-g-champion-silver"] = new SysItem("","G CHAMPION SILVER","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-sentinel-lava"] = new SysItem("","SENTINEL LAVA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-sentinel-argon"] = new SysItem("","SENTINEL ARGON","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-sentinel-legend"] = new SysItem("","SENTINEL LEGEND","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-diminisher-lava"] = new SysItem("","DIMINISHER LAVA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-diminisher-argon"] = new SysItem("","DIMINISHER ARGON","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-diminisher-legend"] = new SysItem("","DIMINISHER LEGEND","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-goliath-x-lava"] = new SysItem("","GOLIATH X LAVA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-goliath-x-argon"] = new SysItem("","GOLIATH X ARGON","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-goliath-x-legend"] = new SysItem("","GOLIATH X LEGEND","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-cyborg-carbonite"] = new SysItem("","CYBORG CARBONITE","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-hammerclaw-carbonite"] = new SysItem("","HAMMERCLAW CARBONITE","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-enigma-carbonite"] = new SysItem("","ENIGMA CARBONITE","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-g-champion-dusklight"] = new SysItem("","G CHAMPION DUSKLIGHT","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-hammerclaw-legend"] = new SysItem("","HAMMERCLAW LEGEND","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-diminisher-dusklight"] = new SysItem("","DIMINISHER DUSKLIGHT","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-berserker-silver"] = new SysItem("","BERSERKER SILVER","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-eostra"] = new SysItem("","EOSTRA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-sentinel-dusklight"] = new SysItem("","SENTINEL DUSKLIGHT","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-berserker-ace"] = new SysItem("","BERSERKER ACE","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-centurion-dusklight"] = new SysItem("","CENTURION DUSKLIGHT","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-sentinel-harbinger"] = new SysItem("","SENTINEL HARBINGER","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-centurion-seraph"] = new SysItem("","CENTURION SERAPH","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-goliath-x-dusklight"] = new SysItem("","GOLIATH X DUSKLIGHT","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-berserker-blaze"] = new SysItem("","BERSERKER BLAZE","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-sentinel-seraph"] = new SysItem("","SENTINEL SERAPH","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-berserker-legend"] = new SysItem("","BERSERKER LEGEND","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-berserker-lava"] = new SysItem("","BERSERKER LAVA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-berserker-argon"] = new SysItem("","BERSERKER ARGON","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-berserker-dusklight"] = new SysItem("","BERSERKER DUSKLIGHT","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-berserker-borealis"] = new SysItem("","BERSERKER BOREALIS","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-centurion-harbinger"] = new SysItem("","CENTURION HARBINGER","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-berserker-sandstorm"] = new SysItem("","BERSERKER SANDSTORM","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-esostrana"] = new SysItem("","CHAMPION EOSTRANA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-pusat-dusklight"] = new SysItem("","PUSAT DUSKLIGHT","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-cyborg-dusklight"] = new SysItem("","CYBORG DUSKLIGHT","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-hammerclaw-dusklight"] = new SysItem("","HAMMERCLAW DUSKLIGHT","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-diminisher-seraph"] = new SysItem("","DIMINISHER SERAPH","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-pusat-legend"] = new SysItem("","PUSAT LEGEND","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-sentinel-mobius"] = new SysItem("","SENTINEL MOBIUS","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-eostrax"] = new SysItem("","CHAMPION EOSTRAX","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-centurion-carbonite"] = new SysItem("","CENTURION CARBONITE","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-diminisher-inferno"] = new SysItem("","DIMINISHER INFERNO","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-diminisher-elysium"] = new SysItem("","DIMINISHER ELYSIUM","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-infiltrator"] = new SysItem("","INFILTRATOR","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-cyborg-horus"] = new SysItem("","CYBORG HORUS","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-cyborg-sandstorm"] = new SysItem("","CYBORG SANDSTORM","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-cyborg-phantasm"] = new SysItem("","CYBORG PHANTASM","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-pusat-argon"] = new SysItem("","PUSAT ARGON","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-diminisher-eldritch"] = new SysItem("","DIMINISHER ELDRITCH","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-cyborg-legend"] = new SysItem("","CYBORG LEGEND","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-orcus-viking"] = new SysItem("","ORCUS VIKING","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-artemis"] = new SysItem("","ARTEMIS","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-sentinel-carbonite"] = new SysItem("","SENTINEL CARBONITE","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-goliath-dogma"] = new SysItem("","GOLIATH DOGMA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-cyborg-inferno"] = new SysItem("","CYBORG INFERNO","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-citadel-samurai"] = new SysItem("","CITADEL SAMURAI","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-solace-enigma"] = new SysItem("","SOLACE ENIGMA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-albania"] = new SysItem("","CHAMPION ALBANIA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-austria"] = new SysItem("","CHAMPION AUSTRIA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-belgium"] = new SysItem("","CHAMPION BELGIUM","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-croatia"] = new SysItem("","CHAMPION CROATIA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-czechia"] = new SysItem("","CHAMPION CZECHIA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-denmark"] = new SysItem("","CHAMPION DENMARK","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-england"] = new SysItem("","CHAMPION ENGLAND","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-france"] = new SysItem("","CHAMPION FRANCE","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-georgia"] = new SysItem("","CHAMPION GEORGIA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-germany"] = new SysItem("","CHAMPION GERMANY","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-hungary"] = new SysItem("","CHAMPION HUNGARY","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-italy"] = new SysItem("","CHAMPION ITALY","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-netherlands"] = new SysItem("","CHAMPION NETHERLANDS","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-poland"] = new SysItem("","CHAMPION POLAND","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-portugal"] = new SysItem("","CHAMPION PORTUGAL","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-romania"] = new SysItem("","CHAMPION ROMANIA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-scotland"] = new SysItem("","CHAMPION SCOTLAND","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-serbia"] = new SysItem("","CHAMPION SERBIA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-slovakia"] = new SysItem("","CHAMPION SLOVAKIA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-slovenia"] = new SysItem("","CHAMPION SLOVENIA","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-spain"] = new SysItem("","CHAMPION SPAIN","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-switzerland"] = new SysItem("","CHAMPION SWITZERLAND","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-turkey"] = new SysItem("","CHAMPION TURKEY","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-champion-ukraine"] = new SysItem("","CHAMPION UKRAINE","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-intimidator"] = new SysItem("","INTIMIDATOR","drone_designs","drone-design");
         this.sysItems["drone_designs_drone-cyborg-elysium"] = new SysItem("","CYBORG ELYSIUM","drone_designs","drone-design");
         this.sysItems["module_defm-1"] = new SysItem("defm-1","DEFM-1","module","module");
         this.sysItems["module_dmgm-1"] = new SysItem("dmgm-1","DMGM-1","module","module");
         this.sysItems["module_honm-1"] = new SysItem("honm-1","HONM-1","module","module");
         this.sysItems["module_hulm-1"] = new SysItem("hulm-1","HULM-1","module","module");
         this.sysItems["module_ltm-hr"] = new SysItem("ltm-hr","LTM-HR","module","module");
         this.sysItems["module_ltm-lr"] = new SysItem("ltm-lr","LTM-LR","module","module");
         this.sysItems["module_ltm-mr"] = new SysItem("ltm-mr","LTM-MR","module","module");
         this.sysItems["module_ram-la"] = new SysItem("ram-la","RAM-LA","module","module");
         this.sysItems["module_ram-ma"] = new SysItem("ram-ma","RAM-MA","module","module");
         this.sysItems["module_repm-1"] = new SysItem("repm-1","REPM-1","module","module");
         this.sysItems["module_xpm-1"] = new SysItem("xpm-1","XPM-1","module","module");
         this.sysItems["currency_credits"] = new SysItem("credits","CREDITS","currency","credits");
         this.sysItems["currency_uridium"] = new SysItem("uridium","URIDIUM","currency","uridium");
         this.sysItems["currency_experience"] = new SysItem("experience","EXPERIENCE","currency","experience");
         this.sysItems["currency_honour"] = new SysItem("honour","HONOUR","currency","honour");
         this.sysItems["currency_jackpotmoney"] = new SysItem("jackpotmoney","JACKPOT MONEY","jackpotmoney");
         this.sysItems["equipment_petgear_csr-02"] = new SysItem("csr-02","CSR-02","equipment.petgear","pet_gear");
         this.sysItems["equipment_petgear_cgm-02"] = new SysItem("cgm-02","CGM-02","equipment.petgear","pet_gear");
         this.sysItems["equipment_petgear_g-al1"] = new SysItem("g-al1","G-AL1","equipment.petgear","pet_gear");
         this.sysItems["equipment_petgear_g-ar1"] = new SysItem("g-ar1","G-AR1","equipment.petgear","pet_gear");
         this.sysItems["equipment_petgear_g-el1"] = new SysItem("g-el1","G-EL1","equipment.petgear","pet_gear");
         this.sysItems["equipment_petgear_g-kk1"] = new SysItem("g-kk1","G-KK1","equipment.petgear","pet_gear");
         this.sysItems["equipment_petgear_g-rep1"] = new SysItem("g-rep1","G-REP1","equipment.petgear","pet_gear");
         this.sysItems["equipment_petgear_g-rl1"] = new SysItem("g-rl1","G-RL1","equipment.petgear","pet_gear");
         this.sysItems["equipment_petgear_g-tra1"] = new SysItem("g-tra1","G-TRA1","equipment.petgear","pet_gear");
         this.sysItems["drone_formation_f-03-la"] = new SysItem("","f-03-la","","ore");
         this.initNettyShipIcons();
         this.initPoi();
         this.initGroupSystemErrorMapping();
         this.initVideoTypeMapping();
         this.initRaidGateConsts();
         this.initMapAssetReskeys();
         this.initEpicMessages();
         this.initTraininggroundsDisabledReasons();
      }
      
      public static function get instance() : InGameCatalog
      {
         if(_instance == null)
         {
            _instance = new InGameCatalog(hidden);
         }
         return _instance;
      }
      
      public static function getInstance() : InGameCatalog
      {
         if(_instance == null)
         {
            _instance = new InGameCatalog(hidden);
         }
         return _instance;
      }
      
      public static function getFactionIdByName(param1:String) : int
      {
         param1 = param1 ? param1.toLowerCase() : param1;
         return _factionIds[param1] ? int(_factionIds[param1]) : -1;
      }
      
      private static function hidden() : void
      {
      }
      
      private static function initQuestgiverPortraitsSets() : Object
      {
         var _loc4_:XML = null;
         var _loc5_:Object = null;
         var _loc6_:XML = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:XML = null;
         var _loc1_:ByteArray = new PORTRAITS_DEFINITION() as ByteArray;
         var _loc2_:XML = new XML(_loc1_.readUTFBytes(_loc1_.length));
         var _loc3_:Object = {};
         for each(_loc4_ in _loc2_.change_quests_portraits)
         {
            _loc5_ = {};
            for each(_loc6_ in _loc4_.portrait)
            {
               _loc5_[String(_loc6_.@faction)] = String(_loc6_.text());
            }
            _loc7_ = new Vector.<int>();
            for each(_loc8_ in _loc4_.affected_quests.quest)
            {
               _loc7_.push(int(_loc8_.@id));
            }
            _loc3_[String(_loc4_.@id)] = {
               "portraits":_loc5_,
               "affectedQuests":_loc7_
            };
         }
         return _loc3_;
      }
      
      private function initPoi() : void
      {
         this._poizonePOITypeToZoneType = new Dictionary();
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_NO_ACCESS] = POIZone.ZONE_TYPE_NOA;
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_FACTION_NO_ACCESS] = POIZone.ZONE_TYPE_NOA;
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_BUFF_ZONE] = POIZone.ZONE_TYPE_BST;
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_DAMAGE] = POIZone.ZONE_TYPE_DMG;
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_HEALING] = POIZone.ZONE_TYPE_HEA;
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_RADIATION] = POIZone.ZONE_TYPE_RAD;
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_TRIGGER] = POIZone.ZONE_TYPE_TRG;
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_SECTOR_CONTROL_HOME_ZONE] = POIZone.ZONE_TYPE_SECTOR_CONTROL_HOME_ZONE;
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_SECTOR_CONTROL_SECTOR_ZONE] = POIZone.ZONE_TYPE_SECTOR_CONTROL_SECTOR_ZONE;
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_ACTIVATION_ZONE] = POIZone.ZONE_TYPE_ACTIVATION_ZONE;
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_OUTLINE_ZONE] = POIZone.ZONE_TYPE_ACTIVATION_ZONE_OUTLINE;
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_GENERIC] = null;
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_MINE_FIELD] = null;
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_FACTORIZED] = null;
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_ENTER_LEAVE] = null;
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_CAGE] = null;
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_EQUIPPABLE_ZONE] = POIZone.ZONE_TYPE_EQUIPPABLE_ZONE;
         this._poizonePOITypeToZoneType[POITypeModule.POITYPE_PET_DISRUPTION_ZONE] = POIZone.ZONE_TYPE_PET_DISRUPTION;
         this._poizoneShapeTypeIdToShapeString = new Dictionary();
         this._poizoneShapeTypeIdToShapeString[MapAddPOICommand.SHAPETYPE_CIRCLE] = POIZone.SHAPE_CIRCLE;
         this._poizoneShapeTypeIdToShapeString[MapAddPOICommand.SHAPETYPE_RECTANGLE] = POIZone.SHAPE_RECT;
         this._poizoneShapeTypeIdToShapeString[MapAddPOICommand.SHAPETYPE_POLYGON] = POIZone.SHAPE_POLYGON;
         this._poizoneDesingSimple[POIDesignModule.POIDESIGN_SIMPLE_LOW_ONLY] = "SIMPLE_IN_LOW";
      }
      
      public function get questgiver_names() : Array
      {
         return this._questgiver_names;
      }
      
      public function get ore_names() : Array
      {
         return this._ore_names;
      }
      
      public function get ore_oldIDtoNewID() : Array
      {
         return this._ore_oldIDtoNewID;
      }
      
      public function get ore_icons() : Array
      {
         return this._ore_icons;
      }
      
      public function get factions_names() : Array
      {
         return this._factions_names;
      }
      
      public function get factions_colours() : Array
      {
         return this._factions_colours;
      }
      
      public function get damage_types() : Array
      {
         return this._damage_types;
      }
      
      public function get battery_types() : Array
      {
         return this.batteryNames;
      }
      
      public function getShipNameFromLootId(param1:String) : String
      {
         return TextUtils.getTranslationByType(param1,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_CODE);
      }
      
      public function getShipName(param1:int) : String
      {
         var _loc2_:ShipPattern = PatternManager.shipPatternsByShipId[param1] as ShipPattern;
         if(_loc2_)
         {
            return _loc2_.name;
         }
         return null;
      }
      
      public function getShipIcon(param1:int) : String
      {
         var _loc2_:ShipPattern = null;
         if(this._ship_icons[param1])
         {
            return this._ship_icons[param1];
         }
         _loc2_ = PatternManager.shipPatternsByShipId[param1] as ShipPattern;
         if(_loc2_)
         {
            return _loc2_.icon;
         }
         return null;
      }
      
      public function getNpcName(param1:int) : String
      {
         var _loc2_:ShipPattern = null;
         if(this._npc_names[param1])
         {
            return this._npc_names[param1];
         }
         _loc2_ = PatternManager.shipPatternsByNpcId[param1] as ShipPattern;
         if(_loc2_)
         {
            return _loc2_.name;
         }
         return null;
      }
      
      public function getMapAssetName(param1:String) : String
      {
         if(this._asset_names[param1])
         {
            return this._asset_names[param1];
         }
         return null;
      }
      
      public function getBootyBoxName(param1:String) : String
      {
         if(this._bootyBoxNames[param1])
         {
            return this._bootyBoxNames[param1];
         }
         return null;
      }
      
      public function getNpcIcon(param1:int) : String
      {
         var _loc2_:Array = null;
         var _loc3_:ShipPattern = null;
         if(this._npc_icons[param1])
         {
            return this._npc_icons[param1];
         }
         _loc2_ = PatternManager.shipPatternsByNpcId;
         _loc3_ = _loc2_[param1] as ShipPattern;
         if(_loc3_)
         {
            return _loc3_.icon;
         }
         return null;
      }
      
      public function getMapAssetIcon(param1:String) : String
      {
         if(this._asset_icons[param1])
         {
            return this._asset_icons[param1];
         }
         return null;
      }
      
      public function get drone_formations_icons() : Array
      {
         return this._drone_formations_icons;
      }
      
      public function get rankedHunt_categories() : Array
      {
         return this._rankedHunt_categories;
      }
      
      public function get factions_resKeys() : Array
      {
         return this._factions_resKeys;
      }
      
      public function get rankPositions() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            _loc1_.push(BPLocale.getItem("company_hierarchy_rank_position_" + _loc2_));
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get nettyShipIcons() : Array
      {
         return this._nettyShipIcons;
      }
      
      public function get factions_names_by_FactionModule() : Array
      {
         return this._factions_names_by_FactionModule;
      }
      
      public function get invitationErrorHashmap() : Dictionary
      {
         return this._invitationErrorHashmap;
      }
      
      public function get mapAssetLocakeys() : Array
      {
         return this._mapAssetLocakeys;
      }
      
      public function get collectable_icons() : Array
      {
         return this._collectable_icons;
      }
      
      public function setQuestgiverPortraits(param1:String = "default") : void
      {
         if(_questgiverPortraitsSets[param1] == null)
         {
            param1 = "default";
         }
         if(this._portraitSetId != param1)
         {
            this._portraitSetId = param1;
            this.questgiverPortraitsChanged.dispatch();
         }
      }
      
      public function getQuestgiverPortrait(param1:int = 0) : String
      {
         var _loc2_:Object = _questgiverPortraitsSets[this._portraitSetId];
         if(param1 == 0 || _loc2_.affectedQuests.length == 0 || _loc2_.affectedQuests.indexOf(param1) != -1)
         {
            return _loc2_.portraits[Hero.factionName];
         }
         return _questgiverPortraitsSets["default"].portraits[Hero.factionName];
      }
      
      public function getQuestfmPortraitResKey(param1:int) : String
      {
         return "questfm_" + this.getQuestgiverPortrait(param1);
      }
      
      public function poizonePOITypeToZoneType(param1:int) : String
      {
         return this._poizonePOITypeToZoneType[param1];
      }
      
      public function poizoneShapeTypeIdToShapeString(param1:int) : String
      {
         return this._poizoneShapeTypeIdToShapeString[param1];
      }
      
      public function getPoiDesingSimpleKey(param1:int) : String
      {
         return this._poizoneDesingSimple[param1];
      }
      
      public function get currentMapPoiColor() : uint
      {
         return ScreenManager.getInstance().map.mapXml.attribute("poiColor").length() > 0 ? uint(ScreenManager.getInstance().map.mapXml.attribute("poiColor")) : 16777215;
      }
      
      public function getGroupSystemMapName(param1:int) : String
      {
         return Map.getGroupSystemMapName(param1) || "?";
      }
      
      public function getGroupSystemMapNameToolTip(param1:int) : String
      {
         return Map.getGroupSystemMapToolTip(param1) || "?";
      }
      
      public function getRaidgateIconColorByState(param1:int) : uint
      {
         return this._raidgateIconColors[param1] ? uint(this._raidgateIconColors[param1]) : 0;
      }
      
      public function specifyVideoType(param1:uint) : uint
      {
         return this._videoTypeMapping[param1] ? uint(this._videoTypeMapping[param1]) : uint(VideoElement.CLASS_COMMANDER);
      }
      
      public function getRaidgateToolTipKey(param1:int) : String
      {
         return this._raidgateTooltipKeys[param1] ? this._raidgateTooltipKeys[param1] : "-";
      }
      
      public function getTitleColor(param1:String) : uint
      {
         return uint(this._title_colours[param1]) || 16776960;
      }
      
      public function isMonthlyTitle(param1:String) : Boolean
      {
         return param1.indexOf("monthlyranking") >= 0;
      }
      
      public function getTitleKey(param1:String) : String
      {
         return this._titleKeyToTitleIdKey[param1] || param1;
      }
      
      private function initTraininggroundsDisabledReasons() : void
      {
         this.trainingGroundDisabledReasons[TrainingGroundRegistrationUnavailableStatusCommand.REGISTRATIONUNAVAILABLETYPE_PVP_OR_GATE_MAP] = "log_msg_traininggrounds_usage_forbidden_feature";
         this.trainingGroundDisabledReasons[TrainingGroundRegistrationUnavailableStatusCommand.REGISTRATIONUNAVAILABLETYPE_MAINTENANCE] = "label_traininggrounds_not_available_maintenance";
         this.trainingGroundDisabledReasons[TrainingGroundRegistrationUnavailableStatusCommand.REGISTRATIONUNAVAILABLETYPE_PREPARE_FOR_JACKPOT] = "label_traininggrounds_not_available_prepare_jpa";
      }
      
      private function initEpicMessages() : void
      {
         this.epicMessages[EpicFightMessageTypeModule.EPICMIGHTMESSAGETYPE_ROUND_WIN] = " YOU WIN ";
         this.epicMessages[EpicFightMessageTypeModule.EPICMIGHTMESSAGETYPE_ROUND_LOSE] = " YOU LOSE ";
         this.epicMessages[EpicFightMessageTypeModule.EPICMIGHTMESSAGETYPE_DRAW] = " DRAW ";
         this.epicMessages[EpicFightMessageTypeModule.EPICMIGHTMESSAGETYPE_FINAL_ROUND] = " FINAL ROUND ";
         this.epicMessages[EpicFightMessageTypeModule.EPICMIGHTMESSAGETYPE_FIGHT] = " FIGHT! ";
         this.epicMessages[EpicFightMessageTypeModule.EPICMIGHTMESSAGETYPE_DOUBLE_KO] = " DOUBLE KO ";
         this.epicMessages[EpicFightMessageTypeModule.EPICMIGHTMESSAGETYPE_ROUND_OVER] = " ROUND OVER ";
         this.epicNumberedMessages[EpicNumberedFightMessageTypeModule.EPICNUMBEREDFIGHTMESSAGETYPE_ROUND_NUMBER] = " ROUND %NUMBER% ";
         this.epicNumberedMessages[EpicNumberedFightMessageTypeModule.EPICNUMBEREDFIGHTMESSAGETYPE_ROUND_COUNTDOWN] = " %NUMBER% ";
         this.epicNumberedMessages[EpicNumberedFightMessageTypeModule.EPICNUMBEREDFIGHTMESSAGETYPE_ROUND_ENDS_IN_SECONDS] = " ROUND ENDS IN %NUMBER% SECONDS ";
         this.epicNumberedMessages[EpicNumberedFightMessageTypeModule.EPICNUMBEREDFIGHTMESSAGETYPE_ROUND_ENDS_IN_MINUTES] = " ROUND ENDS IN %NUMBER% MINUTES ";
      }
      
      private function initMapAssetReskeys() : void
      {
         this._mapAssetLocakeys[AssetTypeModule.ASSETTYPE_COMPANY_HQ_HOME] = "mapasset_company_hq_home";
         this._mapAssetLocakeys[AssetTypeModule.ASSETTYPE_COMPANY_HQ_OUTPOST] = "mapasset_company_hq_outpost";
         this._mapAssetLocakeys[AssetTypeModule.ASSETTYPE_QUESTGIVER] = "mapasset_questgiver";
         this._mapAssetLocakeys[AssetTypeModule.ASSETTYPE_ASTEROID] = "mapasset_asteroid";
         this._mapAssetLocakeys[AssetTypeModule.ASSETTYPE_BATTLESTATION] = "mapasset_battlestation";
         this._mapAssetLocakeys[AssetTypeModule.ASSETTYPE_HANGAR_HOME] = "mapasset_hangar_home";
         this._mapAssetLocakeys[AssetTypeModule.ASSETTYPE_HANGAR_OUTPOST] = "mapasset_hangar_outpost";
         this._mapAssetLocakeys[AssetTypeModule.ASSETTYPE_INSTANT_REPAIR_HOME] = "mapasset_instant_repair_home";
         this._mapAssetLocakeys[AssetTypeModule.ASSETTYPE_INSTANT_REPAIR_OUTPOST] = "mapasset_instant_repair_outpost";
         this._mapAssetLocakeys[AssetTypeModule.ASSETTYPE_ORE_TRADE_HOME] = "mapasset_ore_trade_home";
         this._mapAssetLocakeys[AssetTypeModule.ASSETTYPE_ORE_TRADE_OUTPOST] = "mapasset_ore_trade_outpost";
         this._mapAssetLocakeys[AssetTypeModule.ASSETTYPE_TEAMDEATHMATCH_BATTLEMASTER] = "mapasset_tdm_beacon";
         this._mapAssetLocakeys[AssetTypeModule.ASSETTYPE_SECTOR_CONTROL_BATTLEMASTER] = "mapasset_sector_control_beacon";
         this._mapAssetLocakeys[AssetTypeModule.ASSETTYPE_BILLBOARD_ASTEROID] = "mapasset_billbord";
      }
      
      private function createCollectableLookup() : void
      {
         this._collectable_icons["resource_ore_terbium"] = "ore_3.png";
         this._collectable_icons["resource_ore_prometium"] = "ore_1.png";
         this._collectable_icons["resource_ore_palladium"] = "ore_15.png";
         this._collectable_icons["resource_ore_endurium"] = "ore_2.png";
         this._collectable_icons["resource_ore_duranium"] = "ore_12.png";
         this._bootyBoxNames = new Dictionary();
         this._bootyBoxNames["PIRATE_BOOTY"] = "Pirate Booty Boxes";
         this._bootyBoxNames["PIRATE_BOOTY_GOLD"] = "Pirate Booty Gold Boxes";
         this._bootyBoxNames["PIRATE_BOOTY_SILVER"] = "Silver Pirate Booty Boxes";
         this._bootyBoxNames["PIRATE_BOOTY_RED"] = "Red Pirate Booty Boxes";
         this._bootyBoxNames["PIRATE_BOOTY_BLUE"] = "Blue Pirate Booty Boxes";
         this._bootyBoxNames["ASTRAL_BOOTY_BOX"] = "Astral Booty Boxes";
      }
      
      private function initGroupSystemErrorMapping() : void
      {
         this._invitationErrorHashmap = new Dictionary();
         this._invitationErrorHashmap[InvitationErrorCommand.ERRORTYPE_GROUP_FULL] = "msg_grp_inv_err_group_full";
         this._invitationErrorHashmap[InvitationErrorCommand.ERRORTYPE_CANDIDATE_IN_GROUP] = "msg_grp_inv_err_candidate_in_group";
         this._invitationErrorHashmap[InvitationErrorCommand.ERRORTYPE_CANDIDATE_NONEXISTENT] = "msg_grp_inv_err_candidate_nonexistant";
         this._invitationErrorHashmap[InvitationErrorCommand.ERRORTYPE_INVITER_NONEXISTENT] = "msg_grp_inv_err_inviter_nonexistant";
         this._invitationErrorHashmap[InvitationErrorCommand.ERRORTYPE_NO_INVITATION] = "msg_grp_inv_err_no_invitation";
         this._invitationErrorHashmap[InvitationErrorCommand.ERRORTYPE_BOSS_ONLY] = "msg_grp_inv_err_boss_only";
         this._invitationErrorHashmap[InvitationErrorCommand.ERRORTYPE_MAX_INVITATIONS_INVITER] = "msg_grp_inv_err_max_invitations_inviter";
         this._invitationErrorHashmap[InvitationErrorCommand.ERRORTYPE_MAX_INVITATIONS_CANDIDATE] = "msg_grp_inv_err_max_invitations_candidate";
         this._invitationErrorHashmap[InvitationErrorCommand.ERRORTYPE_CANDIDATE_BLOCKING] = "msg_grp_inv_err_candidate_blocking";
         this._invitationErrorHashmap[InvitationErrorCommand.ERRORTYPE_DUPLICATE_INVITATION] = "msg_grp_inv_err_duplicate_invitation";
      }
      
      private function initVideoTypeMapping() : void
      {
         this._videoTypeMapping = [];
         this._videoTypeMapping[VideoWindowCreateCommand.VIDEOTYPES_COMMANDER] = VideoElement.CLASS_COMMANDER;
         this._videoTypeMapping[VideoWindowCreateCommand.VIDEOTYPES_HELPMOVIE] = VideoElement.CLASS_HELPMOVIE;
      }
      
      private function initRaidGateConsts() : void
      {
         this._raidgateIconColors = [];
         this._raidgateIconColors[RaidGateConstants.DIFFERENT_STAGE] = 4294967040;
         this._raidgateIconColors[RaidGateConstants.HERO_NO_GATE] = 4294901760;
         this._raidgateIconColors[RaidGateConstants.SAME_STAGE] = 4278255360;
         this._raidgateTooltipKeys = [];
         this._raidgateTooltipKeys[RaidGateConstants.DIFFERENT_STAGE] = "ttip_raidGateStatusBG_diff";
         this._raidgateTooltipKeys[RaidGateConstants.HERO_NO_GATE] = "ttip_raidGateStatusBG_hero_no_gate";
         this._raidgateTooltipKeys[RaidGateConstants.SAME_STAGE] = "ttip_raidGateStatusBG_same";
      }
      
      private function initNettyShipIcons() : void
      {
         this._nettyShipIcons = [];
         this._nettyShipIcons[ShipIconModule.SHIPICON_NONE] = "iconShipNull";
         this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT] = "iconShip0";
         this._nettyShipIcons[ShipIconModule.SHIPICON_PHOENIX] = "iconShip1";
         this._nettyShipIcons[ShipIconModule.SHIPICON_YAMATO] = "iconShip2";
         this._nettyShipIcons[ShipIconModule.SHIPICON_LEONOV] = "iconShip3";
         this._nettyShipIcons[ShipIconModule.SHIPICON_DEFCOM] = "iconShip4";
         this._nettyShipIcons[ShipIconModule.SHIPICON_LIBERATOR] = "iconShip5";
         this._nettyShipIcons[ShipIconModule.SHIPICON_PIRANHA] = "iconShip6";
         this._nettyShipIcons[ShipIconModule.SHIPICON_NOSTROMO] = "iconShip7";
         this._nettyShipIcons[ShipIconModule.SHIPICON_VENGEANCE] = "iconShip8";
         this._nettyShipIcons[ShipIconModule.SHIPICON_BIGBOY] = "iconShip9";
         this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH] = "iconShip10";
         this._nettyShipIcons[ShipIconModule.SHIPICON_DEMANER] = "iconShip11";
         this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS] = "iconShip49";
         this._nettyShipIcons[ShipIconModule.SHIPICON_CITADEL] = "iconShip69";
         this._nettyShipIcons[ShipIconModule.SHIPICON_SPEARHEAD] = "iconShip70";
         this._nettyShipIcons[ShipIconModule.SHIPICON_LORDAKIA] = "iconShip71";
         this._nettyShipIcons[ShipIconModule.SHIPICON_DEVOLARIUM] = "iconShip72";
         this._nettyShipIcons[ShipIconModule.SHIPICON_MORDON] = "iconShip73";
         this._nettyShipIcons[ShipIconModule.SHIPICON_SIBELON] = "iconShip74";
         this._nettyShipIcons[ShipIconModule.SHIPICON_SAIMON] = "iconShip75";
         this._nettyShipIcons[ShipIconModule.SHIPICON_SIBELONIT] = "iconShip76";
         this._nettyShipIcons[ShipIconModule.SHIPICON_LORDAKIUM] = "iconShip77";
         this._nettyShipIcons[ShipIconModule.SHIPICON_KRISTALLIN] = "iconShip78";
         this._nettyShipIcons[ShipIconModule.SHIPICON_KRISTALLON] = "iconShip79";
         this._nettyShipIcons[ShipIconModule.SHIPICON_SMALL_KUBIKON] = "iconShip80";
         this._nettyShipIcons[ShipIconModule.SHIPICON_QQQ_PROTEGIT] = "iconShip81";
         this._nettyShipIcons[ShipIconModule.SHIPICON_KUCURBIUM] = "iconShip82";
         this._nettyShipIcons[ShipIconModule.SHIPICON_OUTCAST] = "iconShip90";
         this._nettyShipIcons[ShipIconModule.SHIPICON_HOOLIGAN] = "iconShip91";
         this._nettyShipIcons[ShipIconModule.SHIPICON_MARAUDER] = "iconShip93";
         this._nettyShipIcons[ShipIconModule.SHIPICON_ADMIN_SHIP] = "iconShip98";
         this._nettyShipIcons[ShipIconModule.SHIPICON_IFREET_SCORCHER] = "iconShip99";
         this._nettyShipIcons[ShipIconModule.SHIPICON_IFREET_INFERNAL] = "iconShip100";
         this._nettyShipIcons[ShipIconModule.SHIPICON_ICE_METEROID] = "iconShip101";
         this._nettyShipIcons[ShipIconModule.SHIPICON_IFREET_MELTER] = "iconShip102";
         this._nettyShipIcons[ShipIconModule.SHIPICON_CRAZY_ROBOT_1100101] = "iconShip104";
         this._nettyShipIcons[ShipIconModule.SHIPICON_IFREET_DEVOURER] = "iconShip105";
         this._nettyShipIcons[ShipIconModule.SHIPICON_INTERCEPTOR] = "iconShip111";
         this._nettyShipIcons[ShipIconModule.SHIPICON_EMPEROR_SIBELON] = "iconShip_EmperorSibelon";
         this._nettyShipIcons[ShipIconModule.SHIPICON_EMPEROR_LORDAKIUM] = "iconShip_EmperorLordakium";
         this._nettyShipIcons[ShipIconModule.SHIPICON_EMPEROR_KRISTALLON] = "iconShip_EmperorKristallon";
         this._nettyShipIcons[ShipIconModule.SHIPICON_PLAGUE_MINION] = "iconShip_PlagueMinion";
         this._nettyShipIcons[ShipIconModule.SHIPICON_PLAGUE_BOSS] = "iconShip_PlagueBoss";
         this._nettyShipIcons[ShipIconModule.SHIPICON_KERES] = "iconShip_Keres";
         this._nettyShipIcons[ShipIconModule.SHIPICON_STREUNER_EMPEROR] = "iconShip147";
         this._nettyShipIcons[ShipIconModule.SHIPICON_STREUNER_SOLDIER] = "iconShip150";
         this._nettyShipIcons[ShipIconModule.SHIPICON_STREUNER_SPECIALIST] = "iconShip149";
         this._nettyShipIcons[ShipIconModule.SHIPICON_STREUNER_TURRET] = "iconShip148";
         this._nettyShipIcons[ShipIconModule.SHIPICON_STREUNER_RECRUIT] = "iconShip150";
         this._nettyShipIcons[ShipIconModule.SHIPICON_STREUNER_AIDER] = this._nettyShipIcons[ShipIconModule.SHIPICON_STREUNER_SPECIALIST];
         this._nettyShipIcons[ShipIconModule.SHIPICON_TARTARUS] = "iconShip_Tartarus";
         this._nettyShipIcons[ShipIconModule.SHIPICON_MIMESIS] = "iconShip_Mimesis";
         this._nettyShipIcons[ShipIconModule.SHIPICON_CYBORG] = "iconShip_Cyborg";
         this._nettyShipIcons[ShipIconModule.SHIPICON_HAMMERCLAW] = "iconShip_Hammerclaw";
         this._nettyShipIcons[ShipIconModule.SHIPICON_HECATE] = "iconShip_Hecate";
         this._nettyShipIcons[ShipIconModule.SHIPICON_DISRUPTOR] = "iconShip_Disruptor";
         this._nettyShipIcons[ShipIconModule.SHIPICON_BERSERKER] = "iconShip_Berserker";
         this._nettyShipIcons[ShipIconModule.SHIPICON_ZEPHYR] = "iconShip_Zephyr";
         this._nettyShipIcons[ShipIconModule.SHIPICON_SOLARIS] = "iconShip_Solaris";
         this._nettyShipIcons[ShipIconModule.SHIPICON_ORCUS] = "iconShip_Orcus";
         this._nettyShipIcons[ShipIconModule.SHIPICON_HOLO] = "iconShip_Holo";
         this._nettyShipIcons[ShipIconModule.SHIPICON_CORSAIR] = this._nettyShipIcons[ShipIconModule.SHIPICON_VENGEANCE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_UNIDENTIFIED_DESTROYER] = this._nettyShipIcons[ShipIconModule.SHIPICON_IFREET_INFERNAL];
         this._nettyShipIcons[ShipIconModule.SHIPICON_UNIDENTIFIED_DREADNOUGHT] = this._nettyShipIcons[ShipIconModule.SHIPICON_IFREET_SCORCHER];
         this._nettyShipIcons[ShipIconModule.SHIPICON_HITAC_MINION] = this._nettyShipIcons[ShipIconModule.SHIPICON_INTERCEPTOR];
         this._nettyShipIcons[ShipIconModule.SHIPICON_ADEPT] = this._nettyShipIcons[ShipIconModule.SHIPICON_VENGEANCE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_LIGHTNING] = this._nettyShipIcons[ShipIconModule.SHIPICON_VENGEANCE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_JADE] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_LEONOV_ENHANCED] = this._nettyShipIcons[ShipIconModule.SHIPICON_LEONOV];
         this._nettyShipIcons[ShipIconModule.SHIPICON_MAMBA] = this._nettyShipIcons[ShipIconModule.SHIPICON_BIGBOY];
         this._nettyShipIcons[ShipIconModule.SHIPICON_GIGA_BIGBOY] = this._nettyShipIcons[ShipIconModule.SHIPICON_BIGBOY];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SOLEMN] = this._nettyShipIcons[ShipIconModule.SHIPICON_BIGBOY];
         this._nettyShipIcons[ShipIconModule.SHIPICON_AMBER] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_CRIMSON] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SAPPHIRE] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_ENFORCER] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_INDEPENDANCE] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_REVENGE] = this._nettyShipIcons[ShipIconModule.SHIPICON_VENGEANCE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BASTION] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_AVENGER] = this._nettyShipIcons[ShipIconModule.SHIPICON_VENGEANCE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_VETERAN] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_EXALTED] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SOLACE] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_DIMINISHER] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SPECTRUM] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SPECTRUM_SANDSTORM] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SPECTRUM_POISON] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SPECTRUM_LAVA] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SPECTRUM_LEGEND] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SPECTRUM_BLAZE] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SPECTRUM_OCEAN] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SENTINEL] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SENTINEL_FROST] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_VENOM] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_VENOM_FROST] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_QUAL0R] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_CRAWLER] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_MOTHERSHIP] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_POLICE_SHIP] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_IGNITE] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_KICK] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_REFEREE] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_GOAL] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_CENTAUR] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_STREUNER] = this._nettyShipIcons[ShipIconModule.SHIPICON_YAMATO];
         this._nettyShipIcons[ShipIconModule.SHIPICON_StreuneR] = this._nettyShipIcons[ShipIconModule.SHIPICON_YAMATO];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BIG_KUBIKON] = this._nettyShipIcons[ShipIconModule.SHIPICON_SMALL_KUBIKON];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BOSS_STREUNER] = this._nettyShipIcons[ShipIconModule.SHIPICON_YAMATO];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BOSS_LORDAKIA] = this._nettyShipIcons[ShipIconModule.SHIPICON_LORDAKIA];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BOSS_MORDON] = this._nettyShipIcons[ShipIconModule.SHIPICON_MORDON];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BOSS_SAIMON] = this._nettyShipIcons[ShipIconModule.SHIPICON_SIBELON];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BOSS_DEVOLARIUM] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEVOLARIUM];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BOSS_SIBELONIT] = this._nettyShipIcons[ShipIconModule.SHIPICON_SIBELONIT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BOSS_SIBELON] = this._nettyShipIcons[ShipIconModule.SHIPICON_SIBELON];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BOSS_LORDAKIUM] = this._nettyShipIcons[ShipIconModule.SHIPICON_LORDAKIUM];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BOSS_KRISTALLIN] = this._nettyShipIcons[ShipIconModule.SHIPICON_KRISTALLIN];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BOSS_KRISTALLON] = this._nettyShipIcons[ShipIconModule.SHIPICON_KRISTALLON];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BOSS_StreuneR] = this._nettyShipIcons[ShipIconModule.SHIPICON_YAMATO];
         this._nettyShipIcons[ShipIconModule.SHIPICON_UFONIT] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_UFO] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_AGGRO_STREUNER] = this._nettyShipIcons[ShipIconModule.SHIPICON_YAMATO];
         this._nettyShipIcons[ShipIconModule.SHIPICON_UBER_STREUNER] = this._nettyShipIcons[ShipIconModule.SHIPICON_YAMATO];
         this._nettyShipIcons[ShipIconModule.SHIPICON_UBER_LORDAKIA] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_UBER_MORDON] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_UBER_SAIMON] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_UBER_DEVOLARIUM] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_UBER_SIBELONIT] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_UBER_SIBELON] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_UBER_LORDAKIUM] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_UBER_KRISTALLIN] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_UBER_KRISTALLON] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_UBER_StreuneR] = this._nettyShipIcons[ShipIconModule.SHIPICON_YAMATO];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BOSS_KUCURBIUM] = this._nettyShipIcons[ShipIconModule.SHIPICON_KUCURBIUM];
         this._nettyShipIcons[ShipIconModule.SHIPICON_HENCHMAN] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_RAVAGER] = this._nettyShipIcons[ShipIconModule.SHIPICON_HOOLIGAN];
         this._nettyShipIcons[ShipIconModule.SHIPICON_CONVICT] = this._nettyShipIcons[ShipIconModule.SHIPICON_HOOLIGAN];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BOSS] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_QQQ_CUBKION] = this._nettyShipIcons[ShipIconModule.SHIPICON_SMALL_KUBIKON];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SNOWY] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SUPER_METEROID] = this._nettyShipIcons[ShipIconModule.SHIPICON_ICE_METEROID];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BARRACUDA] = this._nettyShipIcons[ShipIconModule.SHIPICON_INTERCEPTOR];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SABOTEUR] = this._nettyShipIcons[ShipIconModule.SHIPICON_INTERCEPTOR];
         this._nettyShipIcons[ShipIconModule.SHIPICON_ANNIHILATOR] = this._nettyShipIcons[ShipIconModule.SHIPICON_INTERCEPTOR];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BATTLERAY] = this._nettyShipIcons[ShipIconModule.SHIPICON_INTERCEPTOR];
         this._nettyShipIcons[ShipIconModule.SHIPICON_GG_HENCHMAN] = this._nettyShipIcons[ShipIconModule.SHIPICON_HENCHMAN];
         this._nettyShipIcons[ShipIconModule.SHIPICON_GG_MARAUDER] = this._nettyShipIcons[ShipIconModule.SHIPICON_MARAUDER];
         this._nettyShipIcons[ShipIconModule.SHIPICON_GG_OUTCAST] = this._nettyShipIcons[ShipIconModule.SHIPICON_OUTCAST];
         this._nettyShipIcons[ShipIconModule.SHIPICON_GG_CORSAIR] = this._nettyShipIcons[ShipIconModule.SHIPICON_CORSAIR];
         this._nettyShipIcons[ShipIconModule.SHIPICON_GG_HOOLIGAN] = this._nettyShipIcons[ShipIconModule.SHIPICON_HOOLIGAN];
         this._nettyShipIcons[ShipIconModule.SHIPICON_GG_RAVAGER] = this._nettyShipIcons[ShipIconModule.SHIPICON_RAVAGER];
         this._nettyShipIcons[ShipIconModule.SHIPICON_GG_CONVICT] = this._nettyShipIcons[ShipIconModule.SHIPICON_CONVICT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_CRAZY_SANTA_ROBOT] = this._nettyShipIcons[ShipIconModule.SHIPICON_CRAZY_ROBOT_1100101];
         this._nettyShipIcons[ShipIconModule.SHIPICON_CRAZY_REFEREE_ROBOT] = this._nettyShipIcons[ShipIconModule.SHIPICON_CRAZY_ROBOT_1100101];
         this._nettyShipIcons[ShipIconModule.SHIPICON_CRAZY_SOLAR_ROBOT] = this._nettyShipIcons[ShipIconModule.SHIPICON_CRAZY_ROBOT_1100101];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_PHOENX] = this._nettyShipIcons[ShipIconModule.SHIPICON_PHOENIX];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_YAMATO] = this._nettyShipIcons[ShipIconModule.SHIPICON_YAMATO];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_DEFCOM] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFCOM];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_LIBERATOR] = this._nettyShipIcons[ShipIconModule.SHIPICON_LIBERATOR];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_NOSTROMO] = this._nettyShipIcons[ShipIconModule.SHIPICON_NOSTROMO];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_PIRANHA] = this._nettyShipIcons[ShipIconModule.SHIPICON_PIRANHA];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_BIGBOY] = this._nettyShipIcons[ShipIconModule.SHIPICON_BIGBOY];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_VENGEANCE] = this._nettyShipIcons[ShipIconModule.SHIPICON_VENGEANCE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_GOLIATH] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_LEONOV] = this._nettyShipIcons[ShipIconModule.SHIPICON_LEONOV];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_VENOM] = this._nettyShipIcons[ShipIconModule.SHIPICON_VENOM];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_SENTINEL] = this._nettyShipIcons[ShipIconModule.SHIPICON_SENTINEL];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_SPECTRUM] = this._nettyShipIcons[ShipIconModule.SHIPICON_SPECTRUM];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SPECTRUM_FROST] = this._nettyShipIcons[ShipIconModule.SHIPICON_SPECTRUM];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_DIMINISHER] = this._nettyShipIcons[ShipIconModule.SHIPICON_DIMINISHER];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_SOLACE] = this._nettyShipIcons[ShipIconModule.SHIPICON_SOLACE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_REVENGE] = this._nettyShipIcons[ShipIconModule.SHIPICON_REVENGE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_LIGHTNING] = this._nettyShipIcons[ShipIconModule.SHIPICON_LIGHTNING];
         this._nettyShipIcons[ShipIconModule.SHIPICON_LIGHTNING_FROST] = this._nettyShipIcons[ShipIconModule.SHIPICON_LIGHTNING];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_AVENGER] = this._nettyShipIcons[ShipIconModule.SHIPICON_AVENGER];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_BASTION] = this._nettyShipIcons[ShipIconModule.SHIPICON_BASTION];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_ENFORCER] = this._nettyShipIcons[ShipIconModule.SHIPICON_ENFORCER];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_SPEARHEAD] = this._nettyShipIcons[ShipIconModule.SHIPICON_SPEARHEAD];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_CITADEL] = this._nettyShipIcons[ShipIconModule.SHIPICON_CITADEL];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_AEGIS] = this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_CRIMSON] = this._nettyShipIcons[ShipIconModule.SHIPICON_CRIMSON];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_JADE] = this._nettyShipIcons[ShipIconModule.SHIPICON_JADE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_SAPPHIRE] = this._nettyShipIcons[ShipIconModule.SHIPICON_SAPPHIRE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SATURN_EVIL_YOU] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_IRIS_MINION] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_HITAC] = this._nettyShipIcons[ShipIconModule.SHIPICON_HITAC_MINION];
         this._nettyShipIcons[ShipIconModule.SHIPICON_CRAZY_UFO] = this._nettyShipIcons[ShipIconModule.SHIPICON_MORDON];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BOSS_CURCUBITOR] = this._nettyShipIcons[ShipIconModule.SHIPICON_LORDAKIUM];
         this._nettyShipIcons[ShipIconModule.SHIPICON_CURCUBITOR] = this._nettyShipIcons[ShipIconModule.SHIPICON_LORDAKIUM];
         this._nettyShipIcons[ShipIconModule.SHIPICON_ASTEROID] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BATTLE_STATION_HUB] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BATTLE_STATION_SATELLITE] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BILLBOARD_ASTEROID] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BOOSTER_ZONE] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_HEALING_POD] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_PET] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_RELAY_STATION] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SPACEBALL] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_WRECK] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BUFF_CAPSULE] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BOLLERWAGEN] = this._nettyShipIcons[ShipIconModule.SHIPICON_DEFAULT];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SPEARHEAD_ELITE] = this._nettyShipIcons[ShipIconModule.SHIPICON_SPEARHEAD];
         this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS_ELITE] = this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS];
         this._nettyShipIcons[ShipIconModule.SHIPICON_A_ELITE_BLAZE] = this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS];
         this._nettyShipIcons[ShipIconModule.SHIPICON_A_ELITE_SANDSTORM] = this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS];
         this._nettyShipIcons[ShipIconModule.SHIPICON_A_ELITE_OCEAN] = this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS];
         this._nettyShipIcons[ShipIconModule.SHIPICON_A_ELITE_LAVA] = this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS];
         this._nettyShipIcons[ShipIconModule.SHIPICON_A_ELITE_LEGEND] = this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS];
         this._nettyShipIcons[ShipIconModule.SHIPICON_A_ELITE_POISON] = this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS];
         this._nettyShipIcons[ShipIconModule.SHIPICON_CITADEL_ELITE] = this._nettyShipIcons[ShipIconModule.SHIPICON_CITADEL];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SPEARHEAD_SUPERELITE] = this._nettyShipIcons[ShipIconModule.SHIPICON_SPEARHEAD];
         this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS_SUPERELITE] = this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS];
         this._nettyShipIcons[ShipIconModule.SHIPICON_CITADEL_SUPERELITE] = this._nettyShipIcons[ShipIconModule.SHIPICON_CITADEL];
         this._nettyShipIcons[ShipIconModule.SHIPICON_NOSTROMO_DIPLOMAT] = this._nettyShipIcons[ShipIconModule.SHIPICON_NOSTROMO];
         this._nettyShipIcons[ShipIconModule.SHIPICON_NOSTROMO_ENVOY] = this._nettyShipIcons[ShipIconModule.SHIPICON_NOSTROMO];
         this._nettyShipIcons[ShipIconModule.SHIPICON_NOSTROMO_AMBASSADOR] = this._nettyShipIcons[ShipIconModule.SHIPICON_NOSTROMO];
         this._nettyShipIcons[ShipIconModule.SHIPICON_NOSTROMO_AMBASSADOR_FROST] = this._nettyShipIcons[ShipIconModule.SHIPICON_NOSTROMO];
         this._nettyShipIcons[ShipIconModule.SHIPICON_VANQUISHER] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SOVEREIGN] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_PEACEMAKER] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH_RAZER] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_NOSTROMO_RAZER] = this._nettyShipIcons[ShipIconModule.SHIPICON_NOSTROMO];
         this._nettyShipIcons[ShipIconModule.SHIPICON_TURKISH_GOLIATH] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_PUSAT] = this._nettyShipIcons[ShipIconModule.SHIPICON_VENGEANCE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_PUSAT_FROST] = this._nettyShipIcons[ShipIconModule.SHIPICON_VENGEANCE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_PUSAT_LAVA] = this._nettyShipIcons[ShipIconModule.SHIPICON_VENGEANCE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_PUSAT_POISON] = this._nettyShipIcons[ShipIconModule.SHIPICON_VENGEANCE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_PUSAT_SANDSTORM] = this._nettyShipIcons[ShipIconModule.SHIPICON_VENGEANCE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_PUSAT_LEGEND] = this._nettyShipIcons[ShipIconModule.SHIPICON_VENGEANCE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_PUSAT_BLAZE] = this._nettyShipIcons[ShipIconModule.SHIPICON_VENGEANCE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_PUSAT_OCEAN] = this._nettyShipIcons[ShipIconModule.SHIPICON_VENGEANCE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_DEMANER_FREIGHTER] = this._nettyShipIcons[ShipIconModule.SHIPICON_SIBELON];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SKOLL] = this._nettyShipIcons[ShipIconModule.SHIPICON_ICE_METEROID];
         this._nettyShipIcons[ShipIconModule.SHIPICON_GOLD] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SILVER] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_BRONZE] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_IRON] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH_FROST] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS_FROST] = this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS];
         this._nettyShipIcons[ShipIconModule.SHIPICON_SPEARHEAD_FROST] = this._nettyShipIcons[ShipIconModule.SHIPICON_SPEARHEAD];
         this._nettyShipIcons[ShipIconModule.SHIPICON_CITADEL_FROST] = this._nettyShipIcons[ShipIconModule.SHIPICON_CITADEL];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_ALBANIA] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_AUSTRIA] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_BELGIUM] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_CROATIA] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_CZECH_REPUBLIC] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_ENGLAND] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_FRANCE] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_GERMANY] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_HUNGARY] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_ICELAND] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_ITALY] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_NORTHERN_IRELAND] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_POLAND] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_PORTUGAL] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_REPUBLIC_OF_IRELAND] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_ROMANIA] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_RUSSIA] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_SLOVAKIA] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_SPAIN] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_SWEDEN] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_SWITZERLAND] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_TURKEY] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_UKRAINE] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_G_CHAMPION_WALES] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_A_ELITE_BLAZE] = this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS];
         this._nettyShipIcons[ShipIconModule.SHIPICON_A_ELITE_LAVA] = this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS];
         this._nettyShipIcons[ShipIconModule.SHIPICON_A_ELITE_LEGEND] = this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS];
         this._nettyShipIcons[ShipIconModule.SHIPICON_A_ELITE_OCEAN] = this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS];
         this._nettyShipIcons[ShipIconModule.SHIPICON_A_ELITE_POISON] = this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS];
         this._nettyShipIcons[ShipIconModule.SHIPICON_A_ELITE_SANDSTORM] = this._nettyShipIcons[ShipIconModule.SHIPICON_AEGIS];
         this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH_X] = this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH];
         this._nettyShipIcons[ShipIconModule.SHIPICON_CENTURION] = "iconShip_centurion";
         this._nettyShipIcons[ShipIconModule.SHIPICON_PURPOSE_XXI] = "iconShip_bl1";
         this._nettyShipIcons[ShipIconModule.SHIPICON_IMPULSE_II] = "iconShip_bl1";
         this._nettyShipIcons[ShipIconModule.SHIPICON_ATTEND_IX] = "iconShip_bl2";
         this._nettyShipIcons[ShipIconModule.SHIPICON_INVOKE_XVI] = "iconShip_bl3";
         this._nettyShipIcons[ShipIconModule.SHIPICON_MINDFIRE_BEHEMOTH] = "iconShip_bl4";
         this._nettyShipIcons[ShipIconModule.SHIPICON_URGE_IV] = "iconShip_bl1";
         this._nettyShipIcons[ShipIconModule.SHIPICON_ATTEND_XIII] = "iconShip_bl1";
         this._nettyShipIcons[ShipIconModule.SHIPICON_CAPITAL_I] = "iconShip_bl1";
         this._nettyShipIcons[ShipIconModule.SHIPICON_REGARD_CXI] = "iconShip_bl2";
         this._nettyShipIcons[ShipIconModule.SHIPICON_OBSERVE_X] = "iconShip_bl2";
         this._nettyShipIcons[ShipIconModule.SHIPICON_FIND_VII] = "iconShip_bl2";
         this._nettyShipIcons[ShipIconModule.SHIPICON_SANCTION_XXXIII] = "iconShip_bl3";
         this._nettyShipIcons[ShipIconModule.SHIPICON_DEMAND_VII] = "iconShip_bl3";
         this._nettyShipIcons[ShipIconModule.SHIPICON_RESERVE_VIII] = "iconShip_bl3";
         this._nettyShipIcons[ShipIconModule.SHIPICON_SUBJUGATE_XXVII] = "iconShip_bl4";
         this._nettyShipIcons[ShipIconModule.SHIPICON_DISCTATE_XCIC] = "iconShip_bl4";
         this._nettyShipIcons[ShipIconModule.SHIPICON_PARAGON_XX] = "iconShip_bl4";
         this._nettyShipIcons[ShipIconModule.SHIPICON_AGATUS] = "iconShip_Agatus";
         this._nettyShipIcons[ShipIconModule.SHIPICON_SPINEL] = "iconShip_Spinel";
         this._nettyShipIcons[ShipIconModule.SHIPICON_RETIARUS] = "iconShip_Retiarus";
         this._nettyShipIcons[ShipIconModule.SHIPICON_ICEMINOS] = this._nettyShipIcons[ShipIconModule.SHIPICON_NONE];
         this._nettyShipIcons[ShipIconModule.SHIPICON_GOLIATH_PLUS] = "iconShip_Goliath-Plus";
         this._nettyShipIcons[ShipIconModule.SHIPICON_CITADEL_PLUS] = "iconShip_Citadel-Plus";
         this._nettyShipIcons[ShipIconModule.SHIPICON_LIBERATOR_PLUS] = "iconShip_Liberator-Plus";
         this._nettyShipIcons[ShipIconModule.SHIPICON_SOLACE_PLUS] = "iconShip_Solace-Plus";
         this._nettyShipIcons[ShipIconModule.SHIPICON_SOLARIS_PLUS] = "iconShip_Solaris-Plus";
         this._nettyShipIcons[ShipIconModule.SHIPICON_PUSAT_PLUS] = "iconShip_Pusat-Plus";
         this._nettyShipIcons[ShipIconModule.SHIPICON_HECATE_PLUS] = "iconShip_Hecate-Plus";
         this._nettyShipIcons[ShipIconModule.SHIPICON_HAMMERCLAW_PLUS] = "iconShip_Hammerclaw-Plus";
         this._nettyShipIcons[ShipIconModule.SHIPICON_SPEARHEAD_PLUS] = "iconShip_Spearhead-Plus";
         this._nettyShipIcons[ShipIconModule.SHIPICON_TEMPEST] = "iconShip_Tempest";
         this._nettyShipIcons[ShipIconModule.SHIPICON_TARTARUS_PLUS] = "iconShip_Tartarus-Plus";
         this._nettyShipIcons[ShipIconModule.SHIPICON_BASILISK] = "iconShip_Basilisk";
         this._nettyShipIcons[ShipIconModule.SHIPICON_SPECTRUM_PLUS] = "iconShip_Spectrum-Plus";
         this._nettyShipIcons[ShipIconModule.SHIPICON_PALADIN] = "iconShip_Paladin";
      }
      
      public function getShipModuleIcon(param1:int) : String
      {
         return "ship_module" + param1 + "_simple.png";
      }
   }
}

