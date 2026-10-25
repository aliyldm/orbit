package net.bigpoint.darkorbit.mvc.galaxygatebuilder.model.vo
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderBonusGGRewardModule;
   import net.bigpoint.darkorbit.com.module.GalaxyGateBuilderMultiGateProgressModule;
   
   public class GateVO
   {
      
      private var _partsCount:int;
      
      private var _partsTotal:int;
      
      private var _livesLeft:int;
      
      private var _lifePrice:int;
      
      private var _finishState:Boolean;
      
      private var _gateImage:Bitmap;
      
      private var _lastPartImage:Bitmap;
      
      private var _handleLastPart:Boolean = true;
      
      private var _gateProgressList:Array;
      
      private var _totalWave:int = 0;
      
      private var _currentWave:int = 0;
      
      private var _bonusGGReward:GateBonusGGRewardVO;
      
      public function GateVO(param1:int, param2:int, param3:int, param4:int, param5:Boolean = false, param6:Bitmap = null, param7:Bitmap = null)
      {
         super();
         this._partsCount = param1;
         this._partsTotal = param2;
         this._livesLeft = param3;
         this._lifePrice = param4;
         this._finishState = param5;
         this._gateImage = param6;
         this._lastPartImage = param7;
      }
      
      public static function sortModeGates(param1:Array, param2:Array) : int
      {
         if(param1.length == 0)
         {
            return -1;
         }
         if(param2.length == 0)
         {
            return 1;
         }
         return param1[0] - param2[0];
      }
      
      public function get partsCount() : int
      {
         return this._partsCount;
      }
      
      public function set partsCount(param1:int) : void
      {
         this._partsCount = param1;
      }
      
      public function get partsTotal() : int
      {
         return this._partsTotal;
      }
      
      public function get finishState() : Boolean
      {
         return this._finishState;
      }
      
      public function set finishState(param1:Boolean) : void
      {
         this._finishState = param1;
      }
      
      public function get gateImage() : Bitmap
      {
         return this._gateImage;
      }
      
      public function set gateImage(param1:Bitmap) : void
      {
         if(Boolean(this._gateImage) && Boolean(this._gateImage.bitmapData))
         {
            this._gateImage.bitmapData.dispose();
            this._gateImage.bitmapData = null;
         }
         this._gateImage = param1;
      }
      
      public function get lastPartImage() : Bitmap
      {
         return this._lastPartImage;
      }
      
      public function set lastPartImage(param1:Bitmap) : void
      {
         if(Boolean(this._lastPartImage) && Boolean(this._lastPartImage.bitmapData))
         {
            this._lastPartImage.bitmapData.dispose();
            this._lastPartImage.bitmapData = null;
         }
         this._lastPartImage = param1;
      }
      
      public function set handleLastPart(param1:Boolean) : void
      {
         this._handleLastPart = param1;
      }
      
      public function get handleLastPart() : Boolean
      {
         return this._handleLastPart;
      }
      
      public function get lifePrice() : int
      {
         return this._lifePrice;
      }
      
      public function get livesLeft() : int
      {
         return this._livesLeft;
      }
      
      public function set livesLeft(param1:int) : void
      {
         this._livesLeft = param1;
      }
      
      public function set lifePrice(param1:int) : void
      {
         this._lifePrice = param1;
      }
      
      public function parseGateProgress(param1:Vector.<GalaxyGateBuilderMultiGateProgressModule>) : void
      {
         var _loc2_:GalaxyGateBuilderMultiGateProgressModule = null;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         this._gateProgressList = new Array();
         for each(_loc2_ in param1)
         {
            _loc3_ = new Object();
            _loc4_ = _loc2_.name;
            _loc5_ = String("gate_name_" + _loc4_ + "_long").toLowerCase();
            _loc6_ = BPLocale.getItemInCategory("galaxyGates",_loc5_);
            _loc3_.name = _loc6_;
            _loc3_.total = _loc2_.total;
            _loc3_.current = _loc2_.current;
            this._gateProgressList.push(_loc3_);
         }
      }
      
      public function get gateProgressList() : Array
      {
         return this._gateProgressList;
      }
      
      public function get totalWave() : int
      {
         return this._totalWave;
      }
      
      public function set totalWave(param1:int) : void
      {
         this._totalWave = param1;
      }
      
      public function get currentWave() : int
      {
         return this._currentWave;
      }
      
      public function set currentWave(param1:int) : void
      {
         this._currentWave = param1;
      }
      
      public function get bonusGGReward() : GateBonusGGRewardVO
      {
         return this._bonusGGReward;
      }
      
      public function parseBonusGGReward(param1:Vector.<GalaxyGateBuilderBonusGGRewardModule>) : void
      {
         var _loc2_:GalaxyGateBuilderBonusGGRewardModule = null;
         if(Boolean(param1) && param1.length > 0)
         {
            _loc2_ = param1[0];
            this._bonusGGReward = new GateBonusGGRewardVO(_loc2_.lootId,_loc2_.amount,_loc2_.claimed,_loc2_.countdown);
         }
      }
   }
}

