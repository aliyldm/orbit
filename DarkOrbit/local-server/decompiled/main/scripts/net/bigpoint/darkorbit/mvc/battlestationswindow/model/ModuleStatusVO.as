package net.bigpoint.darkorbit.mvc.battlestationswindow.model
{
   public class ModuleStatusVO
   {
      
      private var _asteroidId:int = 0;
      
      private var _slotId:int = 0;
      
      private var _hitpoints:int = 0;
      
      private var _hitpointsMax:int = 0;
      
      private var _shield:int = 0;
      
      private var _shieldMax:int = 0;
      
      private var _emergencyRepairSecondsLeft:int = 0;
      
      private var _emergencyRepairSecondsTotal:int = 0;
      
      private var _installationSecondsLeft:int = 0;
      
      public function ModuleStatusVO(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int = 0, param8:int = 0, param9:int = 0)
      {
         super();
         this._asteroidId = param1;
         this._slotId = param2;
         this._hitpoints = param3;
         this._hitpointsMax = param4;
         this._shield = param5;
         this._shieldMax = param6;
         this._emergencyRepairSecondsLeft = param7;
         this._emergencyRepairSecondsTotal = param8;
         this._installationSecondsLeft = param9;
      }
      
      public function get asteroidId() : int
      {
         return this._asteroidId;
      }
      
      public function get slotId() : int
      {
         return this._slotId;
      }
      
      public function get hitpoints() : int
      {
         return this._hitpoints;
      }
      
      public function get hitpointsMax() : int
      {
         return this._hitpointsMax;
      }
      
      public function get shield() : int
      {
         return this._shield;
      }
      
      public function get shieldMax() : int
      {
         return this._shieldMax;
      }
      
      public function get emergencyRepairSecondsLeft() : int
      {
         return this._emergencyRepairSecondsLeft;
      }
      
      public function get emergencyRepairSecondsTotal() : int
      {
         return this._emergencyRepairSecondsTotal;
      }
      
      public function get installationSecondsLeft() : int
      {
         return this._installationSecondsLeft;
      }
   }
}

