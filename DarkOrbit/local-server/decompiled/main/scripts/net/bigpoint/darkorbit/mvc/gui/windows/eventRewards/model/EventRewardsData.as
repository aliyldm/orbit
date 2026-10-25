package net.bigpoint.darkorbit.mvc.gui.windows.eventRewards.model
{
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class EventRewardsData
   {
      
      public const changed:ISignal = new Signal();
      
      private var _rewardItems:Vector.<RewardContentModule> = new Vector.<RewardContentModule>();
      
      private var _place:int = 0;
      
      private var _rewardType:int = 0;
      
      public function EventRewardsData(param1:int, param2:Vector.<RewardContentModule>, param3:int = 0)
      {
         super();
         this._place = param3;
         this._rewardItems = param2;
         this._rewardType = param1;
      }
      
      public function setData(param1:int, param2:Vector.<RewardContentModule>, param3:int = 0) : void
      {
         this._place = param3;
         this._rewardItems = param2;
         this._rewardType = param1;
         this.changed.dispatch();
      }
      
      public function get rewardItems() : Vector.<RewardContentModule>
      {
         return this._rewardItems;
      }
      
      public function set rewardItems(param1:Vector.<RewardContentModule>) : void
      {
         this._rewardItems = param1;
         this.changed.dispatch();
      }
      
      public function get place() : int
      {
         return this._place;
      }
      
      public function set place(param1:int) : void
      {
         this._place = param1;
         this.changed.dispatch();
      }
      
      public function get rewardType() : int
      {
         return this._rewardType;
      }
      
      public function set rewardType(param1:int) : void
      {
         this._rewardType = param1;
      }
      
      public function isValid() : Boolean
      {
         return Boolean(this._rewardItems) && this._rewardItems.length > 0;
      }
   }
}

