package net.bigpoint.darkorbit.mvc.battlestationswindow.view.skins
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
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.states.SetProperty;
   import mx.states.State;
   import mx.styles.*;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOButtonBaseSkin;
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.HSlider;
   import spark.components.Label;
   import spark.components.VGroup;
   import spark.skins.SparkSkin;
   
   use namespace mx_internal;
   
   public class DOHSliderSkin extends SparkSkin implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const exclusions:Array = ["track","thumb"];
      
      public static const LEFT_ARROW_CLICKED:String = "leftArrowClicked";
      
      public static const RIGHT_ARROW_CLICKED:String = "rightArrowClicked";
      
      public var _DOHSliderSkin_DOButtonBase1:DOButtonBase;
      
      public var _DOHSliderSkin_DOButtonBase2:DOButtonBase;
      
      private var _1443184785dataTip:ClassFactory;
      
      private var _1081147619maxVal:Label;
      
      private var _1074057361minVal:Label;
      
      private var _110342614thumb:Button;
      
      private var _110621003track:Button;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _738804922_dataTipBgBitmap:Bitmap;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _213507019hostComponent:HSlider;
      
      public function DOHSliderSkin()
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
         bindings = this._DOHSliderSkin_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_battlestationswindow_view_skins_DOHSliderSkinWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return DOHSliderSkin[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.name = "DOHSliderSkin";
         this.minHeight = 11;
         this.mxmlContent = [this._DOHSliderSkin_HGroup1_c()];
         this.currentState = "normal";
         this._DOHSliderSkin_ClassFactory1_i();
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
         DOHSliderSkin._watcherSetupUtil = param1;
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
      
      override public function get colorizeExclusions() : Array
      {
         return exclusions;
      }
      
      override protected function initializationComplete() : void
      {
         useChromeColor = true;
         super.initializationComplete();
      }
      
      private function leftArrowClickHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(LEFT_ARROW_CLICKED,true));
      }
      
      private function rightArrowClickHandler(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(RIGHT_ARROW_CLICKED,true));
      }
      
      override protected function measure() : void
      {
         var _loc1_:Number = this.thumb.getLayoutBoundsX();
         this.thumb.setLayoutBoundsPosition(0,this.thumb.getLayoutBoundsY());
         super.measure();
         this.thumb.setLayoutBoundsPosition(_loc1_,this.thumb.getLayoutBoundsY());
      }
      
      private function _DOHSliderSkin_ClassFactory1_i() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = DOHSliderSkinInnerClass0;
         _loc1_.properties = {"outerDocument":this};
         this.dataTip = _loc1_;
         BindingManager.executeBindings(this,"dataTip",this.dataTip);
         return _loc1_;
      }
      
      private function _DOHSliderSkin_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.gap = 0;
         _loc1_.mxmlContent = [this._DOHSliderSkin_DOButtonBase1_i(),this._DOHSliderSkin_VGroup1_c(),this._DOHSliderSkin_DOButtonBase2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DOHSliderSkin_DOButtonBase1_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.width = 18;
         _loc1_.height = 15;
         _loc1_.mouseChildren = false;
         _loc1_.buttonMode = true;
         _loc1_.rotation = 180;
         _loc1_.setStyle("skinClass",DOButtonBaseSkin);
         _loc1_.addEventListener("click",this.___DOHSliderSkin_DOButtonBase1_click);
         _loc1_.id = "_DOHSliderSkin_DOButtonBase1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._DOHSliderSkin_DOButtonBase1 = _loc1_;
         BindingManager.executeBindings(this,"_DOHSliderSkin_DOButtonBase1",this._DOHSliderSkin_DOButtonBase1);
         return _loc1_;
      }
      
      public function ___DOHSliderSkin_DOButtonBase1_click(param1:MouseEvent) : void
      {
         this.leftArrowClickHandler(param1);
      }
      
      private function _DOHSliderSkin_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.gap = 0;
         _loc1_.top = -5;
         _loc1_.mxmlContent = [this._DOHSliderSkin_Group1_c(),this._DOHSliderSkin_Group2_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DOHSliderSkin_Group1_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._DOHSliderSkin_Button1_i(),this._DOHSliderSkin_Button2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DOHSliderSkin_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.minWidth = 33;
         _loc1_.width = 173;
         _loc1_.visible = false;
         _loc1_.id = "track";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.track = _loc1_;
         BindingManager.executeBindings(this,"track",this.track);
         return _loc1_;
      }
      
      private function _DOHSliderSkin_Button2_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.width = 31;
         _loc1_.height = 15;
         _loc1_.setStyle("skinClass",DOHSliderThumbSkin);
         _loc1_.id = "thumb";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.thumb = _loc1_;
         BindingManager.executeBindings(this,"thumb",this.thumb);
         return _loc1_;
      }
      
      private function _DOHSliderSkin_Group2_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._DOHSliderSkin_Label1_i(),this._DOHSliderSkin_Label2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DOHSliderSkin_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "";
         _loc1_.left = 0;
         _loc1_.setStyle("textAlign","right");
         _loc1_.setStyle("color",8553844);
         _loc1_.setStyle("fontSize",11);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.id = "minVal";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.minVal = _loc1_;
         BindingManager.executeBindings(this,"minVal",this.minVal);
         return _loc1_;
      }
      
      private function _DOHSliderSkin_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "";
         _loc1_.right = 0;
         _loc1_.setStyle("textAlign","left");
         _loc1_.setStyle("color",8553844);
         _loc1_.setStyle("fontSize",11);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.id = "maxVal";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.maxVal = _loc1_;
         BindingManager.executeBindings(this,"maxVal",this.maxVal);
         return _loc1_;
      }
      
      private function _DOHSliderSkin_DOButtonBase2_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.width = 18;
         _loc1_.height = 15;
         _loc1_.mouseChildren = false;
         _loc1_.buttonMode = true;
         _loc1_.setStyle("skinClass",DOButtonBaseSkin);
         _loc1_.addEventListener("click",this.___DOHSliderSkin_DOButtonBase2_click);
         _loc1_.id = "_DOHSliderSkin_DOButtonBase2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._DOHSliderSkin_DOButtonBase2 = _loc1_;
         BindingManager.executeBindings(this,"_DOHSliderSkin_DOButtonBase2",this._DOHSliderSkin_DOButtonBase2);
         return _loc1_;
      }
      
      public function ___DOHSliderSkin_DOButtonBase2_click(param1:MouseEvent) : void
      {
         this.rightArrowClickHandler(param1);
      }
      
      private function _DOHSliderSkin_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return getStyle("arrowButtonStyleName");
         },null,"_DOHSliderSkin_DOButtonBase1.styleName");
         result[1] = new Binding(this,function():Object
         {
            return getStyle("arrowButtonStyleName");
         },null,"_DOHSliderSkin_DOButtonBase2.styleName");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get dataTip() : ClassFactory
      {
         return this._1443184785dataTip;
      }
      
      public function set dataTip(param1:ClassFactory) : void
      {
         var _loc2_:Object = this._1443184785dataTip;
         if(_loc2_ !== param1)
         {
            this._1443184785dataTip = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dataTip",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get maxVal() : Label
      {
         return this._1081147619maxVal;
      }
      
      public function set maxVal(param1:Label) : void
      {
         var _loc2_:Object = this._1081147619maxVal;
         if(_loc2_ !== param1)
         {
            this._1081147619maxVal = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxVal",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get minVal() : Label
      {
         return this._1074057361minVal;
      }
      
      public function set minVal(param1:Label) : void
      {
         var _loc2_:Object = this._1074057361minVal;
         if(_loc2_ !== param1)
         {
            this._1074057361minVal = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minVal",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get thumb() : Button
      {
         return this._110342614thumb;
      }
      
      public function set thumb(param1:Button) : void
      {
         var _loc2_:Object = this._110342614thumb;
         if(_loc2_ !== param1)
         {
            this._110342614thumb = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"thumb",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get track() : Button
      {
         return this._110621003track;
      }
      
      public function set track(param1:Button) : void
      {
         var _loc2_:Object = this._110621003track;
         if(_loc2_ !== param1)
         {
            this._110621003track = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"track",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _dataTipBgBitmap() : Bitmap
      {
         return this._738804922_dataTipBgBitmap;
      }
      
      public function set _dataTipBgBitmap(param1:Bitmap) : void
      {
         var _loc2_:Object = this._738804922_dataTipBgBitmap;
         if(_loc2_ !== param1)
         {
            this._738804922_dataTipBgBitmap = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_dataTipBgBitmap",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hostComponent() : HSlider
      {
         return this._213507019hostComponent;
      }
      
      public function set hostComponent(param1:HSlider) : void
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

