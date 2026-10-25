package net.bigpoint.darkorbit.mvc.wordPuzzle.controller
{
   import net.bigpoint.darkorbit.mvc.wordPuzzle.model.proxy.WordPuzzleProxy;
   import net.bigpoint.darkorbit.mvc.wordPuzzle.model.vo.WordPuzzleLetterVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class WordPuzzleSetLettersCommand extends SimpleCommand
   {
      
      public function WordPuzzleSetLettersCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:WordPuzzleLetterVO = param1.getBody() as WordPuzzleLetterVO;
         var _loc3_:WordPuzzleProxy = facade.retrieveProxy(WordPuzzleProxy.NAME) as WordPuzzleProxy;
         _loc3_.updateLetters(_loc2_);
      }
   }
}

