package net.bigpoint.darkorbit.map.common.animation
{
   public class TweenData
   {
      
      private var _targetId:String;
      
      private var _time:Number;
      
      private var _currentTime:Number;
      
      private var _props:Object;
      
      public function TweenData(param1:String, param2:Number, param3:Object, param4:Number)
      {
         super();
         this._props = param3;
         this._time = param2;
         this._targetId = param1;
         this._currentTime = param4;
      }
      
      public function get props() : Object
      {
         return this._props;
      }
      
      public function set props(param1:Object) : void
      {
         this._props = param1;
      }
      
      public function get time() : Number
      {
         return this._time;
      }
      
      public function get targetId() : String
      {
         return this._targetId;
      }
      
      public function get currentTime() : Number
      {
         return this._currentTime;
      }
      
      public function set currentTime(param1:Number) : void
      {
         this._currentTime = param1;
      }
   }
}

