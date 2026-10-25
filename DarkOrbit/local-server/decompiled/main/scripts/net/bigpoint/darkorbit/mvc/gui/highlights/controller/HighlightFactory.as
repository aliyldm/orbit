package net.bigpoint.darkorbit.mvc.gui.highlights.controller
{
   import flash.display.DisplayObject;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.com.module.HighlightTypeModule;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.gui.highlights.view.CombinedHighLighter;
   import net.bigpoint.darkorbit.mvc.gui.highlights.view.FlashHighlight;
   import net.bigpoint.darkorbit.mvc.gui.highlights.view.FlashHighlightWithSound;
   import net.bigpoint.darkorbit.mvc.gui.highlights.view.FlashWindowHighlight;
   import net.bigpoint.darkorbit.mvc.gui.highlights.view.IHighLighter;
   import net.bigpoint.darkorbit.mvc.gui.highlights.view.ItemActivationHighlight;
   import net.bigpoint.darkorbit.mvc.gui.highlights.view.PointingArrowHighlighter;
   import net.bigpoint.darkorbit.mvc.gui.highlights.view.ProgressBarHighlighter;
   import net.bigpoint.darkorbit.mvc.gui.highlights.view.RedBlinkingHighLight;
   import net.bigpoint.darkorbit.mvc.gui.highlights.view.RedDotHighlighter;
   import net.bigpoint.darkorbit.mvc.gui.highlights.view.WrongHighlighter;
   import net.bigpoint.darkorbit.mvc.gui.highlights.view.YellowFlashHighlighter;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   
   public class HighlightFactory
   {
      
      public static const YELLOW_HIGHLIGHT:int = int.MIN_VALUE + 1;
      
      public function HighlightFactory()
      {
         super();
      }
      
      public static function createHighlight(param1:int) : IHighLighter
      {
         var _loc2_:IHighLighter = null;
         switch(param1)
         {
            case HighlightTypeModule.HIGHLIGHTTYPE_RED_BLINK:
               _loc2_ = getRedBlinkingHighlighter();
               break;
            case HighlightTypeModule.HIGHLIGHTTYPE_ARROW:
               _loc2_ = getPointingArrow();
               break;
            case HighlightTypeModule.HIGHLIGHTTYPE_FLASH_AND_SOUND:
               _loc2_ = getFlashingHighlighterWithSound();
               break;
            case HighlightTypeModule.HIGHLIGHTTYPE_FLASH:
               _loc2_ = getFlashingHighlighter();
               break;
            case HighlightTypeModule.HIGHLIGHTTYPE_FLASH_AND_ARROW:
               _loc2_ = getFlashingAndArrowHighlighter();
               break;
            case HighlightTypeModule.HIGHLIGHTTYPE_FLASH_WINDOW:
               _loc2_ = getFlashingWindowHighlighter();
               break;
            case HighlightTypeModule.HIGHLIGHTTYPE_ACTIVE:
               _loc2_ = getItemActivationHighlighter();
               break;
            case HighlightTypeModule.HIGHLIGHTTYPE_RED_DOT:
               _loc2_ = getRedDotHighlighter();
               break;
            case HighlightTypeModule.HIGHLIGHTTYPE_PROGRESS_BAR:
               _loc2_ = getProgressBarHighlighter();
               break;
            case YELLOW_HIGHLIGHT:
               _loc2_ = new YellowFlashHighlighter();
               break;
            default:
               _loc2_ = getMissingHighliter(param1);
         }
         return _loc2_;
      }
      
      private static function getRedDotHighlighter() : IHighLighter
      {
         return new RedDotHighlighter();
      }
      
      private static function getFlashingHighlighterWithSound() : IHighLighter
      {
         return new FlashHighlightWithSound();
      }
      
      private static function getFlashingAndArrowHighlighter() : IHighLighter
      {
         var _loc1_:Vector.<IHighLighter> = new <IHighLighter>[getFlashingHighlighter(),getPointingArrow()];
         return new CombinedHighLighter(_loc1_);
      }
      
      private static function getMissingHighliter(param1:int) : IHighLighter
      {
         return new WrongHighlighter();
      }
      
      private static function getRedBlinkingHighlighter() : IHighLighter
      {
         return new RedBlinkingHighLight();
      }
      
      private static function getFlashingHighlighter() : IHighLighter
      {
         return new FlashHighlight();
      }
      
      private static function getPointingArrow() : IHighLighter
      {
         var _loc1_:SWFFinisher = ResourceManager.fileCollection.getFinisher(ItemsControlMenuConstants.MENU_ID) as SWFFinisher;
         return new PointingArrowHighlighter(_loc1_.getEmbeddedObject(PointingArrowHighlighter.SYMBOL_LINKAGE) as DisplayObject);
      }
      
      private static function getFlashingWindowHighlighter() : IHighLighter
      {
         return new FlashWindowHighlight();
      }
      
      private static function getItemActivationHighlighter() : IHighLighter
      {
         return new ItemActivationHighlight();
      }
      
      private static function getProgressBarHighlighter() : IHighLighter
      {
         return new ProgressBarHighlighter();
      }
   }
}

