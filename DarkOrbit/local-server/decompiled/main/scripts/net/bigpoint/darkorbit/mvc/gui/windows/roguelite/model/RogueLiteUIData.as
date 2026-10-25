package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.InventoryItemAttributeModule;
   import net.bigpoint.darkorbit.com.module.InventoryItemModule;
   import net.bigpoint.darkorbit.com.module.RankModule;
   import net.bigpoint.darkorbit.com.module.RankRewardRangeModule;
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import net.bigpoint.darkorbit.com.module.RogueLiteCashOutCommand;
   import net.bigpoint.darkorbit.com.module.RogueLiteCpuInfoCommand;
   import net.bigpoint.darkorbit.com.module.RogueLiteInfoCommand;
   import net.bigpoint.darkorbit.com.module.RogueLiteInventoryCommand;
   import net.bigpoint.darkorbit.com.module.RogueLiteRankEventInfoCommand;
   import net.bigpoint.darkorbit.com.module.RogueLiteRankInfoCommand;
   import net.bigpoint.darkorbit.com.module.RogueLiteScoreInfoCommand;
   import net.bigpoint.darkorbit.com.module.RogueLiteSelectRewardCommand;
   import net.bigpoint.darkorbit.com.module.UnstableModuleModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.items.item.Item;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteInventoryItemVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteRankRewardVO;
   import org.as3commons.lang.StringUtils;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class RogueLiteUIData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      public var lastRoomCount:BindableInt = new BindableInt(0,0);
      
      public var scoreCount:BindableInt = new BindableInt(0,0);
      
      private var _highScoreCount:int = 0;
      
      public const keyCount:BindableInt = new BindableInt(0,0);
      
      public var showCpu:BindableBoolean = new BindableBoolean(false);
      
      private var _guaranteedList:Vector.<ItemVO> = new Vector.<ItemVO>(0);
      
      private var _chanceList:Vector.<ItemVO> = new Vector.<ItemVO>(0);
      
      public const rewardCashoutChanged:ISignal = new Signal();
      
      private var _rewardList:Vector.<RogueLiteInventoryItemVO> = new Vector.<RogueLiteInventoryItemVO>(0);
      
      public const roomRewardChanged:ISignal = new Signal();
      
      private var _inventoryTabList:Vector.<ItemVO> = new Vector.<ItemVO>(0);
      
      private var _inventoryItemList:Vector.<RogueLiteInventoryItemVO> = new Vector.<RogueLiteInventoryItemVO>(0);
      
      public const inventoryChanged:ISignal = new Signal();
      
      public var canEquip:BindableBoolean = new BindableBoolean(false);
      
      private var _eventEnabled:Boolean = false;
      
      private var _rankRewards:Vector.<RogueLiteRankRewardVO> = new Vector.<RogueLiteRankRewardVO>(0);
      
      public const rankRewardChanged:ISignal = new Signal();
      
      private var _topRankers:Vector.<RankModule> = new Vector.<RankModule>(0);
      
      private var _myRank:RankModule = new RankModule();
      
      public const rankingChanged:ISignal = new Signal();
      
      public function RogueLiteUIData()
      {
         super();
      }
      
      public function get highScoreCount() : int
      {
         return this._highScoreCount;
      }
      
      public function updateScore(param1:RogueLiteScoreInfoCommand) : void
      {
         this.lastRoomCount.value = param1.progress;
         this.scoreCount.value = param1.score;
         this._highScoreCount = Math.max(this._highScoreCount,param1.score);
      }
      
      public function updateInfo(param1:RogueLiteInfoCommand) : void
      {
         this.lastRoomCount.value = param1.progress;
         this.scoreCount.value = param1.score;
         this._highScoreCount = param1.highscore;
         this.updateKeyCount(param1.cpuInfo);
         this.updateRewardsCashout(param1.cashoutInfo);
      }
      
      public function updateKeyCount(param1:RogueLiteCpuInfoCommand) : void
      {
         this.showCpu.value = param1.showCpu;
         this.keyCount.value = param1.keys;
         if(param1.showCpu)
         {
            this.canEquip.value = false;
         }
      }
      
      public function get guaranteedList() : Vector.<ItemVO>
      {
         return this._guaranteedList;
      }
      
      public function get chanceList() : Vector.<ItemVO>
      {
         return this._chanceList;
      }
      
      public function updateRewardsCashout(param1:RogueLiteCashOutCommand) : void
      {
         var _loc2_:InventoryItemModule = null;
         this._guaranteedList = new Vector.<ItemVO>(0);
         for each(_loc2_ in param1.confirmedList)
         {
            this._guaranteedList.push(ItemVO.fromModule(_loc2_));
         }
         this._guaranteedList.sort(this.sortByName);
         this._chanceList = new Vector.<ItemVO>(0);
         for each(_loc2_ in param1.chanceUpList)
         {
            this._chanceList.push(ItemVO.fromModule(_loc2_));
         }
         this._chanceList.sort(this.sortByName);
         this.rewardCashoutChanged.dispatch();
      }
      
      private function sortByName(param1:ItemVO, param2:ItemVO) : Number
      {
         return StringUtils.compareToIgnoreCase(param1.fullname,param2.fullname);
      }
      
      public function get rewardList() : Vector.<RogueLiteInventoryItemVO>
      {
         return this._rewardList;
      }
      
      public function updateRewards(param1:RogueLiteSelectRewardCommand) : void
      {
         var _loc2_:InventoryItemModule = null;
         var _loc3_:ItemVO = null;
         var _loc4_:UnstableModuleModule = null;
         this._rewardList = new Vector.<RogueLiteInventoryItemVO>(0);
         for each(_loc2_ in param1.content)
         {
            if(_loc2_.lootId.match("package"))
            {
               this._rewardList.push(this.parseAsLootPackage(_loc2_));
            }
            else
            {
               _loc3_ = ItemVO.fromModule(_loc2_);
               if(param1.module.length == 0)
               {
                  this._rewardList.push(new RogueLiteInventoryItemVO(_loc3_));
               }
               else
               {
                  for each(_loc4_ in param1.module)
                  {
                     if(_loc2_.itemId == _loc4_.itemId)
                     {
                        this._rewardList.push(new RogueLiteInventoryItemVO(_loc3_,_loc4_.attributes));
                        break;
                     }
                  }
               }
            }
         }
         this.roomRewardChanged.dispatch();
      }
      
      public function get inventoryTabList() : Vector.<ItemVO>
      {
         if(!this._inventoryTabList || this._inventoryTabList.length == 0)
         {
            this._inventoryTabList = new Vector.<ItemVO>(0);
            this._inventoryTabList.push(ItemDataProviderHelper.getItem("equipment_generator_speed_g3n-1010"));
            this._inventoryTabList.push(ItemDataProviderHelper.getItem("equipment_weapon_laser_lf-1"));
            this._inventoryTabList.push(ItemDataProviderHelper.getItem("equipment_shipupgrade_dmg-t01"));
         }
         return this._inventoryTabList;
      }
      
      public function get inventoryItemList() : Vector.<RogueLiteInventoryItemVO>
      {
         return this._inventoryItemList;
      }
      
      public function updateInventory(param1:RogueLiteInventoryCommand) : void
      {
         var _loc2_:InventoryItemModule = null;
         var _loc3_:ItemVO = null;
         var _loc4_:UnstableModuleModule = null;
         this.canEquip.value = true;
         this._inventoryItemList = new Vector.<RogueLiteInventoryItemVO>(0);
         for each(_loc2_ in param1.inventory)
         {
            _loc3_ = ItemVO.fromModule(_loc2_);
            if(_loc3_.getItemType().indexOf("shipupgrade") < 0)
            {
               this._inventoryItemList.push(new RogueLiteInventoryItemVO(_loc3_));
            }
            else
            {
               for each(_loc4_ in param1.unstableModules)
               {
                  if(_loc2_.itemId == _loc4_.itemId)
                  {
                     this._inventoryItemList.push(new RogueLiteInventoryItemVO(_loc3_,_loc4_.attributes));
                     break;
                  }
               }
            }
         }
         this.inventoryChanged.dispatch();
      }
      
      public function get eventEnabled() : Boolean
      {
         return this._eventEnabled;
      }
      
      public function get rankRewards() : Vector.<RogueLiteRankRewardVO>
      {
         return this._rankRewards;
      }
      
      public function updateRankingInfo(param1:RogueLiteRankEventInfoCommand) : void
      {
         this._eventEnabled = param1.isEventEnabled;
         this.updateRanking(param1.rankInfoCommand);
         this.updateRankingRewardList(param1);
      }
      
      private function updateRankingRewardList(param1:RogueLiteRankEventInfoCommand) : void
      {
         var _loc2_:RankRewardRangeModule = null;
         this._rankRewards = new Vector.<RogueLiteRankRewardVO>(0);
         for each(_loc2_ in param1.playerRankRanges)
         {
            this._rankRewards.push(new RogueLiteRankRewardVO(new BindableInt(_loc2_.from,_loc2_.from,_loc2_.to)));
         }
         this._rankRewards.sort(RogueLiteRankRewardVO.sort);
         this.rankRewardChanged.dispatch();
      }
      
      public function updateRankingRewardsPackage(param1:BindableInt, param2:Vector.<RewardContentModule>) : *
      {
         var _loc3_:RogueLiteRankRewardVO = null;
         for each(_loc3_ in this._rankRewards)
         {
            if(_loc3_.min == param1.minValue && _loc3_.max == param1.maxValue)
            {
               _loc3_.rewards = param2;
            }
         }
      }
      
      public function updateRanking(param1:RogueLiteRankInfoCommand) : void
      {
         this._topRankers = param1.topRankers;
         this._myRank = param1.myRank;
         this.rankingChanged.dispatch();
      }
      
      public function get topRankers() : Vector.<RankModule>
      {
         return this._topRankers;
      }
      
      public function get myRank() : RankModule
      {
         return this._myRank;
      }
      
      private function parseAsLootPackage(param1:InventoryItemModule) : RogueLiteInventoryItemVO
      {
         var _loc4_:InventoryItemAttributeModule = null;
         var _loc2_:ItemVO = new ItemVO();
         _loc2_.item = new Item(null,null);
         _loc2_.lootID = param1.lootId;
         _loc2_.amount = param1.amount;
         _loc2_.id = param1.itemId;
         _loc2_.upgradeLevel = param1.upgradeLevel;
         _loc2_.startLevel = param1.star > 0 ? param1.star : 0;
         var _loc3_:int = int(param1.inventoryItemAttributes.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = param1.inventoryItemAttributes[_loc5_];
            _loc2_.attributes[_loc4_.key] = _loc4_.value;
            _loc5_++;
         }
         return new RogueLiteInventoryItemVO(_loc2_);
      }
   }
}

