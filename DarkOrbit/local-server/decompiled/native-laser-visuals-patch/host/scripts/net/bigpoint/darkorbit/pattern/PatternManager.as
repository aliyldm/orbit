package net.bigpoint.darkorbit.pattern
{
   import com.bigpoint.utils.PointLite;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioMultiPattern;
   import net.bigpoint.darkorbit.audio.AudioPattern;
   import net.bigpoint.darkorbit.map.model.env.mine.MinePulsePattern;
   import net.bigpoint.darkorbit.map.model.ship.drones.DroneDesign;
   import net.bigpoint.darkorbit.map.model.ship.drones.DroneFormation;
   import net.bigpoint.darkorbit.map.model.ship.patterns.EnginePositionPattern;
   import net.bigpoint.darkorbit.map.model.ship.patterns.EngineSmokePattern;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ExpansionPattern;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   import net.bigpoint.darkorbit.map.view3D.display3D.ship.drones.DroneRotationGroup;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   import net.bigpoint.darkorbit.mvc.targetedOffersWindow.model.TargetedOfferPattern;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class PatternManager
   {
      
      public static var preloaderPatterns:Array;
      
      public static var colorPatterns:Array;
      
      public static var videoWindowColorPatterns:Array;
      
      public static var expansionClasses:Array;
      
      public static var planetPatterns:Array;
      
      public static var laserClasses:Array;
      
      public static var shieldClasses:Array;
      
      public static var laserDefinitions:Array;
      
      public static var rocketClasses:Array;
      
      public static var backgroundPatterns:Array;
      
      public static var backgroundMaskPatterns:Array;
      
      public static var musicPatterns:Array;
      
      public static var pyroClasses:Array;
      
      public static var bossShieldPatterns:Array;
      
      public static var enginePatterns:Array;
      
      public static var engineSmokePatterns:Array;
      
      public static var rocketSmokePatterns:Array;
      
      public static var enginePositionClasses:Array;
      
      private static var _robotPatternsByLootId:Object;
      
      public static var soundPatterns:Array;
      
      public static var boosterPatterns:Array;
      
      public static var orePatterns:Array;
      
      public static var minePulsePatterns:Array;
      
      public static var hitpointColorPatterns:Array;
      
      public static var shockwavePatterns:Array;
      
      public static var fireworkPatterns:Array;
      
      public static var achievementPatterns:Array;
      
      public static var techDefaults:Array;
      
      public static var petGearPatterns:Array;
      
      public static var petBuffPatterns:Array;
      
      public static var effectPatterns:Array;
      
      public static var poizonePatterns:Vector.<POIPattern>;
      
      private static var _robotSparksPatternsBySkillLevel:Object;
      
      private static var _fireworkDesciptorPatterns:Array = new Array();
      
      private static var _highPrioPreloadList:Dictionary = new Dictionary();
      
      private static var preloaderTypeID:int = 0;
      
      public static const shipPatterns:Array = [];
      
      public static const shipPatternsByShipId:Array = [];
      
      public static const shipPatternsByNpcId:Array = [];
      
      public static var portalAssetPatterns:Dictionary = new Dictionary();
      
      public static var bannerAdPatterns:Dictionary = new Dictionary();
      
      public static var targetedOffersPatterns:Dictionary = new Dictionary();
      
      private static var _iconPattern:Dictionary = new Dictionary();
      
      public function PatternManager()
      {
         super();
      }
      
      public static function parsePatterns(param1:XML) : void
      {
         parsePreloaderPatterns(param1);
         parseDroneFormationPatterns(param1);
         parseDroneFormationPatterns3D(param1);
         parseShipPatterns(param1);
         parseExpansionPatterns(param1);
         parsePortalAssetPatterns(param1);
         parseFireworkPatterns(param1);
         parseLaserDefinitions(param1.patterns.laserDefinitions as XMLList);
         parseLaserPatterns(param1);
         parseShieldPatterns(param1);
         parseRocketPatterns(param1);
         parsePlanetPatterns(param1);
         parseBackgroundPatterns(param1);
         parseBackgroundMaskPatterns(param1);
         parseMusicPatterns(param1);
         parseColorPatterns(param1);
         parseVideoWindowColorPatterns(param1);
         parsePyroPatterns(param1);
         parsePublicWorldBossShieldEffectPartterns(param1);
         parseShockwavePatterns(param1);
         parseEnginePatterns(param1);
         parseEngineSmokePatterns(param1);
         parseRocketSmokePatterns(param1);
         parseEnginePositionPatterns(param1);
         parseRobotPatterns(param1);
         parseSoundPatterns(param1);
         parseBoosterPatterns(param1);
         parseOrePatterns(param1);
         parseMinePulsePatterns(param1);
         parseHitpointColorPatterns(param1);
         parseAchievementPatterns(param1);
         parseBannerAdPatterns(param1);
         parsetargetedOffersPatterns(param1);
         parseTechDefaults(param1);
         parseGearPatterns(param1);
         parseBuffPatterns(param1);
         parseEffectPatterns(param1);
         parsePoizonePatterns(param1);
         parseHighPrioPreloadList(param1);
         parseIconPattern(param1);
      }
      
      public static function parseCustomLaserPatterns(param1:XML, param2:XMLList) : void
      {
         parseLaserDefinitions(param2);
         parseLaserPatterns(param1);
      }
      
      private static function parseIconPattern(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc2_:XMLList = param1.child("patterns").child("hudIcons").child("hudIcon");
         for each(_loc3_ in _loc2_)
         {
            _iconPattern[_loc3_.attribute("id").toString()] = new FullResourcePattern(-1,_loc3_.attribute("srcKey"),_loc3_.attribute("resKey"));
         }
      }
      
      private static function parseHighPrioPreloadList(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:Vector.<String> = null;
         var _loc5_:XML = null;
         var _loc2_:XMLList = param1.child("patterns").child("preloadLists").child("pack");
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = new Vector.<String>();
            for each(_loc5_ in _loc3_.child("item"))
            {
               _loc4_.push(_loc5_.text());
            }
            _highPrioPreloadList[_loc3_.attribute("id").toString()] = _loc4_;
         }
      }
      
      private static function parsePoizonePatterns(param1:XML) : void
      {
         var _loc2_:POIPattern = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:XML = null;
         poizonePatterns = new Vector.<POIPattern>();
         for each(_loc12_ in param1.patterns.poizones.poizone)
         {
            _loc3_ = int(_loc12_.@id);
            _loc4_ = _loc12_.@designType;
            _loc4_ = _loc12_.@designType;
            if(_loc12_.attribute("useCustomShader"))
            {
               _loc9_ = ParserUtility.parseBooleanFromString(_loc12_.@useCustomShader);
            }
            else
            {
               _loc9_ = false;
            }
            if(_loc12_.attribute("radiusOffset"))
            {
               _loc10_ = parseInt(_loc12_.attribute("radiusOffset"));
            }
            else
            {
               _loc10_ = 0;
            }
            switch(_loc4_)
            {
               case POIPattern.DESIGN_TYPE_BACKGROUND:
                  _loc5_ = _loc12_.@backgroundID;
                  _loc6_ = _loc12_.@simpleBackgroundID;
                  _loc2_ = new POIBackgroundPattern(_loc3_,_loc4_,int(_loc5_),int(_loc6_),_loc9_,int(_loc12_.@size),String(_loc12_.@additionalAssetId),Number(_loc12_.@radiusVisualMultiplier) || 1);
                  break;
               case POIPattern.DESIGN_TYPE_TEXTURE:
                  _loc7_ = _loc12_.@resKey;
                  _loc8_ = ParserUtility.parseBooleanFromString(_loc12_.@repeat);
                  _loc2_ = new POITexturePattern(_loc3_,_loc4_,_loc7_,_loc8_,_loc9_,int(_loc12_.@size),String(_loc12_.@additionalAssetId),Number(_loc12_.@radiusVisualMultiplier) || 1);
                  break;
               case POIPattern.DESIGN_TYPE_SIMPLE:
               default:
                  _loc2_ = new POIBackgroundPattern(_loc3_,_loc4_,0,int(_loc6_),_loc9_,int(_loc12_.@size),String(_loc12_.@additionalAssetId),Number(_loc12_.@radiusVisualMultiplier) || 1);
            }
            _loc2_.radiusOffset = _loc10_;
            while(_loc3_ > poizonePatterns.length)
            {
               poizonePatterns[poizonePatterns.length] = null;
            }
            poizonePatterns[_loc3_] = _loc2_;
         }
      }
      
      private static function parseEffectPatterns(param1:XML) : void
      {
         var _loc2_:EffectPattern = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:XML = null;
         effectPatterns = [];
         for each(_loc7_ in param1.patterns.effects.effect)
         {
            _loc3_ = int(_loc7_.@id);
            _loc5_ = _loc7_.@resKey;
            if(_loc7_.attribute("radius").length() > 0)
            {
               _loc4_ = int(_loc7_.@radius);
               _loc2_ = new EffectPattern(_loc3_,_loc5_,_loc4_);
            }
            else
            {
               _loc2_ = new EffectPattern(_loc3_,_loc5_);
            }
            if(_loc7_.attribute("scale").length() > 0)
            {
               _loc2_.scale = Number(_loc7_.@scale);
            }
            if(_loc7_.attribute("alpha").length() > 0)
            {
               _loc2_.initAlpha = Number(_loc7_.@alpha);
            }
            if(_loc7_.attribute("loop").length() > 0)
            {
               _loc2_.isLoop = ParserUtility.parseBooleanFromString(_loc7_.@loop);
            }
            if(_loc7_.attribute("fps").length() > 0)
            {
               _loc2_.FPS = int(_loc7_.@fps);
            }
            if(_loc7_.attribute("scale2D").length() > 0)
            {
               _loc2_.scale2D = Number(_loc7_.@scale2D);
            }
            if(_loc7_.attribute("soundID").length() > 0)
            {
               _loc2_.soundId = Number(_loc7_.@soundID);
            }
            effectPatterns[_loc3_] = _loc2_;
         }
      }
      
      private static function parseBuffPatterns(param1:XML) : void
      {
         var _loc2_:BuffPattern = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:XML = null;
         petBuffPatterns = [];
         for each(_loc7_ in param1.patterns.petBuffs.buff)
         {
            _loc3_ = int(_loc7_.@id);
            _loc4_ = _loc7_.@resKey;
            _loc5_ = _loc7_.@languageKey;
            _loc6_ = getEffectID(String(_loc7_.@effect));
            _loc2_ = new BuffPattern(_loc3_,_loc4_,_loc5_,_loc6_);
            petBuffPatterns[_loc3_] = _loc2_;
         }
      }
      
      private static function getEffectID(param1:String) : int
      {
         var _loc2_:int = 0;
         if(param1 == "")
         {
            _loc2_ = -1;
         }
         else
         {
            _loc2_ = int(param1);
         }
         return _loc2_;
      }
      
      private static function parseGearPatterns(param1:XML) : void
      {
         var _loc2_:GearPattern = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc12_:XML = null;
         petGearPatterns = [];
         var _loc10_:String = param1.patterns.petgears.@normalState;
         var _loc11_:String = param1.patterns.petgears.@activeState;
         for each(_loc12_ in param1.patterns.petgears.gear)
         {
            _loc3_ = int(_loc12_.@id);
            _loc7_ = _loc12_.@effectTarget;
            _loc8_ = _loc12_.@targetList;
            _loc9_ = _loc12_.@suffix;
            _loc6_ = BPLocale.getItem("pet_gear_" + _loc12_.@name);
            _loc5_ = _loc12_.@resKey;
            _loc4_ = getEffectID(_loc12_.@effect);
            _loc2_ = new GearPattern(_loc3_,_loc6_,_loc5_,_loc4_,_loc10_,_loc11_,_loc8_,_loc9_);
            petGearPatterns[_loc3_] = _loc2_;
         }
      }
      
      private static function parsePreloaderPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:PreloadPattern = null;
         preloaderPatterns = [];
         for each(_loc2_ in param1.patterns.preloadedResources.resource)
         {
            _loc3_ = _loc2_.@resKey;
            _loc4_ = false;
            if(_loc2_.@precache.length() > 0)
            {
               _loc4_ = Boolean(int(_loc2_.@precache));
            }
            _loc5_ = new PreloadPattern(preloaderTypeID,_loc3_,_loc4_);
            var _loc8_:Number;
            preloaderPatterns[_loc8_ = preloaderTypeID++] = _loc5_;
         }
      }
      
      private static function parseBannerAdPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc10_:BannerAdPattern = null;
         for each(_loc2_ in param1.patterns.bannerads.bannerad)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = String(_loc2_.@baseKey);
            _loc5_ = String(_loc2_.@enumName);
            _loc6_ = int(_loc2_.@assetCount);
            _loc7_ = String(_loc2_.@url);
            _loc8_ = null;
            if(String(_loc2_.@jsFunctionName).length)
            {
               _loc8_ = _loc2_.@jsFunctionName;
            }
            _loc9_ = _loc2_.@showWindowTitle == "true";
            _loc10_ = new BannerAdPattern(_loc3_,_loc4_,_loc5_,_loc7_,_loc8_,_loc9_);
            if(_loc2_.@footer.length() > 0)
            {
               _loc10_.footerKey = "bannerad_footer_" + String(_loc2_.@footer);
            }
            bannerAdPatterns[_loc5_] = _loc10_;
         }
      }
      
      private static function parsetargetedOffersPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:TargetedOfferPattern = null;
         for each(_loc2_ in param1.patterns.targetedOffers.targetedOffer)
         {
            _loc3_ = _loc2_.@id;
            _loc4_ = String(_loc2_.@gfxKey);
            _loc5_ = new TargetedOfferPattern(_loc3_,_loc4_);
            targetedOffersPatterns[_loc3_] = _loc5_;
         }
      }
      
      private static function parseTechDefaults(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:TechDefault = null;
         techDefaults = [];
         for each(_loc2_ in param1.patterns.techs.tech)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = String(_loc2_.@linkageID);
            _loc5_ = new TechDefault(_loc3_,_loc4_);
            if(_loc2_.@hasDuration.length() > 0)
            {
               _loc5_.hasDuration = ParserUtility.parseBooleanFromString(String(_loc2_.@hasDuration));
            }
            techDefaults[_loc3_] = _loc5_;
         }
      }
      
      private static function parseBoosterPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         boosterPatterns = [];
         for each(_loc2_ in param1.patterns.boosters.booster)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = int(_loc2_.@infoFieldID);
            _loc5_ = _loc2_.@resKey;
            _loc6_ = _loc2_.@barKey;
            boosterPatterns[int(_loc3_)] = new BoosterPattern(_loc3_,_loc4_,_loc5_,_loc6_);
         }
      }
      
      private static function parseHitpointColorPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         hitpointColorPatterns = [];
         for each(_loc2_ in param1.hitpointColors.hitpointColor)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = int("0x" + _loc2_.@code);
            hitpointColorPatterns[int(_loc3_)] = _loc4_;
         }
      }
      
      private static function parseOrePatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:OrePattern = null;
         orePatterns = [];
         for each(_loc2_ in param1.patterns.ores.ore)
         {
            _loc3_ = int(_loc2_.@type);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = _loc2_.@languageKey;
            _loc6_ = new OrePattern(_loc3_,_loc4_,_loc5_);
            if(_loc2_.@refiner.length() > 0)
            {
               _loc6_.parseRefiners(_loc2_.@refiner);
            }
            orePatterns[int(_loc3_)] = _loc6_;
         }
      }
      
      private static function parseAchievementPatterns(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:StartUpQuestPattern = null;
         achievementPatterns = [];
         var _loc2_:int = 0;
         for each(_loc3_ in param1.patterns.achievements.achievement)
         {
            _loc4_ = int(_loc3_.@id);
            _loc2_++;
            _loc5_ = _loc3_.@languageKey;
            _loc6_ = new StartUpQuestPattern(_loc4_,_loc5_);
            achievementPatterns[int(_loc4_)] = _loc6_;
         }
         StartUpQuestPattern.MAX_ID = _loc2_;
      }
      
      private static function parseShipPatterns(param1:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc5_:ShipPattern = null;
         var _loc2_:XMLList = param1.child("patterns").child("ships").child("ship");
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = String(_loc3_.@type);
            _loc5_ = new ShipPattern(_loc4_,int(_loc3_.@shipId),int(_loc3_.@npcId),String(_loc3_.@name));
            shipPatterns[_loc4_] = _loc5_;
            shipPatternsByShipId[_loc5_.shipId] = _loc5_;
            shipPatternsByNpcId[_loc5_.npcId] = _loc5_;
            setShipPatternAttributes(_loc3_,_loc5_);
            createShipDesignPatterns(_loc3_,_loc5_);
         }
      }
      
      private static function setShipPatternAttributes(param1:XML, param2:ShipPattern) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:Vector.<FullResourcePattern> = null;
         var _loc5_:XML = null;
         if(param1.attribute("shipId").length() > 0)
         {
            param2.shipId = int(param1.@shipId);
         }
         if(param1.attribute("npcId").length() > 0)
         {
            param2.npcId = int(param1.@npcId);
         }
         if(param1.attribute("name").length() > 0)
         {
            param2.name = String(param1.@name);
         }
         if(param1.attribute("icon").length() > 0)
         {
            param2.icon = String(param1.@icon);
         }
         if(param1.attribute("type").length() > 0)
         {
            param2.typeId = param1.attribute("type");
         }
         if(param1.attribute("class").length() > 0)
         {
            param2.classId = param1.attribute("class");
         }
         param2.comment = param1.attribute("comment");
         param2.assetId = param2.typeId;
         if(param1.attribute("loopPlay").length() > 0)
         {
            param2.setPlayLoop(ParserUtility.parseBooleanFromString(param1.@loopPlay));
         }
         if(param1.attribute("laserClassID").length() > 0)
         {
            param2.laserClassID = int(param1.@laserClassID);
         }
         if(param1.attribute("rocketClassID").length() > 0)
         {
            param2.rocketClassID = int(param1.@rocketClassID);
         }
         if(param1.attribute("expansionClassID").length() > 0)
         {
            param2.expansionClassID = String(param1.@expansionClassID);
         }
         if(param1.attribute("explodeTypeID").length() > 0)
         {
            param2.explodeTypeID = int(param1.@explodeTypeID);
         }
         if(param1.attribute("engineTypeID").length() > 0)
         {
            param2.setEngineTypeID(int(param1.@engineTypeID));
         }
         if(param1.attribute("engineSmokeID").length() > 0)
         {
            param2.engineSmokeID = int(param1.@engineSmokeID);
         }
         if(param1.attribute("enginePositionClassID").length() > 0)
         {
            param2.setEnginePositionClassID(String(param1.@enginePositionClassID));
         }
         if(param1.attribute("clickRadius").length() > 0)
         {
            param2.clickRadius = int(param1.@clickRadius);
         }
         if(param1.attribute("clickPriority").length() > 0)
         {
            param2.clickPriority = int(param1.@clickPriority);
         }
         if(param1.attribute("clickOffsetX").length() > 0)
         {
            param2.setClickOffsetX(int(param1.@clickOffsetX));
         }
         if(param1.attribute("clickOffsetY").length() > 0)
         {
            param2.setClickOffsetY(int(param1.@clickOffsetY));
         }
         if(param1.attribute("rotatable").length() > 0)
         {
            param2.rotatable = ParserUtility.parseBooleanFromString(param1.@rotatable);
         }
         if(param1.attribute("effect").length() > 0)
         {
            param2.effects = String(param1.@effect).split(",");
         }
         if(param1.attribute("podType").length() > 0)
         {
            param2.podType = int(param1.@podType);
         }
         if(param1.attribute("isLegendaryEventNPC").length() > 0)
         {
            param2.isLegendaryEventNPC = ParserUtility.parseBooleanFromString(param1.@isLegendaryEventNPC);
         }
         if(param1.attribute("minimapIcon").length() > 0)
         {
            param2.minimapIcon = param1.@minimapIcon;
         }
         if(param1.attribute("engine3DEffect").length() > 0)
         {
            param2.engine3DRes = param1.@engine3DEffect;
         }
         if(param1.child("resources") != null)
         {
            _loc3_ = param1.child("resources").child("podOverlay");
            if(_loc3_.length() > 0 && param2.podType != InGameCatalog.POD_TYPE_NONE)
            {
               _loc4_ = new Vector.<FullResourcePattern>();
               for each(_loc5_ in _loc3_)
               {
                  _loc4_.push(new FullResourcePattern(int(_loc5_.attribute("factionId")),_loc5_.attribute("srcKey"),_loc5_.attribute("resKey")));
               }
               param2.podResPatterns = _loc4_;
            }
         }
      }
      
      private static function createShipDesignPatterns(param1:XML, param2:ShipPattern) : void
      {
         var _loc4_:ShipPattern = null;
         var _loc5_:XML = null;
         var _loc3_:XMLList = param1.child("designs").children();
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = param2.clone();
            setShipPatternAttributes(_loc5_,_loc4_);
            shipPatterns[_loc4_.getPatternID()] = _loc4_;
            shipPatternsByShipId[_loc4_.shipId] = _loc4_;
            shipPatternsByNpcId[_loc4_.npcId] = _loc4_;
         }
      }
      
      private static function parsePortalAssetPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:ResourcePattern = null;
         for each(_loc2_ in param1.patterns.portalAssets.portalAsset)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = new ResourcePattern(_loc3_,_loc4_);
            portalAssetPatterns[_loc3_] = _loc5_;
         }
      }
      
      private static function parseFireworkPatterns(param1:XML) : void
      {
         var _loc2_:FireworkClassPatter = null;
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc5_:Vector.<FireworkPattern> = null;
         var _loc6_:XML = null;
         var _loc7_:String = null;
         var _loc8_:Dictionary = null;
         var _loc9_:XML = null;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         fireworkPatterns = [];
         for each(_loc3_ in param1.patterns.fireworks.type)
         {
            _loc4_ = _loc3_.attribute("id");
            _loc5_ = new Vector.<FireworkPattern>();
            for each(_loc6_ in _loc3_.child("firework"))
            {
               _loc7_ = String(_loc6_.attribute("id"));
               _loc8_ = new Dictionary();
               for each(_loc9_ in _loc6_.children())
               {
                  _loc10_ = int(String(_loc9_.localName()).split("color").join(""));
                  _loc11_ = String(_loc9_.toString());
                  _loc8_[_loc10_] = _loc11_;
               }
               _loc5_.push(new FireworkPattern(_loc7_,_loc8_));
            }
            _loc2_ = new FireworkClassPatter(_loc4_,_loc5_);
            fireworkPatterns[_loc4_] = _loc2_;
         }
         parseFireWorkDescriptors(param1);
      }
      
      private static function parseFireWorkDescriptors(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:FireworkDescriptorPattern = null;
         for each(_loc2_ in param1.patterns.fireworkDescriptors.fireworkDescriptor)
         {
            _loc3_ = _loc2_.attribute("firework");
            _loc4_ = String(_loc2_.attribute("order")).split(",");
            _loc5_ = new FireworkDescriptorPattern(_loc3_,_loc4_);
            _fireworkDesciptorPatterns[_loc3_] = _loc5_;
         }
      }
      
      private static function parseMinePulsePatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         minePulsePatterns = [];
         for each(_loc2_ in param1.patterns.minePulseColors.minePulseColor)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = uint("0x" + _loc2_.@color);
            _loc6_ = Number(_loc2_.@alpha);
            _loc7_ = Number(_loc2_.@scale);
            minePulsePatterns[_loc3_] = new MinePulsePattern(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,String(_loc2_.@resKey3D));
         }
      }
      
      private static function parseLaserDefinitions(param1:XMLList) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:LaserPattern = null;
         laserDefinitions = [];
         for each(_loc2_ in param1.laser)
         {
            _loc3_ = int(_loc2_.@salvoID);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = new LaserPattern(_loc3_,_loc4_);
            _loc5_.xml = _loc2_;
            if(_loc2_.@soundID.length() > 0)
            {
               _loc5_.setSoundID(int(_loc2_.@soundID));
            }
            if(_loc2_.@laserLength.length() > 0)
            {
               _loc5_.laserLength = int(_loc2_.@laserLength);
            }
            if(_loc2_.@absorber.length() > 0)
            {
               _loc5_.setAbsorber(ParserUtility.parseBooleanFromString(_loc2_.@absorber));
            }
            if(_loc2_.@speed.length() > 0)
            {
               _loc5_.setSpeed(_loc2_.@speed);
            }
            if(_loc2_.@playLoop.length() > 0)
            {
               _loc5_.setPlayLoop(ParserUtility.parseBooleanFromString(_loc2_.@playLoop));
            }
            if(_loc2_.@playLoopRotated.length() > 0)
            {
               _loc5_.setPlayLoopRotated(ParserUtility.parseBooleanFromString(_loc2_.@playLoopRotated));
            }
            if(_loc2_.@skillResKey.length() > 0)
            {
               _loc5_.skillResKey = _loc2_.@skillResKey;
            }
            if(_loc2_.@ignoreLaserPoints.length() > 0)
            {
               _loc5_.ignoreLaserPoints = _loc2_.@ignoreLaserPoints;
            }
            if(_loc2_.@muzzleFlashResKey.length() > 0)
            {
               _loc5_.muzzleFlashResKey = _loc2_.@muzzleFlashResKey;
            }
            if(_loc2_.@lightColor.length() > 0)
            {
               _loc5_.lightColor = parseInt("0x" + _loc2_.@lightColor);
            }
            if(_loc2_.@laserType.length() > 0)
            {
               _loc5_.laserType = _loc2_.@laserType;
            }
            if(_loc2_.attribute("mcWidth").length() > 0)
            {
               _loc5_.mcWidth = _loc2_.@mcWidth;
            }
            if(_loc2_.attribute("scale").length() > 0)
            {
               _loc5_.scale = _loc2_.@scale;
            }
            laserDefinitions[_loc3_] = _loc5_;
         }
      }
      
      private static function parseLaserPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:LaserSalvoPattern = null;
         var _loc6_:XML = null;
         laserClasses = [];
         for each(_loc2_ in param1.patterns.lasers.laser)
         {
            _loc3_ = int(_loc2_["class"]);
            _loc4_ = int(_loc2_.@type);
            if(!laserClasses[_loc3_])
            {
               laserClasses[_loc3_] = [];
            }
            _loc5_ = new LaserSalvoPattern(_loc3_,_loc4_);
            for each(_loc6_ in _loc2_.salvo)
            {
               _loc5_.addLaserSalvo(laserDefinitions[_loc6_.@salvoID]);
            }
            laserClasses[_loc3_][_loc4_] = _loc5_;
         }
      }
      
      private static function parseShieldPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:ShieldPattern = null;
         shieldClasses = [];
         for each(_loc2_ in param1.patterns.shields.shield)
         {
            _loc3_ = _loc2_.@resKey;
            _loc4_ = new ShieldPattern(_loc3_);
            if(_loc2_.@resKeySkilled.length() > 0)
            {
               _loc4_.resKeySkilled = _loc2_.@resKeySkilled;
            }
            else
            {
               _loc4_.resKeySkilled = _loc3_;
            }
            if(_loc2_.@scale.length() > 0)
            {
               _loc4_.scale = Number(_loc2_.@scale);
            }
            shieldClasses[_loc2_.@type] = _loc4_;
         }
      }
      
      private static function parsePublicWorldBossShieldEffectPartterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         bossShieldPatterns = [];
         for each(_loc2_ in param1.patterns.bossShield.shield)
         {
            _loc3_ = parseInt(_loc2_.@level);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = _loc2_.@particleFilename;
            bossShieldPatterns[_loc3_] = {
               "resKey":_loc4_,
               "particleFilename":_loc5_
            };
         }
      }
      
      private static function parsePyroPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:ExplosionPattern = null;
         pyroClasses = [];
         for each(_loc2_ in param1.patterns.pyroEffects.pyroEffect)
         {
            _loc3_ = int(_loc2_["class"]);
            if(!pyroClasses[_loc3_])
            {
               pyroClasses[_loc3_] = [];
            }
            _loc4_ = int(_loc2_.@id);
            _loc5_ = _loc2_.@resKey;
            _loc6_ = new ExplosionPattern(_loc3_,_loc4_,_loc5_,_loc2_.@has3D != "false");
            if(_loc2_.@soundID.length() > 0)
            {
               _loc6_.setSoundID(int(_loc2_.@soundID));
            }
            if(_loc2_.@useBitmapClip.length() > 0)
            {
               _loc6_.useBitmapClip = ParserUtility.parseBooleanFromString(_loc2_.@useBitmapClip);
            }
            if(_loc2_.@precache.length() > 0)
            {
               _loc6_.precache = ParserUtility.parseBooleanFromString(_loc2_.@precache);
            }
            if(_loc2_.@shockwaveId.length() > 0)
            {
               _loc6_.shockwaveId = int(_loc2_.@shockwaveId);
            }
            if(_loc2_.@rotatable.length() > 0)
            {
               _loc6_.rotatable = ParserUtility.parseBooleanFromString(_loc2_.@rotatable);
            }
            else
            {
               _loc6_.rotatable = true;
            }
            if(_loc2_.@soundID.length() > 0)
            {
               _loc6_.setSoundID(int(_loc2_.@soundID));
            }
            if(_loc2_.@scale.length() > 0)
            {
               _loc6_.scale = Number(_loc2_.@scale);
            }
            pyroClasses[_loc3_][_loc4_] = _loc6_;
         }
      }
      
      private static function parseShockwavePatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:ShockwavePattern = null;
         shockwavePatterns = [];
         for each(_loc2_ in param1.patterns.shockwaves.shockwave)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = int(_loc2_.@soundID);
            _loc6_ = new ShockwavePattern(_loc3_,_loc4_);
            _loc6_.setSoundID(_loc5_);
            if(_loc2_.@radius.length() > 0)
            {
               _loc6_.radius = _loc2_.@radius;
            }
            if(_loc2_.@duration.length() > 0)
            {
               _loc6_.duration = _loc2_.@duration;
            }
            if(_loc2_.@beginScale.length() > 0)
            {
               _loc6_.beginScale = _loc2_.@beginScale;
            }
            if(_loc2_.@endScale.length() > 0)
            {
               _loc6_.endScale = _loc2_.@endScale;
            }
            if(_loc2_.@maxShockwaves.length() > 0)
            {
               _loc6_.maxShockwaves = _loc2_.@maxShockwaves;
            }
            if(_loc2_.@shakeScreen.length() > 0)
            {
               _loc6_.shakeScreen = ParserUtility.parseBooleanFromString(_loc2_.@shakeScreen);
            }
            shockwavePatterns[_loc3_] = _loc6_;
         }
      }
      
      private static function parseDroneFormationPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Number = NaN;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc12_:XML = null;
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc15_:Array = null;
         var _loc16_:String = null;
         var _loc17_:int = 0;
         DroneFormation.standardFormations = new Dictionary();
         for each(_loc2_ in param1.patterns.drones.formations.formation)
         {
            _loc4_ = _loc2_.display2D.length() > 0 ? _loc2_.display2D[0] : _loc2_;
            _loc5_ = int(_loc2_.@id);
            _loc6_ = _loc2_.@name;
            _loc7_ = Number(_loc4_.scale);
            _loc8_ = _loc4_.positionsList.@data;
            _loc9_ = new Array();
            for each(_loc10_ in _loc8_.split(";"))
            {
               _loc13_ = _loc10_.split(",");
               _loc9_.push(new PointLite(int(_loc13_[0]),int(_loc13_[1]),_loc13_.length > 2 ? int(_loc13_[2]) : 0));
            }
            _loc11_ = new Array();
            for each(_loc12_ in _loc4_.usedPositions)
            {
               _loc14_ = int(_loc12_.@droneCount);
               _loc15_ = new Array();
               _loc16_ = _loc12_.@positionIDlist;
               if(_loc16_ != "")
               {
                  for each(_loc17_ in _loc16_.split(","))
                  {
                     _loc15_.push(_loc17_);
                  }
               }
               _loc11_[_loc14_] = _loc15_;
            }
            DroneFormation.standardFormations[_loc5_] = new DroneFormation(_loc9_,_loc11_,_loc7_,_loc5_,_loc6_);
         }
         for each(_loc3_ in param1.patterns.drones.designs.design)
         {
            DroneDesign.registerDesign(int(_loc3_.@id),new DroneDesign(_loc3_.@assetId,uint(_loc3_.@color)));
         }
      }
      
      private static function parseDroneFormationPatterns3D(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         var _loc12_:XML = null;
         var _loc13_:Array = null;
         var _loc14_:XML = null;
         var _loc15_:Array = null;
         var _loc16_:int = 0;
         var _loc17_:Array = null;
         var _loc18_:int = 0;
         var _loc19_:Array = null;
         var _loc20_:int = 0;
         var _loc21_:DroneRotationGroup = null;
         for each(_loc2_ in param1.patterns.drones.formations.formation)
         {
            if(_loc2_.display3D.length() > 0)
            {
               _loc3_ = _loc2_.display3D[0];
               _loc4_ = int(_loc2_.@id);
               _loc5_ = _loc2_.@name;
               _loc6_ = Number(_loc3_.scale);
               _loc7_ = _loc3_.positionsList.@data;
               _loc8_ = new Array();
               for each(_loc9_ in _loc7_.split(";"))
               {
                  _loc15_ = _loc9_.split(",");
                  _loc8_.push(new PointLite(int(_loc15_[0]),int(_loc15_[1]),_loc15_.length > 2 ? int(_loc15_[2]) : 0));
               }
               _loc10_ = new Array();
               for each(_loc12_ in _loc3_.usedPositions)
               {
                  _loc16_ = int(_loc12_.@droneCount);
                  _loc17_ = new Array();
                  _loc11_ = _loc12_.@positionIDlist;
                  if(_loc11_ != "")
                  {
                     for each(_loc18_ in _loc11_.split(","))
                     {
                        _loc17_.push(_loc18_);
                     }
                  }
                  _loc10_[_loc16_] = _loc17_;
               }
               _loc13_ = new Array();
               for each(_loc14_ in _loc3_.rotationGroup)
               {
                  _loc19_ = new Array();
                  _loc11_ = _loc14_.@droneIds;
                  for each(_loc20_ in _loc11_.split(","))
                  {
                     _loc19_.push(Number(_loc20_));
                  }
                  _loc21_ = new DroneRotationGroup(_loc19_,_loc14_);
                  _loc13_.push(_loc21_);
               }
               DroneFormation.standardFormations3D[_loc4_] = new DroneFormation(_loc8_,_loc10_,_loc6_,_loc4_,_loc5_);
               DroneFormation.standardFormations3D[_loc4_].rotationGroups = _loc13_;
            }
         }
      }
      
      private static function parseExpansionPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:ExpansionPattern = null;
         var _loc5_:Object = null;
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:int = 0;
         var _loc9_:Vector.<Vector.<String>> = null;
         var _loc10_:XML = null;
         expansionClasses = [];
         for each(_loc2_ in param1.patterns.expansions.expansion)
         {
            _loc3_ = String(_loc2_["class"]);
            if(!expansionClasses[_loc3_])
            {
               expansionClasses[_loc3_] = [];
            }
            _loc5_ = {};
            for each(_loc6_ in _loc2_.positionsList)
            {
               _loc5_[String(_loc6_.@name)] = ParserUtility.parseCommaCoordinatesList(String(_loc6_.@data));
            }
            for each(_loc7_ in _loc2_.stage)
            {
               _loc8_ = int(_loc7_.@id);
               _loc9_ = new Vector.<Vector.<String>>();
               for each(_loc10_ in _loc7_.salvo)
               {
                  _loc9_.push(Vector.<String>(String(_loc10_.@laser).split(",")));
               }
               _loc4_ = new ExpansionPattern(String(_loc7_.@resKey),_loc9_,_loc5_);
               if(Settings.qualityShip.value == Settings.QUALITY_HIGH && Settings.preloadUserShips && _loc4_.resKey.length > 0)
               {
                  _loc4_.setPreload(true);
               }
               expansionClasses[_loc3_][_loc8_] = _loc4_;
            }
            expansionClasses[_loc3_][0] = expansionClasses[_loc3_][1];
         }
      }
      
      private static function parseRocketPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:RocketPattern = null;
         rocketClasses = [];
         for each(_loc2_ in param1.patterns.rockets.rocket)
         {
            _loc3_ = int(_loc2_["class"]);
            if(!rocketClasses[_loc3_])
            {
               rocketClasses[_loc3_] = [];
            }
            _loc4_ = int(_loc2_.@id);
            _loc5_ = _loc2_.@resKey;
            _loc6_ = new RocketPattern(_loc4_,_loc5_);
            if(_loc2_.@soundID.length() > 0)
            {
               _loc6_.setSoundID(int(_loc2_.@soundID));
            }
            rocketClasses[_loc3_][_loc4_] = _loc6_;
         }
      }
      
      private static function parsePlanetPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         planetPatterns = [];
         for each(_loc2_ in param1.patterns.planets.planet)
         {
            _loc3_ = String(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = int(_loc2_.@radius);
            planetPatterns[_loc3_] = new PlanetPattern(_loc3_,_loc4_,_loc5_);
         }
      }
      
      public static function parseMusicPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:AudioPattern = null;
         musicPatterns = [];
         for each(_loc2_ in param1.patterns.music.track)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = new AudioPattern(_loc3_,null);
            _loc5_.resKey = _loc4_;
            if(_loc2_.@volume.length() > 0)
            {
               _loc5_.setVolume(_loc2_.@volume);
            }
            musicPatterns[_loc3_] = _loc5_;
         }
      }
      
      private static function parseBackgroundPatterns(param1:XML) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:Vector.<String> = null;
         var _loc17_:Vector.<String> = null;
         var _loc18_:Vector.<String> = null;
         var _loc19_:Vector.<String> = null;
         var _loc20_:Vector.<String> = null;
         var _loc21_:Vector.<String> = null;
         var _loc22_:Vector.<String> = null;
         var _loc23_:Boolean = false;
         var _loc24_:Boolean = false;
         var _loc25_:Boolean = false;
         var _loc26_:Boolean = false;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:XML = null;
         var _loc32_:String = null;
         var _loc33_:Array = null;
         var _loc34_:String = null;
         var _loc35_:Array = null;
         var _loc36_:String = null;
         var _loc37_:Array = null;
         var _loc38_:String = null;
         var _loc39_:Array = null;
         var _loc40_:String = null;
         var _loc41_:Array = null;
         var _loc42_:String = null;
         var _loc43_:Array = null;
         var _loc44_:String = null;
         var _loc45_:Array = null;
         var _loc46_:Poi3dVO = null;
         var _loc47_:BackgroundPattern = null;
         var _loc48_:uint = 0;
         backgroundPatterns = [];
         for each(_loc31_ in param1.patterns.backgrounds.background)
         {
            _loc2_ = _loc31_.@content;
            _loc3_ = int(_loc31_.@type);
            if(_loc2_ == "resource")
            {
               _loc4_ = _loc31_.@resKey;
               _loc5_ = _loc31_.@resKeyStarling || null;
               _loc6_ = ParserUtility.parseBooleanFromString(_loc31_.@isTiled);
               _loc7_ = _loc31_.@atlasXml || null;
               _loc8_ = ParserUtility.parseBooleanFromString(_loc31_.@isReloadable);
               _loc9_ = int(_loc31_.@tileWidth);
               _loc10_ = int(_loc31_.@tileHeight);
               _loc13_ = _loc31_.@order;
               _loc11_ = int(_loc31_.@width);
               _loc12_ = int(_loc31_.@height);
               _loc14_ = _loc31_.@showInStarlingMode != "false";
               _loc15_ = ParserUtility.parseBooleanFromString(_loc31_.@useOutOfMapBorder);
               _loc32_ = _loc31_.attribute("geometry").toString();
               if(_loc32_ == null)
               {
                  _loc33_ = [];
               }
               else
               {
                  _loc33_ = _loc32_.length > 0 ? _loc32_.split(",") : [];
               }
               _loc16_ = Vector.<String>(_loc33_);
               _loc34_ = _loc31_.attribute("deepTiles").toString();
               if(_loc34_ == null)
               {
                  _loc35_ = [];
               }
               else
               {
                  _loc35_ = _loc34_.split(",");
               }
               _loc17_ = Vector.<String>(_loc35_);
               _loc36_ = _loc31_.attribute("textureDiff").toString();
               if(_loc36_ == null || _loc36_ == "")
               {
                  _loc37_ = [];
               }
               else
               {
                  _loc37_ = _loc36_.split(",");
               }
               _loc18_ = Vector.<String>(_loc37_);
               _loc38_ = _loc31_.attribute("textureNormal").toString();
               if(_loc38_ == null || _loc38_ == "")
               {
                  _loc39_ = [];
               }
               else
               {
                  _loc39_ = _loc38_.split(",");
               }
               _loc19_ = Vector.<String>(_loc39_);
               _loc40_ = _loc31_.attribute("textureSpecular").toString();
               if(_loc40_ == null || _loc40_ == "")
               {
                  _loc41_ = [];
               }
               else
               {
                  _loc41_ = _loc40_.split(",");
               }
               _loc20_ = Vector.<String>(_loc41_);
               _loc42_ = _loc31_.attribute("textureGlow").toString();
               if(_loc42_ == null || _loc42_ == "")
               {
                  _loc43_ = [];
               }
               else
               {
                  _loc43_ = _loc42_.split(",");
               }
               _loc21_ = Vector.<String>(_loc43_);
               _loc44_ = _loc31_.attribute("textureAlphaMask").toString();
               if(_loc44_ == null || _loc44_ == "")
               {
                  _loc45_ = [];
               }
               else
               {
                  _loc45_ = _loc44_.split(",");
               }
               _loc22_ = Vector.<String>(_loc45_);
               _loc23_ = ParserUtility.parseBooleanFromString(_loc31_.@randomGeometryRotation);
               _loc24_ = ParserUtility.parseBooleanFromString(_loc31_.@alphaBlending);
               _loc25_ = _loc31_.@alphaPremultiplied == undefined || ParserUtility.parseBooleanFromString(_loc31_.@alphaPremultiplied);
               _loc26_ = _loc31_.@useLights == undefined || ParserUtility.parseBooleanFromString(_loc31_.@useLights);
               _loc27_ = int(_loc31_.@ySpread);
               _loc28_ = int(_loc31_.@additionalTilesInGrid);
               _loc29_ = Number(Number(_loc31_.@enlargeInnerTilesFactor) || 1);
               _loc30_ = Number(Number(_loc31_.@meshScale) || 1);
               _loc46_ = new Poi3dVO(_loc16_,_loc17_,_loc18_,_loc19_,_loc20_,_loc21_,_loc22_,_loc23_,_loc24_,_loc25_,_loc26_,_loc27_,_loc28_,_loc29_,ParserUtility.parseBooleanFromString(_loc31_.@textureIdIsGeoId),_loc30_);
               _loc47_ = new BackgroundPattern(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc13_,_loc11_,_loc12_,_loc14_,_loc15_,_loc46_);
               _loc47_.offsetX = int(_loc31_.@offsetX);
               _loc47_.offsetY = int(_loc31_.@offsetY);
               backgroundPatterns[_loc3_] = _loc47_;
            }
            else if(_loc2_ == "custom")
            {
               _loc11_ = int(_loc31_.@width);
               _loc12_ = int(_loc31_.@height);
               _loc48_ = uint("0x" + _loc31_.@color);
               backgroundPatterns[_loc3_] = new CustomBackgroundPattern(_loc3_,_loc11_,_loc12_,_loc48_);
            }
         }
      }
      
      private static function parseBackgroundMaskPatterns(param1:XML) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:XML = null;
         backgroundMaskPatterns = [];
         for each(_loc4_ in param1.patterns.backgroundMasks.backgroundMask)
         {
            _loc2_ = int(_loc4_.@type);
            _loc3_ = _loc4_.@resKey;
            backgroundMaskPatterns[_loc2_] = new ResourcePattern(_loc2_,_loc3_);
         }
      }
      
      private static function parseColorPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         colorPatterns = [];
         for each(_loc2_ in param1.colors.color)
         {
            _loc3_ = _loc2_.@key;
            _loc4_ = _loc2_.@color;
            colorPatterns[_loc3_] = _loc4_;
         }
      }
      
      private static function parseVideoWindowColorPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         videoWindowColorPatterns = [];
         for each(_loc2_ in param1.colors.videoWindow.color)
         {
            _loc3_ = _loc2_.@key;
            _loc4_ = _loc2_.@color;
            videoWindowColorPatterns[_loc3_] = _loc4_;
         }
      }
      
      private static function parseEnginePatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:AudibleResourcePattern = null;
         enginePatterns = [];
         for each(_loc2_ in param1.patterns.engines.engine)
         {
            _loc3_ = int(_loc2_.@type);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = new AudibleResourcePattern(_loc3_,_loc4_);
            if(_loc2_.@soundID.length() > 0)
            {
               _loc5_.setSoundID(int(_loc2_.@soundID));
            }
            if(_loc2_.@loop.length() > 0)
            {
               _loc5_.engineLoop = ParserUtility.parseBooleanFromString(_loc2_.@loop);
            }
            enginePatterns[_loc3_] = _loc5_;
         }
      }
      
      private static function parseEngineSmokePatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:EngineSmokePattern = null;
         engineSmokePatterns = [];
         for each(_loc2_ in param1.patterns.engineSmokes.engineSmoke)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = new EngineSmokePattern(_loc3_,_loc4_);
            if(_loc2_.@rotation.length() > 0)
            {
               _loc5_.setRotation(ParserUtility.parseBooleanFromString(_loc2_.@rotation));
            }
            if(_loc2_.@poolSize.length() > 0)
            {
               _loc5_.poolSize = int(_loc2_.@poolSize);
            }
            engineSmokePatterns[_loc3_] = _loc5_;
         }
      }
      
      private static function parseRocketSmokePatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:RocketSmokePattern = null;
         rocketSmokePatterns = [];
         for each(_loc2_ in param1.patterns.rocketSmokes.rocketSmoke)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@resKey;
            _loc5_ = int(_loc2_.@particleInterval);
            _loc6_ = Number(_loc2_.@particleDuration);
            _loc7_ = new RocketSmokePattern(_loc3_,_loc4_,_loc5_,_loc6_,_loc2_.@fx3D);
            if(_loc2_.@poolSize.length() > 0)
            {
               _loc7_.poolSize = int(_loc2_.@poolSize);
            }
            rocketSmokePatterns[_loc3_] = _loc7_;
         }
      }
      
      private static function parseRobotPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         _robotPatternsByLootId = {};
         for each(_loc2_ in param1.patterns.repairRobots.robot)
         {
            _robotPatternsByLootId[String(_loc2_.@loot_id)] = new RepairRobotPattern(0,String(_loc2_.@resKeyPrefix),String(_loc2_.@robotClip),int(_loc2_.@robotsNum),int(_loc2_.@offsetX),int(_loc2_.@offsetY),String(_loc2_.@asset3D));
         }
         _robotSparksPatternsBySkillLevel = {};
         for each(_loc3_ in param1.patterns.repairRobots.sparks)
         {
            _robotSparksPatternsBySkillLevel[String(_loc3_.@repairSkillLevel)] = new RepairRobotPattern(0,String(_loc3_.@resKeyPrefix),String(_loc3_.@robotClip),int(_loc3_.@robotsNum),int(_loc3_.@offsetX),int(_loc3_.@offsetY),String(_loc3_.@asset3D));
         }
      }
      
      public static function parseSoundPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:AudioMultiPattern = null;
         var _loc6_:XML = null;
         soundPatterns = [];
         for each(_loc2_ in param1.patterns.sounds.sound)
         {
            _loc3_ = int(_loc2_.@id);
            _loc4_ = _loc2_.@soundbank;
            _loc5_ = new AudioMultiPattern(_loc3_,_loc4_);
            if(_loc2_.@volume.length() > 0)
            {
               _loc5_.setVolume(_loc2_.@volume);
            }
            if(_loc2_.@loop.length() > 0)
            {
               _loc5_.setLoop(ParserUtility.parseBooleanFromString(_loc2_.@loop));
            }
            if(_loc2_.@isVoice.length() > 0)
            {
               _loc5_.setVoice(ParserUtility.parseBooleanFromString(_loc2_.@isVoice));
            }
            if(_loc2_.@interval.length() > 0)
            {
               _loc5_.interval = Number(_loc2_.@interval);
            }
            if(_loc2_.@intervalFluctuation.length() > 0)
            {
               _loc5_.intervalFluctuation = int(_loc2_.@intervalFluctuation);
            }
            for each(_loc6_ in _loc2_.child("reskeys").child("reskey"))
            {
               _loc5_.resKey = _loc6_.attribute("resKey").toString();
            }
            soundPatterns[_loc3_] = _loc5_;
         }
      }
      
      private static function parseEnginePositionPatterns(param1:XML) : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:Dictionary = null;
         var _loc5_:XML = null;
         var _loc6_:Dictionary = null;
         var _loc7_:XML = null;
         var _loc8_:EnginePositionPattern = null;
         var _loc9_:Array = null;
         var _loc10_:Vector.<PointLite> = null;
         var _loc11_:Array = null;
         var _loc12_:Vector.<PointLite> = null;
         enginePositionClasses = [];
         for each(_loc2_ in param1.patterns.enginePositions.enginePosition)
         {
            _loc3_ = String(_loc2_["class"]);
            if(!enginePositionClasses[_loc3_])
            {
               enginePositionClasses[_loc3_] = [];
            }
            _loc4_ = new Dictionary();
            for each(_loc5_ in _loc2_.positionsList)
            {
               _loc4_[String(_loc5_.@name)] = ParserUtility.parseCommaCoordinatesList(String(_loc5_.@data));
            }
            _loc6_ = null;
            if(_loc2_.lowPositionsList.length() > 0)
            {
               _loc6_ = new Dictionary();
            }
            for each(_loc7_ in _loc2_.lowPositionsList)
            {
               _loc6_[String(_loc7_.@name)] = ParserUtility.parseCommaCoordinatesList(String(_loc7_.@data));
            }
            _loc9_ = [];
            for each(_loc10_ in _loc4_)
            {
               _loc9_.push(_loc10_);
            }
            _loc11_ = null;
            if(_loc6_ != null)
            {
               _loc11_ = [];
               for each(_loc12_ in _loc6_)
               {
                  _loc11_.push(_loc12_);
               }
            }
            _loc8_ = new EnginePositionPattern(_loc9_,_loc11_);
            enginePositionClasses[_loc3_] = _loc8_;
         }
      }
      
      public static function getLaserPattern(param1:int, param2:int) : LaserSalvoPattern
      {
         var _loc3_:Array = laserClasses[param1] || laserClasses[0];
         return _loc3_[param2] || _loc3_[0] || laserClasses[0][param2];
      }
      
      public static function getShieldPattern(param1:int) : ShieldPattern
      {
         return shieldClasses[param1] || shieldClasses["default"];
      }
      
      public static function getExpansionPattern(param1:String, param2:int) : ExpansionPattern
      {
         var _loc3_:Array = expansionClasses[param1];
         var _loc4_:ExpansionPattern = _loc3_ ? _loc3_[int(param2)] : null;
         if(_loc4_ == null && Boolean(_loc3_))
         {
            _loc4_ = _loc3_[0];
         }
         return _loc4_;
      }
      
      public static function getEnginePositionPattern(param1:String) : EnginePositionPattern
      {
         return enginePositionClasses[param1];
      }
      
      public static function getPyroPattern(param1:int, param2:int) : ExplosionPattern
      {
         var _loc3_:Array = pyroClasses[int(param1)];
         return _loc3_[int(param2)];
      }
      
      public static function getRocketPattern(param1:int, param2:int) : RocketPattern
      {
         var _loc3_:Array = rocketClasses[int(param1)];
         return _loc3_[int(param2)];
      }
      
      public static function getHighPrioPreloadList(param1:String) : Vector.<String>
      {
         return _highPrioPreloadList[param1] as Vector.<String>;
      }
      
      public static function getFireWorkDescriptor(param1:int) : FireworkDescriptorPattern
      {
         return _fireworkDesciptorPatterns[param1] ? _fireworkDesciptorPatterns[param1] : _fireworkDesciptorPatterns[1];
      }
      
      public static function getIconpattern(param1:String) : FullResourcePattern
      {
         return _iconPattern[param1];
      }
      
      public static function getRepairRobotPattern(param1:String) : RepairRobotPattern
      {
         return _robotPatternsByLootId[param1] as RepairRobotPattern;
      }
      
      public static function getRepairSparksPattern(param1:int) : RepairRobotPattern
      {
         return _robotSparksPatternsBySkillLevel[String(param1)] as RepairRobotPattern;
      }
   }
}

