package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.builder.IUIBuilder;
   import net.bigpoint.darkorbit.fui.builder.MappingInstanceNames;
   import net.bigpoint.darkorbit.fui.builder.UIBuilder;
   import net.bigpoint.darkorbit.fui.builder.repository.TextStyleRepository;
   import net.bigpoint.darkorbit.fui.builder.xml.XMLBasedUIBuilder;
   import net.bigpoint.darkorbit.fui.builder.xml.creators.custom.ResultLabelBuilder;
   import net.bigpoint.darkorbit.fui.builder.xml.mapping.XMLNodeNameToInstanceMap;
   import net.bigpoint.darkorbit.fui.system.loader.UISystemLoader;
   import net.bigpoint.darkorbit.fui.system.manager.FocusManager;
   import net.bigpoint.darkorbit.fui.system.manager.KeyboardManager;
   import net.bigpoint.darkorbit.fui.system.manager.PopUpManager;
   import net.bigpoint.darkorbit.fui.system.manager.TooltipManager;
   import net.bigpoint.darkorbit.fui.system.manager.dragNdrop.DragNDropManager;
   import net.bigpoint.darkorbit.fui.system.manager.mouse.MouseManager;
   import net.bigpoint.darkorbit.fui.system.utils.selector.MultiSelector;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
   
   public class SetupUISystemCommand extends AsyncCommand
   {
      
      public function SetupUISystemCommand()
      {
         super();
      }
      
      private static function translateWithOrWithoutCategory(param1:String, param2:String) : String
      {
         var _loc3_:String = null;
         if(param2)
         {
            _loc3_ = BPLocale.getItemInCategory(param2,param1);
         }
         else
         {
            _loc3_ = param1 ? BPLocale.getItem(param1) : "";
         }
         return _loc3_;
      }
      
      private static function createAndRegisterUIBuilder() : IUIBuilder
      {
         var _loc1_:UIBuilder = new UIBuilder();
         var _loc2_:XMLBasedUIBuilder = _loc1_.builders[XMLBasedUIBuilder.TYPE] as XMLBasedUIBuilder;
         _loc2_.registerFromDictionary(new XMLNodeNameToInstanceMap());
         _loc2_.register(MappingInstanceNames.RESULT_LABEL,new ResultLabelBuilder().create);
         return _loc1_;
      }
      
      private static function setupManagers(param1:UISystem) : void
      {
         var _loc2_:ScreenManager = ScreenManager.getInstance();
         param1.focusManager = new FocusManager();
         param1.keyboardManager = new KeyboardManager(param1.stage);
         param1.dragNDropManager = new DragNDropManager(_loc2_.getDragNDropLayer());
         param1.popupManager = new PopUpManager(_loc2_.getPopupLayer());
         param1.tooltipManager = new TooltipManager(_loc2_.getTooltipLayer());
         param1.mouseManager = new MouseManager(_loc2_.getMouseCursorLayer());
         param1.multiSelector = new MultiSelector(_loc2_.getMultiSelectionLayer());
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:UISystem = UISystem.getInstance();
         var _loc3_:AssetsProxy = facade.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         _loc2_.stage = ScreenManager.getInstance().stage;
         _loc2_.builder = createAndRegisterUIBuilder();
         _loc2_.uiloader = new UISystemLoader(_loc3_);
         var _loc4_:ILogger = Log.getLogger("UISystem");
         _loc2_.localizationFunctionReference = translateWithOrWithoutCategory;
         _loc2_.logInfoFunctionReference = _loc4_.info;
         _loc2_.logWarnFunctionReference = _loc4_.error;
         _loc4_.error("error");
         _loc4_.info("info");
         setupManagers(_loc2_);
         TextStyleRepository.getInstance().useDeviceFonts = !Settings.useEmbeddedFonts;
         _loc3_.load("gameclientCommonUIStructure",this.onGameclientCommonUIStructureLoad);
      }
      
      protected function onGameclientCommonUIStructureLoad(param1:XMLFinisher) : void
      {
         UISystem.getInstance().loadAndBuild(param1.getXML(),null,this.onCommonSkinsRegister);
      }
      
      protected function onCommonSkinsRegister() : void
      {
         UISystem.getInstance().mouseManager.showRegularCursor();
         UISystem.getInstance().loadAndBuildWithResKey("commandCenterStyles",null,this.onCommandCenterLoaded);
      }
      
      private function onCommandCenterLoaded(... rest) : void
      {
         UISystem.getInstance().loadAndBuildWithResKey("spaceMapStyles",null,this.onFinishedLoading);
      }
      
      private function onFinishedLoading(... rest) : void
      {
         this.commandComplete();
      }
   }
}

