package net.bigpoint.darkorbit.settings
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class CrowdedCombatPreset
   {
      
      private static var _enabled:Boolean;
      
      public static const changed:ISignal = new Signal();
      
      public function CrowdedCombatPreset()
      {
         super();
      }
      
      public static function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public static function applyForMap(param1:int) : void
      {
         var _loc2_:Boolean = isMapEnabled(param1);
         if(_enabled == _loc2_)
         {
            return;
         }
         _enabled = _loc2_;
         changed.dispatch();
      }
      
      public static function isMapEnabled(param1:int) : Boolean
      {
         return param1 == 482 || param1 == 13 || param1 == 14 || param1 == 15 || param1 == 16 || param1 == 29 || param1 >= 483 && param1 <= 492;
      }
   }
}

