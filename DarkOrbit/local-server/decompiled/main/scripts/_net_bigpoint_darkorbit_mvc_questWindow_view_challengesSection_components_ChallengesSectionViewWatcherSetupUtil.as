package
{
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.questWindow.view.challengesSection.components.ChallengesSectionView;
   
   public class _net_bigpoint_darkorbit_mvc_questWindow_view_challengesSection_components_ChallengesSectionViewWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _net_bigpoint_darkorbit_mvc_questWindow_view_challengesSection_components_ChallengesSectionViewWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChallengesSectionView.watcherSetupUtil = new _net_bigpoint_darkorbit_mvc_questWindow_view_challengesSection_components_ChallengesSectionViewWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var staticPropertyGetter:Function = param3;
         var bindings:Array = param4;
         var watchers:Array = param5;
         watchers[2] = new FunctionReturnWatcher("getItem",target,function():Array
         {
            return ["label_questslots_free"];
         },null,[bindings[2]],null);
         watchers[2].updateParent(BPLocale);
      }
   }
}

