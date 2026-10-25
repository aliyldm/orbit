package net.bigpoint.darkorbit.fui.components.core.layout
{
   public class LayoutAutoSizeMode
   {
      
      public static var PARENT:uint = PARENT_WIDTH | PARENT_HEIGHT;
      
      public static var PARENT_WIDTH:uint = 2;
      
      public static var PARENT_HEIGHT:uint = 32;
      
      public static var CHILDREN:uint = CHILDREN_WIDTH | CHILDREN_HEIGHT;
      
      public static var CHILDREN_WIDTH:uint = 1;
      
      public static var CHILDREN_HEIGHT:uint = 16;
      
      private static var stringToIntValueMapWidth:Object = {
         "parent":PARENT_WIDTH,
         "children":CHILDREN_WIDTH
      };
      
      private static var stringToIntValueMapHeight:Object = {
         "parent":PARENT_HEIGHT,
         "children":CHILDREN_HEIGHT
      };
      
      public function LayoutAutoSizeMode()
      {
         super();
      }
      
      public static function convertAutoWidthMode(param1:String) : uint
      {
         return uint(stringToIntValueMapWidth[param1]);
      }
      
      public static function convertAutoHeigthMode(param1:String) : uint
      {
         return uint(stringToIntValueMapHeight[param1]);
      }
   }
}

