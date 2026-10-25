package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.BattleStationBuildWindowView;
   
   public class _net_bigpoint_darkorbit_mvc_battlestationswindow_view_BattleStationBuildWindowViewWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _net_bigpoint_darkorbit_mvc_battlestationswindow_view_BattleStationBuildWindowViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         BattleStationBuildWindowView.watcherSetupUtil = new _net_bigpoint_darkorbit_mvc_battlestationswindow_view_BattleStationBuildWindowViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("_windowHeight",{"propertyChange":true},[param4[0]],param2);
         param5[0].updateParent(param1);
      }
   }
}

