package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.renderers.questList.QuestListItemRendererContentComponent;
   
   public class _net_bigpoint_darkorbit_mvc_questWindow_view_questsSection_renderers_questList_QuestListItemRendererContentComponentWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _net_bigpoint_darkorbit_mvc_questWindow_view_questsSection_renderers_questList_QuestListItemRendererContentComponentWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         QuestListItemRendererContentComponent.watcherSetupUtil = new _net_bigpoint_darkorbit_mvc_questWindow_view_questsSection_renderers_questList_QuestListItemRendererContentComponentWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

