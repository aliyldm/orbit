package net.bigpoint.darkorbit.equipment.view.mediators
{
   import com.memoryTracker.MemoryTracker;
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.model.AssetProxy;
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.model.LoadDataProxy;
   import net.bigpoint.darkorbit.equipment.model.LoginProxy;
   import net.bigpoint.darkorbit.equipment.model.MenuProxy;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.view.components.AccordionView;
   import net.bigpoint.darkorbit.equipment.view.components.DetailView;
   import net.bigpoint.darkorbit.equipment.view.components.IconURLView;
   import net.bigpoint.darkorbit.equipment.view.components.IconView;
   import net.bigpoint.darkorbit.equipment.view.components.InventoryView;
   import net.bigpoint.darkorbit.equipment.view.components.PopUpView;
   import net.bigpoint.darkorbit.equipment.view.components.SuspendView;
   import net.bigpoint.darkorbit.equipment.view.components.TabView;
   import net.bigpoint.darkorbit.equipment.view.components.items.DragComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.MultiSelectionComponent;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.ShipSelectorView;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.TooltipControl;
   import net.bigpoint.darkorbit.equipment.view.managers.FocusManager;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class StageMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "StageMediator";
      
      private var tabViewComponent:TabView;
      
      private var suspendView:SuspendView;
      
      private var toolTipView:PopUpView;
      
      private var shipSelectorView:ShipSelectorView;
      
      private var accordionViewComponent:AccordionView;
      
      public function StageMediator(param1:DisplayObject)
      {
         super(NAME,param1);
         MemoryTracker.stage = this.stage;
         this.stage.align = StageAlign.TOP_LEFT;
         this.stage.addEventListener(MouseEvent.CLICK,this.handleStageMouseDown);
         this.stage.addEventListener(Event.RESIZE,this.handleStageResizeEvent);
         this.stage.scaleMode = StageScaleMode.EXACT_FIT;
      }
      
      private function handleStageResizeEvent(param1:Event) : void
      {
      }
      
      private function handleStageMouseDown(param1:MouseEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc2_:DisplayObject = FocusManager.getInstance().getFocus() as DisplayObject;
         if(_loc2_)
         {
            _loc3_ = _loc2_.hitTestPoint(param1.stageX,param1.stageY);
            if(!_loc3_)
            {
               FocusManager.getInstance().clearFocus();
            }
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ApplicationNotificationNames.INIT_APPLICATION,ApplicationNotificationNames.INIT_DEBUG_CONFIGURATIONS,ApplicationNotificationNames.MENU_LAYOUT_DEFINED,ApplicationNotificationNames.BP_LOCALE_LOADED,ApplicationNotificationNames.ASSET_CONFIG_DEFINED,ApplicationNotificationNames.BOOTSTRAP_FINISHED,ApplicationNotificationNames.LOG_IN_SUCCESSFUL,ApplicationNotificationNames.ASSETS_LOADED,ApplicationNotificationNames.ACCORDIONS_READY,ApplicationNotificationNames.SHOW_LOAD_SCREEN_ON_INIT,ApplicationNotificationNames.UPDATE_UI_AFTER_HANGAR_SLOT_CHANGED,ApplicationNotificationNames.SWITCH_BETWEEN_EQUIPMENT_AND_SHIP_SELECTOR_VIEW];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:LoadDataProxy = null;
         var _loc3_:ConnectionProxy = null;
         var _loc4_:TooltipControl = null;
         var _loc5_:IconView = null;
         var _loc6_:DetailView = null;
         var _loc7_:IconURLView = null;
         var _loc8_:InventoryView = null;
         var _loc9_:Object = null;
         var _loc10_:AssetProxy = null;
         var _loc11_:MenuProxy = null;
         var _loc12_:LoginProxy = null;
         var _loc13_:MultiSelectionComponent = null;
         switch(param1.getName())
         {
            case ApplicationNotificationNames.SWITCH_BETWEEN_EQUIPMENT_AND_SHIP_SELECTOR_VIEW:
               this.handleSwitchBetweenEquipmentAndShipSelectorView(param1);
               break;
            case ApplicationNotificationNames.INIT_DEBUG_CONFIGURATIONS:
               _loc2_ = facade.retrieveProxy(LoadDataProxy.PROXY_NAME) as LoadDataProxy;
               _loc2_.loadLocalConfig(this.stage);
               break;
            case ApplicationNotificationNames.INIT_APPLICATION:
               _loc4_ = TooltipControl.getInstance();
               _loc4_.setBounds(new Rectangle(0,0,Settings.WINDOW_WIDTH,Settings.WINDOW_HEIGHT - 80));
               _loc5_ = new IconView();
               facade.registerMediator(new IconViewMediator(IconViewMediator.NAME,_loc5_));
               _loc6_ = new DetailView();
               _loc6_.y = IconView.COMPONENT_HEIGHT;
               facade.registerMediator(new DetailViewMediator(DetailViewMediator.NAME,_loc6_));
               _loc7_ = new IconURLView();
               _loc7_.y = IconView.COMPONENT_HEIGHT + DetailView.COMPONENT_HEIGHT;
               facade.registerMediator(new IconURLViewMediator(IconURLViewMediator.NAME,_loc7_));
               this.accordionViewComponent = new AccordionView();
               this.stage.addChild(this.accordionViewComponent);
               facade.registerMediator(new AccordionViewMediator(AccordionViewMediator.NAME,this.accordionViewComponent));
               _loc8_ = new InventoryView();
               this.stage.addChild(_loc8_);
               facade.registerMediator(new InventoryViewMediator(InventoryViewMediator.NAME,_loc8_));
               this.tabViewComponent = new TabView();
               this.stage.addChild(this.tabViewComponent);
               facade.registerMediator(new TabViewMediator(TabViewMediator.NAME,this.tabViewComponent));
               this.tabViewComponent.x = 8;
               this.tabViewComponent.y = 41;
               this.stage.setChildIndex(_loc8_,this.stage.numChildren - 1);
               this.accordionViewComponent.visible = false;
               _loc8_.visible = false;
               this.tabViewComponent.visible = false;
               this.shipSelectorView = new ShipSelectorView();
               this.stage.addChild(this.shipSelectorView);
               facade.registerMediator(new ShipSelectorMediator(this.shipSelectorView));
               _loc9_ = {"showManagement":(Settings.showViewOnInit == Settings.SHOW_VIEW_ON_INIT__EQUIPMENT ? true : false)};
               facade.sendNotification(ApplicationNotificationNames.SWITCH_BETWEEN_EQUIPMENT_AND_SHIP_SELECTOR_VIEW,_loc9_);
               _loc2_ = facade.retrieveProxy(LoadDataProxy.PROXY_NAME) as LoadDataProxy;
               _loc2_.initBPLocale();
               break;
            case ApplicationNotificationNames.BP_LOCALE_LOADED:
               _loc10_ = facade.retrieveProxy(AssetProxy.PROXY_NAME) as AssetProxy;
               _loc10_.init();
               break;
            case ApplicationNotificationNames.ASSET_CONFIG_DEFINED:
               _loc11_ = facade.retrieveProxy(MenuProxy.PROXY_NAME) as MenuProxy;
               _loc11_.loadMenuLayoutXML();
               break;
            case ApplicationNotificationNames.MENU_LAYOUT_DEFINED:
               _loc2_ = facade.retrieveProxy(LoadDataProxy.PROXY_NAME) as LoadDataProxy;
               _loc2_.loadAssets();
               break;
            case ApplicationNotificationNames.SHOW_LOAD_SCREEN_ON_INIT:
               this.suspendView = new SuspendView();
               this.suspendView.name = "suspendView1";
               facade.registerMediator(new SuspendMediator(SuspendMediator.NAME,this.suspendView));
               this.stage.addChild(this.suspendView);
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.CLIENT_INITIALISING]);
               break;
            case ApplicationNotificationNames.ASSETS_LOADED:
               this.toolTipView = new PopUpView();
               facade.registerMediator(new PopUpViewMediator(PopUpViewMediator.NAME,this.toolTipView));
               this.stage.addChild(this.toolTipView);
               this.stage.setChildIndex(this.toolTipView,this.stage.numChildren - 1);
               _loc12_ = facade.retrieveProxy(LoginProxy.PROXY_NAME) as LoginProxy;
               _loc12_.beginLogin();
               break;
            case ApplicationNotificationNames.LOG_IN_SUCCESSFUL:
               _loc3_ = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
               _loc3_.beginConnection();
               break;
            case ApplicationNotificationNames.BOOTSTRAP_FINISHED:
               this.shipSelectorView.initialize(this.stage.stageWidth,this.stage.stageHeight);
               _loc13_ = MultiSelectionComponent.getInstance();
               this.stage.addChild(_loc13_);
               _loc13_.addListeners();
               break;
            case ApplicationNotificationNames.ACCORDIONS_READY:
               sendNotification(ApplicationNotificationNames.INIT_INVENTORY);
               sendNotification(ApplicationNotificationNames.INIT_SHIP_SELECTOR);
               break;
            case ApplicationNotificationNames.UPDATE_UI_AFTER_HANGAR_SLOT_CHANGED:
               _loc9_ = {"showManagement":true};
               sendNotification(ApplicationNotificationNames.SWITCH_BETWEEN_EQUIPMENT_AND_SHIP_SELECTOR_VIEW,_loc9_);
         }
      }
      
      private function trackData(param1:MouseEvent) : void
      {
         MemoryTracker.gcAndCheck();
      }
      
      private function handleSwitchBetweenEquipmentAndShipSelectorView(param1:INotification) : void
      {
         var _loc3_:Boolean = false;
         var _loc2_:Object = param1.getBody();
         if(_loc2_)
         {
            _loc3_ = Boolean(_loc2_.showManagement);
            this.accordionViewComponent.visible = _loc3_;
            this.tabViewComponent.visible = _loc3_;
            if(!_loc3_)
            {
               MultiSelectionComponent.getInstance().dispose();
               TooltipControl.getInstance().dispose();
               DragComponent.getInstance().dispose();
            }
         }
      }
      
      protected function get stage() : Stage
      {
         return viewComponent as Stage;
      }
   }
}

