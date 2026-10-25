package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.info.model
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class StrikeAndExitInfoData
   {
      
      public const changed:ISignal = new Signal();
      
      private var _nextSpawnSeconds:int;
      
      private var _boxType:String;
      
      private var _boxRemainingQuantity:int;
      
      private var _npcType1:int;
      
      private var _npcRemainingQuantity1:int;
      
      private var _npcType2:int;
      
      private var _npcRemainingQuantity2:int;
      
      private var _npcType3:int;
      
      private var _npcRemainingQuantity3:int;
      
      private var _nextSpawnNpcSeconds:int;
      
      private var _bossType:int;
      
      private var _bossAlive:Boolean;
      
      private var _spotLightUserName:String;
      
      private var _spotLightUserX:int;
      
      private var _spotLightUserY:int;
      
      private var _stellarCoinLimit:int;
      
      private var _saeScore:int;
      
      private var _remainingTime:int;
      
      public function StrikeAndExitInfoData()
      {
         super();
      }
      
      public function get nextSpawnSeconds() : int
      {
         return this._nextSpawnSeconds;
      }
      
      public function get boxType() : String
      {
         return this._boxType;
      }
      
      public function get boxRemainingQuantity() : int
      {
         return this._boxRemainingQuantity;
      }
      
      public function get npcType1() : int
      {
         return this._npcType1;
      }
      
      public function get npcRemainingQuantity1() : int
      {
         return this._npcRemainingQuantity1;
      }
      
      public function get npcType2() : int
      {
         return this._npcType2;
      }
      
      public function get npcRemainingQuantity2() : int
      {
         return this._npcRemainingQuantity2;
      }
      
      public function get npcType3() : int
      {
         return this._npcType3;
      }
      
      public function get npcRemainingQuantity3() : int
      {
         return this._npcRemainingQuantity3;
      }
      
      public function get nextSpawnNpcSeconds() : int
      {
         return this._nextSpawnNpcSeconds;
      }
      
      public function get bossType() : int
      {
         return this._bossType;
      }
      
      public function get bossAlive() : Boolean
      {
         return this._bossAlive;
      }
      
      public function get spotLightUserName() : String
      {
         return this._spotLightUserName;
      }
      
      public function get spotLightUserX() : int
      {
         return this._spotLightUserX;
      }
      
      public function get spotLightUserY() : int
      {
         return this._spotLightUserY;
      }
      
      public function get stellarCoinLimit() : int
      {
         return this._stellarCoinLimit;
      }
      
      public function get saeScore() : int
      {
         return this._saeScore;
      }
      
      public function get remainingTime() : int
      {
         return this._remainingTime;
      }
      
      public function update(param1:int, param2:String, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int, param11:int, param12:Boolean, param13:String, param14:int, param15:int, param16:int, param17:int, param18:int) : void
      {
         this._nextSpawnSeconds = param1;
         this._boxType = param2;
         this._boxRemainingQuantity = param3;
         this._npcType1 = param4;
         this._npcRemainingQuantity1 = param5;
         this._npcType2 = param6;
         this._npcRemainingQuantity2 = param7;
         this._npcType3 = param8;
         this._npcRemainingQuantity3 = param9;
         this._nextSpawnNpcSeconds = param10;
         this._bossType = param11;
         this._bossAlive = param12;
         this._spotLightUserName = param13;
         this._spotLightUserX = param14;
         this._spotLightUserY = param15;
         this._stellarCoinLimit = param16;
         this._saeScore = param17;
         this._remainingTime = param18;
         this.changed.dispatch();
      }
   }
}

