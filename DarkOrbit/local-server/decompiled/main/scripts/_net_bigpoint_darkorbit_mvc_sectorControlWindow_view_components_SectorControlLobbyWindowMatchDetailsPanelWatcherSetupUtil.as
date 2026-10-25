package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.SectorControlLobbyWindowMatchDetailsPanel;
   
   public class _net_bigpoint_darkorbit_mvc_sectorControlWindow_view_components_SectorControlLobbyWindowMatchDetailsPanelWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _net_bigpoint_darkorbit_mvc_sectorControlWindow_view_components_SectorControlLobbyWindowMatchDetailsPanelWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SectorControlLobbyWindowMatchDetailsPanel.watcherSetupUtil = new _net_bigpoint_darkorbit_mvc_sectorControlWindow_view_components_SectorControlLobbyWindowMatchDetailsPanelWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

