package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.ccCommands.view.comps.history.CCHistoryRenderer;
   
   public class _net_bigpoint_darkorbit_mvc_ccCommands_view_comps_history_CCHistoryRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _net_bigpoint_darkorbit_mvc_ccCommands_view_comps_history_CCHistoryRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         CCHistoryRenderer.watcherSetupUtil = new _net_bigpoint_darkorbit_mvc_ccCommands_view_comps_history_CCHistoryRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[1] = new PropertyWatcher("currentState",{"currentStateChange":true},[param4[1]],param2);
         param5[0] = new PropertyWatcher("cmdData",{"dataChange":true},[param4[0]],param2);
         param5[1].updateParent(param1);
         param5[0].updateParent(param1);
      }
   }
}

