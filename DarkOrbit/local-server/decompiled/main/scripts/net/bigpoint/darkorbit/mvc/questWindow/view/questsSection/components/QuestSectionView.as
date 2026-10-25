package net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.components
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
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ToolTipEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOHtmlTooltip;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOViewContainerBase;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOButtonBaseSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOOuterViewContainerSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOViewContainerSkin;
   import net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.questObjectives.components.QuestObjectivesView;
   import net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.questRewards.components.QuestRewards;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.Scroller;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   
   use namespace mx_internal;
   
   public class QuestSectionView extends QuestSectionViewBase implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _1376763978acceptButtonTooltipGroup:spark.components.Group;
      
      private var _1205162259groupDepth3b:VGroup;
      
      private var _762870111groupDepth3bBackground:DOViewContainerBase;
      
      private var _593479544questsLeft:Label;
      
      private var _849654389selectedQuestDescription:DOViewContainerBase;
      
      private var _180686017selectedQuestObjectives:QuestObjectivesView;
      
      private var _1840572646selectedQuestObjectivesBg:SkinnableContainer;
      
      private var _1531832861selectedQuestRewards:QuestRewards;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function QuestSectionView()
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
         bindings = this._QuestSectionView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_questWindow_view_questsSection_components_QuestSectionViewWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return QuestSectionView[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._QuestSectionView_Array1_c);
         this.addEventListener("creationComplete",this.___QuestSectionView_QuestSectionViewBase1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         QuestSectionView._watcherSetupUtil = param1;
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
      
      private function handleToolTipCreated(param1:ToolTipEvent) : void
      {
         var _loc2_:DOHtmlTooltip = null;
         if(param1.target is UIComponent)
         {
            _loc2_ = new DOHtmlTooltip();
            _loc2_.htmlText = (param1.target as UIComponent).toolTip;
            param1.toolTip = _loc2_;
         }
      }
      
      private function _QuestSectionView_Array1_c() : Array
      {
         return [this._QuestSectionView_VGroup1_c()];
      }
      
      private function _QuestSectionView_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._QuestSectionView_DOViewContainerBase1_i(),this._QuestSectionView_DOViewContainerBase3_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _QuestSectionView_DOViewContainerBase1_i() : DOViewContainerBase
      {
         var _loc1_:DOViewContainerBase = new DOViewContainerBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.styleName = "questWindowOuter";
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._QuestSectionView_Array3_c);
         _loc1_.setStyle("skinClass",DOOuterViewContainerSkin);
         _loc1_.id = "groupDepth3bBackground";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.groupDepth3bBackground = _loc1_;
         BindingManager.executeBindings(this,"groupDepth3bBackground",this.groupDepth3bBackground);
         return _loc1_;
      }
      
      private function _QuestSectionView_Array3_c() : Array
      {
         return [this._QuestSectionView_VGroup2_i()];
      }
      
      private function _QuestSectionView_VGroup2_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.mxmlContent = [this._QuestSectionView_DOViewContainerBase2_i(),this._QuestSectionView_HGroup1_c(),this._QuestSectionView_SkinnableContainer1_i(),this._QuestSectionView_Label4_i(),this._QuestSectionView_QuestRewards1_i()];
         _loc1_.id = "groupDepth3b";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.groupDepth3b = _loc1_;
         BindingManager.executeBindings(this,"groupDepth3b",this.groupDepth3b);
         return _loc1_;
      }
      
      private function _QuestSectionView_DOViewContainerBase2_i() : DOViewContainerBase
      {
         var _loc1_:DOViewContainerBase = new DOViewContainerBase();
         _loc1_.horizontalCenter = 0;
         _loc1_.percentWidth = 97;
         _loc1_.percentHeight = 40;
         _loc1_.styleName = "questWindowInvisible";
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._QuestSectionView_Array5_c);
         _loc1_.setStyle("skinClass",DOOuterViewContainerSkin);
         _loc1_.id = "selectedQuestDescription";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.selectedQuestDescription = _loc1_;
         BindingManager.executeBindings(this,"selectedQuestDescription",this.selectedQuestDescription);
         return _loc1_;
      }
      
      private function _QuestSectionView_Array5_c() : Array
      {
         return [this._QuestSectionView_VGroup3_c()];
      }
      
      private function _QuestSectionView_VGroup3_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._QuestSectionView_Label1_i(),this._QuestSectionView_Scroller1_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _QuestSectionView_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.text = "";
         _loc1_.setStyle("fontSize",20);
         _loc1_.setStyle("fontFamily","EurostileTHea");
         _loc1_.setStyle("paddingTop",10);
         _loc1_.setStyle("color",16763648);
         _loc1_.setStyle("textAlign","left");
         _loc1_.id = "questTitle";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         questTitle = _loc1_;
         BindingManager.executeBindings(this,"questTitle",questTitle);
         return _loc1_;
      }
      
      private function _QuestSectionView_Scroller1_c() : Scroller
      {
         var _loc1_:Scroller = new Scroller();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.styleName = "skinnedScroller";
         _loc1_.viewport = this._QuestSectionView_Group1_i();
         _loc1_.setStyle("horizontalScrollPolicy","off");
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _QuestSectionView_Group1_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.mxmlContent = [this._QuestSectionView_Label2_i()];
         _loc1_.id = "questDescScrollerGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         questDescScrollerGroup = _loc1_;
         BindingManager.executeBindings(this,"questDescScrollerGroup",questDescScrollerGroup);
         return _loc1_;
      }
      
      private function _QuestSectionView_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 80;
         _loc1_.text = "";
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("textAlign","left");
         _loc1_.setStyle("paddingRight",10);
         _loc1_.id = "questDesc";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         questDesc = _loc1_;
         BindingManager.executeBindings(this,"questDesc",questDesc);
         return _loc1_;
      }
      
      private function _QuestSectionView_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.verticalAlign = "bottom";
         _loc1_.percentWidth = 96;
         _loc1_.paddingBottom = -5;
         _loc1_.mxmlContent = [this._QuestSectionView_Label3_i(),this._QuestSectionView_HGroup2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _QuestSectionView_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "Objectives";
         _loc1_.percentWidth = 50;
         _loc1_.setStyle("fontFamily","EurostileTHea");
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("color",16763648);
         _loc1_.setStyle("textAlign","left");
         _loc1_.id = "objectivesLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         objectivesLabel = _loc1_;
         BindingManager.executeBindings(this,"objectivesLabel",objectivesLabel);
         return _loc1_;
      }
      
      private function _QuestSectionView_HGroup2_i() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.horizontalAlign = "right";
         _loc1_.percentWidth = 50;
         _loc1_.id = "questSubTypeIcons";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         questSubTypeIcons = _loc1_;
         BindingManager.executeBindings(this,"questSubTypeIcons",questSubTypeIcons);
         return _loc1_;
      }
      
      private function _QuestSectionView_SkinnableContainer1_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 97;
         _loc1_.percentHeight = 30;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._QuestSectionView_Array9_c);
         _loc1_.setStyle("skinClass",DOViewContainerSkin);
         _loc1_.id = "selectedQuestObjectivesBg";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.selectedQuestObjectivesBg = _loc1_;
         BindingManager.executeBindings(this,"selectedQuestObjectivesBg",this.selectedQuestObjectivesBg);
         return _loc1_;
      }
      
      private function _QuestSectionView_Array9_c() : Array
      {
         return [this._QuestSectionView_QuestObjectivesView1_i()];
      }
      
      private function _QuestSectionView_QuestObjectivesView1_i() : QuestObjectivesView
      {
         var _loc1_:QuestObjectivesView = new QuestObjectivesView();
         _loc1_.left = 8;
         _loc1_.top = -2;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.id = "selectedQuestObjectives";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.selectedQuestObjectives = _loc1_;
         BindingManager.executeBindings(this,"selectedQuestObjectives",this.selectedQuestObjectives);
         return _loc1_;
      }
      
      private function _QuestSectionView_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "Rewards";
         _loc1_.percentWidth = 96;
         _loc1_.setStyle("fontFamily","EurostileTHea");
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("color",16763648);
         _loc1_.setStyle("paddingTop",10);
         _loc1_.setStyle("textAlign","left");
         _loc1_.setStyle("verticalAlign","bottom");
         _loc1_.setStyle("paddingBottom",-5);
         _loc1_.id = "rewardsLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         rewardsLabel = _loc1_;
         BindingManager.executeBindings(this,"rewardsLabel",rewardsLabel);
         return _loc1_;
      }
      
      private function _QuestSectionView_QuestRewards1_i() : QuestRewards
      {
         var _loc1_:QuestRewards = new QuestRewards();
         _loc1_.percentWidth = 97;
         _loc1_.percentHeight = 26;
         _loc1_.setStyle("skinClass",DOViewContainerSkin);
         _loc1_.id = "selectedQuestRewards";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.selectedQuestRewards = _loc1_;
         BindingManager.executeBindings(this,"selectedQuestRewards",this.selectedQuestRewards);
         return _loc1_;
      }
      
      private function _QuestSectionView_DOViewContainerBase3_c() : DOViewContainerBase
      {
         var _loc1_:DOViewContainerBase = new DOViewContainerBase();
         _loc1_.percentWidth = 100;
         _loc1_.styleName = "questWindowOuter";
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._QuestSectionView_Array10_c);
         _loc1_.setStyle("skinClass",DOOuterViewContainerSkin);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _QuestSectionView_Array10_c() : Array
      {
         return [this._QuestSectionView_Label5_i(),this._QuestSectionView_Group2_i(),this._QuestSectionView_DOButtonBase2_i()];
      }
      
      private function _QuestSectionView_Label5_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.verticalCenter = 0;
         _loc1_.setStyle("fontSize",12);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",12632256);
         _loc1_.setStyle("textAlign","left");
         _loc1_.id = "questsLeft";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.questsLeft = _loc1_;
         BindingManager.executeBindings(this,"questsLeft",this.questsLeft);
         return _loc1_;
      }
      
      private function _QuestSectionView_Group2_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.right = 0;
         _loc1_.mxmlContent = [this._QuestSectionView_DOButtonBase1_i()];
         _loc1_.addEventListener("toolTipCreate",this.__acceptButtonTooltipGroup_toolTipCreate);
         _loc1_.id = "acceptButtonTooltipGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.acceptButtonTooltipGroup = _loc1_;
         BindingManager.executeBindings(this,"acceptButtonTooltipGroup",this.acceptButtonTooltipGroup);
         return _loc1_;
      }
      
      private function _QuestSectionView_DOButtonBase1_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.right = 0;
         _loc1_.styleName = "questWindowAcceptQuest";
         _loc1_.mouseChildren = false;
         _loc1_.buttonMode = true;
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("skinClass",DOButtonBaseSkin);
         _loc1_.addEventListener("click",this.__acceptButton_click);
         _loc1_.id = "acceptButton";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         acceptButton = _loc1_;
         BindingManager.executeBindings(this,"acceptButton",acceptButton);
         return _loc1_;
      }
      
      public function __acceptButton_click(param1:MouseEvent) : void
      {
         handleAcceptQuestButtonClicked(param1);
      }
      
      public function __acceptButtonTooltipGroup_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.handleToolTipCreated(param1);
      }
      
      private function _QuestSectionView_DOButtonBase2_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.right = 0;
         _loc1_.styleName = "questWindowAbortQuest";
         _loc1_.mouseChildren = false;
         _loc1_.buttonMode = true;
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("skinClass",DOButtonBaseSkin);
         _loc1_.addEventListener("click",this.__abortButton_click);
         _loc1_.id = "abortButton";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         abortButton = _loc1_;
         BindingManager.executeBindings(this,"abortButton",abortButton);
         return _loc1_;
      }
      
      public function __abortButton_click(param1:MouseEvent) : void
      {
         handleAbortQuestButtonClicked(param1);
      }
      
      public function ___QuestSectionView_QuestSectionViewBase1_creationComplete(param1:FlexEvent) : void
      {
         handleSectionCreationComplete();
      }
      
      private function _QuestSectionView_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("label_questslots_free_p").replace("%AMOUNT%","X");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"questsLeft.text");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("btn_quest_accept");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"acceptButton.label");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("label_close");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"abortButton.label");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get acceptButtonTooltipGroup() : spark.components.Group
      {
         return this._1376763978acceptButtonTooltipGroup;
      }
      
      public function set acceptButtonTooltipGroup(param1:spark.components.Group) : void
      {
         var _loc2_:Object = this._1376763978acceptButtonTooltipGroup;
         if(_loc2_ !== param1)
         {
            this._1376763978acceptButtonTooltipGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"acceptButtonTooltipGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get groupDepth3b() : VGroup
      {
         return this._1205162259groupDepth3b;
      }
      
      public function set groupDepth3b(param1:VGroup) : void
      {
         var _loc2_:Object = this._1205162259groupDepth3b;
         if(_loc2_ !== param1)
         {
            this._1205162259groupDepth3b = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"groupDepth3b",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get groupDepth3bBackground() : DOViewContainerBase
      {
         return this._762870111groupDepth3bBackground;
      }
      
      public function set groupDepth3bBackground(param1:DOViewContainerBase) : void
      {
         var _loc2_:Object = this._762870111groupDepth3bBackground;
         if(_loc2_ !== param1)
         {
            this._762870111groupDepth3bBackground = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"groupDepth3bBackground",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questsLeft() : Label
      {
         return this._593479544questsLeft;
      }
      
      public function set questsLeft(param1:Label) : void
      {
         var _loc2_:Object = this._593479544questsLeft;
         if(_loc2_ !== param1)
         {
            this._593479544questsLeft = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questsLeft",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedQuestDescription() : DOViewContainerBase
      {
         return this._849654389selectedQuestDescription;
      }
      
      public function set selectedQuestDescription(param1:DOViewContainerBase) : void
      {
         var _loc2_:Object = this._849654389selectedQuestDescription;
         if(_loc2_ !== param1)
         {
            this._849654389selectedQuestDescription = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedQuestDescription",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedQuestObjectives() : QuestObjectivesView
      {
         return this._180686017selectedQuestObjectives;
      }
      
      public function set selectedQuestObjectives(param1:QuestObjectivesView) : void
      {
         var _loc2_:Object = this._180686017selectedQuestObjectives;
         if(_loc2_ !== param1)
         {
            this._180686017selectedQuestObjectives = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedQuestObjectives",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedQuestObjectivesBg() : SkinnableContainer
      {
         return this._1840572646selectedQuestObjectivesBg;
      }
      
      public function set selectedQuestObjectivesBg(param1:SkinnableContainer) : void
      {
         var _loc2_:Object = this._1840572646selectedQuestObjectivesBg;
         if(_loc2_ !== param1)
         {
            this._1840572646selectedQuestObjectivesBg = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedQuestObjectivesBg",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedQuestRewards() : QuestRewards
      {
         return this._1531832861selectedQuestRewards;
      }
      
      public function set selectedQuestRewards(param1:QuestRewards) : void
      {
         var _loc2_:Object = this._1531832861selectedQuestRewards;
         if(_loc2_ !== param1)
         {
            this._1531832861selectedQuestRewards = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedQuestRewards",_loc2_,param1));
            }
         }
      }
   }
}

