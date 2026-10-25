package net.bigpoint.darkorbit.map.model
{
   import away3d.debug.Trident;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.core.MapEntityContainer;
   import net.bigpoint.darkorbit.map.model.effects.EffectManager;
   import net.bigpoint.darkorbit.map.model.poizones.POIZoneManager;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.ShipManager;
   import net.bigpoint.darkorbit.map.model.utils.LockManager;
   import net.bigpoint.darkorbit.utils.XMLUtils;
   import org.osflash.signals.Signal;
   
   public class Map extends MapEntityContainer
   {
      
      private static var _dynamicConfig:XML;
      
      private static var _staticConfig:XML;
      
      private static var _nextFreeId:int = -1;
      
      private static var _hash2id:Object = {};
      
      public static const STD_WIDTH:int = 21000;
      
      public static const STD_HEIGHT:int = 13100;
      
      public static var SAE_MAP_IDS:Array = [483,484,485,486,487,488,489,490,491,492];
      
      public const storage:Dictionary = new Dictionary(true);
      
      public const mapXmlChanged:Signal = new Signal();
      
      private var _mapXml:XML;
      
      private var _poiZones:POIZoneManager;
      
      private var _ships:ShipManager;
      
      private var _lockManager:LockManager = new LockManager();
      
      private var _creationTime:uint;
      
      private var _serious_width:int = 21000;
      
      private var _serious_height:int = 13100;
      
      private var _mapID:int;
      
      private var _scaleFactor:Number;
      
      private var _effects:EffectManager = new EffectManager();
      
      private const debugTridant:Trident = new Trident(100,false);
      
      public function Map(param1:int)
      {
         super();
         this._mapID = param1;
         this._creationTime = getTimer();
         this._poiZones = new POIZoneManager(this);
         this._ships = new ShipManager();
         this.init();
      }
      
      public static function get NEXT_FREE_ID() : int
      {
         return _nextFreeId--;
      }
      
      public static function resetID() : void
      {
         _hash2id = {};
      }
      
      public static function getNextIdForHash(param1:String) : int
      {
         var _loc2_:int = NEXT_FREE_ID;
         _hash2id[param1] = _loc2_;
         return _loc2_;
      }
      
      public static function init(param1:XML, param2:XML) : void
      {
         _dynamicConfig = param1;
         _staticConfig = param2;
      }
      
      public static function getServerIP(param1:int) : String
      {
         var _loc2_:XMLList = XMLUtils.getChildByAttributeName(_dynamicConfig.map,"id",param1.toString());
         return _loc2_.length() > 0 ? _loc2_.child("gameserverIP") : null;
      }
      
      public static function getStaticMapDescriptor(param1:int) : XML
      {
         var _loc2_:XMLList = null;
         if(_staticConfig)
         {
            _loc2_ = XMLUtils.getChildByAttributeName(_staticConfig.map,"id",param1.toString());
            return _loc2_.length() > 0 ? _loc2_[0] : null;
         }
         return null;
      }
      
      public static function getMapName(param1:int) : String
      {
         var _loc2_:XML = Map.getStaticMapDescriptor(param1);
         return _loc2_ ? String(_loc2_.@name) : "";
      }
      
      public static function getMissionMapName(param1:int) : String
      {
         var _loc2_:XML = Map.getStaticMapDescriptor(param1);
         return _loc2_ ? String(_loc2_.@missionName) || String(_loc2_.@name) : "";
      }
      
      public static function getGroupSystemMapName(param1:int) : String
      {
         var _loc2_:XML = Map.getStaticMapDescriptor(param1);
         return _loc2_ ? String(_loc2_.@groupSystemName) || String(_loc2_.@name) : "";
      }
      
      public static function getGroupSystemMapToolTip(param1:int) : String
      {
         var _loc2_:XML = Map.getStaticMapDescriptor(param1);
         return _loc2_ ? String(_loc2_.@groupSystemToolTip) || String(_loc2_.@name) : "";
      }
      
      public static function inSAEMap(param1:int) : Boolean
      {
         return SAE_MAP_IDS.indexOf(param1) >= 0;
      }
      
      public static function get dynamicConfig() : XML
      {
         return _dynamicConfig;
      }
      
      public static function set dynamicConfig(param1:XML) : void
      {
         _dynamicConfig = param1;
      }
      
      public function get serious_width() : int
      {
         return this._serious_width;
      }
      
      public function get serious_height() : int
      {
         return this._serious_height;
      }
      
      public function get mapID() : int
      {
         return this._mapID;
      }
      
      public function get scaleFactor() : Number
      {
         return this._scaleFactor;
      }
      
      public function get effects() : EffectManager
      {
         return this._effects;
      }
      
      public function get hero() : Ship
      {
         return getEntityById(Hero.userID) as Ship;
      }
      
      public function get poiManager() : POIZoneManager
      {
         return this._poiZones;
      }
      
      override public function addEntity(param1:MapEntity) : MapEntity
      {
         return super.addEntity(param1);
      }
      
      override public function removeEntity(param1:MapEntity) : MapEntity
      {
         if(param1)
         {
            this.effects.removeAllEffectsForMapObject(param1.id);
         }
         return super.removeEntity(param1);
      }
      
      public function getEntityByHash(param1:String) : MapEntity
      {
         return getEntityById(_hash2id[param1]);
      }
      
      public function removeEntityByHash(param1:String) : MapEntity
      {
         return removeEntityById(_hash2id[param1]);
      }
      
      override public function removeAll() : void
      {
         this.effects.removeAllEffects();
         super.removeAll();
      }
      
      public function checkCollisions(param1:Point, param2:Point) : Point
      {
         return this._poiZones.checkCollisions(param1,param2);
      }
      
      public function init(param1:XML = null) : void
      {
         this._mapXml = param1 || getStaticMapDescriptor(this.mapID) || new XML();
         if(this._mapXml.attribute("scaleFactor").length() > 0)
         {
            this._scaleFactor = Number(this._mapXml.attribute("scaleFactor"));
         }
         else
         {
            this._scaleFactor = 1;
         }
         this._serious_width = STD_WIDTH * this.scaleFactor;
         this._serious_height = STD_HEIGHT * this.scaleFactor;
         this.mapXmlChanged.dispatch();
      }
      
      public function getMapID() : int
      {
         return this.mapID;
      }
      
      public function cleanup() : void
      {
         this._ships.cleanup();
         this._poiZones.cleanup();
         this._effects.removeAllEffects();
         this.removeAll();
         resetID();
      }
      
      public function getName() : String
      {
         return getMapName(this.getMapID());
      }
      
      public function getShipManager() : ShipManager
      {
         return this._ships;
      }
      
      public function get lifeTime() : int
      {
         return getTimer() - this._creationTime;
      }
      
      public function get lockManager() : LockManager
      {
         return this._lockManager;
      }
      
      public function get mapXml() : XML
      {
         return this._mapXml;
      }
   }
}

