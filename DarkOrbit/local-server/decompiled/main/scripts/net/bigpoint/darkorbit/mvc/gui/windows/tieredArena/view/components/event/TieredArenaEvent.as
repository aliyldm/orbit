package net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.view.components.event
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.model.vo.TieredArenaPlaceVO;
   
   public class TieredArenaEvent extends Event
   {
      
      public static const REQUEST_REP_DATA:String = "TieredArenaEvent.REQUEST_REP_DATA";
      
      public static const REQUEST_REP_PER_KILL_DATA:String = "TieredArenaEvent.REQUEST_REP_PER_KILL_DATA";
      
      private var _vo:TieredArenaPlaceVO;
      
      public function TieredArenaEvent(param1:String, param2:TieredArenaPlaceVO, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._vo = param2;
      }
      
      public function get vo() : TieredArenaPlaceVO
      {
         return this._vo;
      }
   }
}

