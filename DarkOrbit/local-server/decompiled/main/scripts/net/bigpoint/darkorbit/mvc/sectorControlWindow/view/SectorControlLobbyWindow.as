package net.bigpoint.darkorbit.mvc.sectorControlWindow.view
{
   import com.bealearts.collection.VectorCollection;
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.collections.IList;
   import mx.collections.ISort;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.graphics.SolidColor;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.SectorControlMatchDetailCommand;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOButtonSkinWithColoredText;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOSkinnable9ScaleContainerSkin;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.model.vo.SectorControlItemlistOverviewVO;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.DOButtonSectorControlJoinLeave;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.SectorControlLobbyWindowItemList;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.SectorControlLobbyWindowMatchDetailsPanel;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.events.SectorControlLobbyWindowEvent;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.skins.SectorControlLobbyWindowItemListSkin;
   import spark.components.Group;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   import spark.events.GridSelectionEvent;
   import spark.filters.BlurFilter;
   import spark.primitives.Rect;
   
   use namespace mx_internal;
   
   public class SectorControlLobbyWindow extends DOWindow implements IBindingClient, ISectorControlLobbyWindow
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const MARGIN_COMPONENT:uint = 5;
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "closeButton":false,
         "controlBarGroup":false,
         "contentGroup":false,
         "titleDisplay":false,
         "resizeHandle":false
      };
      
      public var _SectorControlLobbyWindow_Group1:spark.components.Group;
      
      private var _1022398728actionButton:DOButtonSectorControlJoinLeave;
      
      private var _410956671container:SkinnableContainer;
      
      private var _1177280081itemList:SectorControlLobbyWindowItemList;
      
      private var _1613721394matchStateDetailsPanel:SectorControlLobbyWindowMatchDetailsPanel;
      
      private var _1659371121windowContainer:VGroup;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var actionButtonJoinLableText:String;
      
      private var actionButtonLeaveLableText:String;
      
      private var ttipJoin:String;
      
      private var ttipLeave:String;
      
      private var selectedIndex:int = -1;
      
      protected var _1883191470lobbyListCollection:VectorCollection;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SectorControlLobbyWindow()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._1883191470lobbyListCollection = new VectorCollection();
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._SectorControlLobbyWindow_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_sectorControlWindow_view_SectorControlLobbyWindowWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return SectorControlLobbyWindow[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.styleName = "questWindow";
         this.width = 524;
         this.minWidth = 524;
         this.height = 474;
         this.minHeight = 474;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._SectorControlLobbyWindow_Array1_c);
         this.addEventListener("preinitialize",this.___SectorControlLobbyWindow_DOWindow1_preinitialize);
         this.addEventListener("creationComplete",this.___SectorControlLobbyWindow_DOWindow1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SectorControlLobbyWindow._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      private function handlePreinitialzeWindowEvent() : void
      {
         this.enableUserInteraction(false);
      }
      
      protected function handleCreationComplete() : void
      {
         var _loc1_:ISort = new Sort();
         _loc1_.fields = [new SortField("matchID",false,false)];
         this.lobbyListCollection.sort = _loc1_;
         this.init();
      }
      
      public function init() : void
      {
         this.selectedIndex = -1;
         this.enableUserInteraction(false);
         this.initializeUIComponents();
         this.sendMatchOverviewRequest();
      }
      
      private function sendMatchOverviewRequest() : void
      {
         var _loc1_:SectorControlLobbyWindowEvent = new SectorControlLobbyWindowEvent(SectorControlLobbyWindowEvent.SEND_MATCH_OVERVIEW_REQUEST);
         dispatchEvent(_loc1_);
      }
      
      protected function initializeUIComponents() : void
      {
         this.ttipLeave = BPLocale.getItem("ttip_sectorcontrol_lobbywindow_leavebutton");
         this.ttipJoin = BPLocale.getItem("ttip_sectorcontrol_lobbywindow_joinbutton");
         this.actionButtonJoinLableText = BPLocale.getItem("sectorcontrol_lobby_window_popup_confirmation");
         this.actionButtonLeaveLableText = BPLocale.getItem("sectorcontrol_lobby_window_popup_leave");
         var _loc1_:BitmapData = ResourceManager.getBitmapData(SectorControlConstants.LIBRARY_NAME,"iconMatchState_running");
         this.container.setStyle("libID",SectorControlConstants.LIBRARY_NAME);
         this.container.setStyle("skinID",SectorControlConstants.FRAME_BORDER);
         this.container.setStyle("scale9Grid",SectorControlConstants.FRAME_BORDER_SCALE9GRID);
         this.container.setStyle("skinClass",DOSkinnable9ScaleContainerSkin);
         this.itemList.init();
         this.itemList.setStyle("libID",SectorControlConstants.LIBRARY_NAME);
         this.itemList.setStyle("skinID",SectorControlConstants.INNER_FRAME_TOP_BORDER);
         this.itemList.setStyle("scale9Grid",SectorControlConstants.INNER_FRAME_TOP_BORDER_SCALE9GRID);
         this.itemList.setStyle("skinClass",SectorControlLobbyWindowItemListSkin);
         this.matchStateDetailsPanel.init();
         this.matchStateDetailsPanel.setStyle("libID",SectorControlConstants.LIBRARY_NAME);
         this.matchStateDetailsPanel.setStyle("skinID",SectorControlConstants.INNER_FRAME_BOTTOM_BORDER);
         this.matchStateDetailsPanel.setStyle("scale9Grid",SectorControlConstants.INNER_FRAME_BOTTOM_BORDER_SCALE9GRID);
         this.matchStateDetailsPanel.setStyle("skinClass",DOSkinnable9ScaleContainerSkin);
         closeButton.toolTip = BPLocale.getItem("ttip_sectorcontrol_lobbywindow_closebutton");
         this.actionButton.toolTip = this.ttipJoin;
         this.actionButton.label = this.actionButtonJoinLableText;
         this.actionButton.enabled = false;
      }
      
      public function enableUserInteraction(param1:Boolean) : void
      {
         this.enabled = param1;
         this.mouseEnabled = param1;
         this.mouseChildren = param1;
         if(param1)
         {
            this.filters = [];
         }
         else
         {
            this.filters = [new BlurFilter(2,2,1)];
         }
      }
      
      protected function handleActionButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:SectorControlItemlistOverviewVO = this.itemList.selectedItem as SectorControlItemlistOverviewVO;
         var _loc3_:SectorControlLobbyWindowEvent = new SectorControlLobbyWindowEvent(SectorControlLobbyWindowEvent.ACTIONBUTTON_CLICKED);
         _loc3_.itemListVO = _loc2_;
         _loc3_.action = this.actionButton.state;
         dispatchEvent(_loc3_);
      }
      
      public function updateMatchStatePanel(param1:SectorControlMatchDetailCommand) : void
      {
         if(this.matchStateDetailsPanel)
         {
            this.matchStateDetailsPanel.visible = true;
            this.matchStateDetailsPanel.update(param1);
         }
      }
      
      public function updateMessageLable(param1:Boolean, param2:Boolean) : void
      {
         if(this.matchStateDetailsPanel)
         {
            this.matchStateDetailsPanel.updateMessageLable(param1,param2);
         }
      }
      
      public function updateActionButtonLable(param1:String) : void
      {
         switch(param1)
         {
            case SectorControlLobbyWindowEvent.ACTION_JOIN:
               this.setJoinMatchStateForActionButton(SectorControlLobbyWindowEvent.ACTION_JOIN);
               break;
            case SectorControlLobbyWindowEvent.ACTION_LEAVE:
               this.setLeaveQuequeStateForActionButton();
               break;
            case SectorControlLobbyWindowEvent.ACTION_SHOW_LEAVE_QUEUE_DIALOG:
               this.setJoinMatchStateForActionButton(SectorControlLobbyWindowEvent.ACTION_SHOW_LEAVE_QUEUE_DIALOG);
         }
      }
      
      protected function setLeaveQuequeStateForActionButton() : void
      {
         this.actionButton.enabled = true;
         this.actionButton.label = this.actionButtonLeaveLableText;
         this.actionButton.toolTip = this.ttipLeave;
         this.actionButton.state = SectorControlLobbyWindowEvent.ACTION_LEAVE;
      }
      
      protected function setJoinMatchStateForActionButton(param1:String) : void
      {
         this.actionButton.enabled = true;
         this.actionButton.label = this.actionButtonJoinLableText;
         this.actionButton.toolTip = this.ttipJoin;
         this.actionButton.state = param1;
      }
      
      public function updateUserLevel(param1:int, param2:uint, param3:uint) : void
      {
         var _loc4_:String = BPLocale.getItem("sectorcontrol_lobby_window_title");
         var _loc5_:String = param2.toString() + " - " + param3.toString();
         _loc5_ = _loc5_.replace(/999/,"∞");
         this.title = _loc4_.replace(SectorControlConstants.LOCALIZATION_PLACEHOLDER__LEVELZONE,_loc5_);
      }
      
      public function updateMatchTime(param1:String) : void
      {
         if(this.matchStateDetailsPanel)
         {
            this.matchStateDetailsPanel.updateTimerLabel(param1);
         }
      }
      
      public function clearMatchTime() : void
      {
         if(this.matchStateDetailsPanel)
         {
            this.matchStateDetailsPanel.clearTimerLabel();
         }
      }
      
      public function updateItemlist(param1:Vector.<SectorControlItemlistOverviewVO>) : void
      {
         this.setList(param1);
         if(this.selectedIndex == -1)
         {
            this.enableUserInteraction(true);
         }
      }
      
      public function setList(param1:Vector.<SectorControlItemlistOverviewVO>) : void
      {
         this.lobbyListCollection.source = param1;
         this.updateItemSelection();
      }
      
      protected function updateItemSelection() : void
      {
         if(this.selectedIndex >= 0)
         {
            this.itemList.setSelectedIndex(this.selectedIndex);
            this.setItemSelection();
         }
      }
      
      protected function setItemSelection() : void
      {
         this.selectedIndex = this.itemList.selectedIndex;
         var _loc1_:SectorControlItemlistOverviewVO = this.itemList.selectedItem as SectorControlItemlistOverviewVO;
         var _loc2_:SectorControlLobbyWindowEvent = new SectorControlLobbyWindowEvent(SectorControlLobbyWindowEvent.ITEMLIST_SELECTION_CHANGED);
         _loc2_.itemListVO = _loc1_;
         dispatchEvent(_loc2_);
      }
      
      protected function handleItemListSelectionChanged(param1:GridSelectionEvent) : void
      {
         this.setItemSelection();
      }
      
      public function updateUserMinPlayerPerTeam(param1:int) : void
      {
         this.matchStateDetailsPanel.updateMinPlayersPerFaction(param1);
      }
      
      private function _SectorControlLobbyWindow_Array1_c() : Array
      {
         return [this._SectorControlLobbyWindow_VGroup1_i()];
      }
      
      private function _SectorControlLobbyWindow_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.visible = true;
         _loc1_.mxmlContent = [this._SectorControlLobbyWindow_SkinnableContainer1_i(),this._SectorControlLobbyWindow_Group2_c(),this._SectorControlLobbyWindow_Group3_c()];
         _loc1_.id = "windowContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.windowContainer = _loc1_;
         BindingManager.executeBindings(this,"windowContainer",this.windowContainer);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindow_SkinnableContainer1_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.width = 474;
         _loc1_.height = 335;
         _loc1_.bottom = 25;
         _loc1_.top = 25;
         _loc1_.left = 25;
         _loc1_.right = 25;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._SectorControlLobbyWindow_Array3_c);
         _loc1_.id = "container";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.container = _loc1_;
         BindingManager.executeBindings(this,"container",this.container);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindow_Array3_c() : Array
      {
         return [this._SectorControlLobbyWindow_SectorControlLobbyWindowItemList1_i(),this._SectorControlLobbyWindow_SectorControlLobbyWindowMatchDetailsPanel1_i(),this._SectorControlLobbyWindow_Group1_i()];
      }
      
      private function _SectorControlLobbyWindow_SectorControlLobbyWindowItemList1_i() : SectorControlLobbyWindowItemList
      {
         var _loc1_:SectorControlLobbyWindowItemList = new SectorControlLobbyWindowItemList();
         _loc1_.percentWidth = 100;
         _loc1_.height = 166;
         _loc1_.focusEnabled = false;
         _loc1_.editable = false;
         _loc1_.resizableColumns = false;
         _loc1_.sortableColumns = false;
         _loc1_.setStyle("contentBackgroundColor",1317149);
         _loc1_.setStyle("rollOverColor",2106665);
         _loc1_.setStyle("selectionColor",1975079);
         _loc1_.addEventListener("selectionChange",this.__itemList_selectionChange);
         _loc1_.id = "itemList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.itemList = _loc1_;
         BindingManager.executeBindings(this,"itemList",this.itemList);
         return _loc1_;
      }
      
      public function __itemList_selectionChange(param1:GridSelectionEvent) : void
      {
         this.handleItemListSelectionChanged(param1);
      }
      
      private function _SectorControlLobbyWindow_SectorControlLobbyWindowMatchDetailsPanel1_i() : SectorControlLobbyWindowMatchDetailsPanel
      {
         var _loc1_:SectorControlLobbyWindowMatchDetailsPanel = new SectorControlLobbyWindowMatchDetailsPanel();
         _loc1_.percentWidth = 100;
         _loc1_.height = 140;
         _loc1_.top = 180;
         _loc1_.visible = false;
         _loc1_.id = "matchStateDetailsPanel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.matchStateDetailsPanel = _loc1_;
         BindingManager.executeBindings(this,"matchStateDetailsPanel",this.matchStateDetailsPanel);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindow_Group1_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.height = 1;
         _loc1_.top = 290;
         _loc1_.mxmlContent = [this._SectorControlLobbyWindow_Rect1_c()];
         _loc1_.id = "_SectorControlLobbyWindow_Group1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._SectorControlLobbyWindow_Group1 = _loc1_;
         BindingManager.executeBindings(this,"_SectorControlLobbyWindow_Group1",this._SectorControlLobbyWindow_Group1);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindow_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.fill = this._SectorControlLobbyWindow_SolidColor1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindow_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 2895923;
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindow_Group2_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.width = 10;
         _loc1_.height = 10;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindow_Group3_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.x = 0;
         _loc1_.y = 0;
         _loc1_.percentWidth = 100;
         _loc1_.height = 32;
         _loc1_.mxmlContent = [this._SectorControlLobbyWindow_DOButtonSectorControlJoinLeave1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindow_DOButtonSectorControlJoinLeave1_i() : DOButtonSectorControlJoinLeave
      {
         var _loc1_:DOButtonSectorControlJoinLeave = new DOButtonSectorControlJoinLeave();
         _loc1_.enabled = false;
         _loc1_.width = 230;
         _loc1_.height = 32;
         _loc1_.styleName = "greenButtonWithColoredText";
         _loc1_.mouseChildren = false;
         _loc1_.buttonMode = true;
         _loc1_.horizontalCenter = 0;
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("skinClass",DOButtonSkinWithColoredText);
         _loc1_.addEventListener("click",this.__actionButton_click);
         _loc1_.id = "actionButton";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.actionButton = _loc1_;
         BindingManager.executeBindings(this,"actionButton",this.actionButton);
         return _loc1_;
      }
      
      public function __actionButton_click(param1:MouseEvent) : void
      {
         this.handleActionButtonClicked(param1);
      }
      
      public function ___SectorControlLobbyWindow_DOWindow1_preinitialize(param1:FlexEvent) : void
      {
         this.handlePreinitialzeWindowEvent();
      }
      
      public function ___SectorControlLobbyWindow_DOWindow1_creationComplete(param1:FlexEvent) : void
      {
         this.handleCreationComplete();
      }
      
      private function _SectorControlLobbyWindow_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():IList
         {
            return lobbyListCollection;
         },null,"itemList.dataProvider");
         result[1] = new Binding(this,function():Object
         {
            return MARGIN_COMPONENT;
         },null,"itemList.left");
         result[2] = new Binding(this,function():Object
         {
            return MARGIN_COMPONENT;
         },null,"itemList.right");
         result[3] = new Binding(this,function():Object
         {
            return MARGIN_COMPONENT;
         },null,"itemList.top");
         result[4] = new Binding(this,function():Object
         {
            return MARGIN_COMPONENT;
         },null,"matchStateDetailsPanel.left");
         result[5] = new Binding(this,function():Object
         {
            return MARGIN_COMPONENT;
         },null,"matchStateDetailsPanel.right");
         result[6] = new Binding(this,function():Object
         {
            return MARGIN_COMPONENT;
         },null,"_SectorControlLobbyWindow_Group1.left");
         result[7] = new Binding(this,function():Object
         {
            return MARGIN_COMPONENT;
         },null,"_SectorControlLobbyWindow_Group1.right");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get actionButton() : DOButtonSectorControlJoinLeave
      {
         return this._1022398728actionButton;
      }
      
      public function set actionButton(param1:DOButtonSectorControlJoinLeave) : void
      {
         var _loc2_:Object = this._1022398728actionButton;
         if(_loc2_ !== param1)
         {
            this._1022398728actionButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"actionButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get container() : SkinnableContainer
      {
         return this._410956671container;
      }
      
      public function set container(param1:SkinnableContainer) : void
      {
         var _loc2_:Object = this._410956671container;
         if(_loc2_ !== param1)
         {
            this._410956671container = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"container",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get itemList() : SectorControlLobbyWindowItemList
      {
         return this._1177280081itemList;
      }
      
      public function set itemList(param1:SectorControlLobbyWindowItemList) : void
      {
         var _loc2_:Object = this._1177280081itemList;
         if(_loc2_ !== param1)
         {
            this._1177280081itemList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get matchStateDetailsPanel() : SectorControlLobbyWindowMatchDetailsPanel
      {
         return this._1613721394matchStateDetailsPanel;
      }
      
      public function set matchStateDetailsPanel(param1:SectorControlLobbyWindowMatchDetailsPanel) : void
      {
         var _loc2_:Object = this._1613721394matchStateDetailsPanel;
         if(_loc2_ !== param1)
         {
            this._1613721394matchStateDetailsPanel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"matchStateDetailsPanel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get windowContainer() : VGroup
      {
         return this._1659371121windowContainer;
      }
      
      public function set windowContainer(param1:VGroup) : void
      {
         var _loc2_:Object = this._1659371121windowContainer;
         if(_loc2_ !== param1)
         {
            this._1659371121windowContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"windowContainer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get lobbyListCollection() : VectorCollection
      {
         return this._1883191470lobbyListCollection;
      }
      
      protected function set lobbyListCollection(param1:VectorCollection) : void
      {
         var _loc2_:Object = this._1883191470lobbyListCollection;
         if(_loc2_ !== param1)
         {
            this._1883191470lobbyListCollection = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lobbyListCollection",_loc2_,param1));
            }
         }
      }
   }
}

