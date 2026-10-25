package net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.model.vo
{
   import net.bigpoint.darkorbit.com.module.porting.birthday2025.Birthday2025PointRewardCommand;
   import net.bigpoint.darkorbit.com.module.porting.events.EventLootShowCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.highlights.HighLightItemNotification;
   import net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.model.BirthdayGate2025Constants;
   
   public class Birthday2025PointRewardViewData
   {
      
      private var _sourceData:Birthday2025PointRewardCommand;
      
      private var _currentRewardItems:Vector.<Birthday2025PointRewardItemData>;
      
      private var _hasClaim:Boolean = false;
      
      public function Birthday2025PointRewardViewData()
      {
         super();
      }
      
      public function update(param1:Birthday2025PointRewardCommand) : void
      {
         this._currentRewardItems = null;
         this._sourceData = param1;
         this._currentRewardItems = new Vector.<Birthday2025PointRewardItemData>();
         this._hasClaim = false;
         this.formatData();
         this.showMenuIconRedDot();
      }
      
      private function formatData() : void
      {
         var _loc4_:EventLootShowCommand = null;
         var _loc5_:Birthday2025PointRewardItemData = null;
         var _loc1_:int = 0;
         var _loc2_:Vector.<int> = this._sourceData.claimedIndexes;
         var _loc3_:int = 0;
         while(_loc3_ < this._sourceData.lootShowCommandList.length)
         {
            _loc4_ = this._sourceData.lootShowCommandList[_loc3_];
            _loc5_ = new Birthday2025PointRewardItemData(_loc4_.lootId,_loc4_.lootAmount,_loc4_.bg);
            _loc5_.index = _loc3_ + 1;
            if(_loc2_.indexOf(_loc5_.index) != -1)
            {
               _loc1_ = _loc5_.index;
               _loc5_.isClaim = true;
            }
            else if(_loc5_.index <= this._sourceData.curRewardLevel)
            {
               _loc5_.canClaim = true;
               this._hasClaim = true;
            }
            this._currentRewardItems.push(_loc5_);
            _loc3_++;
         }
         if(_loc1_ >= this._currentRewardItems.length)
         {
            _loc1_--;
         }
         this._currentRewardItems[_loc1_].isLast = true;
      }
      
      private function showMenuIconRedDot() : void
      {
         if(this._hasClaim)
         {
            GameFacade.getInstance().sendNotification(HighLightItemNotification.ADD_HIGHLIGHT,BirthdayGate2025Constants.RED_DOT);
         }
         else
         {
            GameFacade.getInstance().sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,BirthdayGate2025Constants.RED_DOT);
         }
      }
      
      public function get hasClaim() : Boolean
      {
         return this._hasClaim;
      }
      
      public function get curRewardLevel() : int
      {
         return this._sourceData.curRewardLevel;
      }
      
      public function get curLevelTotalPoint() : int
      {
         return this._sourceData.curLevelPoints;
      }
      
      public function get curPoints() : int
      {
         return this._sourceData.curPoints;
      }
      
      public function get rewardItems() : Vector.<Birthday2025PointRewardItemData>
      {
         return this._currentRewardItems;
      }
   }
}

