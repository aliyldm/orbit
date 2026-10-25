package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.wordPuzzle.view.WordPuzzleWindowView;
   
   public class _net_bigpoint_darkorbit_mvc_wordPuzzle_view_WordPuzzleWindowViewWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _net_bigpoint_darkorbit_mvc_wordPuzzle_view_WordPuzzleWindowViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         WordPuzzleWindowView.watcherSetupUtil = new _net_bigpoint_darkorbit_mvc_wordPuzzle_view_WordPuzzleWindowViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

