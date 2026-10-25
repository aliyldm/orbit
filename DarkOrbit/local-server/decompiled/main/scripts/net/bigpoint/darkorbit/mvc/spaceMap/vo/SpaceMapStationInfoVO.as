package net.bigpoint.darkorbit.mvc.spaceMap.vo
{
   import com.bigpoint.utils.TimeFormatter;
   
   public class SpaceMapStationInfoVO
   {
      
      private var _mapId:int = 0;
      
      private var _xPositionPercentage:int = 0;
      
      private var _yPositionPercentage:int = 0;
      
      private var _status:uint = 0;
      
      private var _lastChangedTimestamp:Number = 0;
      
      private var _lastChangedServerTimeDelta:Number = 0;
      
      private var _clanName:String = "";
      
      private var _asteroidName:String = "";
      
      private var _owningFactionId:int;
      
      private var _dataReceiveTime:Number;
      
      public function SpaceMapStationInfoVO(param1:int, param2:int, param3:int, param4:uint, param5:Number, param6:Number, param7:String, param8:String, param9:int)
      {
         super();
         this._mapId = param1;
         this._xPositionPercentage = param2;
         this._yPositionPercentage = param3;
         this._status = param4;
         this._lastChangedTimestamp = param5;
         this._lastChangedServerTimeDelta = param6;
         this._clanName = param7;
         this._asteroidName = param8;
         this._owningFactionId = param9;
         this._dataReceiveTime = new Date().getTime();
      }
      
      public function get mapId() : int
      {
         return this._mapId;
      }
      
      public function get xPositionPercentage() : int
      {
         return this._xPositionPercentage;
      }
      
      public function get yPositionPercentage() : int
      {
         return this._yPositionPercentage;
      }
      
      public function get status() : uint
      {
         return this._status;
      }
      
      public function get clanName() : String
      {
         return this._clanName;
      }
      
      public function get asteroidName() : String
      {
         return this._asteroidName;
      }
      
      public function get owningFactionId() : int
      {
         return this._owningFactionId;
      }
      
      public function get lastChangedTimestamp() : Number
      {
         return this._lastChangedTimestamp;
      }
      
      public function get lastChangedTimeTextInfo() : String
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         if(this._lastChangedTimestamp)
         {
            _loc1_ = new Date().getTime() - this._dataReceiveTime;
            _loc2_ = this._lastChangedServerTimeDelta + _loc1_;
            _loc3_ = int(_loc2_ / 60000);
            return TimeFormatter.formatTimeValueFromMinutes(_loc3_,true);
         }
         return "-";
      }
   }
}

