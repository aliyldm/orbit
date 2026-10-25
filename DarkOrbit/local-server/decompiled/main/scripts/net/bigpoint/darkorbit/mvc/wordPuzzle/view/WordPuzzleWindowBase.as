package net.bigpoint.darkorbit.mvc.wordPuzzle.view
{
   import net.bigpoint.darkorbit.mvc.common.view.components.DODowngradeWindow;
   
   public class WordPuzzleWindowBase extends DODowngradeWindow
   {
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "closeButton":false,
         "controlBarGroup":false,
         "contentGroup":false,
         "titleDisplay":false,
         "resizeHandle":false
      };
      
      private var _handler:IWordPuzzleWindowHandler;
      
      public function WordPuzzleWindowBase()
      {
         super();
      }
      
      public function set handler(param1:IWordPuzzleWindowHandler) : void
      {
         this._handler = param1;
      }
   }
}

