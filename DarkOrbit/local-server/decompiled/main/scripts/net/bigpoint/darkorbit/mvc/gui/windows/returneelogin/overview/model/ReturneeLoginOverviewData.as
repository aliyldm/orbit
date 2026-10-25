package net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.overview.model
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.ReturneeLoginInitialRewardClaimableInfoCommand;
   import net.bigpoint.darkorbit.com.module.ReturneeLoginInitialRewardInfoCommand;
   import net.bigpoint.darkorbit.com.module.ReturneeLoginItemRewardModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   
   public class ReturneeLoginOverviewData extends EventDispatcher
   {
      
      public const claimable:BindableBoolean = new BindableBoolean();
      
      private var _rewardList:Vector.<ItemVO> = new Vector.<ItemVO>(0);
      
      public function ReturneeLoginOverviewData()
      {
         super();
      }
      
      public function updateInfo(param1:ReturneeLoginInitialRewardInfoCommand) : void
      {
         var _loc2_:ReturneeLoginItemRewardModule = null;
         var _loc3_:ItemVO = null;
         this.claimable.value = param1.isClaimable;
         this._rewardList = new Vector.<ItemVO>();
         for each(_loc2_ in param1.rewardList)
         {
            _loc3_ = ItemDataProviderHelper.getItem(_loc2_.lootId);
            _loc3_.amount = _loc2_.amount;
            this._rewardList.push(_loc3_);
         }
      }
      
      public function updateClaimable(param1:ReturneeLoginInitialRewardClaimableInfoCommand) : void
      {
         this.claimable.value = param1.isClaimable;
      }
      
      public function get rewardList() : Vector.<ItemVO>
      {
         return this._rewardList;
      }
   }
}

