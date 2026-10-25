package com.bigpoint.utils.time
{
   public class TimeVo
   {
      
      private var _daysVal:int;
      
      private var _hoursVal:int;
      
      private var _minutesVal:int;
      
      private var _secondsVal:int;
      
      public function TimeVo(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0)
      {
         super();
         this._secondsVal = param4;
         this._minutesVal = param3;
         this._hoursVal = param2;
         this._daysVal = param1;
      }
      
      public function get daysVal() : int
      {
         return this._daysVal;
      }
      
      public function get hoursVal() : int
      {
         return this._hoursVal;
      }
      
      public function get minutesVal() : int
      {
         return this._minutesVal;
      }
      
      public function get secondsVal() : int
      {
         return this._secondsVal;
      }
      
      public function set daysVal(param1:int) : void
      {
         this._daysVal = param1;
      }
      
      public function set hoursVal(param1:int) : void
      {
         this._hoursVal = param1;
      }
      
      public function set minutesVal(param1:int) : void
      {
         this._minutesVal = param1;
      }
      
      public function set secondsVal(param1:int) : void
      {
         this._secondsVal = param1;
      }
   }
}

