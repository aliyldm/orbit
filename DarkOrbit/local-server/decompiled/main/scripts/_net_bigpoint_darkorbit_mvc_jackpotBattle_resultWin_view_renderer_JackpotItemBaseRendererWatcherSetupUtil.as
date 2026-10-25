package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.view.renderer.JackpotItemBaseRenderer;
   
   public class _net_bigpoint_darkorbit_mvc_jackpotBattle_resultWin_view_renderer_JackpotItemBaseRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _net_bigpoint_darkorbit_mvc_jackpotBattle_resultWin_view_renderer_JackpotItemBaseRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         JackpotItemBaseRenderer.watcherSetupUtil = new _net_bigpoint_darkorbit_mvc_jackpotBattle_resultWin_view_renderer_JackpotItemBaseRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

