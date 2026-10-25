package net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.view.components.event
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.model.vo.EternalBlacklightPlaceVO;
   
   public class EternalBlacklightEvent extends Event
   {
      
      public static const REQUEST_PLAYER_DATA:String = "EternalBlacklightEvent.REQUEST_PLAYER_DATA";
      
      private var _vo:EternalBlacklightPlaceVO;
      
      public function EternalBlacklightEvent(param1:String, param2:EternalBlacklightPlaceVO, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._vo = param2;
      }
      
      public function get vo() : EternalBlacklightPlaceVO
      {
         return this._vo;
      }
   }
}

