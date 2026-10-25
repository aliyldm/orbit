package com.bigpoint.utils.bindables
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BindableRotation
   {
      
      private const PI_DIV_180:Number = 0.017453292519943295;
      
      private const PI_DIV_180_INV:Number = 57.29577951308232;
      
      public const changed:ISignal = new Signal();
      
      private var _degrees:int = 0;
      
      public function BindableRotation(param1:int = 0)
      {
         super();
         this.degrees = param1;
      }
      
      public function get degrees() : int
      {
         return this._degrees;
      }
      
      public function set degrees(param1:int) : void
      {
         if(this._degrees != param1)
         {
            this._degrees = param1;
            this.changed.dispatch();
         }
      }
      
      public function getAbsoluteDegrees() : int
      {
         var _loc1_:int = this._degrees;
         while(_loc1_ >= 360)
         {
            _loc1_ -= 360;
         }
         while(_loc1_ < 0)
         {
            _loc1_ += 360;
         }
         return _loc1_;
      }
      
      public function get radians() : Number
      {
         return this._degrees * this.PI_DIV_180;
      }
      
      public function set radians(param1:Number) : void
      {
         this.degrees = param1 * this.PI_DIV_180_INV;
      }
   }
}

