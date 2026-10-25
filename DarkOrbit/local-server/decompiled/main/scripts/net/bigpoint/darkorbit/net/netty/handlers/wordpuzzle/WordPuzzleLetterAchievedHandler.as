package net.bigpoint.darkorbit.net.netty.handlers.wordpuzzle
{
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.WordPuzzleLetterAchievedCommand;
   import net.bigpoint.darkorbit.mvc.wordPuzzle.model.vo.WordPuzzleLetterVO;
   import net.bigpoint.darkorbit.mvc.wordPuzzle.notfications.WordPuzzleNotification;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class WordPuzzleLetterAchievedHandler extends BaseHandler
   {
      
      public function WordPuzzleLetterAchievedHandler()
      {
         super();
      }
      
      public static function run(param1:IModule) : void
      {
         var _loc2_:WordPuzzleLetterAchievedCommand = param1 as WordPuzzleLetterAchievedCommand;
         var _loc3_:WordPuzzleLetterVO = new WordPuzzleLetterVO();
         _loc3_.letterValues = _loc2_.letterValues;
         _loc3_.complete = _loc2_.complete;
         _facade.forwardNotification(WordPuzzleNotification.LETTER_ACHIEVED,_loc3_);
      }
   }
}

