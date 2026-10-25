package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.view.components.RankedClanItem;
   
   public class _net_bigpoint_darkorbit_mvc_companyhierarchy_view_components_RankedClanItemWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _net_bigpoint_darkorbit_mvc_companyhierarchy_view_components_RankedClanItemWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         RankedClanItem.watcherSetupUtil = new _net_bigpoint_darkorbit_mvc_companyhierarchy_view_components_RankedClanItemWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

