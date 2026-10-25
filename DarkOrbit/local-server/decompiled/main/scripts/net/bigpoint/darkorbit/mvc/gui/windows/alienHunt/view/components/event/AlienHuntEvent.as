package net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.view.components.event
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.model.AlienHuntPlaceVO;
   
   public class AlienHuntEvent extends Event
   {
      
      public static const REQUEST_PLAYER_DATA:String = "AlienHuntEvent.REQUEST_PLAYER_DATA";
      
      public static const REQUEST_CLAN_DATA:String = "AlienHuntEvent.REQUEST_CLAN_DATA";
      
      private var _vo:AlienHuntPlaceVO;
      
      public function AlienHuntEvent(param1:String, param2:AlienHuntPlaceVO, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._vo = param2;
      }
      
      public function get vo() : AlienHuntPlaceVO
      {
         return this._vo;
      }
   }
}

