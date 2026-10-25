package net.bigpoint.darkorbit.mvc.tdm.statusWindow
{
   import com.bigpoint.utils.PointLite;
   
   public class TDMStatusWindowConstants
   {
      
      public static const START_POINT:PointLite = new PointLite(10,40);
      
      public static const TOTAL_SCORE_GAP:int = 5;
      
      public static const BAR_WIDTH:int = 120;
      
      public static const CONTAINER_WIDTH:int = 160;
      
      public static const GAP_LOW:int = 10;
      
      public static const LIVES_TEXT_KEY:String = "tdm_status_lives_remaining";
      
      public static const TIME_TEXT_KEY:String = "tdm_status_time_left";
      
      public static const STATUS_HEADLINE_TEXT_KEY:String = "tdm_status_event_headline";
      
      public function TDMStatusWindowConstants()
      {
         super();
      }
   }
}

