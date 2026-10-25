package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.ccCommands.view.CCCommandWindow;
   
   public class _net_bigpoint_darkorbit_mvc_ccCommands_view_CCCommandWindowWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _net_bigpoint_darkorbit_mvc_ccCommands_view_CCCommandWindowWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         CCCommandWindow.watcherSetupUtil = new _net_bigpoint_darkorbit_mvc_ccCommands_view_CCCommandWindowWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[3] = new PropertyWatcher("_history",{"propertyChange":true},[param4[5]],param2);
         param5[1] = new PropertyWatcher("_commands",{"propertyChange":true},[param4[1]],param2);
         param5[2] = new PropertyWatcher("_servercommandsAndRequests",{"propertyChange":true},[param4[2]],param2);
         param5[3].updateParent(param1);
         param5[1].updateParent(param1);
         param5[2].updateParent(param1);
      }
   }
}

