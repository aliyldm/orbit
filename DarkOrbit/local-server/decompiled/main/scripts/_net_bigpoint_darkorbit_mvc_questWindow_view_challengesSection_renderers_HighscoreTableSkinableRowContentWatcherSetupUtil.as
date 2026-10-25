package
{
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.questWindow.view.challengesSection.renderers.HighscoreTableSkinableRowContent;
   
   public class _net_bigpoint_darkorbit_mvc_questWindow_view_challengesSection_renderers_HighscoreTableSkinableRowContentWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _net_bigpoint_darkorbit_mvc_questWindow_view_challengesSection_renderers_HighscoreTableSkinableRowContentWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         HighscoreTableSkinableRowContent.watcherSetupUtil = new _net_bigpoint_darkorbit_mvc_questWindow_view_challengesSection_renderers_HighscoreTableSkinableRowContentWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var staticPropertyGetter:Function = param3;
         var bindings:Array = param4;
         var watchers:Array = param5;
         watchers[6] = new FunctionReturnWatcher("getStyle",target,function():Array
         {
            return ["paddingLeft"];
         },null,[bindings[5]],propertyGetter,true);
         watchers[5] = new FunctionReturnWatcher("getStyle",target,function():Array
         {
            return ["paddingBottom"];
         },null,[bindings[4]],propertyGetter,true);
         watchers[4] = new FunctionReturnWatcher("getStyle",target,function():Array
         {
            return ["paddingRight"];
         },null,[bindings[3]],propertyGetter,true);
         watchers[3] = new FunctionReturnWatcher("getStyle",target,function():Array
         {
            return ["paddingTop"];
         },null,[bindings[2]],propertyGetter,true);
         watchers[1] = new FunctionReturnWatcher("getStyle",target,function():Array
         {
            return ["column" + target.columnIndex + 1 + "align"];
         },null,[bindings[1]],propertyGetter,true);
         watchers[2] = new PropertyWatcher("columnIndex",{"propertyChange":true},[bindings[1]],propertyGetter);
         watchers[0] = new PropertyWatcher("label",{"propertyChange":true},[bindings[0]],propertyGetter);
         watchers[6].updateParent(target);
         watchers[5].updateParent(target);
         watchers[4].updateParent(target);
         watchers[3].updateParent(target);
         watchers[1].updateParent(target);
         watchers[2].updateParent(target);
         watchers[0].updateParent(target);
      }
   }
}

