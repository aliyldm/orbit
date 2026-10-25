package net.bigpoint.darkorbit.questfm.conditions
{
   public class MiscellaneousConditionTypes
   {
      
      private static var _instance:MiscellaneousConditionTypes;
      
      private var _types:Array = [];
      
      public function MiscellaneousConditionTypes(param1:Function)
      {
         super();
         this._types[0] = "NOTHING";
         this._types[1] = "ON_ENEMY_MAP";
         this._types[2] = "ON_PVP_MAP";
         this._types[3] = "VISIBLE";
         this._types[4] = "INVISIBLE";
         this._types[5] = "IN_RADIATION_AREA";
         this._types[6] = "INSTANT_SHIELD_ACTIVE";
         this._types[7] = "LOW_ON_LIFE";
         this._types[8] = "ATTACKING";
         this._types[9] = "ATTACKED";
         this._types[10] = "MARTYR";
         this._types[11] = "REPAIRING";
         this._types[12] = "OUTLAW";
         this._types[13] = "ON_HOME_MAP";
         this._types[14] = "ON_HOSTILE_HOME_MAP";
         this._types[15] = "ON_MARS_MAP";
         this._types[16] = "ON_EARTH_MAP";
         this._types[17] = "ON_VENUS_MAP";
         this._types[18] = "ON_OWN_FACTION_MAP";
         this._types[19] = "ON_X_1";
         this._types[20] = "ON_X_2";
         this._types[21] = "ON_X_3";
         this._types[22] = "ON_X_4";
         this._types[23] = "ON_X_5";
         this._types[24] = "ON_X_6";
         this._types[25] = "ON_X_7";
         this._types[26] = "ON_X_8";
         this._types[27] = "ON_EVENT_MAP";
         this._types[28] = "ON_ESCORT_MAP";
         this._types[29] = "ON_EVENT_OR_BATTLE_MAP";
         this._types[30] = "ON_ESCORT_OR_BATTLE_MAP";
         this._types[31] = "ON_ETERNAL_MAP";
         this._types[32] = "ON_GOP_MAP";
         this._types[33] = "ON_GALACTIC_STRIFE_MAP";
         this._types[34] = "ON_ETERNAL_BLACKLIGHT_MAP";
         this._types[35] = "ON_FROZEN_LABYRINTH_MAP";
         if(param1 !== hidden)
         {
            throw new Error("MiscellaneousConditionTypes is a Singleton and can only be accessed through MiscellaneousConditionTypes.getInstance()");
         }
      }
      
      private static function hidden() : void
      {
      }
      
      public static function get instance() : MiscellaneousConditionTypes
      {
         if(_instance == null)
         {
            _instance = new MiscellaneousConditionTypes(hidden);
         }
         return _instance;
      }
      
      public function getTranslationSuffix(param1:int) : String
      {
         return String(this._types[param1]);
      }
   }
}

