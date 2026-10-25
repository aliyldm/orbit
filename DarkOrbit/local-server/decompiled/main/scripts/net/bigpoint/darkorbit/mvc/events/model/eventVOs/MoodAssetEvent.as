package net.bigpoint.darkorbit.mvc.events.model.eventVOs
{
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.mvc.events.model.interfaces.IDOEvent;
   
   public class MoodAssetEvent implements IDOEvent
   {
      
      public static const SPRING_FIGHT_MOOD_ASSET_LIB_ID:String = "springFightMoodAssetsDefinition";
      
      public static const BREACH_MOOD_ASSET_LIB_ID:String = "breachMoodAssetsDefinition";
      
      public static const PLAGUE_MOOD_ASSET_LIB_ID:String = "plagueMoodAssetsDefinition";
      
      public static const PROMETHEUS_DAY_ASSET_LIB_ID:String = "prometheusAssetsDefinition";
      
      public static const CARNIVAL_DAY_ASSET_LIB_ID:String = "masqueAssetsDefinition";
      
      public static const EASTER_2016_ASSET_LIB_ID:String = "easter2016AssetsDefinition";
      
      private static const SPRING_FIGHT_WINNER_ASSET_LIB_ID_MMO:String = "springFightWinnerAssetsDefinitionMMO";
      
      private static const SPRING_FIGHT_WINNER_ASSET_LIB_ID_EIC:String = "springFightWinnerAssetsDefinitionEIC";
      
      private static const SPRING_FIGHT_WINNER_ASSET_LIB_ID_VRU:String = "springFightWinnerAssetsDefinitionVRU";
      
      private var _type:uint;
      
      private var _active:Boolean;
      
      private var _definitionResKey:String;
      
      public function MoodAssetEvent(param1:uint, param2:Boolean, param3:String)
      {
         super();
         this._definitionResKey = param3;
         this._active = param2;
         this._type = param1;
      }
      
      public static function getReskeyByFaction(param1:FactionModule) : String
      {
         switch(param1.faction)
         {
            case FactionModule.FACTION_MMO:
               return SPRING_FIGHT_WINNER_ASSET_LIB_ID_MMO;
            case FactionModule.FACTION_EIC:
               return SPRING_FIGHT_WINNER_ASSET_LIB_ID_EIC;
            case FactionModule.FACTION_VRU:
         }
         return SPRING_FIGHT_WINNER_ASSET_LIB_ID_VRU;
      }
      
      public function get id() : int
      {
         return this._type;
      }
      
      public function get isActive() : Boolean
      {
         return this._active;
      }
      
      public function get definitionResKey() : String
      {
         return this._definitionResKey;
      }
   }
}

