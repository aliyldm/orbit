package net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.view
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
   import mx.controls.Text;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.graphics.BitmapScaleMode;
   import mx.graphics.SolidColor;
   import mx.styles.*;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOViewContainerBase;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.common.view.components.resultHeader.view.ResultHeaderLabel;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOOuterViewContainerSkin;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.constants.JackpotResultWindowConstants;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.view.components.JackpotDataGrid;
   import spark.components.Group;
   import spark.components.Image;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   import spark.components.gridClasses.GridSelectionMode;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.VerticalAlign;
   import spark.primitives.Rect;
   
   use namespace mx_internal;
   
   public class JackpotArenaMatchResultWindow extends DOWindow implements IBindingClient
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
      
      public var _JackpotArenaMatchResultWindow_Group2:spark.components.Group;
      
      public var _JackpotArenaMatchResultWindow_Text1:Text;
      
      public var _JackpotArenaMatchResultWindow_VGroup2:VGroup;
      
      private var _410956671container:SkinnableContainer;
      
      private var _213307459headerPic:Image;
      
      private var _1177280081itemList:JackpotDataGrid;
      
      private var _1323802622victoryLabel:ResultHeaderLabel;
      
      private var _1659371121windowContainer:VGroup;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _541574415_headerImage:Bitmap;
      
      private var _90937190_hint:String;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function JackpotArenaMatchResultWindow()
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
         bindings = this._JackpotArenaMatchResultWindow_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_jackpotBattle_resultWin_view_JackpotArenaMatchResultWindowWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return JackpotArenaMatchResultWindow[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 460;
         this.height = 470;
         this.styleName = "jackpotWindow";
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._JackpotArenaMatchResultWindow_Array1_c);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         JackpotArenaMatchResultWindow._watcherSetupUtil = param1;
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
      
      public function set hint(param1:String) : void
      {
         this._hint = param1;
      }
      
      public function set textTexture(param1:DisplayObject) : void
      {
         this.victoryLabel.texture = param1;
      }
      
      public function set gradient(param1:DisplayObject) : void
      {
         this.victoryLabel.gradient = param1;
      }
      
      public function set effectImg(param1:DisplayObject) : void
      {
         this.victoryLabel.effectImg = param1;
      }
      
      public function set backGround(param1:DisplayObject) : void
      {
         this.victoryLabel.backGround = param1;
      }
      
      private function _JackpotArenaMatchResultWindow_Array1_c() : Array
      {
         return [this._JackpotArenaMatchResultWindow_VGroup1_i()];
      }
      
      private function _JackpotArenaMatchResultWindow_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.visible = true;
         _loc1_.paddingBottom = 10;
         _loc1_.mxmlContent = [this._JackpotArenaMatchResultWindow_Group1_c(),this._JackpotArenaMatchResultWindow_SkinnableContainer1_i(),this._JackpotArenaMatchResultWindow_Group3_c()];
         _loc1_.id = "windowContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.windowContainer = _loc1_;
         BindingManager.executeBindings(this,"windowContainer",this.windowContainer);
         return _loc1_;
      }
      
      private function _JackpotArenaMatchResultWindow_Group1_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 99.5;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         _loc1_.mask = this._JackpotArenaMatchResultWindow_Group2_i();
         _loc1_.mxmlContent = [this._JackpotArenaMatchResultWindow_Image1_i(),this._JackpotArenaMatchResultWindow_VGroup2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _JackpotArenaMatchResultWindow_Group2_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.mxmlContent = [this._JackpotArenaMatchResultWindow_Rect1_c()];
         _loc1_.id = "_JackpotArenaMatchResultWindow_Group2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._JackpotArenaMatchResultWindow_Group2 = _loc1_;
         BindingManager.executeBindings(this,"_JackpotArenaMatchResultWindow_Group2",this._JackpotArenaMatchResultWindow_Group2);
         return _loc1_;
      }
      
      private function _JackpotArenaMatchResultWindow_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.fill = this._JackpotArenaMatchResultWindow_SolidColor1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _JackpotArenaMatchResultWindow_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 65280;
         _loc1_.alpha = 1;
         return _loc1_;
      }
      
      private function _JackpotArenaMatchResultWindow_Image1_i() : Image
      {
         var _loc1_:Image = new Image();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 90;
         _loc1_.id = "headerPic";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.headerPic = _loc1_;
         BindingManager.executeBindings(this,"headerPic",this.headerPic);
         return _loc1_;
      }
      
      private function _JackpotArenaMatchResultWindow_VGroup2_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._JackpotArenaMatchResultWindow_ResultHeaderLabel1_i()];
         _loc1_.id = "_JackpotArenaMatchResultWindow_VGroup2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._JackpotArenaMatchResultWindow_VGroup2 = _loc1_;
         BindingManager.executeBindings(this,"_JackpotArenaMatchResultWindow_VGroup2",this._JackpotArenaMatchResultWindow_VGroup2);
         return _loc1_;
      }
      
      private function _JackpotArenaMatchResultWindow_ResultHeaderLabel1_i() : ResultHeaderLabel
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
      
      private function _JackpotArenaMatchResultWindow_SkinnableContainer1_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.bottom = 25;
         _loc1_.top = 25;
         _loc1_.left = 25;
         _loc1_.right = 25;
         _loc1_.height = 235;
         _loc1_.percentWidth = 90;
         _loc1_.styleName = "jackpot";
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._JackpotArenaMatchResultWindow_Array6_c);
         _loc1_.id = "container";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.container = _loc1_;
         BindingManager.executeBindings(this,"container",this.container);
         return _loc1_;
      }
      
      private function _JackpotArenaMatchResultWindow_Array6_c() : Array
      {
         return [this._JackpotArenaMatchResultWindow_JackpotDataGrid1_i()];
      }
      
      private function _JackpotArenaMatchResultWindow_JackpotDataGrid1_i() : JackpotDataGrid
      {
         var _loc1_:JackpotDataGrid = new JackpotDataGrid();
         _loc1_.percentWidth = 100;
         _loc1_.focusEnabled = false;
         _loc1_.editable = false;
         _loc1_.resizableColumns = false;
         _loc1_.sortableColumns = false;
         _loc1_.styleName = "jackpotGrid";
         _loc1_.setStyle("contentBackgroundColor",1317149);
         _loc1_.setStyle("rollOverColor",2106665);
         _loc1_.setStyle("selectionColor",2106665);
         _loc1_.id = "itemList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.itemList = _loc1_;
         BindingManager.executeBindings(this,"itemList",this.itemList);
         return _loc1_;
      }
      
      private function _JackpotArenaMatchResultWindow_Group3_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 90;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         _loc1_.mxmlContent = [this._JackpotArenaMatchResultWindow_DOViewContainerBase1_c(),this._JackpotArenaMatchResultWindow_Text1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _JackpotArenaMatchResultWindow_DOViewContainerBase1_c() : DOViewContainerBase
      {
         var _loc1_:DOViewContainerBase = new DOViewContainerBase();
         _loc1_.styleName = "questWindowOuter";
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.setStyle("skinClass",DOOuterViewContainerSkin);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _JackpotArenaMatchResultWindow_Text1_i() : Text
      {
         var _loc1_:Text = new Text();
         _loc1_.percentWidth = 100;
         _loc1_.setStyle("fontSize",11);
         _loc1_.setStyle("paddingTop",4);
         _loc1_.setStyle("paddingBottom",4);
         _loc1_.setStyle("paddingLeft",6);
         _loc1_.setStyle("paddingRight",6);
         _loc1_.id = "_JackpotArenaMatchResultWindow_Text1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._JackpotArenaMatchResultWindow_Text1 = _loc1_;
         BindingManager.executeBindings(this,"_JackpotArenaMatchResultWindow_Text1",this._JackpotArenaMatchResultWindow_Text1);
         return _loc1_;
      }
      
      private function _JackpotArenaMatchResultWindow_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = HorizontalAlign.CENTER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"windowContainer.horizontalAlign");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = VerticalAlign.TOP;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"windowContainer.verticalAlign");
         result[2] = new Binding(this,function():Number
         {
            return headerPic.width;
         },null,"_JackpotArenaMatchResultWindow_Group2.width");
         result[3] = new Binding(this,function():Number
         {
            return headerPic.height;
         },null,"_JackpotArenaMatchResultWindow_Group2.height");
         result[4] = new Binding(this,function():Object
         {
            return _headerImage;
         },null,"headerPic.source");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = HorizontalAlign.CENTER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"headerPic.horizontalAlign");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = VerticalAlign.MIDDLE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"headerPic.verticalAlign");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = BitmapScaleMode.STRETCH;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"headerPic.scaleMode");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = VerticalAlign.MIDDLE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_JackpotArenaMatchResultWindow_VGroup2.verticalAlign");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = HorizontalAlign.CENTER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_JackpotArenaMatchResultWindow_VGroup2.horizontalAlign");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontHeavyFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"victoryLabel.font");
         result[11] = new Binding(this,function():int
         {
            return JackpotResultWindowConstants.HEADER_FONT_SIZE;
         },null,"victoryLabel.fontSize");
         result[12] = new Binding(this,function():int
         {
            return JackpotResultWindowConstants.HEADER_TRACKING;
         },null,"victoryLabel.trackingLeft");
         result[13] = new Binding(this,function():Object
         {
            return MARGIN_COMPONENT;
         },null,"itemList.left");
         result[14] = new Binding(this,function():Object
         {
            return MARGIN_COMPONENT;
         },null,"itemList.right");
         result[15] = new Binding(this,function():Object
         {
            return MARGIN_COMPONENT;
         },null,"itemList.top");
         result[16] = new Binding(this,function():String
         {
            var _loc1_:* = GridSelectionMode.NONE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"itemList.selectionMode");
         result[17] = new Binding(this,function():String
         {
            var _loc1_:* = _hint;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_JackpotArenaMatchResultWindow_Text1.htmlText");
         result[18] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.baseFont;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _JackpotArenaMatchResultWindow_Text1.setStyle("fontFamily",param1);
         },"_JackpotArenaMatchResultWindow_Text1.fontFamily");
         return result;
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
      public function get itemList() : JackpotDataGrid
      {
         return this._1177280081itemList;
      }
      
      public function set itemList(param1:JackpotDataGrid) : void
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
      private function get _hint() : String
      {
         return this._90937190_hint;
      }
      
      private function set _hint(param1:String) : void
      {
         var _loc2_:Object = this._90937190_hint;
         if(_loc2_ !== param1)
         {
            this._90937190_hint = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_hint",_loc2_,param1));
            }
         }
      }
   }
}

