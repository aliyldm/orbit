package net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.view.components
{
   import flash.events.Event;
   
   public class EventProgressBarEvent extends Event
   {
      
      public static const EVENT_UPDATE_REWARD_PROGRESS:String = "EVENT_UPDATE_REWARD_PROGRESS";
      
      public static const EVENT_COLLECTABLE_ITEM_AVAILABLE:String = "EVENT_COLLECTABLE_ITEM_AVAILABLE";
      
      public static const EVENT_UPDATE_FINAL_REWARD_TOOLTIP:String = "EVENT_UPDATE_FINAL_REWARD_TOOLTIP";
      
      private var _absoluteProgress:Number;
      
      private var _nextRewardAbsolute:Number;
      
      private var _progress:Number;
      
      private var _select:Boolean;
      
      private var _collectableItemAvailable:Boolean;
      
      private var _maxProgressReached:Boolean;
      
      private var _finalRewardTooltip:String;
      
      public function EventProgressBarEvent(param1:String)
      {
         super(param1);
      }
      
      public function setAbsoluteProgress(param1:Number) : EventProgressBarEvent
      {
         this._absoluteProgress = param1;
         return this;
      }
      
      public function get absoluteProgress() : Number
      {
         return this._absoluteProgress;
      }
      
      public function setNextRewardAbsolute(param1:Number) : EventProgressBarEvent
      {
         this._nextRewardAbsolute = param1;
         return this;
      }
      
      public function get nextRewardAbsolute() : Number
      {
         return this._nextRewardAbsolute;
      }
      
      public function setProgress(param1:Number) : EventProgressBarEvent
      {
         this._progress = param1;
         return this;
      }
      
      public function get progress() : Number
      {
         return this._progress;
      }
      
      public function setSelection(param1:Boolean) : EventProgressBarEvent
      {
         this._select = param1;
         return this;
      }
      
      public function get select() : Boolean
      {
         return this._select;
      }
      
      public function setCollectableItemAvailable(param1:Boolean) : EventProgressBarEvent
      {
         this._collectableItemAvailable = param1;
         return this;
      }
      
      public function collectableItemsAvailable() : Boolean
      {
         return this._collectableItemAvailable;
      }
      
      public function setMaxProgressReached(param1:Boolean) : EventProgressBarEvent
      {
         this._maxProgressReached = param1;
         return this;
      }
      
      public function maxProgressReached() : Boolean
      {
         return this._maxProgressReached;
      }
      
      public function finalRewardTooltip() : String
      {
         return this._finalRewardTooltip;
      }
      
      public function setFinalRewardTooltip(param1:String) : EventProgressBarEvent
      {
         this._finalRewardTooltip = param1;
         return this;
      }
   }
}

