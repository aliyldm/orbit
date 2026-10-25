package net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.view.components.event
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.model.vo.PvpSummerPlaceVO;
   
   public class PvpSummerEvent extends Event
   {
      
      public static const REQUEST_REP_DATA:String = "PvpSummerEvent.REQUEST_REP_DATA";
      
      public static const REQUEST_REP_PER_KILL_DATA:String = "PvpSummerEvent.REQUEST_REP_PER_KILL_DATA";
      
      private var _vo:PvpSummerPlaceVO;
      
      public function PvpSummerEvent(param1:String, param2:PvpSummerPlaceVO, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._vo = param2;
      }
      
      public function get vo() : PvpSummerPlaceVO
      {
         return this._vo;
      }
   }
}

