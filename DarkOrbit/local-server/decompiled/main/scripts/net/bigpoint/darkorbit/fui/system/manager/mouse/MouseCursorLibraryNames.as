package net.bigpoint.darkorbit.fui.system.manager.mouse
{
   public class MouseCursorLibraryNames
   {
      
      public static const MOVE:String = "cursor_move";
      
      public static const REGULAR:String = "cursor_regular";
      
      public static const DRAGNDROP:String = "cursor_dragndrop";
      
      public static const HAND:String = "cursor_hand";
      
      public static const CROSS:String = "cursor_cross";
      
      public static const RESIZE_HORIZONTAL:String = "cursor_resize_horizontal";
      
      public static const RESIZE_VERTICAL:String = "cursor_resize_vertical";
      
      public static const RESIZE_DIAGONAL:String = "cursor_resize_diagonal";
      
      public function MouseCursorLibraryNames()
      {
         super();
      }
      
      public static function getAllNames() : Vector.<String>
      {
         var _loc1_:Vector.<String> = new Vector.<String>();
         _loc1_.push(MOVE,REGULAR,DRAGNDROP,HAND,RESIZE_HORIZONTAL,RESIZE_VERTICAL,RESIZE_DIAGONAL);
         return _loc1_;
      }
   }
}

