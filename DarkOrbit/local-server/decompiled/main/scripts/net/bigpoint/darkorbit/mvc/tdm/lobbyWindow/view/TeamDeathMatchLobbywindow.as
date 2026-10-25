package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view
{
   import com.bealearts.collection.VectorCollection;
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.BlurFilter;
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
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.graphics.SolidColor;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchDetailCommand;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchOverviewCommand;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchOverviewModule;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOButtonSkinWithColoredText;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.components.TeamDeathMatchDetailsPanel;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.components.TeamDeathMatchLobbyWindowItemList;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.components.renderers.TeamDeathMatchLobbyWindowOpponentCellRenderer;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.events.TeamDeathMatchLobbyWindowEvent;
   import spark.collections.Sort;
   import spark.collections.SortField;
   import spark.components.Group;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   import spark.events.GridSelectionEvent;
   import spark.primitives.Rect;
   
   use namespace mx_internal;
   
   public class TeamDeathMatchLobbywindow extends DOWindow implements IBindingClient, ITeamDeathMatchLobbywindow
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
      
      public var _TeamDeathMatchLobbywindow_Group1:spark.components.Group;
      
      private var _1022398728actionButton:DOButtonBase;
      
      private var _410956671container:SkinnableContainer;
      
      private var _949905826matchOverview:TeamDeathMatchLobbyWindowItemList;
      
      private var _1613721394matchStateDetailsPanel:TeamDeathMatchDetailsPanel;
      
      private var _1659371121windowContainer:VGroup;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      protected const ACTION_BUTTON_STATE_DEACTIVE:uint = 1;
      
      protected const ACTION_BUTTON_STATE_JOIN:uint = 2;
      
      protected const ACTION_BUTTON_STATE_LEAVE:uint = 3;
      
      private var UNDEFINED_QUEUED_MATCH_ID:int = -13;
      
      private var _queuedMatchID:int;
      
      private var selectedMatchID:int = -1;
      
      private var userInteractionEnabled:Boolean = false;
      
      protected var _1883191470lobbyListCollection:VectorCollection;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function TeamDeathMatchLobbywindow()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._queuedMatchID = this.UNDEFINED_QUEUED_MATCH_ID;
         this._1883191470lobbyListCollection = new VectorCollection();
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._TeamDeathMatchLobbywindow_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_tdm_lobbyWindow_view_TeamDeathMatchLobbywindowWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return TeamDeathMatchLobbywindow[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 524;
         this.minWidth = 524;
         this.height = 474;
         this.minHeight = 474;
         this.styleName = "questWindow";
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._TeamDeathMatchLobbywindow_Array1_c);
         this.addEventListener("preinitialize",this.___TeamDeathMatchLobbywindow_DOWindow1_preinitialize);
         this.addEventListener("creationComplete",this.___TeamDeathMatchLobbywindow_DOWindow1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         TeamDeathMatchLobbywindow._watcherSetupUtil = param1;
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
         _loc1_.fields = [new SortField("matchID",false,true)];
         this.lobbyListCollection.sort = _loc1_;
         this.init();
      }
      
      private function init() : void
      {
         this.queuedMatchID = this.UNDEFINED_QUEUED_MATCH_ID;
         this.initializeUIComponents();
         dispatchEvent(new TeamDeathMatchLobbyWindowEvent(TeamDeathMatchLobbyWindowEvent.WINDOW_CREATED));
         this.enableUserInteraction(true);
      }
      
      protected function initializeUIComponents() : void
      {
         this.matchStateDetailsPanel.alpha = 0.1;
         closeButton.toolTip = BPLocale.getItem("ttip_teamdeathmatch_lobbywindow_close_button");
      }
      
      public function enableUserInteraction(param1:Boolean) : void
      {
         this.enabled = param1;
         this.mouseEnabled = param1;
         this.mouseChildren = param1;
         this.userInteractionEnabled = param1;
         if(this.userInteractionEnabled)
         {
            this.filters = [];
         }
         else
         {
            this.filters = [new BlurFilter(2,2,1)];
         }
      }
      
      public function updateLevelrange(param1:uint, param2:uint) : void
      {
         var _loc3_:String = BPLocale.getItem("teamdeathmatch_lobbywindow_title");
         var _loc4_:String = param1.toString() + " - " + param2.toString();
         _loc4_ = _loc4_.replace(/999/,"∞");
         this.title = _loc4_.toString();
         this.title = _loc3_.replace(TeamDeathMatchLobbyWindowConstants.LOCALIZATION_PLACEHOLDER__LEVELZONE,_loc4_);
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
      
      protected function setActionButtonMode(param1:uint) : void
      {
         this.actionButton.removeEventListener(MouseEvent.CLICK,this.handleJoinButtonClicked);
         this.actionButton.removeEventListener(MouseEvent.CLICK,this.handleLeaveButtonClicked);
         switch(param1)
         {
            case this.ACTION_BUTTON_STATE_JOIN:
               this.actionButton.enabled = true;
               this.actionButton.toolTip = BPLocale.getItem("ttip_teamdeathmatch_lobbywindow_joinbutton");
               this.actionButton.label = BPLocale.getItem("teamdeathmatch_lobbywindow_button_join");
               this.actionButton.addEventListener(MouseEvent.CLICK,this.handleJoinButtonClicked);
               break;
            case this.ACTION_BUTTON_STATE_LEAVE:
               this.actionButton.enabled = true;
               this.actionButton.toolTip = BPLocale.getItem("ttip_teamdeathmatch_lobbywindow_leave_button");
               this.actionButton.label = BPLocale.getItem("teamdeathmatch_lobbywindow_button_leave");
               this.actionButton.addEventListener(MouseEvent.CLICK,this.handleLeaveButtonClicked);
               break;
            case this.ACTION_BUTTON_STATE_DEACTIVE:
               this.actionButton.enabled = false;
         }
      }
      
      protected function handleJoinButtonClicked(param1:MouseEvent) : void
      {
         var _loc3_:TeamDeathMatchLobbyWindowEvent = null;
         var _loc2_:int = this.getSelectedMatchID();
         if(_loc2_ >= 0)
         {
            _loc3_ = new TeamDeathMatchLobbyWindowEvent(TeamDeathMatchLobbyWindowEvent.JOIN_BUTTON_CLICKED);
            _loc3_.matchId = _loc2_;
            dispatchEvent(_loc3_);
         }
      }
      
      protected function handleLeaveButtonClicked(param1:MouseEvent) : void
      {
         var _loc3_:TeamDeathMatchLobbyWindowEvent = null;
         var _loc2_:int = this.getSelectedMatchID();
         if(_loc2_ >= 0)
         {
            _loc3_ = new TeamDeathMatchLobbyWindowEvent(TeamDeathMatchLobbyWindowEvent.LEAVE_BUTTON_CLICKED);
            _loc3_.matchId = this.getSelectedMatchID();
            dispatchEvent(_loc3_);
         }
      }
      
      protected function handleMatchOverviewSelectionChanged(param1:Event = null) : void
      {
         this.updateAfterOverviewSelectionChanged();
      }
      
      public function updateMatchOverviewData(param1:TeamDeathMatchOverviewCommand) : void
      {
         var _loc2_:Vector.<TeamDeathMatchOverviewModule> = null;
         var _loc3_:int = 0;
         if(param1)
         {
            _loc2_ = param1.overviewModules;
            this.lobbyListCollection.source = _loc2_;
            _loc3_ = param1.queuedForMatch;
            if(_loc3_ == -1)
            {
               this.queuedMatchID = _loc3_;
               this.setSelectionForLastSelectedItem();
            }
            else if(_loc3_ >= 0)
            {
               if(this.queuedMatchID == this.UNDEFINED_QUEUED_MATCH_ID)
               {
                  this.queuedMatchID = _loc3_;
                  this.setSelectionFor(_loc3_);
               }
               else
               {
                  this.queuedMatchID = _loc3_;
                  this.setSelectionForLastSelectedItem();
               }
            }
            this.enableUserInteraction(this.userInteractionEnabled);
         }
      }
      
      public function updateMatchDetailData(param1:TeamDeathMatchDetailCommand) : void
      {
         this.updateMatchPanel(param1);
      }
      
      protected function updateMatchPanel(param1:TeamDeathMatchDetailCommand) : void
      {
         var _loc2_:int = 0;
         if(this.matchStateDetailsPanel)
         {
            if(param1)
            {
               this.matchStateDetailsPanel.update(param1);
               _loc2_ = this.getMatchState(param1.matchId);
               if(_loc2_ == TeamDeathMatchOverviewModule.MATCHSTATE_RUNNING)
               {
                  this.matchStateDetailsPanel.message = "";
               }
            }
            this.matchStateDetailsPanel.fadeIn();
         }
      }
      
      protected function getMatchState(param1:int) : int
      {
         var _loc4_:TeamDeathMatchOverviewModule = null;
         var _loc2_:Vector.<TeamDeathMatchOverviewModule> = this.lobbyListCollection.source as Vector.<TeamDeathMatchOverviewModule>;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            if(_loc4_.matchId == param1)
            {
               return _loc4_.matchState;
            }
            _loc3_++;
         }
         return -1;
      }
      
      protected function getSelectedMatchID() : int
      {
         var _loc1_:TeamDeathMatchOverviewModule = null;
         if(this.matchOverview.selectedItem)
         {
            _loc1_ = this.matchOverview.selectedItem as TeamDeathMatchOverviewModule;
            return _loc1_.matchId;
         }
         return -1;
      }
      
      private function setSelectionForLastSelectedItem() : void
      {
         if(this.selectedMatchID == -1)
         {
            this.setSelectionForTheFirstElement();
         }
         else if(this.selectedMatchID >= 0)
         {
            this.setSelectionFor(this.selectedMatchID);
         }
      }
      
      private function setSelectionFor(param1:int) : void
      {
         var _loc2_:IList = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TeamDeathMatchOverviewModule = null;
         if(this.matchOverview)
         {
            _loc2_ = this.matchOverview.dataProvider;
            _loc3_ = _loc2_.length;
            if(_loc3_ > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  _loc5_ = _loc2_[_loc4_];
                  if(_loc5_.matchId == param1)
                  {
                     this.matchOverview.selectedIndex = _loc4_;
                     this.selectedMatchID = param1;
                     this.updateAfterOverviewSelectionChanged();
                  }
                  _loc4_++;
               }
            }
            else
            {
               this.setActionButtonMode(this.ACTION_BUTTON_STATE_DEACTIVE);
            }
         }
      }
      
      private function setSelectionForTheFirstElement() : void
      {
         var _loc1_:IList = null;
         var _loc2_:int = 0;
         var _loc3_:TeamDeathMatchOverviewModule = null;
         if(this.matchOverview)
         {
            _loc1_ = this.matchOverview.dataProvider;
            _loc2_ = _loc1_.length;
            if(_loc2_ > 0)
            {
               this.matchOverview.selectedIndex = 0;
               _loc3_ = _loc1_[0];
               this.selectedMatchID = _loc3_.matchId;
               this.updateAfterOverviewSelectionChanged();
            }
         }
      }
      
      private function updateAfterOverviewSelectionChanged() : void
      {
         var _loc2_:TeamDeathMatchLobbyWindowEvent = null;
         var _loc1_:TeamDeathMatchOverviewModule = this.matchOverview.selectedItem as TeamDeathMatchOverviewModule;
         if(_loc1_)
         {
            this.updateButtonState(_loc1_,this.queuedMatchID);
            _loc2_ = new TeamDeathMatchLobbyWindowEvent(TeamDeathMatchLobbyWindowEvent.MATCHOVERVIEW_SELECTION_CHANGED);
            this.selectedMatchID = _loc1_.matchId;
            _loc2_.matchId = _loc1_.matchId;
            dispatchEvent(_loc2_);
         }
      }
      
      private function updateButtonState(param1:TeamDeathMatchOverviewModule, param2:int) : void
      {
         var _loc3_:Boolean = param1.matchId == param2;
         var _loc4_:int = _loc3_ ? int(this.ACTION_BUTTON_STATE_LEAVE) : int(this.ACTION_BUTTON_STATE_JOIN);
         this.setActionButtonMode(_loc4_);
      }
      
      public function get queuedMatchID() : int
      {
         return this._queuedMatchID;
      }
      
      public function set queuedMatchID(param1:int) : void
      {
         this._queuedMatchID = param1;
         TeamDeathMatchLobbyWindowOpponentCellRenderer._QUEUED_MATCH_ID = param1;
      }
      
      private function _TeamDeathMatchLobbywindow_Array1_c() : Array
      {
         return [this._TeamDeathMatchLobbywindow_VGroup1_i()];
      }
      
      private function _TeamDeathMatchLobbywindow_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.visible = true;
         _loc1_.mxmlContent = [this._TeamDeathMatchLobbywindow_SkinnableContainer1_i(),this._TeamDeathMatchLobbywindow_Group2_c(),this._TeamDeathMatchLobbywindow_Group3_c()];
         _loc1_.id = "windowContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.windowContainer = _loc1_;
         BindingManager.executeBindings(this,"windowContainer",this.windowContainer);
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbywindow_SkinnableContainer1_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.styleName = "teamDeathMatchLobbywindow";
         _loc1_.width = 474;
         _loc1_.height = 335;
         _loc1_.bottom = 25;
         _loc1_.top = 25;
         _loc1_.left = 25;
         _loc1_.right = 25;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._TeamDeathMatchLobbywindow_Array3_c);
         _loc1_.id = "container";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.container = _loc1_;
         BindingManager.executeBindings(this,"container",this.container);
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbywindow_Array3_c() : Array
      {
         return [this._TeamDeathMatchLobbywindow_TeamDeathMatchLobbyWindowItemList1_i(),this._TeamDeathMatchLobbywindow_TeamDeathMatchDetailsPanel1_i(),this._TeamDeathMatchLobbywindow_Group1_i()];
      }
      
      private function _TeamDeathMatchLobbywindow_TeamDeathMatchLobbyWindowItemList1_i() : TeamDeathMatchLobbyWindowItemList
      {
         var _loc1_:TeamDeathMatchLobbyWindowItemList = new TeamDeathMatchLobbyWindowItemList();
         _loc1_.styleName = "TeamDeathMatchLobbyWindowMatchoverviewCSS";
         _loc1_.percentWidth = 100;
         _loc1_.height = 166;
         _loc1_.focusEnabled = false;
         _loc1_.editable = false;
         _loc1_.resizableColumns = false;
         _loc1_.sortableColumns = false;
         _loc1_.setStyle("contentBackgroundColor",1317149);
         _loc1_.setStyle("rollOverColor",2106665);
         _loc1_.setStyle("selectionColor",1975079);
         _loc1_.addEventListener("selectionChange",this.__matchOverview_selectionChange);
         _loc1_.id = "matchOverview";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.matchOverview = _loc1_;
         BindingManager.executeBindings(this,"matchOverview",this.matchOverview);
         return _loc1_;
      }
      
      public function __matchOverview_selectionChange(param1:GridSelectionEvent) : void
      {
         this.handleMatchOverviewSelectionChanged(param1);
      }
      
      private function _TeamDeathMatchLobbywindow_TeamDeathMatchDetailsPanel1_i() : TeamDeathMatchDetailsPanel
      {
         var _loc1_:TeamDeathMatchDetailsPanel = new TeamDeathMatchDetailsPanel();
         _loc1_.styleName = "TeamDeathMatchLobbyWindowMatchdetailCSS";
         _loc1_.percentWidth = 100;
         _loc1_.height = 140;
         _loc1_.top = 180;
         _loc1_.visible = true;
         _loc1_.id = "matchStateDetailsPanel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.matchStateDetailsPanel = _loc1_;
         BindingManager.executeBindings(this,"matchStateDetailsPanel",this.matchStateDetailsPanel);
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbywindow_Group1_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.height = 1;
         _loc1_.top = 290;
         _loc1_.mxmlContent = [this._TeamDeathMatchLobbywindow_Rect1_c()];
         _loc1_.id = "_TeamDeathMatchLobbywindow_Group1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._TeamDeathMatchLobbywindow_Group1 = _loc1_;
         BindingManager.executeBindings(this,"_TeamDeathMatchLobbywindow_Group1",this._TeamDeathMatchLobbywindow_Group1);
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbywindow_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.fill = this._TeamDeathMatchLobbywindow_SolidColor1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbywindow_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 2895923;
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbywindow_Group2_c() : spark.components.Group
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
      
      private function _TeamDeathMatchLobbywindow_Group3_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.x = 0;
         _loc1_.y = 0;
         _loc1_.percentWidth = 100;
         _loc1_.height = 32;
         _loc1_.mxmlContent = [this._TeamDeathMatchLobbywindow_DOButtonBase1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbywindow_DOButtonBase1_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
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
         _loc1_.id = "actionButton";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.actionButton = _loc1_;
         BindingManager.executeBindings(this,"actionButton",this.actionButton);
         return _loc1_;
      }
      
      public function ___TeamDeathMatchLobbywindow_DOWindow1_preinitialize(param1:FlexEvent) : void
      {
         this.handlePreinitialzeWindowEvent();
      }
      
      public function ___TeamDeathMatchLobbywindow_DOWindow1_creationComplete(param1:FlexEvent) : void
      {
         this.handleCreationComplete();
      }
      
      private function _TeamDeathMatchLobbywindow_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():IList
         {
            return lobbyListCollection;
         },null,"matchOverview.dataProvider");
         result[1] = new Binding(this,function():Object
         {
            return MARGIN_COMPONENT;
         },null,"matchOverview.left");
         result[2] = new Binding(this,function():Object
         {
            return MARGIN_COMPONENT;
         },null,"matchOverview.right");
         result[3] = new Binding(this,function():Object
         {
            return MARGIN_COMPONENT;
         },null,"matchOverview.top");
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
         },null,"_TeamDeathMatchLobbywindow_Group1.left");
         result[7] = new Binding(this,function():Object
         {
            return MARGIN_COMPONENT;
         },null,"_TeamDeathMatchLobbywindow_Group1.right");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get actionButton() : DOButtonBase
      {
         return this._1022398728actionButton;
      }
      
      public function set actionButton(param1:DOButtonBase) : void
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
      public function get matchOverview() : TeamDeathMatchLobbyWindowItemList
      {
         return this._949905826matchOverview;
      }
      
      public function set matchOverview(param1:TeamDeathMatchLobbyWindowItemList) : void
      {
         var _loc2_:Object = this._949905826matchOverview;
         if(_loc2_ !== param1)
         {
            this._949905826matchOverview = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"matchOverview",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get matchStateDetailsPanel() : TeamDeathMatchDetailsPanel
      {
         return this._1613721394matchStateDetailsPanel;
      }
      
      public function set matchStateDetailsPanel(param1:TeamDeathMatchDetailsPanel) : void
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

