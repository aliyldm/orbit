package net.bigpoint.darkorbit.net.models.skills
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.DiminischerEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SentinelEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SolaceEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpectrumEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpeedBuffEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.VenomEffect;
   
   public class AbilityNames
   {
      
      private static var effectIDMap:Array;
      
      public static const SHIP_SKILL_SOLACE_NAME:String = "SHIP_SKILL_SOLACE";
      
      public static const SHIP_SKILL_DIMINISHER_NAME:String = "SHIP_SKILL_DIMINISHER";
      
      public static const SHIP_SKILL_SPECTRUM_NAME:String = "SHIP_SKILL_SPECTRUM";
      
      public static const SHIP_SKILL_SENTINEL_NAME:String = "SHIP_SKILL_SENTINEL";
      
      public static const SHIP_SKILL_VENOM_NAME:String = "SHIP_SKILL_VENOM";
      
      public static const SHIP_SKILL_LIGHTNING_NAME:String = "SHIP_SKILL_LIGHTNING";
      
      public static const SHIP_SKILL_AEGIS_HEALING_BEAM_NAME:String = "SHIP_SKILL_AEGIS_HEALING_BEAM";
      
      public static const SHIP_SKILL_AEGIS_SHIELD_BEAM_NAME:String = "SHIP_SKILL_AEGIS_SHIELD_BEAM";
      
      public static const SHIP_SKILL_AEGIS_HEALING_POD_NAME:String = "SHIP_SKILL_AEGIS_HEALING_POD";
      
      public static const SHIP_SKILL_CITADEL_DRAW_FIRE_NAME:String = "SHIP_SKILL_CITADEL_DRAW_FIRE";
      
      public static const SHIP_SKILL_CITADEL_TRAVEL_MODE_NAME:String = "SHIP_SKILL_CITADEL_TRAVEL_MODE";
      
      public static const SHIP_SKILL_CITADEL_FORTIFY_NAME:String = "SHIP_SKILL_CITADEL_FORTIFY";
      
      public static const SHIP_SKILL_CITADEL_PROTECTION_NAME:String = "SHIP_SKILL_CITADEL_PROTECTION";
      
      public static const SHIP_SKILL_SPEARHEAD_ULTIMATE_CLOAKING_NAME:String = "SHIP_SKILL_SPEARHEAD_ULTIMATE_CLOAKING";
      
      public static const SHIP_SKILL_SPEARHEAD_JAMX_NAME:String = "SHIP_SKILL_SPEARHEAD_JAMX";
      
      public static const SHIP_SKILL_SPEARHEAD_MARK_TARGET_NAME:String = "SHIP_SKILL_SPEARHEAD_MARK_TARGET";
      
      public static const SHIP_SKILL_SPEARHEAD_DOUBLE_MINIMAP_NAME:String = "SHIP_SKILL_SPEARHEAD_DOUBLE_MINIMAP";
      
      private static var effectClassMap:Object = {};
      
      effectClassMap[InGameCatalog.SHIP_ABILITY_SOLACE_INSTANT_HEAL] = SolaceEffect;
      effectClassMap[InGameCatalog.SHIP_ABILITY_SOLACE_PLUS_INSTANT_HEAL_PLUS] = SolaceEffect;
      effectClassMap[InGameCatalog.SHIP_ABILITY_DIMINISHER_WEAKEN_SHIELDS] = DiminischerEffect;
      effectClassMap[InGameCatalog.SHIP_ABILITY_SENTINEL_FORTRESS] = SentinelEffect;
      effectClassMap[InGameCatalog.SHIP_ABILITY_SPECTRUM_PRISMATIC_SHIELDING] = SpectrumEffect;
      effectClassMap[InGameCatalog.SHIP_ABILITY_VENOM_SINGULARITY] = VenomEffect;
      effectClassMap[InGameCatalog.SHIP_ABILITY_LIGHTNING_AFTERBURNER] = SpeedBuffEffect;
      
      public function AbilityNames()
      {
         super();
      }
      
      public static function getEffectIDByCode(param1:int) : int
      {
         if(effectIDMap == null)
         {
            initEffectIDMap();
         }
         return effectIDMap[param1];
      }
      
      private static function initEffectIDMap() : void
      {
         effectIDMap = [];
         effectIDMap[InGameCatalog.SHIP_ABILITY_SOLACE_INSTANT_HEAL] = EffectIDList.SOLACE_EFFECT;
         effectIDMap[InGameCatalog.SHIP_ABILITY_SOLACE_PLUS_INSTANT_HEAL_PLUS] = EffectIDList.SOLACE_EFFECT;
         effectIDMap[InGameCatalog.SHIP_ABILITY_DIMINISHER_WEAKEN_SHIELDS] = EffectIDList.DIMINISHER_EFFECT;
         effectIDMap[InGameCatalog.SHIP_ABILITY_SENTINEL_FORTRESS] = EffectIDList.SENTINEL_EFFECT;
         effectIDMap[InGameCatalog.SHIP_ABILITY_SPECTRUM_PRISMATIC_SHIELDING] = EffectIDList.SPECTRUM_EFFECT;
         effectIDMap[InGameCatalog.SHIP_ABILITY_VENOM_SINGULARITY] = EffectIDList.VENOM_EFFECT;
         effectIDMap[InGameCatalog.SHIP_ABILITY_LIGHTNING_AFTERBURNER] = EffectIDList.SPEED_BUFF_EFFECT;
      }
      
      public static function getEffectClassByName(param1:int) : Class
      {
         return effectClassMap[param1];
      }
   }
}

