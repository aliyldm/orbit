package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.model.vo
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class SeasonPassLevelItemVO
   {
      
      public const onClaimItem:ISignal = new Signal();
      
      private var _freeItemVO:ItemVO;
      
      private var _freeItemClaimed:BindableBoolean = new BindableBoolean();
      
      private var _goldLocked:Boolean;
      
      private var _goldItemVO:ItemVO;
      
      private var _goldItemClaimed:BindableBoolean = new BindableBoolean();
      
      private var _levelClaimable:BindableBoolean = new BindableBoolean();
      
      private var _extGoldLocked:Boolean;
      
      private var _extGoldItemVO:ItemVO;
      
      private var _extGoldItemClaimed:BindableBoolean = new BindableBoolean();
      
      private var _extLevelClaimable:BindableBoolean = new BindableBoolean();
      
      public function SeasonPassLevelItemVO()
      {
         super();
         this._freeItemVO = null;
         this._freeItemClaimed.value = false;
         this._goldLocked = false;
         this._goldItemVO = null;
         this._goldItemClaimed.value = false;
         this._levelClaimable.value = false;
         this._extGoldLocked = false;
         this._extGoldItemVO = null;
         this._extGoldItemClaimed.value = false;
         this._extLevelClaimable.value = false;
      }
      
      public function set freeItemVO(param1:ItemVO) : void
      {
         this._freeItemVO = param1;
      }
      
      public function get freeItemVO() : ItemVO
      {
         return this._freeItemVO;
      }
      
      public function set isFreeItemClaimed(param1:Boolean) : void
      {
         this._freeItemClaimed.value = param1;
      }
      
      public function get isFreeItemClaimed() : Boolean
      {
         return this._freeItemClaimed.value;
      }
      
      public function get freeItemClaimedBindable() : BindableBoolean
      {
         return this._freeItemClaimed;
      }
      
      public function set goldItemVO(param1:ItemVO) : void
      {
         this._goldItemVO = param1;
      }
      
      public function get goldItemVO() : ItemVO
      {
         return this._goldItemVO;
      }
      
      public function set isGoldItemClaimed(param1:Boolean) : void
      {
         this._goldItemClaimed.value = param1;
      }
      
      public function get isGoldItemClaimed() : Boolean
      {
         return this._goldItemClaimed.value;
      }
      
      public function get goldItemClaimedBindable() : BindableBoolean
      {
         return this._goldItemClaimed;
      }
      
      public function set isGoldLocked(param1:Boolean) : void
      {
         this._goldLocked = param1;
      }
      
      public function get isGoldLocked() : Boolean
      {
         return this._goldLocked;
      }
      
      public function set isLevelClaimable(param1:Boolean) : void
      {
         this._levelClaimable.value = param1;
      }
      
      public function get isFreeItemClaimable() : Boolean
      {
         return !this.isFreeItemClaimed && this._levelClaimable.value && this._freeItemVO != null;
      }
      
      public function get isGoldItemClaimable() : Boolean
      {
         return !this.isGoldItemClaimed && this._levelClaimable.value && this._goldItemVO != null;
      }
      
      public function get isExtGoldItemClaimable() : Boolean
      {
         return !this.isExtGoldItemClaimed && this._levelClaimable.value && this._extGoldItemVO != null;
      }
      
      public function get levelClaimableBindable() : BindableBoolean
      {
         return this._levelClaimable;
      }
      
      public function get extGoldLocked() : Boolean
      {
         return this._extGoldLocked;
      }
      
      public function set extGoldLocked(param1:Boolean) : void
      {
         this._extGoldLocked = param1;
      }
      
      public function get extGoldItemVO() : ItemVO
      {
         return this._extGoldItemVO;
      }
      
      public function set extGoldItemVO(param1:ItemVO) : void
      {
         this._extGoldItemVO = param1;
      }
      
      public function get extGoldItemClaimed() : BindableBoolean
      {
         return this._extGoldItemClaimed;
      }
      
      public function set extGoldItemClaimed(param1:BindableBoolean) : void
      {
         this._extGoldItemClaimed = param1;
      }
      
      public function get extLevelClaimable() : BindableBoolean
      {
         return this._extLevelClaimable;
      }
      
      public function set extLevelClaimable(param1:BindableBoolean) : void
      {
         this._extLevelClaimable = param1;
      }
      
      public function set isExtGoldItemClaimed(param1:Boolean) : void
      {
         this._extGoldItemClaimed.value = param1;
      }
      
      public function get isExtGoldItemClaimed() : Boolean
      {
         return this._extGoldItemClaimed.value;
      }
      
      public function get extGoldItemClaimedBindable() : BindableBoolean
      {
         return this._extGoldItemClaimed;
      }
      
      public function set isExtGoldLocked(param1:Boolean) : void
      {
         this._extGoldLocked = param1;
      }
      
      public function get isExtGoldLocked() : Boolean
      {
         return this._extGoldLocked;
      }
   }
}

