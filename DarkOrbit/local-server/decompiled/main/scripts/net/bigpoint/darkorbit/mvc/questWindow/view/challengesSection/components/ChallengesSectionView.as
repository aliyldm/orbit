package net.bigpoint.darkorbit.mvc.questWindow.view.challengesSection.components
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
   import mx.collections.ArrayList;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOViewContainerBase;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOButtonBaseSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOOuterViewContainerSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOViewContainerSkin;
   import net.bigpoint.darkorbit.mvc.questWindow.model.QuestProxy;
   import net.bigpoint.darkorbit.mvc.questWindow.model.vo.HighscoreVO;
   import net.bigpoint.darkorbit.mvc.questWindow.model.vo.QuestListItemVO;
   import net.bigpoint.darkorbit.mvc.questWindow.view.events.QuestGiverWindowEvent;
   import net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.questObjectives.components.QuestObjectivesView;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.questfm.Quest;
   import net.bigpoint.darkorbit.settings.Settings;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Image;
   import spark.components.Label;
   import spark.components.Scroller;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   import spark.events.GridEvent;
   
   use namespace mx_internal;
   
   public class ChallengesSectionView extends SkinnableContainer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _363785598abortButton:DOButtonBase;
      
      private var _1480909402acceptButton:DOButtonBase;
      
      private var _812644972challengeDesc:Label;
      
      private var _1892679985challengeDescScrollerGroup:spark.components.Group;
      
      private var _592706485challengeTitle:Label;
      
      private var _1205162259groupDepth3b:VGroup;
      
      private var _762870111groupDepth3bBackground:DOViewContainerBase;
      
      private var _1759783840highscoreDataGrid:HighscoreDataGrid;
      
      private var _681244486objectivesLabel:Label;
      
      private var _1419500450questSubTypeIcons:HGroup;
      
      private var _593479544questsLeft:Label;
      
      private var _758540350rankingTitle:Label;
      
      private var _562884308selectedChallengeDescription:DOViewContainerBase;
      
      private var _1109878362selectedChallengeHighscoreTable:SkinnableContainer;
      
      private var _1002719362selectedChallengeObjectives:QuestObjectivesView;
      
      private var _1540634727selectedChallengeObjectivesBg:SkinnableContainer;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public var currentlyDisplayedQuestID:int;
      
      public var currentlyDisplayedRootCaseID:int;
      
      public var currentlyDisplayedQuestActiveStatus:Boolean;
      
      private var _2100177384objectivesList:ArrayList;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ChallengesSectionView()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._2100177384objectivesList = new ArrayList([]);
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._ChallengesSectionView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_questWindow_view_challengesSection_components_ChallengesSectionViewWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return ChallengesSectionView[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChallengesSectionView_Array1_c);
         this.addEventListener("creationComplete",this.___ChallengesSectionView_SkinnableContainer1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ChallengesSectionView._watcherSetupUtil = param1;
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
      
      public function setQuestObjectivesList(param1:ArrayList) : void
      {
         this.objectivesList = param1;
      }
      
      private function handleSectionCreationComplete(param1:Event) : void
      {
      }
      
      public function updateChallengesSectionView(param1:Quest, param2:QuestListItemVO) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Bitmap = null;
         var _loc6_:Image = null;
         var _loc7_:String = null;
         this.currentlyDisplayedQuestID = param1.id;
         this.currentlyDisplayedRootCaseID = param1.getCase().id;
         this.currentlyDisplayedQuestActiveStatus = param2.getQuestActive();
         if(this.currentlyDisplayedQuestActiveStatus)
         {
            this.acceptButton.visible = false;
            this.abortButton.visible = true;
         }
         else
         {
            this.acceptButton.visible = true;
            this.abortButton.visible = false;
         }
         this.questSubTypeIcons.removeAllElements();
         if(param2.questSubTypeList != null)
         {
            _loc3_ = 0;
            while(_loc3_ < param2.questSubTypeList.length)
            {
               _loc4_ = String(QuestProxy.questIconMap[param2.questSubTypeList[_loc3_].icon]);
               _loc5_ = ResourceManager.getBitmap("questWin",_loc4_ + "_framed");
               _loc6_ = new Image();
               _loc6_.source = _loc5_;
               this.questSubTypeIcons.addElement(_loc6_);
               _loc7_ = QuestProxy.questIconTooltipMap[param2.questSubTypeList[_loc3_].icon];
               if(_loc7_)
               {
                  _loc6_.toolTip = BPLocale.getItem(_loc7_);
               }
               _loc3_++;
            }
         }
         this.updateQuestTitle(param1.title);
         this.updateQuestDescription(param1.description);
      }
      
      private function updateQuestTitle(param1:String) : void
      {
         this.challengeTitle.text = param1;
      }
      
      private function updateQuestDescription(param1:String) : void
      {
         this.challengeDescScrollerGroup.verticalScrollPosition = 0;
         this.challengeDesc.text = String(param1);
      }
      
      private function handleAcceptQuestButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:QuestGiverWindowEvent = new QuestGiverWindowEvent(QuestGiverWindowEvent.ACCEPT_QUEST);
         _loc2_.questID = this.currentlyDisplayedQuestID;
         _loc2_.rootCaseID = this.currentlyDisplayedRootCaseID;
         this.abortButton.visible = true;
         this.acceptButton.visible = false;
         dispatchEvent(_loc2_);
      }
      
      private function handleAbortQuestButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:QuestGiverWindowEvent = new QuestGiverWindowEvent(QuestGiverWindowEvent.ABORT_QUEST);
         _loc2_.questID = this.currentlyDisplayedQuestID;
         _loc2_.rootCaseID = this.currentlyDisplayedRootCaseID;
         dispatchEvent(_loc2_);
      }
      
      private function handleGridClicked(param1:GridEvent) : void
      {
         var _loc2_:ArrayList = (param1.currentTarget as HighscoreDataGrid).dataProvider as ArrayList;
         if(param1.rowIndex < 0 || param1.rowIndex >= _loc2_.length)
         {
            return;
         }
         var _loc3_:HighscoreVO = _loc2_.getItemAt(param1.rowIndex) as HighscoreVO;
         var _loc4_:String = Settings.dynamicHost + _loc3_.epppLink + "/?lang=" + Settings.language;
         JavascriptProxy.call(JavascriptProxy.FUNCTION_REFER_TO_EXTERNAL_URL_IN_NEW_WINDOW,[_loc4_,false]);
      }
      
      private function handleGridRollOver(param1:GridEvent) : void
      {
      }
      
      private function handleGridRollOut(param1:GridEvent) : void
      {
      }
      
      public function refreshQuestActiveStatus(param1:QuestListItemVO) : void
      {
         this.currentlyDisplayedQuestActiveStatus = param1.getQuestActive();
         if(this.currentlyDisplayedQuestActiveStatus)
         {
            this.acceptButton.visible = false;
            this.abortButton.visible = true;
         }
         else
         {
            this.acceptButton.visible = true;
            this.abortButton.visible = false;
         }
      }
      
      private function _ChallengesSectionView_Array1_c() : Array
      {
         return [this._ChallengesSectionView_VGroup1_c()];
      }
      
      private function _ChallengesSectionView_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._ChallengesSectionView_DOViewContainerBase1_i(),this._ChallengesSectionView_DOViewContainerBase3_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChallengesSectionView_DOViewContainerBase1_i() : DOViewContainerBase
      {
         var _loc1_:DOViewContainerBase = new DOViewContainerBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.styleName = "questWindowOuter";
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChallengesSectionView_Array3_c);
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
      
      private function _ChallengesSectionView_Array3_c() : Array
      {
         return [this._ChallengesSectionView_VGroup2_i()];
      }
      
      private function _ChallengesSectionView_VGroup2_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.mxmlContent = [this._ChallengesSectionView_DOViewContainerBase2_i(),this._ChallengesSectionView_HGroup1_c(),this._ChallengesSectionView_SkinnableContainer2_i(),this._ChallengesSectionView_Label4_i(),this._ChallengesSectionView_SkinnableContainer3_i()];
         _loc1_.id = "groupDepth3b";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.groupDepth3b = _loc1_;
         BindingManager.executeBindings(this,"groupDepth3b",this.groupDepth3b);
         return _loc1_;
      }
      
      private function _ChallengesSectionView_DOViewContainerBase2_i() : DOViewContainerBase
      {
         var _loc1_:DOViewContainerBase = new DOViewContainerBase();
         _loc1_.horizontalCenter = 0;
         _loc1_.percentWidth = 97;
         _loc1_.percentHeight = 40;
         _loc1_.styleName = "questWindowInvisible";
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChallengesSectionView_Array5_c);
         _loc1_.setStyle("skinClass",DOOuterViewContainerSkin);
         _loc1_.id = "selectedChallengeDescription";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.selectedChallengeDescription = _loc1_;
         BindingManager.executeBindings(this,"selectedChallengeDescription",this.selectedChallengeDescription);
         return _loc1_;
      }
      
      private function _ChallengesSectionView_Array5_c() : Array
      {
         return [this._ChallengesSectionView_VGroup3_c()];
      }
      
      private function _ChallengesSectionView_VGroup3_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._ChallengesSectionView_Label1_i(),this._ChallengesSectionView_Scroller1_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChallengesSectionView_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.text = "";
         _loc1_.setStyle("fontSize",20);
         _loc1_.setStyle("fontFamily","EurostileTHea");
         _loc1_.setStyle("paddingTop",10);
         _loc1_.setStyle("color",16763648);
         _loc1_.setStyle("textAlign","left");
         _loc1_.id = "challengeTitle";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.challengeTitle = _loc1_;
         BindingManager.executeBindings(this,"challengeTitle",this.challengeTitle);
         return _loc1_;
      }
      
      private function _ChallengesSectionView_Scroller1_c() : Scroller
      {
         var _loc1_:Scroller = new Scroller();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.styleName = "skinnedScroller";
         _loc1_.viewport = this._ChallengesSectionView_Group1_i();
         _loc1_.setStyle("horizontalScrollPolicy","off");
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChallengesSectionView_Group1_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.mxmlContent = [this._ChallengesSectionView_Label2_i()];
         _loc1_.id = "challengeDescScrollerGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.challengeDescScrollerGroup = _loc1_;
         BindingManager.executeBindings(this,"challengeDescScrollerGroup",this.challengeDescScrollerGroup);
         return _loc1_;
      }
      
      private function _ChallengesSectionView_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 360;
         _loc1_.text = "";
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("textAlign","left");
         _loc1_.setStyle("paddingRight",10);
         _loc1_.id = "challengeDesc";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.challengeDesc = _loc1_;
         BindingManager.executeBindings(this,"challengeDesc",this.challengeDesc);
         return _loc1_;
      }
      
      private function _ChallengesSectionView_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.verticalAlign = "bottom";
         _loc1_.percentWidth = 96;
         _loc1_.paddingBottom = -5;
         _loc1_.mxmlContent = [this._ChallengesSectionView_Label3_i(),this._ChallengesSectionView_HGroup2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChallengesSectionView_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
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
         this.objectivesLabel = _loc1_;
         BindingManager.executeBindings(this,"objectivesLabel",this.objectivesLabel);
         return _loc1_;
      }
      
      private function _ChallengesSectionView_HGroup2_i() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.horizontalAlign = "right";
         _loc1_.percentWidth = 50;
         _loc1_.id = "questSubTypeIcons";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.questSubTypeIcons = _loc1_;
         BindingManager.executeBindings(this,"questSubTypeIcons",this.questSubTypeIcons);
         return _loc1_;
      }
      
      private function _ChallengesSectionView_SkinnableContainer2_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 97;
         _loc1_.percentHeight = 30;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChallengesSectionView_Array9_c);
         _loc1_.setStyle("skinClass",DOViewContainerSkin);
         _loc1_.id = "selectedChallengeObjectivesBg";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.selectedChallengeObjectivesBg = _loc1_;
         BindingManager.executeBindings(this,"selectedChallengeObjectivesBg",this.selectedChallengeObjectivesBg);
         return _loc1_;
      }
      
      private function _ChallengesSectionView_Array9_c() : Array
      {
         return [this._ChallengesSectionView_QuestObjectivesView1_i()];
      }
      
      private function _ChallengesSectionView_QuestObjectivesView1_i() : QuestObjectivesView
      {
         var _loc1_:QuestObjectivesView = new QuestObjectivesView();
         _loc1_.left = 8;
         _loc1_.top = -2;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.id = "selectedChallengeObjectives";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.selectedChallengeObjectives = _loc1_;
         BindingManager.executeBindings(this,"selectedChallengeObjectives",this.selectedChallengeObjectives);
         return _loc1_;
      }
      
      private function _ChallengesSectionView_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.setStyle("fontSize",15);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("paddingLeft",10);
         _loc1_.setStyle("paddingTop",5);
         _loc1_.setStyle("paddingBottom",-3);
         _loc1_.setStyle("color",16763648);
         _loc1_.setStyle("textAlign","left");
         _loc1_.id = "rankingTitle";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.rankingTitle = _loc1_;
         BindingManager.executeBindings(this,"rankingTitle",this.rankingTitle);
         return _loc1_;
      }
      
      private function _ChallengesSectionView_SkinnableContainer3_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 97;
         _loc1_.percentHeight = 25;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChallengesSectionView_Array10_c);
         _loc1_.setStyle("skinClass",DOViewContainerSkin);
         _loc1_.id = "selectedChallengeHighscoreTable";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.selectedChallengeHighscoreTable = _loc1_;
         BindingManager.executeBindings(this,"selectedChallengeHighscoreTable",this.selectedChallengeHighscoreTable);
         return _loc1_;
      }
      
      private function _ChallengesSectionView_Array10_c() : Array
      {
         return [this._ChallengesSectionView_HighscoreDataGrid1_i()];
      }
      
      private function _ChallengesSectionView_HighscoreDataGrid1_i() : HighscoreDataGrid
      {
         var _loc1_:HighscoreDataGrid = new HighscoreDataGrid();
         _loc1_.percentWidth = 100;
         _loc1_.styleName = "skinnedDataGrid";
         _loc1_.percentHeight = 100;
         _loc1_.addEventListener("gridClick",this.__highscoreDataGrid_gridClick);
         _loc1_.addEventListener("gridRollOver",this.__highscoreDataGrid_gridRollOver);
         _loc1_.addEventListener("gridRollOut",this.__highscoreDataGrid_gridRollOut);
         _loc1_.id = "highscoreDataGrid";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.highscoreDataGrid = _loc1_;
         BindingManager.executeBindings(this,"highscoreDataGrid",this.highscoreDataGrid);
         return _loc1_;
      }
      
      public function __highscoreDataGrid_gridClick(param1:GridEvent) : void
      {
         this.handleGridClicked(param1);
      }
      
      public function __highscoreDataGrid_gridRollOver(param1:GridEvent) : void
      {
         this.handleGridRollOver(param1);
      }
      
      public function __highscoreDataGrid_gridRollOut(param1:GridEvent) : void
      {
         this.handleGridRollOut(param1);
      }
      
      private function _ChallengesSectionView_DOViewContainerBase3_c() : DOViewContainerBase
      {
         var _loc1_:DOViewContainerBase = new DOViewContainerBase();
         _loc1_.percentWidth = 100;
         _loc1_.styleName = "questWindowOuter";
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ChallengesSectionView_Array11_c);
         _loc1_.setStyle("skinClass",DOOuterViewContainerSkin);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ChallengesSectionView_Array11_c() : Array
      {
         return [this._ChallengesSectionView_Label5_i(),this._ChallengesSectionView_DOButtonBase1_i(),this._ChallengesSectionView_DOButtonBase2_i()];
      }
      
      private function _ChallengesSectionView_Label5_i() : Label
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
      
      private function _ChallengesSectionView_DOButtonBase1_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.width = 200;
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
         this.acceptButton = _loc1_;
         BindingManager.executeBindings(this,"acceptButton",this.acceptButton);
         return _loc1_;
      }
      
      public function __acceptButton_click(param1:MouseEvent) : void
      {
         this.handleAcceptQuestButtonClicked(param1);
      }
      
      private function _ChallengesSectionView_DOButtonBase2_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.width = 200;
         _loc1_.right = 0;
         _loc1_.styleName = "questWindowAbortQuest";
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("skinClass",DOButtonBaseSkin);
         _loc1_.addEventListener("click",this.__abortButton_click);
         _loc1_.id = "abortButton";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.abortButton = _loc1_;
         BindingManager.executeBindings(this,"abortButton",this.abortButton);
         return _loc1_;
      }
      
      public function __abortButton_click(param1:MouseEvent) : void
      {
         this.handleAbortQuestButtonClicked(param1);
      }
      
      public function ___ChallengesSectionView_SkinnableContainer1_creationComplete(param1:FlexEvent) : void
      {
         this.handleSectionCreationComplete(param1);
      }
      
      private function _ChallengesSectionView_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("label_objectives");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"objectivesLabel.text");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("label_ranking");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"rankingTitle.text");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("label_questslots_free").replace("%AMOUNT%","X");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"questsLeft.text");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("btn_challenge_accept");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"acceptButton.label");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("label_close");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"abortButton.label");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get abortButton() : DOButtonBase
      {
         return this._363785598abortButton;
      }
      
      public function set abortButton(param1:DOButtonBase) : void
      {
         var _loc2_:Object = this._363785598abortButton;
         if(_loc2_ !== param1)
         {
            this._363785598abortButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"abortButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get acceptButton() : DOButtonBase
      {
         return this._1480909402acceptButton;
      }
      
      public function set acceptButton(param1:DOButtonBase) : void
      {
         var _loc2_:Object = this._1480909402acceptButton;
         if(_loc2_ !== param1)
         {
            this._1480909402acceptButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"acceptButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get challengeDesc() : Label
      {
         return this._812644972challengeDesc;
      }
      
      public function set challengeDesc(param1:Label) : void
      {
         var _loc2_:Object = this._812644972challengeDesc;
         if(_loc2_ !== param1)
         {
            this._812644972challengeDesc = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"challengeDesc",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get challengeDescScrollerGroup() : spark.components.Group
      {
         return this._1892679985challengeDescScrollerGroup;
      }
      
      public function set challengeDescScrollerGroup(param1:spark.components.Group) : void
      {
         var _loc2_:Object = this._1892679985challengeDescScrollerGroup;
         if(_loc2_ !== param1)
         {
            this._1892679985challengeDescScrollerGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"challengeDescScrollerGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get challengeTitle() : Label
      {
         return this._592706485challengeTitle;
      }
      
      public function set challengeTitle(param1:Label) : void
      {
         var _loc2_:Object = this._592706485challengeTitle;
         if(_loc2_ !== param1)
         {
            this._592706485challengeTitle = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"challengeTitle",_loc2_,param1));
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
      public function get highscoreDataGrid() : HighscoreDataGrid
      {
         return this._1759783840highscoreDataGrid;
      }
      
      public function set highscoreDataGrid(param1:HighscoreDataGrid) : void
      {
         var _loc2_:Object = this._1759783840highscoreDataGrid;
         if(_loc2_ !== param1)
         {
            this._1759783840highscoreDataGrid = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"highscoreDataGrid",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get objectivesLabel() : Label
      {
         return this._681244486objectivesLabel;
      }
      
      public function set objectivesLabel(param1:Label) : void
      {
         var _loc2_:Object = this._681244486objectivesLabel;
         if(_loc2_ !== param1)
         {
            this._681244486objectivesLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"objectivesLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questSubTypeIcons() : HGroup
      {
         return this._1419500450questSubTypeIcons;
      }
      
      public function set questSubTypeIcons(param1:HGroup) : void
      {
         var _loc2_:Object = this._1419500450questSubTypeIcons;
         if(_loc2_ !== param1)
         {
            this._1419500450questSubTypeIcons = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questSubTypeIcons",_loc2_,param1));
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
      public function get rankingTitle() : Label
      {
         return this._758540350rankingTitle;
      }
      
      public function set rankingTitle(param1:Label) : void
      {
         var _loc2_:Object = this._758540350rankingTitle;
         if(_loc2_ !== param1)
         {
            this._758540350rankingTitle = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankingTitle",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedChallengeDescription() : DOViewContainerBase
      {
         return this._562884308selectedChallengeDescription;
      }
      
      public function set selectedChallengeDescription(param1:DOViewContainerBase) : void
      {
         var _loc2_:Object = this._562884308selectedChallengeDescription;
         if(_loc2_ !== param1)
         {
            this._562884308selectedChallengeDescription = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedChallengeDescription",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedChallengeHighscoreTable() : SkinnableContainer
      {
         return this._1109878362selectedChallengeHighscoreTable;
      }
      
      public function set selectedChallengeHighscoreTable(param1:SkinnableContainer) : void
      {
         var _loc2_:Object = this._1109878362selectedChallengeHighscoreTable;
         if(_loc2_ !== param1)
         {
            this._1109878362selectedChallengeHighscoreTable = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedChallengeHighscoreTable",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedChallengeObjectives() : QuestObjectivesView
      {
         return this._1002719362selectedChallengeObjectives;
      }
      
      public function set selectedChallengeObjectives(param1:QuestObjectivesView) : void
      {
         var _loc2_:Object = this._1002719362selectedChallengeObjectives;
         if(_loc2_ !== param1)
         {
            this._1002719362selectedChallengeObjectives = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedChallengeObjectives",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedChallengeObjectivesBg() : SkinnableContainer
      {
         return this._1540634727selectedChallengeObjectivesBg;
      }
      
      public function set selectedChallengeObjectivesBg(param1:SkinnableContainer) : void
      {
         var _loc2_:Object = this._1540634727selectedChallengeObjectivesBg;
         if(_loc2_ !== param1)
         {
            this._1540634727selectedChallengeObjectivesBg = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedChallengeObjectivesBg",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get objectivesList() : ArrayList
      {
         return this._2100177384objectivesList;
      }
      
      private function set objectivesList(param1:ArrayList) : void
      {
         var _loc2_:Object = this._2100177384objectivesList;
         if(_loc2_ !== param1)
         {
            this._2100177384objectivesList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"objectivesList",_loc2_,param1));
            }
         }
      }
   }
}

