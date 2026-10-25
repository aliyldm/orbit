package net.bigpoint.darkorbit.mvc.gui.windows.battlePass.model.vo
{
   import net.bigpoint.darkorbit.com.module.BattlePassKeyExchangeLootModule;
   import net.bigpoint.darkorbit.com.module.BattlePassKeyExchangeRewardModule;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BattlePassExchangeVO
   {
      
      public static const SpecialType:String = "special";
      
      public static const StandardType:String = "standard";
      
      public const claimCountChanged:ISignal = new Signal();
      
      public const requestClaim:ISignal = new Signal(BattlePassExchangeVO);
      
      private var _rewardName:String;
      
      private var _loots:Vector.<BattlePassKeyExchangeLootModule>;
      
      private var _cost:int;
      
      private var _limit:int;
      
      private var _claimCount:int;
      
      private var _priority:int;
      
      private var _isSpecial:Boolean;
      
      private var _category:String;
      
      private var _currentTotalKey:int;
      
      public function BattlePassExchangeVO(param1:BattlePassKeyExchangeRewardModule, param2:int)
      {
         super();
         this._rewardName = param1.exchangeReward;
         this._loots = param1.listOfloot;
         this._cost = param1.cost;
         this._limit = param1.limit;
         this._claimCount = param1.claimCount;
         this._priority = param1.priority;
         this._isSpecial = param1.isSpecial;
         this._currentTotalKey = param2;
         if(this._isSpecial)
         {
            this._category = SpecialType;
         }
         else
         {
            this._category = StandardType;
         }
      }
      
      public static function sort(param1:BattlePassExchangeVO, param2:BattlePassExchangeVO) : int
      {
         if(param1.isCompleted() == param2.isCompleted())
         {
            if(param1.isSpecial && param2.isSpecial)
            {
               return param1.priority - param2.priority;
            }
            if(param1.isSpecial && !param2.isSpecial)
            {
               return -1;
            }
            if(!param1.isSpecial && param2.isSpecial)
            {
               return 1;
            }
            return param1.priority - param2.priority;
         }
         if(!param1.isCompleted() && param2.isCompleted())
         {
            return -1;
         }
         if(!param2.isCompleted() && param1.isCompleted())
         {
            return 1;
         }
         return 0;
      }
      
      public function sendClaimRequest() : void
      {
         this.requestClaim.dispatch(this);
      }
      
      public function isCompleted() : Boolean
      {
         return this.limit > 0 && this.claimCount >= this.limit;
      }
      
      public function isEnoughKey() : Boolean
      {
         return this._currentTotalKey >= this._cost;
      }
      
      public function get rewardName() : String
      {
         return this._rewardName;
      }
      
      public function set rewardName(param1:String) : void
      {
         this._rewardName = param1;
      }
      
      public function get loots() : Vector.<BattlePassKeyExchangeLootModule>
      {
         return this._loots;
      }
      
      public function set loots(param1:Vector.<BattlePassKeyExchangeLootModule>) : void
      {
         this._loots = param1;
      }
      
      public function get cost() : int
      {
         return this._cost;
      }
      
      public function set cost(param1:int) : void
      {
         this._cost = param1;
      }
      
      public function get limit() : int
      {
         return this._limit;
      }
      
      public function set limit(param1:int) : void
      {
         this._limit = param1;
      }
      
      public function get claimCount() : int
      {
         return this._claimCount;
      }
      
      public function set claimCount(param1:int) : void
      {
         this._claimCount = param1;
         this.claimCountChanged.dispatch();
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function set priority(param1:int) : void
      {
         this._priority = param1;
      }
      
      public function get isSpecial() : Boolean
      {
         return this._isSpecial;
      }
      
      public function set isSpecial(param1:Boolean) : void
      {
         this._isSpecial = param1;
      }
      
      public function get category() : String
      {
         return this._category;
      }
      
      public function set category(param1:String) : void
      {
         this._category = param1;
      }
      
      public function get currentTotalKey() : int
      {
         return this._currentTotalKey;
      }
      
      public function set currentTotalKey(param1:int) : void
      {
         this._currentTotalKey = param1;
         this.claimCountChanged.dispatch();
      }
   }
}

