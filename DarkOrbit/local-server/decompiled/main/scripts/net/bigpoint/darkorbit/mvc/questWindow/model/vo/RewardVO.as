package net.bigpoint.darkorbit.mvc.questWindow.model.vo
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.darkorbit.com.module.LootModule;
   
   public class RewardVO implements IEventDispatcher
   {
      
      private var _amount:int;
      
      private var _lootId:String;
      
      private var _modifier:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function RewardVO(param1:LootModule)
      {
         super();
         this._amount = param1.amount;
         this._lootId = param1.lootId;
         this._modifier = param1.modifier;
      }
      
      public function get amount() : int
      {
         return this._amount;
      }
      
      private function set _1413853096amount(param1:int) : void
      {
         this._amount = param1;
      }
      
      public function get lootId() : String
      {
         return this._lootId;
      }
      
      private function set _1097087517lootId(param1:String) : void
      {
         this._lootId = param1;
      }
      
      public function get modifier() : String
      {
         return this._modifier;
      }
      
      private function set _615513385modifier(param1:String) : void
      {
         this._modifier = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set amount(param1:int) : void
      {
         var _loc2_:Object = this.amount;
         if(_loc2_ !== param1)
         {
            this._1413853096amount = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"amount",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set modifier(param1:String) : void
      {
         var _loc2_:Object = this.modifier;
         if(_loc2_ !== param1)
         {
            this._615513385modifier = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"modifier",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set lootId(param1:String) : void
      {
         var _loc2_:Object = this.lootId;
         if(_loc2_ !== param1)
         {
            this._1097087517lootId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lootId",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

