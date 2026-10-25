package net.bigpoint.darkorbit.mvc.wordPuzzle.model.proxy
{
   import net.bigpoint.darkorbit.mvc.wordPuzzle.model.vo.WordPuzzleLetterVO;
   import net.bigpoint.darkorbit.mvc.wordPuzzle.notfications.WordPuzzleNotification;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class WordPuzzleProxy extends Proxy
   {
      
      public static const NAME:String = "WordPuzzleProxy";
      
      public function WordPuzzleProxy()
      {
         super(NAME);
         var _loc1_:WordPuzzleLetterVO = new WordPuzzleLetterVO();
         setData(_loc1_);
      }
      
      public function setLetterCount(param1:int) : void
      {
         var _loc2_:WordPuzzleLetterVO = this.getLetterVo();
         _loc2_.initialize(param1);
         sendNotification(WordPuzzleNotification.UPDATE_UI__LETTER_COUNT_CHANGED,this.getLetterVo());
      }
      
      public function updateLetters(param1:WordPuzzleLetterVO) : void
      {
         var _loc2_:WordPuzzleLetterVO = this.getLetterVo();
         _loc2_.updateLetters(param1);
         sendNotification(WordPuzzleNotification.UPDATE_UI__LETTER_ACHIEVED,_loc2_);
      }
      
      public function getLetterVo() : WordPuzzleLetterVO
      {
         return getData() as WordPuzzleLetterVO;
      }
   }
}

