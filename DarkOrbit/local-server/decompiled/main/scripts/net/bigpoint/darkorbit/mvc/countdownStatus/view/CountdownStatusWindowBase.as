package net.bigpoint.darkorbit.mvc.countdownStatus.view
{
   import net.bigpoint.darkorbit.mvc.common.view.components.DODowngradeWindow;
   
   public class CountdownStatusWindowBase extends DODowngradeWindow
   {
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "closeButton":false,
         "controlBarGroup":false,
         "contentGroup":false,
         "titleDisplay":false,
         "resizeHandle":false
      };
      
      public function CountdownStatusWindowBase()
      {
         super();
      }
   }
}

