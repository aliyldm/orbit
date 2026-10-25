package net.bigpoint.darkorbit.mvc.gui.windows.payloadEscort.view.components.event
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.gui.windows.payloadEscort.model.vo.PayloadEscortPlaceVO;
   
   public class PayloadEscortEvent extends Event
   {
      
      public static const REQUEST_PLAYER_DATA:String = "PayloadEscortEvent.REQUEST_PLAYER_DATA";
      
      private var _vo:PayloadEscortPlaceVO;
      
      public function PayloadEscortEvent(param1:String, param2:PayloadEscortPlaceVO, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._vo = param2;
      }
      
      public function get vo() : PayloadEscortPlaceVO
      {
         return this._vo;
      }
   }
}

