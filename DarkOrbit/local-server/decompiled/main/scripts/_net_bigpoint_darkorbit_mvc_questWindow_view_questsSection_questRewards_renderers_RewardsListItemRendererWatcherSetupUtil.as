package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.questRewards.renderers.RewardsListItemRenderer;
   
   public class _net_bigpoint_darkorbit_mvc_questWindow_view_questsSection_questRewards_renderers_RewardsListItemRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _net_bigpoint_darkorbit_mvc_questWindow_view_questsSection_questRewards_renderers_RewardsListItemRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         RewardsListItemRenderer.watcherSetupUtil = new _net_bigpoint_darkorbit_mvc_questWindow_view_questsSection_questRewards_renderers_RewardsListItemRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[1] = new PropertyWatcher("rewardData",{"dataChange":true},[param4[0],param4[1]],param2);
         param5[1].updateParent(param1);
      }
   }
}

