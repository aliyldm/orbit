package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.TeamDeathMatchLobbywindow;
   
   public class _net_bigpoint_darkorbit_mvc_tdm_lobbyWindow_view_TeamDeathMatchLobbywindowWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _net_bigpoint_darkorbit_mvc_tdm_lobbyWindow_view_TeamDeathMatchLobbywindowWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         TeamDeathMatchLobbywindow.watcherSetupUtil = new _net_bigpoint_darkorbit_mvc_tdm_lobbyWindow_view_TeamDeathMatchLobbywindowWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("lobbyListCollection",{"propertyChange":true},[param4[0]],param2);
         param5[0].updateParent(param1);
      }
   }
}

