package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.ccCommands.view.comps.CCDate;
   
   public class _net_bigpoint_darkorbit_mvc_ccCommands_view_comps_CCDateWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _net_bigpoint_darkorbit_mvc_ccCommands_view_comps_CCDateWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         CCDate.watcherSetupUtil = new _net_bigpoint_darkorbit_mvc_ccCommands_view_comps_CCDateWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("_data",{"propertyChange":true},[param4[0]],param2);
         param5[2] = new PropertyWatcher("timezoneOffset",null,[param4[1]],null);
         param5[0].updateParent(param1);
         param5[2].updateParent(Date);
      }
   }
}

