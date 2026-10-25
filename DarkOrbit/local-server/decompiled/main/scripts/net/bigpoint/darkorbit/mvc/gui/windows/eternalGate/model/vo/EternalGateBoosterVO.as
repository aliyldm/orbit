package net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.model.vo
{
   public class EternalGateBoosterVO
   {
      
      public static const boosterTypes:Vector.<String> = new <String>["ability_cooldown_time","damage","damage_laser","damage_rockets","hitchance_laser","hitpoints","shield","speed"];
      
      private var _category:String;
      
      private var _percentage:int;
      
      public function EternalGateBoosterVO(param1:String, param2:int)
      {
         super();
         this._category = param1;
         this._percentage = param2;
      }
      
      public function get category() : String
      {
         return this._category;
      }
      
      public function get percentage() : int
      {
         return this._percentage;
      }
      
      public function set percentage(param1:int) : void
      {
         this._percentage = param1;
      }
   }
}

