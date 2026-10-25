package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window
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
   import mx.core.ClassFactory;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.ScrollPolicy;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.graphics.BitmapScaleMode;
   import mx.graphics.SolidColor;
   import mx.styles.*;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.view.ResultHeaderLabel;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.consts.TDMResultWindowConstants;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.model.vo.TDMResultWindowModel;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.TDMResultTabBarSkin;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.TDMRewardIcon;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.accordion.TDMAccordion;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.accordion.TDMResultWindowAccordionContentListRenderer;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo.TDMResultWindowTabVo;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo.TDMRewardsModel;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Image;
   import spark.components.ScrollSnappingMode;
   import spark.components.SkinnableContainer;
   import spark.components.TabBar;
   import spark.components.VGroup;
   import spark.events.IndexChangeEvent;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.HorizontalLayout;
   import spark.layouts.VerticalAlign;
   import spark.layouts.VerticalLayout;
   import spark.primitives.Rect;
   
   use namespace mx_internal;
   
   public class TDMMatchResultWindow extends DOWindow implements IBindingClient
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
      
      public var _TDMMatchResultWindow_Group2:spark.components.Group;
      
      public var _TDMMatchResultWindow_HGroup1:HGroup;
      
      public var _TDMMatchResultWindow_TDMRewardIcon1:TDMRewardIcon;
      
      public var _TDMMatchResultWindow_VGroup2:VGroup;
      
      public var _TDMMatchResultWindow_VerticalLayout1:VerticalLayout;
      
      private var _1830107832accordion:TDMAccordion;
      
      private var _213307459headerPic:Image;
      
      private var _881418178tabBar:TabBar;
      
      private var _1323802622victoryLabel:ResultHeaderLabel;
      
      private var _1659371121windowContainer:VGroup;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _541574415_headerImage:Bitmap;
      
      private var _91286621_tabs:VectorCollection;
      
      private var _1151002861_accordionData:VectorCollection;
      
      private var _836092443_rewards:TDMRewardsModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function TDMMatchResultWindow()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._91286621_tabs = new VectorCollection();
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._TDMMatchResultWindow_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_tdm_matchresultWindow_view_window_TDMMatchResultWindowWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return TDMMatchResultWindow[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 500;
         this.height = 450;
         this.styleName = "tdmResultWindow";
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._TDMMatchResultWindow_Array1_c);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         TDMMatchResultWindow._watcherSetupUtil = param1;
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
      
      public function setHeaderImage(param1:Bitmap) : void
      {
         this._headerImage = param1;
      }
      
      public function set headerText(param1:String) : void
      {
         this.victoryLabel.headerText = param1.toUpperCase();
      }
      
      public function set textTexture(param1:DisplayObject) : void
      {
         this.victoryLabel.texture = param1;
      }
      
      public function set gradient(param1:DisplayObject) : void
      {
         this.victoryLabel.gradient = param1;
      }
      
      public function set windowData(param1:TDMResultWindowModel) : void
      {
         this.tabData = param1.tabs;
         this._rewards = param1.rewards;
      }
      
      public function set effectImg(param1:DisplayObject) : void
      {
         this.victoryLabel.effectImg = param1;
      }
      
      public function set backGround(param1:DisplayObject) : void
      {
         this.victoryLabel.backGround = param1;
      }
      
      private function set tabData(param1:Vector.<TDMResultWindowTabVo>) : void
      {
         this._tabs.source = param1;
         this.goToTabByIndex(Math.max(0,this.tabBar.selectedIndex));
      }
      
      private function handleTabBarChange(param1:IndexChangeEvent) : void
      {
         var _loc2_:int = param1.newIndex;
         this.goToTabByIndex(_loc2_);
      }
      
      private function goToTabByIndex(param1:int) : void
      {
         this._accordionData = (this._tabs[param1] as TDMResultWindowTabVo).contentConllection;
      }
      
      private function _TDMMatchResultWindow_Array1_c() : Array
      {
         return [this._TDMMatchResultWindow_VGroup1_i()];
      }
      
      private function _TDMMatchResultWindow_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.visible = true;
         _loc1_.paddingBottom = 10;
         _loc1_.mxmlContent = [this._TDMMatchResultWindow_Group1_c(),this._TDMMatchResultWindow_SkinnableContainer1_c()];
         _loc1_.id = "windowContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.windowContainer = _loc1_;
         BindingManager.executeBindings(this,"windowContainer",this.windowContainer);
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_Group1_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 99.5;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         _loc1_.mask = this._TDMMatchResultWindow_Group2_i();
         _loc1_.mxmlContent = [this._TDMMatchResultWindow_Image1_i(),this._TDMMatchResultWindow_VGroup2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_Group2_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.mxmlContent = [this._TDMMatchResultWindow_Rect1_c()];
         _loc1_.id = "_TDMMatchResultWindow_Group2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._TDMMatchResultWindow_Group2 = _loc1_;
         BindingManager.executeBindings(this,"_TDMMatchResultWindow_Group2",this._TDMMatchResultWindow_Group2);
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.fill = this._TDMMatchResultWindow_SolidColor1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 65280;
         _loc1_.alpha = 1;
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_Image1_i() : Image
      {
         var _loc1_:Image = new Image();
         _loc1_.percentHeight = 90;
         _loc1_.right = 0;
         _loc1_.left = 0;
         _loc1_.id = "headerPic";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.headerPic = _loc1_;
         BindingManager.executeBindings(this,"headerPic",this.headerPic);
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_VGroup2_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._TDMMatchResultWindow_HGroup1_i()];
         _loc1_.id = "_TDMMatchResultWindow_VGroup2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._TDMMatchResultWindow_VGroup2 = _loc1_;
         BindingManager.executeBindings(this,"_TDMMatchResultWindow_VGroup2",this._TDMMatchResultWindow_VGroup2);
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_HGroup1_i() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._TDMMatchResultWindow_ResultHeaderLabel1_i()];
         _loc1_.id = "_TDMMatchResultWindow_HGroup1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._TDMMatchResultWindow_HGroup1 = _loc1_;
         BindingManager.executeBindings(this,"_TDMMatchResultWindow_HGroup1",this._TDMMatchResultWindow_HGroup1);
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_ResultHeaderLabel1_i() : ResultHeaderLabel
      {
         var _loc1_:ResultHeaderLabel = new ResultHeaderLabel();
         _loc1_.id = "victoryLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.victoryLabel = _loc1_;
         BindingManager.executeBindings(this,"victoryLabel",this.victoryLabel);
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_SkinnableContainer1_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.bottom = 25;
         _loc1_.top = 26;
         _loc1_.left = 25;
         _loc1_.right = 25;
         _loc1_.styleName = "tdmResultBorder";
         _loc1_.percentWidth = 90;
         _loc1_.layout = this._TDMMatchResultWindow_HorizontalLayout1_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._TDMMatchResultWindow_Array7_c);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_HorizontalLayout1_c() : HorizontalLayout
      {
         return new HorizontalLayout();
      }
      
      private function _TDMMatchResultWindow_Array7_c() : Array
      {
         return [this._TDMMatchResultWindow_VGroup3_c()];
      }
      
      private function _TDMMatchResultWindow_VGroup3_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.gap = 0;
         _loc1_.mxmlContent = [this._TDMMatchResultWindow_Group3_c(),this._TDMMatchResultWindow_SkinnableContainer2_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_Group3_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._TDMMatchResultWindow_TabBar1_i(),this._TDMMatchResultWindow_TDMRewardIcon1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_TabBar1_i() : TabBar
      {
         var _loc1_:TabBar = new TabBar();
         _loc1_.percentWidth = 100;
         _loc1_.left = 7;
         _loc1_.top = 7;
         _loc1_.setStyle("skinClass",TDMResultTabBarSkin);
         _loc1_.addEventListener("change",this.__tabBar_change);
         _loc1_.id = "tabBar";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.tabBar = _loc1_;
         BindingManager.executeBindings(this,"tabBar",this.tabBar);
         return _loc1_;
      }
      
      public function __tabBar_change(param1:IndexChangeEvent) : void
      {
         this.handleTabBarChange(param1);
      }
      
      private function _TDMMatchResultWindow_TDMRewardIcon1_i() : TDMRewardIcon
      {
         var _loc1_:TDMRewardIcon = new TDMRewardIcon();
         _loc1_.percentHeight = 100;
         _loc1_.right = 7;
         _loc1_.top = 0;
         _loc1_.id = "_TDMMatchResultWindow_TDMRewardIcon1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._TDMMatchResultWindow_TDMRewardIcon1 = _loc1_;
         BindingManager.executeBindings(this,"_TDMMatchResultWindow_TDMRewardIcon1",this._TDMMatchResultWindow_TDMRewardIcon1);
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_SkinnableContainer2_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.height = 200;
         _loc1_.percentWidth = 100;
         _loc1_.styleName = "tdmResult";
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._TDMMatchResultWindow_Array10_c);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_Array10_c() : Array
      {
         return [this._TDMMatchResultWindow_Group4_c()];
      }
      
      private function _TDMMatchResultWindow_Group4_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.focusEnabled = false;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._TDMMatchResultWindow_TDMAccordion1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_TDMAccordion1_i() : TDMAccordion
      {
         var _loc1_:TDMAccordion = new TDMAccordion();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.hasFocusableChildren = false;
         _loc1_.allowMultipleSelection = true;
         _loc1_.focusEnabled = false;
         _loc1_.useVirtualLayout = true;
         _loc1_.styleName = "skinnedList";
         _loc1_.scrollInterval = 1;
         _loc1_.itemRenderer = this._TDMMatchResultWindow_ClassFactory1_c();
         _loc1_.layout = this._TDMMatchResultWindow_VerticalLayout1_i();
         _loc1_.setStyle("contentBackgroundAlpha",0);
         _loc1_.setStyle("borderVisible",false);
         _loc1_.id = "accordion";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.accordion = _loc1_;
         BindingManager.executeBindings(this,"accordion",this.accordion);
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = TDMResultWindowAccordionContentListRenderer;
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_VerticalLayout1_i() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 0;
         _loc1_.requestedRowCount = -1;
         this._TDMMatchResultWindow_VerticalLayout1 = _loc1_;
         BindingManager.executeBindings(this,"_TDMMatchResultWindow_VerticalLayout1",this._TDMMatchResultWindow_VerticalLayout1);
         return _loc1_;
      }
      
      private function _TDMMatchResultWindow_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Number
         {
            return this.width;
         },null,"windowContainer.maxWidth");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = HorizontalAlign.CENTER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"windowContainer.horizontalAlign");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = VerticalAlign.TOP;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"windowContainer.verticalAlign");
         result[3] = new Binding(this,function():Number
         {
            return headerPic.width;
         },null,"_TDMMatchResultWindow_Group2.width");
         result[4] = new Binding(this,function():Number
         {
            return headerPic.height;
         },null,"_TDMMatchResultWindow_Group2.height");
         result[5] = new Binding(this,function():Object
         {
            return _headerImage;
         },null,"headerPic.source");
         result[6] = new Binding(this,function():Number
         {
            return this.width;
         },null,"headerPic.maxWidth");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = BitmapScaleMode.STRETCH;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"headerPic.scaleMode");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = VerticalAlign.MIDDLE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TDMMatchResultWindow_VGroup2.verticalAlign");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = HorizontalAlign.CENTER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TDMMatchResultWindow_VGroup2.horizontalAlign");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = HorizontalAlign.CENTER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TDMMatchResultWindow_HGroup1.horizontalAlign");
         result[11] = new Binding(this,function():Number
         {
            return this.width;
         },null,"victoryLabel.maxWidth");
         result[12] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontHeavyFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"victoryLabel.font");
         result[13] = new Binding(this,function():int
         {
            return TDMResultWindowConstants.HEADER_FONT_SIZE;
         },null,"victoryLabel.fontSize");
         result[14] = new Binding(this,function():int
         {
            return TDMResultWindowConstants.HEADER_TRACKING;
         },null,"victoryLabel.trackingLeft");
         result[15] = new Binding(this,function():IList
         {
            return _tabs;
         },null,"tabBar.dataProvider");
         result[16] = new Binding(this,function():Object
         {
            return _rewards;
         },null,"_TDMMatchResultWindow_TDMRewardIcon1.data");
         result[17] = new Binding(this,function():String
         {
            var _loc1_:* = ScrollPolicy.OFF;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            accordion.setStyle("horizontalScrollPolicy",param1);
         },"accordion.horizontalScrollPolicy");
         result[18] = new Binding(this,function():String
         {
            var _loc1_:* = ScrollPolicy.AUTO;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            accordion.setStyle("verticalScrollPolicy",param1);
         },"accordion.verticalScrollPolicy");
         result[19] = new Binding(this,function():String
         {
            var _loc1_:* = ScrollSnappingMode.LEADING_EDGE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"accordion.scrollSnappingMode");
         result[20] = new Binding(this,function():IList
         {
            return _accordionData;
         },null,"accordion.dataProvider");
         result[21] = new Binding(this,function():String
         {
            var _loc1_:* = HorizontalAlign.CONTENT_JUSTIFY;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TDMMatchResultWindow_VerticalLayout1.horizontalAlign");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get accordion() : TDMAccordion
      {
         return this._1830107832accordion;
      }
      
      public function set accordion(param1:TDMAccordion) : void
      {
         var _loc2_:Object = this._1830107832accordion;
         if(_loc2_ !== param1)
         {
            this._1830107832accordion = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"accordion",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get headerPic() : Image
      {
         return this._213307459headerPic;
      }
      
      public function set headerPic(param1:Image) : void
      {
         var _loc2_:Object = this._213307459headerPic;
         if(_loc2_ !== param1)
         {
            this._213307459headerPic = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerPic",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tabBar() : TabBar
      {
         return this._881418178tabBar;
      }
      
      public function set tabBar(param1:TabBar) : void
      {
         var _loc2_:Object = this._881418178tabBar;
         if(_loc2_ !== param1)
         {
            this._881418178tabBar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tabBar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get victoryLabel() : ResultHeaderLabel
      {
         return this._1323802622victoryLabel;
      }
      
      public function set victoryLabel(param1:ResultHeaderLabel) : void
      {
         var _loc2_:Object = this._1323802622victoryLabel;
         if(_loc2_ !== param1)
         {
            this._1323802622victoryLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"victoryLabel",_loc2_,param1));
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
      private function get _headerImage() : Bitmap
      {
         return this._541574415_headerImage;
      }
      
      private function set _headerImage(param1:Bitmap) : void
      {
         var _loc2_:Object = this._541574415_headerImage;
         if(_loc2_ !== param1)
         {
            this._541574415_headerImage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_headerImage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _tabs() : VectorCollection
      {
         return this._91286621_tabs;
      }
      
      private function set _tabs(param1:VectorCollection) : void
      {
         var _loc2_:Object = this._91286621_tabs;
         if(_loc2_ !== param1)
         {
            this._91286621_tabs = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_tabs",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _accordionData() : VectorCollection
      {
         return this._1151002861_accordionData;
      }
      
      private function set _accordionData(param1:VectorCollection) : void
      {
         var _loc2_:Object = this._1151002861_accordionData;
         if(_loc2_ !== param1)
         {
            this._1151002861_accordionData = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_accordionData",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _rewards() : TDMRewardsModel
      {
         return this._836092443_rewards;
      }
      
      private function set _rewards(param1:TDMRewardsModel) : void
      {
         var _loc2_:Object = this._836092443_rewards;
         if(_loc2_ !== param1)
         {
            this._836092443_rewards = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_rewards",_loc2_,param1));
            }
         }
      }
   }
}

