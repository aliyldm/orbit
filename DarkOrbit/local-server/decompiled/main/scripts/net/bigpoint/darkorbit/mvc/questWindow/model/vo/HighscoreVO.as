package net.bigpoint.darkorbit.mvc.questWindow.model.vo
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class HighscoreVO implements IEventDispatcher
   {
      
      private var _position:int;
      
      private var _playername:String;
      
      private var _points:int;
      
      private var _active:Boolean;
      
      private var _difference:int;
      
      private var _epppLink:String;
      
      private var _isHero:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function HighscoreVO(param1:int, param2:String, param3:int, param4:Boolean, param5:int, param6:String, param7:Boolean)
      {
         super();
         this._position = param1;
         this._playername = param2;
         this._points = param3;
         this._active = param4;
         this._difference = param5;
         this._epppLink = param6;
         this._isHero = param7;
      }
      
      public function get position() : int
      {
         return this._position;
      }
      
      public function get points() : int
      {
         return this._points;
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function get difference() : int
      {
         return this._difference;
      }
      
      public function get playername() : String
      {
         return this._playername;
      }
      
      public function get epppLink() : String
      {
         return this._epppLink;
      }
      
      public function get isHero() : Boolean
      {
         return this._isHero;
      }
      
      public function getField(param1:String) : Object
      {
         return this[param1];
      }
      
      private function set _1422950650active(param1:Boolean) : void
      {
         this._active = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set active(param1:Boolean) : void
      {
         var _loc2_:Object = this.active;
         if(_loc2_ !== param1)
         {
            this._1422950650active = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"active",_loc2_,param1));
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

