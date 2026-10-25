package net.bigpoint.darkorbit.mvc.gui.windows.plutus.view.components.event
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.gui.windows.plutus.model.PlutusPlaceVO;
   
   public class PlutusEvent extends Event
   {
      
      public static const REQUEST_PLAYER_DATA:String = "PlutusEvent.REQUEST_PLAYER_DATA";
      
      private var _vo:PlutusPlaceVO;
      
      public function PlutusEvent(param1:String, param2:PlutusPlaceVO, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._vo = param2;
      }
      
      public function get vo() : PlutusPlaceVO
      {
         return this._vo;
      }
   }
}

