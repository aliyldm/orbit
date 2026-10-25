package net.bigpoint.darkorbit.mvc.gui.windows.rankings.events
{
   import net.bigpoint.darkorbit.com.module.RankingsEventsInfoRequest;
   
   public class RankingsUIEventsConsts
   {
      
      public static const WORLD_BOSS:String = "event_title_world_boss";
      
      public static const TITLE_FRENZY:String = "title_titlefrenzy";
      
      public static var EVENT_FILTERS:Vector.<String> = new <String>[WORLD_BOSS,TITLE_FRENZY];
      
      public function RankingsUIEventsConsts()
      {
         super();
      }
      
      public static function getRankId(param1:String, param2:int) : int
      {
         switch(param1)
         {
            case WORLD_BOSS:
               if(param2 == 0)
               {
                  return RankingsEventsInfoRequest.RANKTYPE_WORLD_BOSS_EVENT;
               }
               if(param2 == 1)
               {
                  return RankingsEventsInfoRequest.RANKTYPE_WORLD_BOSS_DAILY_TODAY;
               }
               if(param2 == 2)
               {
                  return RankingsEventsInfoRequest.RANKTYPE_WORLD_BOSS_DAILY_YESTERDAY;
               }
               return -1;
               break;
            case TITLE_FRENZY:
               return RankingsEventsInfoRequest.RANKTYPE_TITLE_FRENZY;
            default:
               return -1;
         }
      }
   }
}

