package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.model
{
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.DispatchGetRetrieverListCommand;
   import net.bigpoint.darkorbit.com.module.DispatchGetRewardPackageCommand;
   import net.bigpoint.darkorbit.com.module.DispatchModule;
   import net.bigpoint.darkorbit.com.module.DispatchRewardModule;
   import net.bigpoint.darkorbit.com.module.DispatchSlotCostCommand;
   import net.bigpoint.darkorbit.com.module.DispatchSlotInfoCommand;
   import net.bigpoint.darkorbit.com.module.DispatchSlotModule;
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.model.vo.DispatchRetrieverVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.rewardlist.model.DispatchRewardVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class DispatchRetrieverData extends EventDispatcher
   {
      
      public const changed:ISignal = new Signal();
      
      public const rewardListPopup:ISignal = new Signal();
      
      private var _availableRetrieverList:Vector.<DispatchRetrieverVO>;
      
      private var _inProgressRetrieverList:Vector.<DispatchRetrieverVO>;
      
      private var _selectedRetrieverVO:DispatchRetrieverVO;
      
      private var _rewardListName:String;
      
      private var _rewardsList:Vector.<DispatchRewardVO>;
      
      private var _slotCosts:Vector.<DispatchSlotModule>;
      
      private var _availableSlotCount:int = 0;
      
      private var _currentMaxSlotCount:int = 0;
      
      public function DispatchRetrieverData()
      {
         super();
         this.updateRetrieverList(DispatchDefaultList.getRetrieverList());
         this.updateSlotCosts(DispatchDefaultList.getSlotCost());
      }
      
      public function updateRetrieverList(param1:DispatchGetRetrieverListCommand) : void
      {
         var _loc2_:DispatchModule = null;
         var _loc3_:DispatchRetrieverVO = null;
         if(param1.statusType == DispatchGetRetrieverListCommand.STATUSTYPE_AVAILABLE)
         {
            this._availableRetrieverList = new Vector.<DispatchRetrieverVO>(0);
            for each(_loc2_ in param1.retrieverList)
            {
               _loc3_ = new DispatchRetrieverVO();
               _loc3_.dispatchModule = _loc2_;
               _loc3_.isAvailable = true;
               _loc3_.changedSignal = this.changed;
               this._availableRetrieverList.push(_loc3_);
            }
            this._availableRetrieverList.sort(DispatchRetrieverVO.sort);
         }
         else if(param1.statusType == DispatchGetRetrieverListCommand.STATUSTYPE_IN_PROGRESS)
         {
            this._inProgressRetrieverList = new Vector.<DispatchRetrieverVO>(0);
            for each(_loc2_ in param1.retrieverList)
            {
               _loc3_ = new DispatchRetrieverVO();
               _loc3_.dispatchModule = _loc2_;
               _loc3_.isAvailable = false;
               _loc3_.changedSignal = this.changed;
               this._inProgressRetrieverList.push(_loc3_);
            }
            this._inProgressRetrieverList.sort(DispatchRetrieverVO.sort);
         }
         this.changed.dispatch();
      }
      
      public function get availableRetrieverList() : Vector.<DispatchRetrieverVO>
      {
         return this._availableRetrieverList;
      }
      
      public function get inProgressRetrieverList() : Vector.<DispatchRetrieverVO>
      {
         return this._inProgressRetrieverList;
      }
      
      public function showRewardListPopup(param1:DispatchGetRewardPackageCommand) : void
      {
         var _loc2_:RewardContentModule = null;
         var _loc3_:DispatchRewardVO = null;
         this._rewardListName = param1.name;
         this._rewardsList = new Vector.<DispatchRewardVO>(0);
         for each(_loc2_ in param1.rewards)
         {
            _loc3_ = new DispatchRewardVO();
            _loc3_.rewardModule = _loc2_ as DispatchRewardModule;
            this._rewardsList.push(_loc3_);
         }
         this.rewardListPopup.dispatch();
      }
      
      public function get selectedRetrieverVO() : DispatchRetrieverVO
      {
         return this._selectedRetrieverVO;
      }
      
      public function set selectedRetrieverVO(param1:DispatchRetrieverVO) : void
      {
         this._selectedRetrieverVO = param1;
      }
      
      public function get rewardListName() : String
      {
         return this._rewardListName;
      }
      
      public function get rewardsList() : Vector.<DispatchRewardVO>
      {
         return this._rewardsList;
      }
      
      public function updateSlotCosts(param1:DispatchSlotCostCommand) : void
      {
         this._slotCosts = param1.slotCosts;
      }
      
      public function getNextSlotCost() : DispatchSlotModule
      {
         if(!this._slotCosts || this._currentMaxSlotCount >= this._slotCosts.length)
         {
            return null;
         }
         return this._slotCosts[this._currentMaxSlotCount];
      }
      
      public function updateSlotInfo(param1:DispatchSlotInfoCommand) : void
      {
         this._availableSlotCount = param1.availableSlotCount;
         this._currentMaxSlotCount = param1.currentMaxSlotCount;
         this.changed.dispatch();
      }
      
      public function get availableSlotCount() : int
      {
         return this._availableSlotCount;
      }
      
      public function get currentMaxSlotCount() : int
      {
         return this._currentMaxSlotCount;
      }
   }
}

