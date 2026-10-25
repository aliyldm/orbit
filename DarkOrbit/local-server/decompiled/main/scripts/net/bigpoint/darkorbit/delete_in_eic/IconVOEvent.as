package net.bigpoint.darkorbit.delete_in_eic
{
   import flash.events.Event;
   
   public class IconVOEvent extends Event
   {
      
      public static const EVENT_ICON_LOADED:String = "net.bigpoint.darkorbit.delete_in_eic.IconVOEvent.EVENT_ICON_LOADED";
      
      private var _IconVO:IconVO;
      
      public function IconVOEvent(param1:IconVO)
      {
         super(EVENT_ICON_LOADED);
         this._IconVO = param1;
      }
      
      public function get iconVO() : IconVO
      {
         return this._IconVO;
      }
   }
}

