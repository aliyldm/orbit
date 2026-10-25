package net.bigpoint.darkorbit.net.netty.handlers.wordpuzzle
{
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.WordPuzzleWindowInitCommand;
   import net.bigpoint.darkorbit.mvc.wordPuzzle.model.vo.WordPuzzleLetterVO;
   import net.bigpoint.darkorbit.mvc.wordPuzzle.notfications.WordPuzzleNotification;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class WordPuzzleWindowInitHandler extends BaseHandler
   {
      
      public function WordPuzzleWindowInitHandler()
      {
         super();
      }
      
      public static function run(param1:IModule) : void
      {
         var _loc2_:WordPuzzleWindowInitCommand = param1 as WordPuzzleWindowInitCommand;
         var _loc3_:WordPuzzleLetterVO = new WordPuzzleLetterVO();
         _loc3_.letterCount = _loc2_.letterCount;
         _facade.forwardNotification(WordPuzzleNotification.INIT,_loc3_);
      }
   }
}

