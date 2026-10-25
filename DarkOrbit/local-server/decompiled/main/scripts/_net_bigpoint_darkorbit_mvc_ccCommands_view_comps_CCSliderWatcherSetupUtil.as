package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.ccCommands.view.comps.CCSlider;
   
   public class _net_bigpoint_darkorbit_mvc_ccCommands_view_comps_CCSliderWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _net_bigpoint_darkorbit_mvc_ccCommands_view_comps_CCSliderWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         CCSlider.watcherSetupUtil = new _net_bigpoint_darkorbit_mvc_ccCommands_view_comps_CCSliderWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("_data",{"propertyChange":true},[param4[0],param4[2],param4[3]],param2);
         param5[2] = new PropertyWatcher("slider",{"propertyChange":true},[param4[1]],param2);
         param5[3] = new PropertyWatcher("value",{
            "change":true,
            "valueCommit":true
         },[param4[1]],null);
         param5[7] = new PropertyWatcher("input",{"propertyChange":true},[param4[4]],param2);
         param5[8] = new PropertyWatcher("text",{
            "change":true,
            "textChanged":true
         },[param4[4]],null);
         param5[0].updateParent(param1);
         param5[2].updateParent(param1);
         param5[2].addChild(param5[3]);
         param5[7].updateParent(param1);
         param5[7].addChild(param5[8]);
      }
   }
}

