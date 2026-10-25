package net.bigpoint.darkorbit.mvc.gui.windows.killUI.model
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.KillUiFullMessageCommand;
   import net.bigpoint.darkorbit.com.module.KillUiInfoMessageCommand;
   import net.bigpoint.darkorbit.map.model.Map;
   
   public class KillUIData extends EventDispatcher
   {
      
      public static const EVENT_DATA_CHANGED:String = "KillUIData.DATA_CHANGED";
      
      public static const INFO_VIEW:String = "KillUIData.INFO_VIEW";
      
      public static const FULL_VIEW:String = "KillUIData.FULL_VIEW";
      
      private var _currentViewState:String;
      
      private var _currentNpcKills:int;
      
      private var _maxNpcAmountForMap:int;
      
      private var _currentNpcOnMap:int;
      
      private var _totalAmountOfNpcOnMap:int;
      
      private var _npcId:int = -1;
      
      private var _mapName:String;
      
      private var _spawnNpcId:int;
      
      private var _killNpcId:int;
      
      public function KillUIData()
      {
         super();
      }
      
      public function set currentViewState(param1:String) : void
      {
         this._currentViewState = param1;
         dispatchEvent(new Event(EVENT_DATA_CHANGED));
      }
      
      public function get currentViewState() : String
      {
         return this._currentViewState;
      }
      
      public function updateFromInfoMessage(param1:KillUiInfoMessageCommand) : void
      {
         this._currentNpcKills = param1.currentNpcKills;
         this._maxNpcAmountForMap = param1.maxNpcAmountForMap;
         this._currentNpcOnMap = param1.currentNpcOnMap;
         this._mapName = Map.getMapName(param1.mapId);
         this._spawnNpcId = param1.spawnNpcId;
         this._killNpcId = param1.killNpcId;
         this.currentViewState = INFO_VIEW;
      }
      
      public function updateFromFullMessage(param1:KillUiFullMessageCommand) : void
      {
         this._totalAmountOfNpcOnMap = param1.totalAmountOfNpcOnMap;
         this._npcId = param1.npcId;
         this._mapName = Map.getMapName(param1.mapId);
         this.currentViewState = FULL_VIEW;
      }
      
      public function get currentNpcKills() : int
      {
         return this._currentNpcKills;
      }
      
      public function get maxNpcAmountForMap() : int
      {
         return this._maxNpcAmountForMap;
      }
      
      public function get currentNpcOnMap() : int
      {
         return this._currentNpcOnMap;
      }
      
      public function get totalAmountOfNpcOnMap() : int
      {
         return this._totalAmountOfNpcOnMap;
      }
      
      public function get npcId() : int
      {
         return this._npcId;
      }
      
      public function get mapName() : String
      {
         return this._mapName;
      }
      
      public function get killNpcId() : int
      {
         return this._killNpcId;
      }
      
      public function get spawnNpcId() : int
      {
         return this._spawnNpcId;
      }
   }
}

