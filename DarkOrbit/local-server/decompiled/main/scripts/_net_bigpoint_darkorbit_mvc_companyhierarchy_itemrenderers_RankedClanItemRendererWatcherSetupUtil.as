package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.itemrenderers.RankedClanItemRenderer;
   
   public class _net_bigpoint_darkorbit_mvc_companyhierarchy_itemrenderers_RankedClanItemRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _net_bigpoint_darkorbit_mvc_companyhierarchy_itemrenderers_RankedClanItemRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         RankedClanItemRenderer.watcherSetupUtil = new _net_bigpoint_darkorbit_mvc_companyhierarchy_itemrenderers_RankedClanItemRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("data",{"dataChange":true},[param4[0]],param2);
         param5[0].updateParent(param1);
      }
   }
}

