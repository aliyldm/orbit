package net.bigpoint.darkorbit.mvc.hintSystem.view.hintOverviewWindow.components
{
   import flash.events.Event;
   
   public class HintSystemOverlistItemRendererEvent extends Event
   {
      
      public static const ITEM_CLICKED:String = "fuiDeubel";
      
      private var _contentID:uint;
      
      public function HintSystemOverlistItemRendererEvent(param1:String, param2:uint)
      {
         super(param1);
         this._contentID = param2;
      }
      
      public function get contentID() : uint
      {
         return this._contentID;
      }
   }
}

