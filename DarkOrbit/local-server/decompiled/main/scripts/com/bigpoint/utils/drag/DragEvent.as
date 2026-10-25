package com.bigpoint.utils.drag
{
   import flash.events.Event;
   
   public class DragEvent extends Event
   {
      
      public static const DRAG_ACCEPTED:String = "dragAccepted";
      
      public static const DRAG_NOT_ACCEPTED:String = "dragNotAccepted";
      
      public static const DRAG_ENTER:String = "dragEnter";
      
      public static const DRAG_EXIT:String = "dragExit";
      
      public static const DRAG_OVER:String = "dragOver";
      
      public static const DRAG_START:String = "dragStart";
      
      private var _draggingItem:IDraggable;
      
      private var _dropTarget:IDropable;
      
      public function DragEvent(param1:String, param2:IDraggable = null, param3:IDropable = null)
      {
         super(param1,true);
         this._draggingItem = param2;
         this._dropTarget = param3;
      }
      
      public function get draggingItem() : IDraggable
      {
         return this._draggingItem;
      }
      
      public function get dropTarget() : IDropable
      {
         return this._dropTarget;
      }
   }
}

