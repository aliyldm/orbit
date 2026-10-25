package net.bigpoint.darkorbit.mvc.sectorControlWindow.model.vo
{
   public class SectorControlMatchStateVO
   {
      
      public static var MATCH_STATE__UNDEFINED:uint = 0;
      
      public static var MATCH_STATE_JOIN_MATCH:uint = 1;
      
      public static var MATCH_STATE_LEAVE_MATCH:uint = 2;
      
      public static var MATCH_STATE_JOIN_QUEUE:uint = 4;
      
      public static var MATCH_STATE_LEAVE_QUEUE:uint = 8;
      
      protected var currentMatchState:uint = MATCH_STATE__UNDEFINED;
      
      public function SectorControlMatchStateVO()
      {
         super();
      }
   }
}

