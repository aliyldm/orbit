package net.bigpoint.darkorbit.map.hud.ship
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class HealthInfoDisplayConfig
   {
      
      public static const HEALS_COLOR:uint = 3203878;
      
      public static const SHIELD_COLOR:uint = 33023;
      
      public static const NANO_HEALS_COLOR:uint = 16776960;
      
      private var _width:Number = 50;
      
      private var _height:Number = 3;
      
      private var _shieldColor:uint = 33023;
      
      private var _nanoHealthColor:uint = 16776960;
      
      private var _healthColor:uint = 3203878;
      
      public const changed:ISignal = new Signal();
      
      public function HealthInfoDisplayConfig()
      {
         super();
      }
      
      public function get width() : Number
      {
         return this._width;
      }
      
      public function get height() : Number
      {
         return this._height;
      }
      
      public function get shieldColor() : uint
      {
         return this._shieldColor;
      }
      
      public function get nanoHealthColor() : uint
      {
         return this._nanoHealthColor;
      }
      
      public function get healthColor() : uint
      {
         return this._healthColor;
      }
      
      public function set width(param1:Number) : void
      {
         if(this._width != param1)
         {
            this._width = param1;
            this.changed.dispatch();
         }
      }
      
      public function set height(param1:Number) : void
      {
         if(this._height != param1)
         {
            this._height = param1;
            this.changed.dispatch();
         }
      }
   }
}

