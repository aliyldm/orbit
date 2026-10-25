package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class KillCounterEffect extends MapObjectEffect
   {
      
      private var _killCount:int;
      
      private var _colorId:int;
      
      private var _colorGlow:int;
      
      private var _effectName:String;
      
      public function KillCounterEffect(param1:Ship, param2:int, param3:String, param4:int = 0, param5:int = 0)
      {
         this._effectName = param3;
         this._colorId = param4 == 0 ? this.getColor() : param4;
         this._colorGlow = param5 == 0 ? this.getColorGlow() : param5;
         this._killCount = param2;
         super(EffectIDList.KILL_COUNTER_EFFECT,param1,NOT_PERSISTANT);
      }
      
      public function get killCount() : int
      {
         return this._killCount;
      }
      
      public function get colorId() : int
      {
         return this._colorId;
      }
      
      public function get colorGlow() : int
      {
         return this._colorGlow;
      }
      
      public function get effectName() : String
      {
         return this._effectName;
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return true;
      }
      
      private function getColor() : int
      {
         switch(this.effectName)
         {
            case "PROMETHEUS_KILL_COUNTER_VISUAL_PERK":
               return int("0x7182FF");
            case "KILL_COUNTER_VISUAL_PERK":
               return int("0xFFFF96");
            default:
               return int("0xFFFF96");
         }
      }
      
      private function getColorGlow() : int
      {
         switch(this.effectName)
         {
            case "PROMETHEUS_KILL_COUNTER_VISUAL_PERK":
               return int("0x1649FF");
            case "KILL_COUNTER_VISUAL_PERK":
               return int("0xFF6E00");
            default:
               return int("0xFF6E00");
         }
      }
   }
}

