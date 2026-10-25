package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.model
{
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.model.vo.SeasonPassLevelItemVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class SeasonPassUIRewardsData extends EventDispatcher
   {
      
      public const onSeasonPassItemChanged:ISignal = new Signal();
      
      private var _items:Vector.<SeasonPassLevelItemVO> = new Vector.<SeasonPassLevelItemVO>(0);
      
      private var _goldpassLocked:Boolean = false;
      
      private var _extGoldpassLocked:Boolean = false;
      
      public function SeasonPassUIRewardsData()
      {
         super();
      }
      
      public function notifyItemChanged() : void
      {
         this.onSeasonPassItemChanged.dispatch();
      }
      
      public function get levelItems() : Vector.<SeasonPassLevelItemVO>
      {
         return this._items;
      }
      
      public function set levelItems(param1:Vector.<SeasonPassLevelItemVO>) : void
      {
         this._items = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._items.length)
         {
            this._items[_loc2_].isExtGoldLocked = this._extGoldpassLocked;
            this._items[_loc2_].isGoldLocked = this._goldpassLocked;
            _loc2_++;
         }
         this.notifyItemChanged();
      }
      
      public function set goldPassUnlocked(param1:Boolean) : void
      {
         this._goldpassLocked = !param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._items.length)
         {
            this._items[_loc2_].isExtGoldLocked = this._extGoldpassLocked;
            this._items[_loc2_].isGoldLocked = this._goldpassLocked;
            _loc2_++;
         }
         this.notifyItemChanged();
      }
      
      public function get goldPassLocked() : Boolean
      {
         return this._goldpassLocked;
      }
      
      public function set extGoldPassUnlocked(param1:Boolean) : void
      {
         this._extGoldpassLocked = !param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._items.length)
         {
            this._items[_loc2_].isExtGoldLocked = this._extGoldpassLocked;
            _loc2_++;
         }
         this.notifyItemChanged();
      }
      
      public function get extGoldPassLocked() : Boolean
      {
         return this._extGoldpassLocked;
      }
   }
}

