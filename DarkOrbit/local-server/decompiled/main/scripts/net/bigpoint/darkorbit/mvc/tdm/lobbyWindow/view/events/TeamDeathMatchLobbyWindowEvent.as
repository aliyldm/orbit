package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.events
{
   import flash.events.Event;
   
   public class TeamDeathMatchLobbyWindowEvent extends Event
   {
      
      public static const SEND_MATCH_OVERVIEW_REQUEST:String = "sendMatchOverviewRequest";
      
      public static const JOIN_BUTTON_CLICKED:String = "joinButtonClicked";
      
      public static const LEAVE_BUTTON_CLICKED:String = "leaveButtonClicked";
      
      public static const MATCHOVERVIEW_SELECTION_CHANGED:String = "matchoverviewSelectionChanged";
      
      public static const WINDOW_CREATED:String = "windowCreated";
      
      private var _matchId:int;
      
      public function TeamDeathMatchLobbyWindowEvent(param1:String)
      {
         super(param1);
      }
      
      public function set matchId(param1:int) : void
      {
         this._matchId = param1;
      }
      
      public function get matchId() : int
      {
         return this._matchId;
      }
   }
}

