package net.bigpoint.darkorbit.mvc.sectorControl
{
   public class SectorControlNotifications
   {
      
      public static const NAME:String = "SectorControlNotification";
      
      public static const INIT:String = NAME + "Init";
      
      public static const BLEED:String = NAME + "Bleed";
      
      public static const UPDATE_FACTION_TICKETS_MODEL:String = NAME + "UpdateFactionTicketsModel";
      
      public static const UPDATE_FACTION_PLAYERS_MODEL:String = NAME + "UpdateFactionPlayersModel";
      
      public static const FACTION_TICKETS_MODEL_CHANGED:String = NAME + "FactionTicketsModelChanged";
      
      public static const FACTION_PLAYER_COUNTS_MODEL_CHANGED:String = NAME + "FactionPlayerCountsModelChanged";
      
      public static const UPDATE_FACTION_CONTROL_POINT_BONUSSES_MODEL:String = NAME + "UpdateFactionControlPointBonussesModel";
      
      public static const FACTION_CONTROL_POINT_BONUSSES_MODEL_CHANGED:String = NAME + "FactionControlPointBonussesModelChanged";
      
      public static const UPDATE_PROGRESS_BAR_VIEW:String = NAME + "UpdateProgressBarView";
      
      public static const UPDATE_PROGRESS_BAR_MODEL_SECTOR:String = NAME + "UpdateProgressBarModelSector";
      
      public static const UPDATE_PROGRESS_BAR_MODEL_PROGRESS:String = NAME + "UpdateProgressBarModelProgress";
      
      public static const PING_UNSTABLE_SECTORS:String = NAME + "PingUnstableSectors";
      
      public static const RESET:String = NAME + "Reset";
      
      public static const CLEANUP:String = NAME + "CLEANUP";
      
      public function SectorControlNotifications()
      {
         super();
      }
   }
}

