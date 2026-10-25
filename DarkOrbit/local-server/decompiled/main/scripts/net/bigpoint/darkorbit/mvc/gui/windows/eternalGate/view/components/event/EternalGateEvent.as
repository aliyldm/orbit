package net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.view.components.event
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.model.vo.EternalGatePlaceVO;
   
   public class EternalGateEvent extends Event
   {
      
      public static const REQUEST_PLAYER_DATA:String = "EternalGateEvent.REQUEST_PLAYER_DATA";
      
      private var _vo:EternalGatePlaceVO;
      
      public function EternalGateEvent(param1:String, param2:EternalGatePlaceVO, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._vo = param2;
      }
      
      public function get vo() : EternalGatePlaceVO
      {
         return this._vo;
      }
   }
}

