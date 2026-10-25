package net.bigpoint.darkorbit.mvc.sectorControlWindow.model.vo
{
   import net.bigpoint.darkorbit.com.module.SectorControlMatchOverviewModule;
   
   public class SectorControlItemlistOverviewVO
   {
      
      public static const MATCH_MAKING:uint = SectorControlMatchOverviewModule.MATCHSTATE_MATCH_MAKING;
      
      public static const QUEUED:uint = 2;
      
      public static const RUNNING:uint = SectorControlMatchOverviewModule.MATCHSTATE_RUNNING;
      
      public var faction:String = "Not defined";
      
      public var id:uint;
      
      public var matchID:uint;
      
      public var matchState:uint;
      
      public var remainingTickets:uint;
      
      public var totalTickets:uint;
      
      public var playersInQueue:uint;
      
      public var playersOfOwnFaction:int;
      
      public var maxPlayersOfOwnFaction:int;
      
      public var minPlayersPerTeam:int;
      
      public function SectorControlItemlistOverviewVO()
      {
         super();
      }
   }
}

