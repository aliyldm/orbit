package net.bigpoint.darkorbit.mvc.battlestationswindow.model
{
   public class DeflectorStatusVO
   {
      
      private var _deflectorShieldActive:Boolean;
      
      private var _deflectorShieldSeconds:Number;
      
      private var _deflectorShieldSecondsMax:int;
      
      private var _summedTpf:int = 0;
      
      private var _deflectorShieldRate:int;
      
      public function DeflectorStatusVO(param1:Boolean, param2:int, param3:int, param4:int)
      {
         super();
         this._deflectorShieldActive = param1;
         this._deflectorShieldSeconds = param2;
         this._deflectorShieldSecondsMax = param3;
         this._deflectorShieldRate = param4;
      }
      
      public function increaseDeflectorShieldSeconds(param1:Number) : void
      {
         this._deflectorShieldSeconds += param1;
      }
      
      public function decreaseeDeflectorShieldSeconds(param1:int) : void
      {
         this._deflectorShieldSeconds -= param1;
      }
      
      public function get deflectorShieldSeconds() : Number
      {
         return this._deflectorShieldSeconds;
      }
      
      public function get deflectorShieldSecondsMax() : int
      {
         return this._deflectorShieldSecondsMax;
      }
      
      public function get summedTpf() : int
      {
         return this._summedTpf;
      }
      
      public function get deflectorShieldRate() : int
      {
         return this._deflectorShieldRate;
      }
      
      public function set summedTpf(param1:int) : void
      {
         this._summedTpf = param1;
      }
      
      public function get deflectorShieldActive() : Boolean
      {
         return this._deflectorShieldActive;
      }
   }
}

