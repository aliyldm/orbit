package net.bigpoint.darkorbit.mvc.companyhierarchy.view.components
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
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOScalableDivider;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOScalableDividerSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOViewContainerSkin;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.itemrenderers.RankedClanItemRenderer;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.view.skins.RankedClansListSkin;
   import net.bigpoint.darkorbit.mvc.questWindow.view.components.QuestGiverTabBarSkin;
   import spark.components.BorderContainer;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.List;
   import spark.components.Scroller;
   import spark.components.TabBar;
   import spark.components.VGroup;
   import spark.events.IndexChangeEvent;
   import spark.primitives.BitmapImage;
   
   use namespace mx_internal;
   
   public class CompanyHierarchyWindowView extends CompanyHierarchyWindowBase implements IBindingClient
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
      
      private var _1475584580bgContainer:BorderContainer;
      
      private var _1996695116bottomVGroup:VGroup;
      
      private var _508629048companyLogo:BitmapImage;
      
      private var _1674318617divider:DOScalableDivider;
      
      private var _182027724hierarchyContainer:BorderContainer;
      
      private var _1909550038hierarchyInnerVGroup:VGroup;
      
      private var _858224271hierarchyOuterVGroup:VGroup;
      
      private var _475505495mainTabBar:TabBar;
      
      private var _509272770mainVGroup:VGroup;
      
      private var _1891507435topBarHGroup:VGroup;
      
      private var _581328724topHGroup:HGroup;
      
      private var _984130913topLabel:Label;
      
      private var _709395988windowDescription:VGroup;
      
      private var _246916107windowDescriptionContainer:HGroup;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _handler:ICompanyHierarchyWindowHandler;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CompanyHierarchyWindowView()
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
         bindings = this._CompanyHierarchyWindowView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_companyhierarchy_view_components_CompanyHierarchyWindowViewWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return CompanyHierarchyWindowView[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.styleName = "companyHierarchyWindow";
         this.width = 600;
         this.height = 500;
         this.minHeight = 500;
         this.minWidth = 600;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._CompanyHierarchyWindowView_Array1_c);
         this.addEventListener("creationComplete",this.___CompanyHierarchyWindowView_CompanyHierarchyWindowBase1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         CompanyHierarchyWindowView._watcherSetupUtil = param1;
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
      
      public function set handler(param1:ICompanyHierarchyWindowHandler) : void
      {
         this._handler = param1;
      }
      
      private function onComplete() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:UIComponent = null;
         if(ResourceManager.fileCollection.getFinisher("clanHierarchyWin") != null && Boolean((ResourceManager.fileCollection.getFinisher("clanHierarchyWin") as SWFFinisher).getEmbeddedObject("contentBg")))
         {
            this.bgContainer.setStyle("backgroundImage",ResourceManager.getBitmap("clanHierarchyWin","contentBg"));
         }
         if(ResourceManager.fileCollection.getFinisher("clanHierarchyWin") != null && Boolean((ResourceManager.fileCollection.getFinisher("clanHierarchyWin") as SWFFinisher).getEmbeddedObject("infoBtn")))
         {
            _loc1_ = ResourceManager.getMovieClip("clanHierarchyWin","infoBtn");
            _loc1_.stop();
            _loc1_.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverInfoButton);
            _loc1_.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutsideInfoButton);
            _loc2_ = new UIComponent();
            _loc2_.addChild(_loc1_);
            this.windowDescription.addElement(_loc2_);
            this.windowDescription.toolTip = BPLocale.getItem("company_hierarchy_desc_window");
         }
         itsYourClan.text = BPLocale.getItem("company_hierarchy_desc_your_clan");
         this.updateCompanyLogo();
      }
      
      private function handleMouseOverInfoButton(param1:Event) : void
      {
         (param1.target as MovieClip).gotoAndStop(2);
      }
      
      private function handleMouseOutsideInfoButton(param1:Event) : void
      {
         (param1.target as MovieClip).gotoAndStop(1);
      }
      
      public function updateCompanyLogo() : void
      {
         var _loc1_:Bitmap = null;
         if(InGameCatalog.instance.factions_resKeys[this.mainTabBar.selectedIndex + 1] != undefined && ResourceManager.fileCollection.getFinisher("clanHierarchyWin") != null && Boolean((ResourceManager.fileCollection.getFinisher("clanHierarchyWin") as SWFFinisher).getEmbeddedObject("logo_" + InGameCatalog.instance.factions_resKeys[this.mainTabBar.selectedIndex + 1])))
         {
            _loc1_ = ResourceManager.getBitmap("clanHierarchyWin","logo_" + InGameCatalog.instance.factions_resKeys[this.mainTabBar.selectedIndex + 1]);
            this.companyLogo.source = _loc1_;
            this.companyLogo.alpha = 1;
         }
         else
         {
            this.companyLogo.alpha = 0;
         }
      }
      
      private function handleTabClicked(param1:IndexChangeEvent) : void
      {
         this.mainTabBar.selectedIndex = param1.newIndex;
         this.updateCompanyLogo();
         super.onTabChange(param1.newIndex);
         if(this._handler != null)
         {
            this._handler.handleFactionTabChanged(param1.newIndex);
         }
      }
      
      private function _CompanyHierarchyWindowView_Array1_c() : Array
      {
         return [this._CompanyHierarchyWindowView_DOScalableDivider1_i(),this._CompanyHierarchyWindowView_VGroup1_i()];
      }
      
      private function _CompanyHierarchyWindowView_DOScalableDivider1_i() : DOScalableDivider
      {
         var _loc1_:DOScalableDivider = new DOScalableDivider();
         _loc1_.percentWidth = 100;
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
      
      private function _CompanyHierarchyWindowView_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.paddingLeft = 1;
         _loc1_.paddingRight = 1;
         _loc1_.paddingTop = -10;
         _loc1_.mxmlContent = [this._CompanyHierarchyWindowView_VGroup2_i(),this._CompanyHierarchyWindowView_BorderContainer1_i()];
         _loc1_.id = "mainVGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.mainVGroup = _loc1_;
         BindingManager.executeBindings(this,"mainVGroup",this.mainVGroup);
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_VGroup2_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 0;
         _loc1_.mxmlContent = [this._CompanyHierarchyWindowView_VGroup3_c(),this._CompanyHierarchyWindowView_DOScalableDivider2_c()];
         _loc1_.id = "topBarHGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.topBarHGroup = _loc1_;
         BindingManager.executeBindings(this,"topBarHGroup",this.topBarHGroup);
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_VGroup3_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.paddingLeft = 1;
         _loc1_.mxmlContent = [this._CompanyHierarchyWindowView_TabBar1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_TabBar1_i() : TabBar
      {
         var _loc1_:TabBar = new TabBar();
         _loc1_.setStyle("skinClass",QuestGiverTabBarSkin);
         _loc1_.addEventListener("change",this.__mainTabBar_change);
         _loc1_.id = "mainTabBar";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.mainTabBar = _loc1_;
         BindingManager.executeBindings(this,"mainTabBar",this.mainTabBar);
         return _loc1_;
      }
      
      public function __mainTabBar_change(param1:IndexChangeEvent) : void
      {
         this.handleTabClicked(param1);
      }
      
      private function _CompanyHierarchyWindowView_DOScalableDivider2_c() : DOScalableDivider
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
      
      private function _CompanyHierarchyWindowView_BorderContainer1_i() : BorderContainer
      {
         var _loc1_:BorderContainer = new BorderContainer();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._CompanyHierarchyWindowView_Array5_c);
         _loc1_.setStyle("backgroundAlpha",1);
         _loc1_.setStyle("borderAlpha",0);
         _loc1_.setStyle("borderColor",16777215);
         _loc1_.setStyle("skinClass",DOViewContainerSkin);
         _loc1_.id = "hierarchyContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.hierarchyContainer = _loc1_;
         BindingManager.executeBindings(this,"hierarchyContainer",this.hierarchyContainer);
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_Array5_c() : Array
      {
         return [this._CompanyHierarchyWindowView_Scroller1_c()];
      }
      
      private function _CompanyHierarchyWindowView_Scroller1_c() : Scroller
      {
         var _loc1_:Scroller = new Scroller();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.bottom = 20;
         _loc1_.styleName = "skinnedScroller";
         _loc1_.viewport = this._CompanyHierarchyWindowView_VGroup4_i();
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_VGroup4_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.mxmlContent = [this._CompanyHierarchyWindowView_BorderContainer2_i()];
         _loc1_.id = "hierarchyOuterVGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.hierarchyOuterVGroup = _loc1_;
         BindingManager.executeBindings(this,"hierarchyOuterVGroup",this.hierarchyOuterVGroup);
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_BorderContainer2_i() : BorderContainer
      {
         var _loc1_:BorderContainer = new BorderContainer();
         _loc1_.percentWidth = 100;
         _loc1_.height = 483;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._CompanyHierarchyWindowView_Array7_c);
         _loc1_.id = "bgContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.bgContainer = _loc1_;
         BindingManager.executeBindings(this,"bgContainer",this.bgContainer);
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_Array7_c() : Array
      {
         return [this._CompanyHierarchyWindowView_VGroup5_i()];
      }
      
      private function _CompanyHierarchyWindowView_VGroup5_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.mxmlContent = [this._CompanyHierarchyWindowView_Label1_i(),this._CompanyHierarchyWindowView_HGroup1_i(),this._CompanyHierarchyWindowView_VGroup7_c(),this._CompanyHierarchyWindowView_VGroup8_i()];
         _loc1_.id = "hierarchyInnerVGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.hierarchyInnerVGroup = _loc1_;
         BindingManager.executeBindings(this,"hierarchyInnerVGroup",this.hierarchyInnerVGroup);
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.alpha = 0;
         _loc1_.text = " ";
         _loc1_.id = "topLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.topLabel = _loc1_;
         BindingManager.executeBindings(this,"topLabel",this.topLabel);
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_HGroup1_i() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.verticalAlign = "middle";
         _loc1_.mxmlContent = [this._CompanyHierarchyWindowView_HGroup2_c(),this._CompanyHierarchyWindowView_RankedClanItem1_i(),this._CompanyHierarchyWindowView_HGroup3_i()];
         _loc1_.id = "topHGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.topHGroup = _loc1_;
         BindingManager.executeBindings(this,"topHGroup",this.topHGroup);
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_HGroup2_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 25;
         _loc1_.paddingLeft = 46;
         _loc1_.verticalAlign = "middle";
         _loc1_.mxmlContent = [this._CompanyHierarchyWindowView_BitmapImage1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_BitmapImage1_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.initialized(this,"companyLogo");
         this.companyLogo = _loc1_;
         BindingManager.executeBindings(this,"companyLogo",this.companyLogo);
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_RankedClanItem1_i() : RankedClanItem
      {
         var _loc1_:RankedClanItem = new RankedClanItem();
         _loc1_.percentWidth = 50;
         _loc1_.id = "leader";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         leader = _loc1_;
         BindingManager.executeBindings(this,"leader",leader);
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_HGroup3_i() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 25;
         _loc1_.horizontalAlign = "center";
         _loc1_.mxmlContent = [this._CompanyHierarchyWindowView_VGroup6_i()];
         _loc1_.id = "windowDescriptionContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.windowDescriptionContainer = _loc1_;
         BindingManager.executeBindings(this,"windowDescriptionContainer",this.windowDescriptionContainer);
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_VGroup6_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.x = 82;
         _loc1_.id = "windowDescription";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.windowDescription = _loc1_;
         BindingManager.executeBindings(this,"windowDescription",this.windowDescription);
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_VGroup7_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.paddingTop = -3;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._CompanyHierarchyWindowView_List1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_List1_i() : List
      {
         var _loc1_:List = new List();
         _loc1_.itemRenderer = this._CompanyHierarchyWindowView_ClassFactory1_c();
         _loc1_.percentWidth = 100;
         _loc1_.enabled = true;
         _loc1_.setStyle("skinClass",RankedClansListSkin);
         _loc1_.setStyle("contentBackgroundAlpha",0);
         _loc1_.setStyle("borderAlpha",0);
         _loc1_.id = "rankedClanItemList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         rankedClanItemList = _loc1_;
         BindingManager.executeBindings(this,"rankedClanItemList",rankedClanItemList);
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = RankedClanItemRenderer;
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_VGroup8_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.verticalAlign = "middle";
         _loc1_.mxmlContent = [this._CompanyHierarchyWindowView_Label2_i(),this._CompanyHierarchyWindowView_VGroup9_c()];
         _loc1_.id = "bottomVGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.bottomVGroup = _loc1_;
         BindingManager.executeBindings(this,"bottomVGroup",this.bottomVGroup);
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.text = "Your Clan Position";
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("fontSize",14);
         _loc1_.id = "itsYourClan";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         itsYourClan = _loc1_;
         BindingManager.executeBindings(this,"itsYourClan",itsYourClan);
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_VGroup9_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.paddingTop = -6;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.mxmlContent = [this._CompanyHierarchyWindowView_RankedClanItem2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CompanyHierarchyWindowView_RankedClanItem2_i() : RankedClanItem
      {
         var _loc1_:RankedClanItem = new RankedClanItem();
         _loc1_.percentWidth = 50;
         _loc1_.id = "bottomClan";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         bottomClan = _loc1_;
         BindingManager.executeBindings(this,"bottomClan",bottomClan);
         return _loc1_;
      }
      
      public function ___CompanyHierarchyWindowView_CompanyHierarchyWindowBase1_creationComplete(param1:FlexEvent) : void
      {
         this.onComplete();
      }
      
      private function _CompanyHierarchyWindowView_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("title_company_hierarchy");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"this.title");
         result[1] = new Binding(this,function():Number
         {
            return mainTabBar.y + mainTabBar.height;
         },null,"divider.y");
         result[2] = new Binding(this,null,null,"mainTabBar.dataProvider","tabList");
         result[3] = new Binding(this,function():uint
         {
            return Styles.companyHierarchyColorHeading;
         },function(param1:uint):void
         {
            itsYourClan.setStyle("color",param1);
         },"itsYourClan.color");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontHeavyFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            itsYourClan.setStyle("fontFamily",param1);
         },"itsYourClan.fontFamily");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get bgContainer() : BorderContainer
      {
         return this._1475584580bgContainer;
      }
      
      public function set bgContainer(param1:BorderContainer) : void
      {
         var _loc2_:Object = this._1475584580bgContainer;
         if(_loc2_ !== param1)
         {
            this._1475584580bgContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bgContainer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomVGroup() : VGroup
      {
         return this._1996695116bottomVGroup;
      }
      
      public function set bottomVGroup(param1:VGroup) : void
      {
         var _loc2_:Object = this._1996695116bottomVGroup;
         if(_loc2_ !== param1)
         {
            this._1996695116bottomVGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomVGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get companyLogo() : BitmapImage
      {
         return this._508629048companyLogo;
      }
      
      public function set companyLogo(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._508629048companyLogo;
         if(_loc2_ !== param1)
         {
            this._508629048companyLogo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"companyLogo",_loc2_,param1));
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
      public function get hierarchyContainer() : BorderContainer
      {
         return this._182027724hierarchyContainer;
      }
      
      public function set hierarchyContainer(param1:BorderContainer) : void
      {
         var _loc2_:Object = this._182027724hierarchyContainer;
         if(_loc2_ !== param1)
         {
            this._182027724hierarchyContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hierarchyContainer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hierarchyInnerVGroup() : VGroup
      {
         return this._1909550038hierarchyInnerVGroup;
      }
      
      public function set hierarchyInnerVGroup(param1:VGroup) : void
      {
         var _loc2_:Object = this._1909550038hierarchyInnerVGroup;
         if(_loc2_ !== param1)
         {
            this._1909550038hierarchyInnerVGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hierarchyInnerVGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hierarchyOuterVGroup() : VGroup
      {
         return this._858224271hierarchyOuterVGroup;
      }
      
      public function set hierarchyOuterVGroup(param1:VGroup) : void
      {
         var _loc2_:Object = this._858224271hierarchyOuterVGroup;
         if(_loc2_ !== param1)
         {
            this._858224271hierarchyOuterVGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hierarchyOuterVGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mainTabBar() : TabBar
      {
         return this._475505495mainTabBar;
      }
      
      public function set mainTabBar(param1:TabBar) : void
      {
         var _loc2_:Object = this._475505495mainTabBar;
         if(_loc2_ !== param1)
         {
            this._475505495mainTabBar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainTabBar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mainVGroup() : VGroup
      {
         return this._509272770mainVGroup;
      }
      
      public function set mainVGroup(param1:VGroup) : void
      {
         var _loc2_:Object = this._509272770mainVGroup;
         if(_loc2_ !== param1)
         {
            this._509272770mainVGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainVGroup",_loc2_,param1));
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
      public function get topHGroup() : HGroup
      {
         return this._581328724topHGroup;
      }
      
      public function set topHGroup(param1:HGroup) : void
      {
         var _loc2_:Object = this._581328724topHGroup;
         if(_loc2_ !== param1)
         {
            this._581328724topHGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topHGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get topLabel() : Label
      {
         return this._984130913topLabel;
      }
      
      public function set topLabel(param1:Label) : void
      {
         var _loc2_:Object = this._984130913topLabel;
         if(_loc2_ !== param1)
         {
            this._984130913topLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get windowDescription() : VGroup
      {
         return this._709395988windowDescription;
      }
      
      public function set windowDescription(param1:VGroup) : void
      {
         var _loc2_:Object = this._709395988windowDescription;
         if(_loc2_ !== param1)
         {
            this._709395988windowDescription = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"windowDescription",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get windowDescriptionContainer() : HGroup
      {
         return this._246916107windowDescriptionContainer;
      }
      
      public function set windowDescriptionContainer(param1:HGroup) : void
      {
         var _loc2_:Object = this._246916107windowDescriptionContainer;
         if(_loc2_ !== param1)
         {
            this._246916107windowDescriptionContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"windowDescriptionContainer",_loc2_,param1));
            }
         }
      }
   }
}

