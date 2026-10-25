package net.bigpoint.darkorbit.mvc.wordPuzzle.controller
{
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.wordPuzzle.model.proxy.WordPuzzleProxy;
   import net.bigpoint.darkorbit.mvc.wordPuzzle.model.vo.WordPuzzleLetterVO;
   import net.bigpoint.darkorbit.mvc.wordPuzzle.notfications.WordPuzzleNotification;
   import net.bigpoint.darkorbit.mvc.wordPuzzle.view.WordPuzzleWindowMediator;
   import net.bigpoint.darkorbit.mvc.wordPuzzle.view.WordPuzzleWindowView;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class WordPuzzleInitWindowCommand extends SimpleCommand
   {
      
      public function WordPuzzleInitWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:WordPuzzleWindowMediator = null;
         var _loc3_:WordPuzzleProxy = null;
         var _loc5_:GuiManager = null;
         var _loc6_:SimpleWindow = null;
         var _loc7_:FlexWindowManager = null;
         var _loc8_:WordPuzzleWindowView = null;
         super.execute(param1);
         var _loc4_:WordPuzzleLetterVO = param1.getBody() as WordPuzzleLetterVO;
         if(!facade.hasMediator(WordPuzzleWindowMediator.NAME))
         {
            _loc5_ = GuiManager.instance;
            _loc6_ = _loc5_.createWindow(GuiConstants.WORD_PUZZLE_WINDOW) as SimpleWindow;
            _loc7_ = FlexWindowManager.getInstance();
            _loc8_ = _loc7_.createDownGradedWindow(FlexWindowManager.WORD_PUZZLE,_loc6_) as WordPuzzleWindowView;
            _loc2_ = new WordPuzzleWindowMediator(_loc8_);
            facade.registerMediator(_loc2_);
         }
         if(!facade.hasProxy(WordPuzzleProxy.NAME))
         {
            _loc3_ = new WordPuzzleProxy();
            facade.registerProxy(_loc3_);
         }
         else
         {
            _loc3_ = facade.retrieveProxy(WordPuzzleProxy.NAME) as WordPuzzleProxy;
         }
         _loc3_.setLetterCount(_loc4_.letterCount);
         if(!facade.hasCommand(WordPuzzleNotification.LETTER_ACHIEVED))
         {
            facade.registerCommand(WordPuzzleNotification.LETTER_ACHIEVED,WordPuzzleSetLettersCommand);
         }
      }
   }
}

