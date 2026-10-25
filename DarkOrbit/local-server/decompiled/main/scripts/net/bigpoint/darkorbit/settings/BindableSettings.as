package net.bigpoint.darkorbit.settings
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BindableSettings
   {
      
      public static const NONE:int = int.MIN_VALUE;
      
      public static const LOW:int = 0;
      
      public static const MEDIUM:int = 1;
      
      public static const HIGH:int = 2;
      
      public static const ULTRA:int = 3;
      
      public const none:BindableBoolean = new BindableBoolean(false);
      
      public const low:BindableBoolean = new BindableBoolean(false);
      
      public const medium:BindableBoolean = new BindableBoolean(false);
      
      public const high:BindableBoolean = new BindableBoolean(false);
      
      public const max:BindableBoolean = new BindableBoolean(false);
      
      public const changed:ISignal = new Signal();
      
      private var _value:int = 0;
      
      public function BindableSettings(param1:int = -2147483648)
      {
         super();
         this._value = param1;
         this.updateBooleans();
      }
      
      public function get value() : int
      {
         return this._value;
      }
      
      public function set value(param1:int) : void
      {
         if(this._value != param1)
         {
            this._value = param1;
            this.updateBooleans();
            this.changed.dispatch();
         }
      }
      
      private function updateBooleans() : void
      {
         this.none.value = this.value >= NONE;
         this.low.value = this.value >= LOW;
         this.medium.value = this.value >= MEDIUM;
         this.high.value = this.value >= HIGH;
         this.max.value = this.value >= ULTRA;
      }
   }
}

