package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.tooltip
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
   import flashx.textLayout.formats.TextAlign;
   import mx.binding.*;
   import mx.core.ClassFactory;
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.graphics.SolidColor;
   import mx.graphics.SolidColorStroke;
   import mx.states.SetProperty;
   import mx.states.State;
   import mx.styles.*;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOSkinnable9ScaleContainerSkin;
   import spark.components.DataGrid;
   import spark.components.Grid;
   import spark.components.GridColumnHeaderGroup;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.Scroller;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   import spark.components.gridClasses.GridLayer;
   import spark.primitives.Line;
   import spark.primitives.Rect;
   import spark.skins.SparkSkin;
   import spark.skins.spark.DefaultGridItemRenderer;
   
   use namespace mx_internal;
   
   public class DOToolTipListSkinTDM extends SparkSkin implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const exclusions:Array = ["scroller","background","columnHeaderGroup"];
      
      private static const contentFill:Array = ["bgFill"];
      
      public var _DOToolTipListSkinTDM_Label1:Label;
      
      public var _DOToolTipListSkinTDM_Label2:Label;
      
      private var _1277490047alternatingRowColorsBackground:ClassFactory;
      
      private var _1332194002background:Rect;
      
      private var _1391998104bgFill:SolidColor;
      
      private var _1383304148border:SkinnableContainer;
      
      private var _502679092caretIndicator:ClassFactory;
      
      private var _1482148164columnHeaderGroup:GridColumnHeaderGroup;
      
      private var _237342767columnSeparator:ClassFactory;
      
      private var _1555036382editorIndicator:ClassFactory;
      
      private var _3181382grid:Grid;
      
      private var _1346001378headerColumnSeparator:ClassFactory;
      
      private var _1027582576headerRenderer:ClassFactory;
      
      private var _1683467992headerSeparator:spark.primitives.Line;
      
      private var _1933789133hoverIndicator:ClassFactory;
      
      private var _402164678scroller:Scroller;
      
      private var _627206627selectionIndicator:ClassFactory;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _1229135111_headerText:String;
      
      private var _1495155691_messageText:String;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _213507019hostComponent:DataGrid;
      
      public function DOToolTipListSkinTDM()
      {
         var watchers:Array;
         var i:uint;
         var bindings:Array = null;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._DOToolTipListSkinTDM_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_tdm_matchresultWindow_view_window_components_tooltip_DOToolTipListSkinTDMWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return DOToolTipListSkinTDM[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.minWidth = 89;
         this.minHeight = 84;
         this.mxmlContent = [this._DOToolTipListSkinTDM_SkinnableContainer1_i(),this._DOToolTipListSkinTDM_VGroup1_c()];
         this.currentState = "normal";
         this._DOToolTipListSkinTDM_ClassFactory1_i();
         this._DOToolTipListSkinTDM_ClassFactory2_i();
         this._DOToolTipListSkinTDM_ClassFactory3_i();
         this._DOToolTipListSkinTDM_ClassFactory8_i();
         this._DOToolTipListSkinTDM_ClassFactory4_i();
         this._DOToolTipListSkinTDM_ClassFactory5_i();
         this._DOToolTipListSkinTDM_ClassFactory6_i();
         this._DOToolTipListSkinTDM_ClassFactory7_i();
         this.addEventListener("preinitialize",this.___DOToolTipListSkinTDM_SparkSkin1_preinitialize);
         states = [new State({
            "name":"normal",
            "overrides":[]
         }),new State({
            "name":"disabled",
            "overrides":[new SetProperty().initializeFromObject({
               "name":"alpha",
               "value":0.5
            })]
         })];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         DOToolTipListSkinTDM._watcherSetupUtil = param1;
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
      
      protected function preInitializeSkin() : void
      {
         var _loc1_:String = this.getStyle("libID");
         var _loc2_:String = this.getStyle("scale9Grid");
         var _loc3_:String = this.getStyle("skinID");
         this.border.setStyle("libID",_loc1_);
         this.border.setStyle("skinID",_loc3_);
         this.border.setStyle("scale9Grid",_loc2_);
         this.border.setStyle("skinClass",DOSkinnable9ScaleContainerSkin);
      }
      
      public function set headerText(param1:String) : void
      {
         this._headerText = param1;
      }
      
      public function set messageText(param1:String) : void
      {
         this._messageText = param1;
      }
      
      override public function get colorizeExclusions() : Array
      {
         return exclusions;
      }
      
      override public function get contentItems() : Array
      {
         return contentFill;
      }
      
      override protected function initializationComplete() : void
      {
         useChromeColor = true;
         super.initializationComplete();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         if(getStyle("borderVisible") == true)
         {
            this.border.visible = true;
            this.scroller.minViewportInset = 1;
         }
         else
         {
            this.border.visible = false;
            this.scroller.minViewportInset = 0;
         }
         super.updateDisplayList(param1,param2);
      }
      
      private function _DOToolTipListSkinTDM_ClassFactory1_i() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = DOToolTipListSkinTDMInnerClass0;
         _loc1_.properties = {"outerDocument":this};
         this.alternatingRowColorsBackground = _loc1_;
         BindingManager.executeBindings(this,"alternatingRowColorsBackground",this.alternatingRowColorsBackground);
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_ClassFactory2_i() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = DOToolTipListSkinTDMInnerClass1;
         _loc1_.properties = {"outerDocument":this};
         this.caretIndicator = _loc1_;
         BindingManager.executeBindings(this,"caretIndicator",this.caretIndicator);
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_ClassFactory3_i() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = DOToolTipListSkinTDMInnerClass2;
         _loc1_.properties = {"outerDocument":this};
         this.columnSeparator = _loc1_;
         BindingManager.executeBindings(this,"columnSeparator",this.columnSeparator);
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_ClassFactory8_i() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = DOToolTipListSkinTDMInnerClass7;
         _loc1_.properties = {"outerDocument":this};
         this.editorIndicator = _loc1_;
         BindingManager.executeBindings(this,"editorIndicator",this.editorIndicator);
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_ClassFactory4_i() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = DOToolTipListSkinTDMInnerClass3;
         _loc1_.properties = {"outerDocument":this};
         this.headerColumnSeparator = _loc1_;
         BindingManager.executeBindings(this,"headerColumnSeparator",this.headerColumnSeparator);
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_ClassFactory5_i() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = DOToolTipListSkinTDMInnerClass4;
         _loc1_.properties = {"outerDocument":this};
         this.headerRenderer = _loc1_;
         BindingManager.executeBindings(this,"headerRenderer",this.headerRenderer);
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_ClassFactory6_i() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = DOToolTipListSkinTDMInnerClass5;
         _loc1_.properties = {"outerDocument":this};
         this.hoverIndicator = _loc1_;
         BindingManager.executeBindings(this,"hoverIndicator",this.hoverIndicator);
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_ClassFactory7_i() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = DOToolTipListSkinTDMInnerClass6;
         _loc1_.properties = {"outerDocument":this};
         this.selectionIndicator = _loc1_;
         BindingManager.executeBindings(this,"selectionIndicator",this.selectionIndicator);
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_SkinnableContainer1_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.bottom = 0;
         _loc1_.top = 0;
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.percentWidth = 100;
         _loc1_.height = 36;
         _loc1_.mouseChildren = false;
         _loc1_.mouseEnabled = false;
         _loc1_.id = "border";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.border = _loc1_;
         BindingManager.executeBindings(this,"border",this.border);
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.horizontalAlign = "justify";
         _loc1_.gap = 1;
         _loc1_.left = 2;
         _loc1_.right = 2;
         _loc1_.top = 5;
         _loc1_.bottom = 5;
         _loc1_.mxmlContent = [this._DOToolTipListSkinTDM_Label1_i(),this._DOToolTipListSkinTDM_Label2_i(),this._DOToolTipListSkinTDM_GridColumnHeaderGroup1_i(),this._DOToolTipListSkinTDM_Group1_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.maxWidth = 250;
         _loc1_.maxDisplayedLines = 3;
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("color",16763904);
         _loc1_.id = "_DOToolTipListSkinTDM_Label1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._DOToolTipListSkinTDM_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_DOToolTipListSkinTDM_Label1",this._DOToolTipListSkinTDM_Label1);
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.maxWidth = 250;
         _loc1_.maxDisplayedLines = 3;
         _loc1_.setStyle("fontSize",12);
         _loc1_.setStyle("color",10066329);
         _loc1_.id = "_DOToolTipListSkinTDM_Label2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._DOToolTipListSkinTDM_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_DOToolTipListSkinTDM_Label2",this._DOToolTipListSkinTDM_Label2);
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_GridColumnHeaderGroup1_i() : GridColumnHeaderGroup
      {
         var _loc1_:GridColumnHeaderGroup = new GridColumnHeaderGroup();
         _loc1_.minHeight = 21;
         _loc1_.setStyle("paddingLeft",1);
         _loc1_.setStyle("paddingTop",1);
         _loc1_.setStyle("paddingRight",1);
         _loc1_.id = "columnHeaderGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.columnHeaderGroup = _loc1_;
         BindingManager.executeBindings(this,"columnHeaderGroup",this.columnHeaderGroup);
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_Group1_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._DOToolTipListSkinTDM_Rect1_i(),this._DOToolTipListSkinTDM_VGroup2_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_Rect1_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.right = 1;
         _loc1_.top = 1;
         _loc1_.bottom = 1;
         _loc1_.alpha = 0;
         _loc1_.fill = this._DOToolTipListSkinTDM_SolidColor1_i();
         _loc1_.initialized(this,"background");
         this.background = _loc1_;
         BindingManager.executeBindings(this,"background",this.background);
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         this.bgFill = _loc1_;
         BindingManager.executeBindings(this,"bgFill",this.bgFill);
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_VGroup2_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.horizontalAlign = "justify";
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.gap = -1;
         _loc1_.mxmlContent = [this._DOToolTipListSkinTDM_Line1_i(),this._DOToolTipListSkinTDM_Scroller1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_Line1_i() : spark.primitives.Line
      {
         var _loc1_:spark.primitives.Line = new spark.primitives.Line();
         _loc1_.stroke = this._DOToolTipListSkinTDM_SolidColorStroke1_c();
         _loc1_.initialized(this,"headerSeparator");
         this.headerSeparator = _loc1_;
         BindingManager.executeBindings(this,"headerSeparator",this.headerSeparator);
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_SolidColorStroke1_c() : SolidColorStroke
      {
         var _loc1_:SolidColorStroke = new SolidColorStroke();
         _loc1_.color = 936542;
         _loc1_.weight = 1;
         _loc1_.caps = "square";
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_Scroller1_i() : Scroller
      {
         var _loc1_:Scroller = new Scroller();
         _loc1_.minViewportInset = 1;
         _loc1_.hasFocusableChildren = false;
         _loc1_.percentHeight = 100;
         _loc1_.styleName = "skinnedScroller";
         _loc1_.viewport = this._DOToolTipListSkinTDM_Grid1_i();
         _loc1_.setStyle("horizontalScrollPolicy","off");
         _loc1_.id = "scroller";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.scroller = _loc1_;
         BindingManager.executeBindings(this,"scroller",this.scroller);
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_Grid1_i() : Grid
      {
         var _loc1_:Grid = new Grid();
         _loc1_.itemRenderer = this._DOToolTipListSkinTDM_ClassFactory9_c();
         _loc1_.mxmlContent = [this._DOToolTipListSkinTDM_GridLayer1_c(),this._DOToolTipListSkinTDM_GridLayer2_c(),this._DOToolTipListSkinTDM_GridLayer3_c(),this._DOToolTipListSkinTDM_GridLayer4_c(),this._DOToolTipListSkinTDM_GridLayer5_c()];
         _loc1_.id = "grid";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.grid = _loc1_;
         BindingManager.executeBindings(this,"grid",this.grid);
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_ClassFactory9_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = DefaultGridItemRenderer;
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_GridLayer1_c() : GridLayer
      {
         var _loc1_:GridLayer = new GridLayer();
         _loc1_.name = "backgroundLayer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_GridLayer2_c() : GridLayer
      {
         var _loc1_:GridLayer = new GridLayer();
         _loc1_.name = "selectionLayer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_GridLayer3_c() : GridLayer
      {
         var _loc1_:GridLayer = new GridLayer();
         _loc1_.name = "editorIndicatorLayer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_GridLayer4_c() : GridLayer
      {
         var _loc1_:GridLayer = new GridLayer();
         _loc1_.name = "rendererLayer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DOToolTipListSkinTDM_GridLayer5_c() : GridLayer
      {
         var _loc1_:GridLayer = new GridLayer();
         _loc1_.name = "overlayLayer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function ___DOToolTipListSkinTDM_SparkSkin1_preinitialize(param1:FlexEvent) : void
      {
         this.preInitializeSkin();
      }
      
      private function _DOToolTipListSkinTDM_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = _headerText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_DOToolTipListSkinTDM_Label1.text");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = TextAlign.CENTER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _DOToolTipListSkinTDM_Label1.setStyle("textAlign",param1);
         },"_DOToolTipListSkinTDM_Label1.textAlign");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontRegularFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _DOToolTipListSkinTDM_Label1.setStyle("fontFamily",param1);
         },"_DOToolTipListSkinTDM_Label1.fontFamily");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = _messageText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_DOToolTipListSkinTDM_Label2.text");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = TextAlign.LEFT;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _DOToolTipListSkinTDM_Label2.setStyle("textAlign",param1);
         },"_DOToolTipListSkinTDM_Label2.textAlign");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontRegularFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _DOToolTipListSkinTDM_Label2.setStyle("fontFamily",param1);
         },"_DOToolTipListSkinTDM_Label2.fontFamily");
         result[6] = new Binding(this,null,null,"columnHeaderGroup.columnSeparator","headerColumnSeparator");
         result[7] = new Binding(this,null,null,"columnHeaderGroup.headerRenderer","headerRenderer");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get alternatingRowColorsBackground() : ClassFactory
      {
         return this._1277490047alternatingRowColorsBackground;
      }
      
      public function set alternatingRowColorsBackground(param1:ClassFactory) : void
      {
         var _loc2_:Object = this._1277490047alternatingRowColorsBackground;
         if(_loc2_ !== param1)
         {
            this._1277490047alternatingRowColorsBackground = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"alternatingRowColorsBackground",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get background() : Rect
      {
         return this._1332194002background;
      }
      
      public function set background(param1:Rect) : void
      {
         var _loc2_:Object = this._1332194002background;
         if(_loc2_ !== param1)
         {
            this._1332194002background = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"background",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bgFill() : SolidColor
      {
         return this._1391998104bgFill;
      }
      
      public function set bgFill(param1:SolidColor) : void
      {
         var _loc2_:Object = this._1391998104bgFill;
         if(_loc2_ !== param1)
         {
            this._1391998104bgFill = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bgFill",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get border() : SkinnableContainer
      {
         return this._1383304148border;
      }
      
      public function set border(param1:SkinnableContainer) : void
      {
         var _loc2_:Object = this._1383304148border;
         if(_loc2_ !== param1)
         {
            this._1383304148border = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"border",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get caretIndicator() : ClassFactory
      {
         return this._502679092caretIndicator;
      }
      
      public function set caretIndicator(param1:ClassFactory) : void
      {
         var _loc2_:Object = this._502679092caretIndicator;
         if(_loc2_ !== param1)
         {
            this._502679092caretIndicator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"caretIndicator",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get columnHeaderGroup() : GridColumnHeaderGroup
      {
         return this._1482148164columnHeaderGroup;
      }
      
      public function set columnHeaderGroup(param1:GridColumnHeaderGroup) : void
      {
         var _loc2_:Object = this._1482148164columnHeaderGroup;
         if(_loc2_ !== param1)
         {
            this._1482148164columnHeaderGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnHeaderGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get columnSeparator() : ClassFactory
      {
         return this._237342767columnSeparator;
      }
      
      public function set columnSeparator(param1:ClassFactory) : void
      {
         var _loc2_:Object = this._237342767columnSeparator;
         if(_loc2_ !== param1)
         {
            this._237342767columnSeparator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnSeparator",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get editorIndicator() : ClassFactory
      {
         return this._1555036382editorIndicator;
      }
      
      public function set editorIndicator(param1:ClassFactory) : void
      {
         var _loc2_:Object = this._1555036382editorIndicator;
         if(_loc2_ !== param1)
         {
            this._1555036382editorIndicator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"editorIndicator",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get grid() : Grid
      {
         return this._3181382grid;
      }
      
      public function set grid(param1:Grid) : void
      {
         var _loc2_:Object = this._3181382grid;
         if(_loc2_ !== param1)
         {
            this._3181382grid = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"grid",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get headerColumnSeparator() : ClassFactory
      {
         return this._1346001378headerColumnSeparator;
      }
      
      public function set headerColumnSeparator(param1:ClassFactory) : void
      {
         var _loc2_:Object = this._1346001378headerColumnSeparator;
         if(_loc2_ !== param1)
         {
            this._1346001378headerColumnSeparator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerColumnSeparator",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get headerRenderer() : ClassFactory
      {
         return this._1027582576headerRenderer;
      }
      
      public function set headerRenderer(param1:ClassFactory) : void
      {
         var _loc2_:Object = this._1027582576headerRenderer;
         if(_loc2_ !== param1)
         {
            this._1027582576headerRenderer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerRenderer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get headerSeparator() : spark.primitives.Line
      {
         return this._1683467992headerSeparator;
      }
      
      public function set headerSeparator(param1:spark.primitives.Line) : void
      {
         var _loc2_:Object = this._1683467992headerSeparator;
         if(_loc2_ !== param1)
         {
            this._1683467992headerSeparator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerSeparator",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hoverIndicator() : ClassFactory
      {
         return this._1933789133hoverIndicator;
      }
      
      public function set hoverIndicator(param1:ClassFactory) : void
      {
         var _loc2_:Object = this._1933789133hoverIndicator;
         if(_loc2_ !== param1)
         {
            this._1933789133hoverIndicator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hoverIndicator",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get scroller() : Scroller
      {
         return this._402164678scroller;
      }
      
      public function set scroller(param1:Scroller) : void
      {
         var _loc2_:Object = this._402164678scroller;
         if(_loc2_ !== param1)
         {
            this._402164678scroller = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"scroller",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectionIndicator() : ClassFactory
      {
         return this._627206627selectionIndicator;
      }
      
      public function set selectionIndicator(param1:ClassFactory) : void
      {
         var _loc2_:Object = this._627206627selectionIndicator;
         if(_loc2_ !== param1)
         {
            this._627206627selectionIndicator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectionIndicator",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _headerText() : String
      {
         return this._1229135111_headerText;
      }
      
      private function set _headerText(param1:String) : void
      {
         var _loc2_:Object = this._1229135111_headerText;
         if(_loc2_ !== param1)
         {
            this._1229135111_headerText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_headerText",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _messageText() : String
      {
         return this._1495155691_messageText;
      }
      
      private function set _messageText(param1:String) : void
      {
         var _loc2_:Object = this._1495155691_messageText;
         if(_loc2_ !== param1)
         {
            this._1495155691_messageText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_messageText",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hostComponent() : DataGrid
      {
         return this._213507019hostComponent;
      }
      
      public function set hostComponent(param1:DataGrid) : void
      {
         var _loc2_:Object = this._213507019hostComponent;
         if(_loc2_ !== param1)
         {
            this._213507019hostComponent = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hostComponent",_loc2_,param1));
            }
         }
      }
   }
}

