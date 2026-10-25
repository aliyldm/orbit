package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.ccCommands.view.comps.CCCRootCommandPanel;
   import net.bigpoint.darkorbit.mvc.ccCommands.view.comps.CCComponentFactorySingleton;
   
   public class _net_bigpoint_darkorbit_mvc_ccCommands_view_comps_CCCRootCommandPanelWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _net_bigpoint_darkorbit_mvc_ccCommands_view_comps_CCCRootCommandPanelWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         CCCRootCommandPanel.watcherSetupUtil = new _net_bigpoint_darkorbit_mvc_ccCommands_view_comps_CCCRootCommandPanelWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("_data",{"propertyChange":true},[param4[0],param4[1]],param2);
         param5[3] = new PropertyWatcher("getRendererForType",null,[param4[3]],null);
         param5[0].updateParent(param1);
         param5[3].updateParent(CCComponentFactorySingleton);
      }
   }
}

