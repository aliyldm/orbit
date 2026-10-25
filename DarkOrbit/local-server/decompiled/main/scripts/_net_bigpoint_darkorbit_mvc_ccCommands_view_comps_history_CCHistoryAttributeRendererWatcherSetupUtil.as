package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.ccCommands.view.comps.history.CCHistoryAttributeRenderer;
   
   public class _net_bigpoint_darkorbit_mvc_ccCommands_view_comps_history_CCHistoryAttributeRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _net_bigpoint_darkorbit_mvc_ccCommands_view_comps_history_CCHistoryAttributeRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         CCHistoryAttributeRenderer.watcherSetupUtil = new _net_bigpoint_darkorbit_mvc_ccCommands_view_comps_history_CCHistoryAttributeRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[1] = new PropertyWatcher("cmdData",{"dataChange":true},[param4[0],param4[1]],param2);
         param5[3] = new PropertyWatcher("subAttributes",null,[param4[1]],null);
         param5[4] = new PropertyWatcher("length",null,[param4[1]],null);
         param5[1].updateParent(param1);
         param5[1].addChild(param5[3]);
         param5[3].addChild(param5[4]);
      }
   }
}

