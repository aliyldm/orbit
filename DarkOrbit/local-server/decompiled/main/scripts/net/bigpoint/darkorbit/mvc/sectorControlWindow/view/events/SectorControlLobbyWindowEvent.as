package net.bigpoint.darkorbit.mvc.sectorControlWindow.view.events
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.model.vo.SectorControlItemlistOverviewVO;
   
   public class SectorControlLobbyWindowEvent extends Event
   {
      
      private static const NAME:String = "SectorControlLobbyWindowEvent.";
      
      public static const SEND_MATCH_OVERVIEW_REQUEST:String = NAME + "sendMatchOverviewRequest";
      
      public static const ITEMLIST_SELECTION_CHANGED:String = NAME + "itemlistSelectionChanged";
      
      public static const ACTIONBUTTON_CLICKED:String = NAME + "actionButtonClicked";
      
      public static const ACTION_JOIN:String = "join";
      
      public static const ACTION_LEAVE:String = "leave";
      
      public static const ACTION_SHOW_LEAVE_QUEUE_DIALOG:String = "leaveQueue";
      
      private var _itemListVO:SectorControlItemlistOverviewVO;
      
      private var _action:String;
      
      public function SectorControlLobbyWindowEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      public function set itemListVO(param1:SectorControlItemlistOverviewVO) : void
      {
         this._itemListVO = param1;
      }
      
      public function get itemListVO() : SectorControlItemlistOverviewVO
      {
         return this._itemListVO;
      }
      
      public function get matchID() : uint
      {
         var _loc1_:uint = 0;
         if(this._itemListVO)
         {
            _loc1_ = this._itemListVO.matchID;
         }
         return _loc1_;
      }
      
      public function get action() : String
      {
         return this._action;
      }
      
      public function set action(param1:String) : void
      {
         this._action = param1;
      }
   }
}

