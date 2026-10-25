package net.bigpoint.darkorbit.mvc.traininggrounds.model
{
   public class TraininggroundsFightInfoVO
   {
      
      private var _opponentName:String;
      
      private var _opponentUid:int;
      
      private var _opponentInstanceid:int;
      
      private var _opponentHitpoints:int;
      
      private var _opponentHitpointsMax:int;
      
      private var _opponentShield:int;
      
      private var _opponentShieldMax:int;
      
      private var _opponentVictoryPoint:int;
      
      private var _playerHitpoints:int;
      
      private var _playerHitpointsMax:int;
      
      private var _playerShield:int;
      
      private var _playerShieldMax:int;
      
      private var _playerVictoryPoint:int;
      
      private var _roundNumber:int;
      
      private var _seasonName:String;
      
      public function TraininggroundsFightInfoVO(param1:String, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int, param11:int, param12:int, param13:int, param14:int, param15:String)
      {
         super();
         this._roundNumber = param14;
         this._playerVictoryPoint = param13;
         this._playerShieldMax = param12;
         this._playerShield = param11;
         this._playerHitpointsMax = param10;
         this._playerHitpoints = param9;
         this._opponentVictoryPoint = param8;
         this._opponentShieldMax = param7;
         this._opponentShield = param6;
         this._opponentHitpointsMax = param5;
         this._opponentHitpoints = param4;
         this._opponentName = param1;
         this._opponentUid = param2;
         this._opponentInstanceid = param3;
         this._seasonName = param15;
      }
      
      public function get opponentName() : String
      {
         return this._opponentName;
      }
      
      public function get opponentUid() : int
      {
         return this._opponentUid;
      }
      
      public function get opponentInstanceid() : int
      {
         return this._opponentInstanceid;
      }
      
      public function get opponentHitpoints() : int
      {
         return this._opponentHitpoints;
      }
      
      public function get opponentHitpointsMax() : int
      {
         return this._opponentHitpointsMax;
      }
      
      public function get opponentShield() : int
      {
         return this._opponentShield;
      }
      
      public function get opponentShieldMax() : int
      {
         return this._opponentShieldMax;
      }
      
      public function get opponentVictoryPoint() : int
      {
         return this._opponentVictoryPoint;
      }
      
      public function get playerHitpoints() : int
      {
         return this._playerHitpoints;
      }
      
      public function get playerHitpointsMax() : int
      {
         return this._playerHitpointsMax;
      }
      
      public function get playerShield() : int
      {
         return this._playerShield;
      }
      
      public function get playerShieldMax() : int
      {
         return this._playerShieldMax;
      }
      
      public function get playerVictoryPoint() : int
      {
         return this._playerVictoryPoint;
      }
      
      public function get roundNumber() : int
      {
         return this._roundNumber;
      }
      
      public function get seasonName() : String
      {
         return this._seasonName;
      }
   }
}

