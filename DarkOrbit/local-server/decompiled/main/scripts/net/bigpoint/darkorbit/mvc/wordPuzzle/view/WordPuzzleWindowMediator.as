package net.bigpoint.darkorbit.mvc.wordPuzzle.view
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.wordPuzzle.model.vo.WordPuzzleLetterVO;
   import net.bigpoint.darkorbit.mvc.wordPuzzle.notfications.WordPuzzleNotification;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   import spark.components.Label;
   
   public class WordPuzzleWindowMediator extends Mediator implements IWordPuzzleWindowHandler
   {
      
      public static const NAME:String = "WordPuzzleMediator";
      
      public function WordPuzzleWindowMediator(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [WordPuzzleNotification.UPDATE_UI__LETTER_ACHIEVED,WordPuzzleNotification.UPDATE_UI__LETTER_COUNT_CHANGED];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:WordPuzzleLetterVO = null;
         super.handleNotification(param1);
         var _loc3_:String = param1.getName();
         switch(_loc3_)
         {
            case WordPuzzleNotification.UPDATE_UI__LETTER_ACHIEVED:
               _loc2_ = param1.getBody() as WordPuzzleLetterVO;
               this.setLetterFromVO(_loc2_);
               this.updateStatusMessageFromVO(_loc2_);
               break;
            case WordPuzzleNotification.UPDATE_UI__LETTER_COUNT_CHANGED:
               _loc2_ = param1.getBody() as WordPuzzleLetterVO;
               this.initializeUI(_loc2_);
         }
      }
      
      protected function initializeUI(param1:WordPuzzleLetterVO) : void
      {
         this.updateStatusMessageFromVO(param1);
         var _loc2_:String = param1.getWordAsString();
         this.window.labelSolutionWord.text = _loc2_;
         this.window.labelSolutionWord.setStyle("color",Styles.LIGHT_YELLOW_COLOR);
      }
      
      protected function setLetterFromVO(param1:WordPuzzleLetterVO) : void
      {
         var _loc2_:String = param1.getWordAsString();
         this.window.labelSolutionWord.text = _loc2_;
      }
      
      protected function updateStatusMessageFromVO(param1:WordPuzzleLetterVO) : void
      {
         var _loc2_:Boolean = param1.complete;
         var _loc3_:Label = this.window.labelPuzzleStatus;
         var _loc4_:Label = this.window.labelPuzzleDescription;
         if(_loc2_)
         {
            _loc3_.text = BPLocale.getItem("label_wordpuzzle_status_complete");
            _loc4_.text = BPLocale.getItem("label_wordpuzzle_description_complete");
         }
         else
         {
            _loc3_.text = BPLocale.getItem("label_wordpuzzle_status_incomplete");
            _loc4_.text = BPLocale.getItem("label_wordpuzzle_description_incomplete");
         }
      }
      
      override public function setViewComponent(param1:Object) : void
      {
         super.setViewComponent(param1);
      }
      
      public function get window() : WordPuzzleWindowView
      {
         return super.getViewComponent() as WordPuzzleWindowView;
      }
   }
}

