package net.bigpoint.darkorbit.pattern
{
   public class BuffPattern
   {
      
      public static const SINGULARITY_BUFF:int = 1;
      
      public static const SPEEDLEACH_BUFF:int = 2;
      
      public static const TRADE_BUFF:int = 3;
      
      public static const WEAKENSHIELD_BUFF:int = 4;
      
      public static const KAMIKAZE_BUFF:int = 5;
      
      public static const SHIP_REPAIR_BUFF:int = 6;
      
      public static const FRIENDLY_SACRIFICE:int = 7;
      
      public static const PET_RETARGETING_GEAR:int = 8;
      
      public static const PET_HP_LINK_GEAR:int = 9;
      
      public static const PET_MEGA_MINE_GEAR:int = 10;
      
      public static const PET_COMBAT_BEACON_GEAR:int = 11;
      
      public static const PET_HP_BEACON_GEAR:int = 12;
      
      public static const PET_HEAT_RELEASE_GEAR:int = 13;
      
      public static const PET_SIMPLE_BLOCKING_WINDOW:int = 99;
      
      public var id:int;
      
      public var resKey:String;
      
      public var languageKey:String;
      
      public var effect:int;
      
      public function BuffPattern(param1:int, param2:String, param3:String, param4:int)
      {
         super();
         this.id = param1;
         this.resKey = param2;
         this.languageKey = param3;
         this.effect = param4;
      }
   }
}

