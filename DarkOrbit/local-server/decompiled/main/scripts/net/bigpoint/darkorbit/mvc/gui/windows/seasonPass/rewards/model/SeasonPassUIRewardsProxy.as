package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.model
{
   import net.bigpoint.darkorbit.com.module.SeasonPassRewardClaimCommand;
   import net.bigpoint.darkorbit.com.module.SeasonPassRewardInfoCommand;
   import net.bigpoint.darkorbit.com.module.SeasonPassRewardModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.items.item.Item;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.model.vo.SeasonPassLevelItemVO;
   
   public class SeasonPassUIRewardsProxy extends SimpleWindowProxy
   {
      
      public function SeasonPassUIRewardsProxy(param1:String)
      {
         super(param1,new SeasonPassUIRewardsData());
      }
      
      public function get viewData() : SeasonPassUIRewardsData
      {
         return data as SeasonPassUIRewardsData;
      }
      
      public function updateGoldPassUnlockedStatus(param1:Boolean) : void
      {
         this.viewData.goldPassUnlocked = param1;
      }
      
      public function updateExtGoldPassUnlockedStatus(param1:Boolean) : void
      {
         this.viewData.extGoldPassUnlocked = param1;
      }
      
      public function updateInfo(param1:SeasonPassRewardInfoCommand) : void
      {
         var _loc5_:SeasonPassRewardModule = null;
         var _loc2_:int = this.findMaxLevel(param1);
         var _loc3_:Vector.<SeasonPassLevelItemVO> = new Vector.<SeasonPassLevelItemVO>();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_.push(new SeasonPassLevelItemVO());
            _loc4_++;
         }
         for each(_loc5_ in param1.extGoldPassRewardItems)
         {
            _loc3_[_loc5_.level].extGoldItemVO = this.getItemVO(_loc5_.lootId);
            _loc3_[_loc5_.level].extGoldItemVO.amount = _loc5_.amount;
            _loc3_[_loc5_.level].extGoldItemVO.upgradeLevel = _loc5_.level;
            _loc3_[_loc5_.level].isExtGoldItemClaimed = _loc5_.claimed;
         }
         for each(_loc5_ in param1.goldPassRewardItems)
         {
            _loc3_[_loc5_.level].goldItemVO = this.getItemVO(_loc5_.lootId);
            _loc3_[_loc5_.level].goldItemVO.amount = _loc5_.amount;
            _loc3_[_loc5_.level].goldItemVO.upgradeLevel = _loc5_.level;
            _loc3_[_loc5_.level].isGoldItemClaimed = _loc5_.claimed;
         }
         for each(_loc5_ in param1.freeRewardItems)
         {
            _loc3_[_loc5_.level].freeItemVO = this.getItemVO(_loc5_.lootId);
            _loc3_[_loc5_.level].freeItemVO.amount = _loc5_.amount;
            _loc3_[_loc5_.level].freeItemVO.upgradeLevel = _loc5_.level;
            _loc3_[_loc5_.level].isFreeItemClaimed = _loc5_.claimed;
         }
         this.viewData.levelItems = _loc3_;
      }
      
      private function getItemVO(param1:String) : ItemVO
      {
         return param1.match("package") ? this.parseLootPackage(param1) : ItemDataProviderHelper.getItem(param1);
      }
      
      public function updateClaimStatus(param1:SeasonPassRewardClaimCommand) : void
      {
         if(param1.extGoldPass)
         {
            this.viewData.levelItems[param1.level].isExtGoldItemClaimed = param1.claimed;
         }
         else if(param1.goldPass)
         {
            this.viewData.levelItems[param1.level].isGoldItemClaimed = param1.claimed;
         }
         else
         {
            this.viewData.levelItems[param1.level].isFreeItemClaimed = param1.claimed;
         }
         this.viewData.notifyItemChanged();
      }
      
      private function findMaxLevel(param1:SeasonPassRewardInfoCommand) : int
      {
         var _loc3_:SeasonPassRewardModule = null;
         var _loc2_:int = 0;
         for each(_loc3_ in param1.freeRewardItems)
         {
            _loc2_ = Math.max(_loc2_,_loc3_.level);
         }
         for each(_loc3_ in param1.goldPassRewardItems)
         {
            _loc2_ = Math.max(_loc2_,_loc3_.level);
         }
         for each(_loc3_ in param1.extGoldPassRewardItems)
         {
            _loc2_ = Math.max(_loc2_,_loc3_.level);
         }
         return _loc2_ + 1;
      }
      
      private function parseLootPackage(param1:String) : ItemVO
      {
         var _loc2_:ItemVO = new ItemVO();
         _loc2_.item = new Item(null,null);
         _loc2_.lootID = param1;
         return _loc2_;
      }
   }
}

