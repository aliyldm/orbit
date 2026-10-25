package net.bigpoint.darkorbit.fui.components.list.combobox
{
   import flash.events.Event;
   
   public class ComboBoxEvent extends Event
   {
      
      public static const POPUP_CREATED:String = "ComboxEvent.popupCreated";
      
      public static const POPUP_SHOW:String = "ComboxEvent.popupShow";
      
      public static const POPUP_HIDE:String = "ComboxEvent.popupHide";
      
      public static const SELECTION_CHANGED:String = "ComboxEvent.selectionChanged";
      
      public function ComboBoxEvent(param1:String)
      {
         super(param1);
      }
   }
}

