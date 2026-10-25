package net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.meta
{
   import net.bigpoint.darkorbit.mvc.spaceMap.vo.SpaceMapStationInfoVO;
   
   public dynamic class SpaceMapDataItem
   {
      
      public static const LOCKED:uint = 0;
      
      public static const LEVEL_LOCKED:uint = LOCKED + 1;
      
      public static const URI_LOCKED:uint = LEVEL_LOCKED + 1;
      
      public static const HARD_LOCKED:uint = URI_LOCKED + 1;
      
      public static const HARD_LOCKED_NO_OBFUSCATE:uint = HARD_LOCKED + 1;
      
      public static const PIRATE_MAP:uint = HARD_LOCKED_NO_OBFUSCATE + 1;
      
      public static const ENEMY_MAP:uint = PIRATE_MAP + 1;
      
      public static const MAX_LOCKED_STATE:uint = ENEMY_MAP;
      
      public static const NO_ICON:uint = MAX_LOCKED_STATE + 1;
      
      public static const OBFUSCATE_MAP_DATA:uint = NO_ICON + 1;
      
      public static const MAP_ID:uint = OBFUSCATE_MAP_DATA + 1;
      
      public static const STATION_INFO:uint = MAP_ID + 1;
      
      public function SpaceMapDataItem()
      {
         super();
      }
      
      public function get mapId() : int
      {
         return this[MAP_ID];
      }
      
      public function set mapId(param1:int) : void
      {
         this[MAP_ID] = param1;
      }
      
      public function get stationInfo() : SpaceMapStationInfoVO
      {
         return this[STATION_INFO];
      }
      
      public function set stationInfo(param1:SpaceMapStationInfoVO) : void
      {
         this[STATION_INFO] = param1;
      }
      
      public function get locked() : Boolean
      {
         return this[LOCKED] === true;
      }
      
      public function set locked(param1:Boolean) : void
      {
         this[LOCKED] = param1;
      }
      
      public function get levelLocked() : Boolean
      {
         return this[LEVEL_LOCKED] === true;
      }
      
      public function set levelLocked(param1:Boolean) : void
      {
         this[LEVEL_LOCKED] = param1;
      }
      
      public function get uriLocked() : Boolean
      {
         return this[URI_LOCKED] === true;
      }
      
      public function set uriLocked(param1:Boolean) : void
      {
         this[URI_LOCKED] = param1;
      }
      
      public function get hardLock() : Boolean
      {
         return this[HARD_LOCKED] === true;
      }
      
      public function set hardLock(param1:Boolean) : void
      {
         this[HARD_LOCKED] = param1;
      }
      
      public function get pirateMap() : Boolean
      {
         return this[PIRATE_MAP] === true;
      }
      
      public function set pirateMap(param1:Boolean) : void
      {
         this[PIRATE_MAP] = param1;
      }
      
      public function get enemyMap() : Boolean
      {
         return this[ENEMY_MAP] === true;
      }
      
      public function set enemyMap(param1:Boolean) : void
      {
         this[ENEMY_MAP] = param1;
      }
      
      public function get jumpNotAllowed() : Boolean
      {
         var _loc1_:Boolean = this.locked;
         _loc1_ ||= this.levelLocked;
         _loc1_ ||= this.uriLocked;
         _loc1_ ||= this.hardLock;
         _loc1_ ||= this.pirateMap;
         return _loc1_ || this.enemyMap;
      }
      
      public function get noIcon() : Boolean
      {
         return this[NO_ICON] === true;
      }
      
      public function set noIcon(param1:Boolean) : void
      {
         this[NO_ICON] = param1;
      }
      
      public function get obfuscateMap() : Boolean
      {
         return this[OBFUSCATE_MAP_DATA] === true;
      }
      
      public function set obfuscateMap(param1:Boolean) : void
      {
         this[OBFUSCATE_MAP_DATA] = param1;
      }
      
      public function getMapProperty(param1:int) : Boolean
      {
         return this[param1];
      }
      
      public function setMapProperty(param1:int, param2:Boolean) : void
      {
         this[param1] = param2;
      }
      
      public function unlockFull() : void
      {
         this.hardLock = false;
         this.locked = false;
         this.levelLocked = false;
         this.uriLocked = false;
         this.pirateMap = false;
         this.enemyMap = false;
      }
   }
}

