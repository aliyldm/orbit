package net.bigpoint.darkorbit.mvc.questWindow.view.components
{
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
   import mx.core.ClassFactory;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.graphics.SolidColor;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOScalableDivider;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOViewContainerBase;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOCheckBoxSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOOuterViewContainerSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOScalableDividerSkin;
   import net.bigpoint.darkorbit.mvc.questWindow.view.challengesSection.components.ChallengesSectionView;
   import net.bigpoint.darkorbit.mvc.questWindow.view.events.QuestGiverWindowEvent;
   import net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.components.QuestSectionView;
   import net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.renderers.questList.QuestListItemRenderer;
   import net.bigpoint.darkorbit.settings.Settings;
   import spark.components.BorderContainer;
   import spark.components.CheckBox;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.List;
   import spark.components.TabBar;
   import spark.components.VGroup;
   import spark.core.SpriteVisualElement;
   import spark.events.IndexChangeEvent;
   import spark.layouts.HorizontalAlign;
   import spark.primitives.BitmapImage;
   import spark.primitives.Rect;
   
   use namespace mx_internal;
   
   public class QuestGiverWindowView extends QuestGiverWindowBase implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "closeButton":false,
         "controlBarGroup":false,
         "contentGroup":false,
         "titleDisplay":false,
         "resizeHandle":false
      };
      
      private var _733902135available:CheckBox;
      
      private var _693263401availableQuestList:BorderContainer;
      
      private var _1719531403bigTopLevelHoldingGroupObjectThingy:spark.components.Group;
      
      private var _1402931637completed:CheckBox;
      
      private var _1674318617divider:DOScalableDivider;
      
      private var _3089282done:CheckBox;
      
      private var _315970861groupDepth1:VGroup;
      
      private var _315970862groupDepth2:HGroup;
      
      private var _1205162258groupDepth3a:VGroup;
      
      private var _221806154levelorder:CheckBox;
      
      private var _1781162039notYetDone:CheckBox;
      
      private var _586736518questGiverPortrait:BorderContainer;
      
      private var _1891507435topBarHGroup:VGroup;
      
      private var _665462704unavailable:CheckBox;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function QuestGiverWindowView()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._QuestGiverWindowView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_questWindow_view_components_QuestGiverWindowViewWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return QuestGiverWindowView[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.styleName = "questWindow";
         this.title = "Mission Giver";
         this.width = 840;
         this.height = 550;
         this.minHeight = 550;
         this.minWidth = 840;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._QuestGiverWindowView_Array1_c);
         this.addEventListener("creationComplete",this.___QuestGiverWindowView_QuestGiverWindowBase1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         QuestGiverWindowView._watcherSetupUtil = param1;
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
      
      public function getMaxQuestsLabels() : Vector.<Label>
      {
         var _loc1_:Vector.<Label> = new Vector.<Label>();
         _loc1_.push(questWindowQuestSection.questsLeft);
         _loc1_.push(questWindowChallengesSection.questsLeft);
         return _loc1_;
      }
      
      private function filterCheckboxesChanged() : void
      {
         Settings.questsAvailableFilter = this.available.selected;
         Settings.questsUnavailableFilter = this.unavailable.selected;
         Settings.questsCompletedFilter = this.completed.selected;
         Settings.questsLevelOrderDescending = this.levelorder.selected;
         Settings.challengesUnattemptedFilter = this.notYetDone.selected;
         Settings.challengesAttemptedFilter = this.done.selected;
         dispatchEvent(new QuestGiverWindowEvent(QuestGiverWindowEvent.FILTERS_CHANGED));
      }
      
      override public function handleCreationComplete() : void
      {
         super.handleCreationComplete();
         this.available.selected = Settings.questsAvailableFilter;
         this.unavailable.selected = Settings.questsUnavailableFilter;
         this.completed.selected = Settings.questsCompletedFilter;
         this.levelorder.selected = Settings.questsLevelOrderDescending;
         this.notYetDone.selected = Settings.challengesUnattemptedFilter;
         this.done.selected = Settings.challengesAttemptedFilter;
         this.filterCheckboxesChanged();
      }
      
      private function _QuestGiverWindowView_Array1_c() : Array
      {
         return [this._QuestGiverWindowView_DOScalableDivider1_i(),this._QuestGiverWindowView_Group1_i()];
      }
      
      private function _QuestGiverWindowView_DOScalableDivider1_i() : DOScalableDivider
      {
         var _loc1_:DOScalableDivider = new DOScalableDivider();
         _loc1_.percentWidth = 100;
         _loc1_.right = 16;
         _loc1_.styleName = "questWindowTabBar";
         _loc1_.setStyle("skinClass",DOScalableDividerSkin);
         _loc1_.id = "divider";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.divider = _loc1_;
         BindingManager.executeBindings(this,"divider",this.divider);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_Group1_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.top = 0;
         _loc1_.bottom = 30;
         _loc1_.left = 20;
         _loc1_.right = 20;
         _loc1_.mxmlContent = [this._QuestGiverWindowView_VGroup1_i()];
         _loc1_.id = "bigTopLevelHoldingGroupObjectThingy";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.bigTopLevelHoldingGroupObjectThingy = _loc1_;
         BindingManager.executeBindings(this,"bigTopLevelHoldingGroupObjectThingy",this.bigTopLevelHoldingGroupObjectThingy);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.gap = 0;
         _loc1_.mxmlContent = [this._QuestGiverWindowView_VGroup2_i(),this._QuestGiverWindowView_HGroup1_i()];
         _loc1_.id = "groupDepth1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.groupDepth1 = _loc1_;
         BindingManager.executeBindings(this,"groupDepth1",this.groupDepth1);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_VGroup2_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 0;
         _loc1_.mxmlContent = [this._QuestGiverWindowView_VGroup3_c(),this._QuestGiverWindowView_DOScalableDivider2_c()];
         _loc1_.id = "topBarHGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.topBarHGroup = _loc1_;
         BindingManager.executeBindings(this,"topBarHGroup",this.topBarHGroup);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_VGroup3_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.paddingLeft = 0;
         _loc1_.mxmlContent = [this._QuestGiverWindowView_TabBar1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_TabBar1_i() : TabBar
      {
         var _loc1_:TabBar = new TabBar();
         _loc1_.setStyle("skinClass",QuestGiverTabBarSkin);
         _loc1_.addEventListener("change",this.__mainTabBar_change);
         _loc1_.id = "mainTabBar";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         mainTabBar = _loc1_;
         BindingManager.executeBindings(this,"mainTabBar",mainTabBar);
         return _loc1_;
      }
      
      public function __mainTabBar_change(param1:IndexChangeEvent) : void
      {
         indexChangedHandler(param1);
      }
      
      private function _QuestGiverWindowView_DOScalableDivider2_c() : DOScalableDivider
      {
         var _loc1_:DOScalableDivider = new DOScalableDivider();
         _loc1_.percentWidth = 100;
         _loc1_.styleName = "questWindowTabBar";
         _loc1_.alpha = 0;
         _loc1_.setStyle("skinClass",DOScalableDividerSkin);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_HGroup1_i() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._QuestGiverWindowView_VGroup4_i(),this._QuestGiverWindowView_Group3_c()];
         _loc1_.id = "groupDepth2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.groupDepth2 = _loc1_;
         BindingManager.executeBindings(this,"groupDepth2",this.groupDepth2);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_VGroup4_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.width = 240;
         _loc1_.percentHeight = 100;
         _loc1_.gap = -1;
         _loc1_.mxmlContent = [this._QuestGiverWindowView_BorderContainer1_i(),this._QuestGiverWindowView_BorderContainer2_c(),this._QuestGiverWindowView_Group2_c()];
         _loc1_.id = "groupDepth3a";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.groupDepth3a = _loc1_;
         BindingManager.executeBindings(this,"groupDepth3a",this.groupDepth3a);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_BorderContainer1_i() : BorderContainer
      {
         var _loc1_:BorderContainer = new BorderContainer();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.maxHeight = 200;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._QuestGiverWindowView_Array8_c);
         _loc1_.setStyle("backgroundAlpha",0);
         _loc1_.setStyle("borderAlpha",0);
         _loc1_.id = "questGiverPortrait";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.questGiverPortrait = _loc1_;
         BindingManager.executeBindings(this,"questGiverPortrait",this.questGiverPortrait);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_Array8_c() : Array
      {
         return [this._QuestGiverWindowView_SpriteVisualElement1_i(),this._QuestGiverWindowView_BitmapImage1_i()];
      }
      
      private function _QuestGiverWindowView_SpriteVisualElement1_i() : SpriteVisualElement
      {
         var _loc1_:SpriteVisualElement = new SpriteVisualElement();
         _loc1_.left = -1;
         _loc1_.top = 12;
         _loc1_.height = 200;
         _loc1_.initialized(this,"questGiverImageContainer");
         questGiverImageContainer = _loc1_;
         BindingManager.executeBindings(this,"questGiverImageContainer",questGiverImageContainer);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_BitmapImage1_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.right = 0;
         _loc1_.initialized(this,"questGiverPortraitNameText");
         questGiverPortraitNameText = _loc1_;
         BindingManager.executeBindings(this,"questGiverPortraitNameText",questGiverPortraitNameText);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_BorderContainer2_c() : BorderContainer
      {
         var _loc1_:BorderContainer = new BorderContainer();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._QuestGiverWindowView_Array9_c);
         _loc1_.setStyle("borderColor",5789784);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_Array9_c() : Array
      {
         return [this._QuestGiverWindowView_Rect1_c(),this._QuestGiverWindowView_HGroup2_i(),this._QuestGiverWindowView_HGroup3_i()];
      }
      
      private function _QuestGiverWindowView_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.percentWidth = 100;
         _loc1_.height = 36;
         _loc1_.fill = this._QuestGiverWindowView_SolidColor1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 1844009;
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_HGroup2_i() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.top = 4;
         _loc1_.bottom = 2;
         _loc1_.gap = 10;
         _loc1_.mxmlContent = [this._QuestGiverWindowView_CheckBox1_i(),this._QuestGiverWindowView_CheckBox2_i(),this._QuestGiverWindowView_CheckBox3_i(),this._QuestGiverWindowView_CheckBox4_i()];
         _loc1_.id = "questStateFilters";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         questStateFilters = _loc1_;
         BindingManager.executeBindings(this,"questStateFilters",questStateFilters);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_CheckBox1_i() : CheckBox
      {
         var _loc1_:CheckBox = new CheckBox();
         _loc1_.styleName = "doCheckBoxFilterAvailable";
         _loc1_.setStyle("skinClass",DOCheckBoxSkin);
         _loc1_.addEventListener("change",this.__available_change);
         _loc1_.id = "available";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.available = _loc1_;
         BindingManager.executeBindings(this,"available",this.available);
         return _loc1_;
      }
      
      public function __available_change(param1:Event) : void
      {
         this.filterCheckboxesChanged();
      }
      
      private function _QuestGiverWindowView_CheckBox2_i() : CheckBox
      {
         var _loc1_:CheckBox = new CheckBox();
         _loc1_.styleName = "doCheckBoxFilterUnavailable";
         _loc1_.setStyle("skinClass",DOCheckBoxSkin);
         _loc1_.addEventListener("change",this.__unavailable_change);
         _loc1_.id = "unavailable";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.unavailable = _loc1_;
         BindingManager.executeBindings(this,"unavailable",this.unavailable);
         return _loc1_;
      }
      
      public function __unavailable_change(param1:Event) : void
      {
         this.filterCheckboxesChanged();
      }
      
      private function _QuestGiverWindowView_CheckBox3_i() : CheckBox
      {
         var _loc1_:CheckBox = new CheckBox();
         _loc1_.styleName = "doCheckBoxFilterCompleted";
         _loc1_.setStyle("skinClass",DOCheckBoxSkin);
         _loc1_.addEventListener("change",this.__completed_change);
         _loc1_.id = "completed";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.completed = _loc1_;
         BindingManager.executeBindings(this,"completed",this.completed);
         return _loc1_;
      }
      
      public function __completed_change(param1:Event) : void
      {
         this.filterCheckboxesChanged();
      }
      
      private function _QuestGiverWindowView_CheckBox4_i() : CheckBox
      {
         var _loc1_:CheckBox = new CheckBox();
         _loc1_.styleName = "doCheckBoxLevelOrder";
         _loc1_.setStyle("skinClass",DOCheckBoxSkin);
         _loc1_.addEventListener("change",this.__levelorder_change);
         _loc1_.id = "levelorder";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.levelorder = _loc1_;
         BindingManager.executeBindings(this,"levelorder",this.levelorder);
         return _loc1_;
      }
      
      public function __levelorder_change(param1:Event) : void
      {
         this.filterCheckboxesChanged();
      }
      
      private function _QuestGiverWindowView_HGroup3_i() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.visible = false;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.top = 4;
         _loc1_.bottom = 2;
         _loc1_.gap = 23;
         _loc1_.mxmlContent = [this._QuestGiverWindowView_CheckBox5_i(),this._QuestGiverWindowView_CheckBox6_i()];
         _loc1_.id = "challengeStateFilters";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         challengeStateFilters = _loc1_;
         BindingManager.executeBindings(this,"challengeStateFilters",challengeStateFilters);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_CheckBox5_i() : CheckBox
      {
         var _loc1_:CheckBox = new CheckBox();
         _loc1_.styleName = "doCheckBoxFilterUnattempted";
         _loc1_.setStyle("skinClass",DOCheckBoxSkin);
         _loc1_.addEventListener("change",this.__notYetDone_change);
         _loc1_.id = "notYetDone";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.notYetDone = _loc1_;
         BindingManager.executeBindings(this,"notYetDone",this.notYetDone);
         return _loc1_;
      }
      
      public function __notYetDone_change(param1:Event) : void
      {
         this.filterCheckboxesChanged();
      }
      
      private function _QuestGiverWindowView_CheckBox6_i() : CheckBox
      {
         var _loc1_:CheckBox = new CheckBox();
         _loc1_.styleName = "doCheckBoxFilterAttempted";
         _loc1_.setStyle("skinClass",DOCheckBoxSkin);
         _loc1_.addEventListener("change",this.__done_change);
         _loc1_.id = "done";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.done = _loc1_;
         BindingManager.executeBindings(this,"done",this.done);
         return _loc1_;
      }
      
      public function __done_change(param1:Event) : void
      {
         this.filterCheckboxesChanged();
      }
      
      private function _QuestGiverWindowView_Group2_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._QuestGiverWindowView_BorderContainer3_i(),this._QuestGiverWindowView_DOViewContainerBase1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_BorderContainer3_i() : BorderContainer
      {
         var _loc1_:BorderContainer = new BorderContainer();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._QuestGiverWindowView_Array13_c);
         _loc1_.setStyle("borderColor",5789784);
         _loc1_.setStyle("backgroundAlpha",0);
         _loc1_.id = "availableQuestList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.availableQuestList = _loc1_;
         BindingManager.executeBindings(this,"availableQuestList",this.availableQuestList);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_Array13_c() : Array
      {
         return [this._QuestGiverWindowView_List1_i()];
      }
      
      private function _QuestGiverWindowView_List1_i() : List
      {
         var _loc1_:List = new List();
         _loc1_.itemRenderer = this._QuestGiverWindowView_ClassFactory1_c();
         _loc1_.styleName = "skinnedList";
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalCenter = 0;
         _loc1_.id = "questList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         questList = _loc1_;
         BindingManager.executeBindings(this,"questList",questList);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = QuestListItemRenderer;
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_DOViewContainerBase1_i() : DOViewContainerBase
      {
         var _loc1_:DOViewContainerBase = new DOViewContainerBase();
         _loc1_.visible = false;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.styleName = "questWindowOuter";
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._QuestGiverWindowView_Array14_c);
         _loc1_.setStyle("skinClass",DOOuterViewContainerSkin);
         _loc1_.id = "noQuestListMessageContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         noQuestListMessageContainer = _loc1_;
         BindingManager.executeBindings(this,"noQuestListMessageContainer",noQuestListMessageContainer);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_Array14_c() : Array
      {
         return [this._QuestGiverWindowView_Label1_i()];
      }
      
      private function _QuestGiverWindowView_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.text = "No quests avails!";
         _loc1_.setStyle("fontSize",20);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("paddingTop",10);
         _loc1_.setStyle("color",16763648);
         _loc1_.setStyle("textAlign","center");
         _loc1_.id = "noAvailableQuestListMessage";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         noAvailableQuestListMessage = _loc1_;
         BindingManager.executeBindings(this,"noAvailableQuestListMessage",noAvailableQuestListMessage);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_Group3_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._QuestGiverWindowView_QuestSectionView1_i(),this._QuestGiverWindowView_ChallengesSectionView1_i(),this._QuestGiverWindowView_DOViewContainerBase2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_QuestSectionView1_i() : QuestSectionView
      {
         var _loc1_:QuestSectionView = new QuestSectionView();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.visible = true;
         _loc1_.id = "questWindowQuestSection";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         questWindowQuestSection = _loc1_;
         BindingManager.executeBindings(this,"questWindowQuestSection",questWindowQuestSection);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_ChallengesSectionView1_i() : ChallengesSectionView
      {
         var _loc1_:ChallengesSectionView = new ChallengesSectionView();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.visible = false;
         _loc1_.id = "questWindowChallengesSection";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         questWindowChallengesSection = _loc1_;
         BindingManager.executeBindings(this,"questWindowChallengesSection",questWindowChallengesSection);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_DOViewContainerBase2_i() : DOViewContainerBase
      {
         var _loc1_:DOViewContainerBase = new DOViewContainerBase();
         _loc1_.visible = false;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.styleName = "questWindowOuter";
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._QuestGiverWindowView_Array16_c);
         _loc1_.setStyle("skinClass",DOOuterViewContainerSkin);
         _loc1_.id = "noQuestsMessageContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         noQuestsMessageContainer = _loc1_;
         BindingManager.executeBindings(this,"noQuestsMessageContainer",noQuestsMessageContainer);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_Array16_c() : Array
      {
         return [this._QuestGiverWindowView_VGroup5_c()];
      }
      
      private function _QuestGiverWindowView_VGroup5_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._QuestGiverWindowView_Label2_i(),this._QuestGiverWindowView_Label3_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.text = "";
         _loc1_.setStyle("fontSize",20);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("paddingTop",10);
         _loc1_.setStyle("color",16763648);
         _loc1_.setStyle("textAlign","center");
         _loc1_.id = "noAvailableQuestsMessage";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         noAvailableQuestsMessage = _loc1_;
         BindingManager.executeBindings(this,"noAvailableQuestsMessage",noAvailableQuestsMessage);
         return _loc1_;
      }
      
      private function _QuestGiverWindowView_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.text = "";
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("paddingTop",10);
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("textAlign","center");
         _loc1_.id = "noAvailableQuestsMessageDescription";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         noAvailableQuestsMessageDescription = _loc1_;
         BindingManager.executeBindings(this,"noAvailableQuestsMessageDescription",noAvailableQuestsMessageDescription);
         return _loc1_;
      }
      
      public function ___QuestGiverWindowView_QuestGiverWindowBase1_creationComplete(param1:FlexEvent) : void
      {
         this.handleCreationComplete();
      }
      
      private function _QuestGiverWindowView_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Number
         {
            return mainTabBar.y + mainTabBar.height;
         },null,"divider.y");
         result[1] = new Binding(this,null,null,"mainTabBar.dataProvider","tabList");
         result[2] = new Binding(this,function():Number
         {
            return questGiverPortrait.height - questGiverPortraitNameText.height;
         },null,"questGiverPortraitNameText.y");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = HorizontalAlign.CENTER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"questStateFilters.horizontalAlign");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("ttip_questsAvailable_filter");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"available.toolTip");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("ttip_questsUnavailable_filter");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"unavailable.toolTip");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("ttip_questsCompleted_filter");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"completed.toolTip");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("ttip_levelOrdering_toggle");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"levelorder.toolTip");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = HorizontalAlign.CENTER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"challengeStateFilters.horizontalAlign");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("ttip_challengesNotYetDone_filter");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"notYetDone.toolTip");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("ttip_challengesDone_filter");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"done.toolTip");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get available() : CheckBox
      {
         return this._733902135available;
      }
      
      public function set available(param1:CheckBox) : void
      {
         var _loc2_:Object = this._733902135available;
         if(_loc2_ !== param1)
         {
            this._733902135available = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"available",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get availableQuestList() : BorderContainer
      {
         return this._693263401availableQuestList;
      }
      
      public function set availableQuestList(param1:BorderContainer) : void
      {
         var _loc2_:Object = this._693263401availableQuestList;
         if(_loc2_ !== param1)
         {
            this._693263401availableQuestList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"availableQuestList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bigTopLevelHoldingGroupObjectThingy() : spark.components.Group
      {
         return this._1719531403bigTopLevelHoldingGroupObjectThingy;
      }
      
      public function set bigTopLevelHoldingGroupObjectThingy(param1:spark.components.Group) : void
      {
         var _loc2_:Object = this._1719531403bigTopLevelHoldingGroupObjectThingy;
         if(_loc2_ !== param1)
         {
            this._1719531403bigTopLevelHoldingGroupObjectThingy = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bigTopLevelHoldingGroupObjectThingy",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get completed() : CheckBox
      {
         return this._1402931637completed;
      }
      
      public function set completed(param1:CheckBox) : void
      {
         var _loc2_:Object = this._1402931637completed;
         if(_loc2_ !== param1)
         {
            this._1402931637completed = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"completed",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get divider() : DOScalableDivider
      {
         return this._1674318617divider;
      }
      
      public function set divider(param1:DOScalableDivider) : void
      {
         var _loc2_:Object = this._1674318617divider;
         if(_loc2_ !== param1)
         {
            this._1674318617divider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"divider",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get done() : CheckBox
      {
         return this._3089282done;
      }
      
      public function set done(param1:CheckBox) : void
      {
         var _loc2_:Object = this._3089282done;
         if(_loc2_ !== param1)
         {
            this._3089282done = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"done",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get groupDepth1() : VGroup
      {
         return this._315970861groupDepth1;
      }
      
      public function set groupDepth1(param1:VGroup) : void
      {
         var _loc2_:Object = this._315970861groupDepth1;
         if(_loc2_ !== param1)
         {
            this._315970861groupDepth1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"groupDepth1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get groupDepth2() : HGroup
      {
         return this._315970862groupDepth2;
      }
      
      public function set groupDepth2(param1:HGroup) : void
      {
         var _loc2_:Object = this._315970862groupDepth2;
         if(_loc2_ !== param1)
         {
            this._315970862groupDepth2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"groupDepth2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get groupDepth3a() : VGroup
      {
         return this._1205162258groupDepth3a;
      }
      
      public function set groupDepth3a(param1:VGroup) : void
      {
         var _loc2_:Object = this._1205162258groupDepth3a;
         if(_loc2_ !== param1)
         {
            this._1205162258groupDepth3a = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"groupDepth3a",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get levelorder() : CheckBox
      {
         return this._221806154levelorder;
      }
      
      public function set levelorder(param1:CheckBox) : void
      {
         var _loc2_:Object = this._221806154levelorder;
         if(_loc2_ !== param1)
         {
            this._221806154levelorder = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"levelorder",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get notYetDone() : CheckBox
      {
         return this._1781162039notYetDone;
      }
      
      public function set notYetDone(param1:CheckBox) : void
      {
         var _loc2_:Object = this._1781162039notYetDone;
         if(_loc2_ !== param1)
         {
            this._1781162039notYetDone = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"notYetDone",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questGiverPortrait() : BorderContainer
      {
         return this._586736518questGiverPortrait;
      }
      
      public function set questGiverPortrait(param1:BorderContainer) : void
      {
         var _loc2_:Object = this._586736518questGiverPortrait;
         if(_loc2_ !== param1)
         {
            this._586736518questGiverPortrait = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questGiverPortrait",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get topBarHGroup() : VGroup
      {
         return this._1891507435topBarHGroup;
      }
      
      public function set topBarHGroup(param1:VGroup) : void
      {
         var _loc2_:Object = this._1891507435topBarHGroup;
         if(_loc2_ !== param1)
         {
            this._1891507435topBarHGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topBarHGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get unavailable() : CheckBox
      {
         return this._665462704unavailable;
      }
      
      public function set unavailable(param1:CheckBox) : void
      {
         var _loc2_:Object = this._665462704unavailable;
         if(_loc2_ !== param1)
         {
            this._665462704unavailable = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"unavailable",_loc2_,param1));
            }
         }
      }
   }
}

