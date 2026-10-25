package net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.inventoryFilter.skins
{
   import com.greensock.TweenLite;
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
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.graphics.SolidColor;
   import mx.states.State;
   import mx.styles.*;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.inventoryFilter.components.FilterOptionButton;
   import spark.components.Label;
   import spark.primitives.BitmapImage;
   import spark.primitives.Rect;
   import spark.skins.SparkButtonSkin;
   
   use namespace mx_internal;
   
   public class FilterOptionButtonSkin extends SparkButtonSkin implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _FilterOptionButtonSkin_SolidColor1:SolidColor;
      
      public var _FilterOptionButtonSkin_SolidColor2:SolidColor;
      
      public var _FilterOptionButtonSkin_SolidColor3:SolidColor;
      
      public var _FilterOptionButtonSkin_SolidColor4:SolidColor;
      
      public var _FilterOptionButtonSkin_SolidColor5:SolidColor;
      
      private var _1217269816brightBackground:Rect;
      
      private var _1784988996darkBackground:Rect;
      
      private var _1291732406eyeIcon:BitmapImage;
      
      private var _1250159915overStateBackground:Rect;
      
      private var _2086543831selectedBackground:Rect;
      
      private var _1732829925separator:Rect;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function FilterOptionButtonSkin()
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
         bindings = this._FilterOptionButtonSkin_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_battlestationswindow_view_moduleInventory_inventoryFilter_skins_FilterOptionButtonSkinWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return FilterOptionButtonSkin[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.percentWidth = 100;
         this.minHeight = 20;
         this.mxmlContent = [this._FilterOptionButtonSkin_Rect1_i(),this._FilterOptionButtonSkin_Rect2_i(),this._FilterOptionButtonSkin_Rect3_i(),this._FilterOptionButtonSkin_Rect4_i(),this._FilterOptionButtonSkin_Rect5_i(),this._FilterOptionButtonSkin_BitmapImage1_i(),this._FilterOptionButtonSkin_Label1_i()];
         this.currentState = "up";
         states = [new State({
            "name":"up",
            "overrides":[]
         }),new State({
            "name":"down",
            "overrides":[]
         }),new State({
            "name":"over",
            "overrides":[]
         }),new State({
            "name":"disabled",
            "overrides":[]
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
         FilterOptionButtonSkin._watcherSetupUtil = param1;
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
      
      override protected function initializationComplete() : void
      {
         useChromeColor = true;
         super.initializationComplete();
         this.intiBackgounds();
      }
      
      private function intiBackgounds() : void
      {
         this.darkBackground.visible = this.customHostComponent.evenRow;
         this.brightBackground.visible = !this.customHostComponent.evenRow;
         this.updateSelection(this.customHostComponent.selected);
      }
      
      public function updateSelection(param1:Boolean) : void
      {
         TweenLite.to(this.eyeIcon,0.3,{"autoAlpha":int(param1)});
         setStyle("color",param1 ? getStyle("activeFontColor") : getStyle("unactiveFontColor"));
      }
      
      override protected function stateChanged(param1:String, param2:String, param3:Boolean) : void
      {
         super.stateChanged(param1,param2,param3);
         TweenLite.to(this.overStateBackground,0.3,{"autoAlpha":int(param2 == "over")});
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         hostComponent.buttonMode = true;
      }
      
      public function get customHostComponent() : FilterOptionButton
      {
         return hostComponent as FilterOptionButton;
      }
      
      private function _FilterOptionButtonSkin_Rect1_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.right = 1;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.fill = this._FilterOptionButtonSkin_SolidColor1_i();
         _loc1_.initialized(this,"darkBackground");
         this.darkBackground = _loc1_;
         BindingManager.executeBindings(this,"darkBackground",this.darkBackground);
         return _loc1_;
      }
      
      private function _FilterOptionButtonSkin_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         this._FilterOptionButtonSkin_SolidColor1 = _loc1_;
         BindingManager.executeBindings(this,"_FilterOptionButtonSkin_SolidColor1",this._FilterOptionButtonSkin_SolidColor1);
         return _loc1_;
      }
      
      private function _FilterOptionButtonSkin_Rect2_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.right = 1;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.fill = this._FilterOptionButtonSkin_SolidColor2_i();
         _loc1_.initialized(this,"brightBackground");
         this.brightBackground = _loc1_;
         BindingManager.executeBindings(this,"brightBackground",this.brightBackground);
         return _loc1_;
      }
      
      private function _FilterOptionButtonSkin_SolidColor2_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         this._FilterOptionButtonSkin_SolidColor2 = _loc1_;
         BindingManager.executeBindings(this,"_FilterOptionButtonSkin_SolidColor2",this._FilterOptionButtonSkin_SolidColor2);
         return _loc1_;
      }
      
      private function _FilterOptionButtonSkin_Rect3_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.right = 1;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.alpha = 0;
         _loc1_.visible = false;
         _loc1_.fill = this._FilterOptionButtonSkin_SolidColor3_i();
         _loc1_.initialized(this,"overStateBackground");
         this.overStateBackground = _loc1_;
         BindingManager.executeBindings(this,"overStateBackground",this.overStateBackground);
         return _loc1_;
      }
      
      private function _FilterOptionButtonSkin_SolidColor3_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         this._FilterOptionButtonSkin_SolidColor3 = _loc1_;
         BindingManager.executeBindings(this,"_FilterOptionButtonSkin_SolidColor3",this._FilterOptionButtonSkin_SolidColor3);
         return _loc1_;
      }
      
      private function _FilterOptionButtonSkin_Rect4_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.right = 1;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.alpha = 0;
         _loc1_.visible = false;
         _loc1_.fill = this._FilterOptionButtonSkin_SolidColor4_i();
         _loc1_.initialized(this,"selectedBackground");
         this.selectedBackground = _loc1_;
         BindingManager.executeBindings(this,"selectedBackground",this.selectedBackground);
         return _loc1_;
      }
      
      private function _FilterOptionButtonSkin_SolidColor4_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         this._FilterOptionButtonSkin_SolidColor4 = _loc1_;
         BindingManager.executeBindings(this,"_FilterOptionButtonSkin_SolidColor4",this._FilterOptionButtonSkin_SolidColor4);
         return _loc1_;
      }
      
      private function _FilterOptionButtonSkin_Rect5_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.width = 1;
         _loc1_.right = 29;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.fill = this._FilterOptionButtonSkin_SolidColor5_i();
         _loc1_.initialized(this,"separator");
         this.separator = _loc1_;
         BindingManager.executeBindings(this,"separator",this.separator);
         return _loc1_;
      }
      
      private function _FilterOptionButtonSkin_SolidColor5_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         this._FilterOptionButtonSkin_SolidColor5 = _loc1_;
         BindingManager.executeBindings(this,"_FilterOptionButtonSkin_SolidColor5",this._FilterOptionButtonSkin_SolidColor5);
         return _loc1_;
      }
      
      private function _FilterOptionButtonSkin_BitmapImage1_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.verticalAlign = "middle";
         _loc1_.right = 5;
         _loc1_.visible = false;
         _loc1_.alpha = 0;
         _loc1_.initialized(this,"eyeIcon");
         this.eyeIcon = _loc1_;
         BindingManager.executeBindings(this,"eyeIcon",this.eyeIcon);
         return _loc1_;
      }
      
      private function _FilterOptionButtonSkin_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.maxDisplayedLines = 1;
         _loc1_.left = 7;
         _loc1_.verticalCenter = 0;
         _loc1_.setStyle("fontSize",11);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("textAlign","left");
         _loc1_.setStyle("verticalAlign","middle");
         _loc1_.id = "labelDisplay";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         labelDisplay = _loc1_;
         BindingManager.executeBindings(this,"labelDisplay",labelDisplay);
         return _loc1_;
      }
      
      private function _FilterOptionButtonSkin_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():uint
         {
            return getStyle("darkBackgroundColor");
         },null,"_FilterOptionButtonSkin_SolidColor1.color");
         result[1] = new Binding(this,function():uint
         {
            return getStyle("brightBackgroundColor");
         },null,"_FilterOptionButtonSkin_SolidColor2.color");
         result[2] = new Binding(this,function():uint
         {
            return getStyle("overStateBackgroundColor");
         },null,"_FilterOptionButtonSkin_SolidColor3.color");
         result[3] = new Binding(this,function():uint
         {
            return getStyle("overStateBackgroundColor");
         },null,"_FilterOptionButtonSkin_SolidColor4.color");
         result[4] = new Binding(this,function():uint
         {
            return getStyle("separatorColor");
         },null,"_FilterOptionButtonSkin_SolidColor5.color");
         result[5] = new Binding(this,function():Object
         {
            return ResourceManager.getBitmapData("battleStationsUI","eye_orange");
         },null,"eyeIcon.source");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get brightBackground() : Rect
      {
         return this._1217269816brightBackground;
      }
      
      public function set brightBackground(param1:Rect) : void
      {
         var _loc2_:Object = this._1217269816brightBackground;
         if(_loc2_ !== param1)
         {
            this._1217269816brightBackground = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"brightBackground",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get darkBackground() : Rect
      {
         return this._1784988996darkBackground;
      }
      
      public function set darkBackground(param1:Rect) : void
      {
         var _loc2_:Object = this._1784988996darkBackground;
         if(_loc2_ !== param1)
         {
            this._1784988996darkBackground = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"darkBackground",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get eyeIcon() : BitmapImage
      {
         return this._1291732406eyeIcon;
      }
      
      public function set eyeIcon(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._1291732406eyeIcon;
         if(_loc2_ !== param1)
         {
            this._1291732406eyeIcon = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eyeIcon",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get overStateBackground() : Rect
      {
         return this._1250159915overStateBackground;
      }
      
      public function set overStateBackground(param1:Rect) : void
      {
         var _loc2_:Object = this._1250159915overStateBackground;
         if(_loc2_ !== param1)
         {
            this._1250159915overStateBackground = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"overStateBackground",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedBackground() : Rect
      {
         return this._2086543831selectedBackground;
      }
      
      public function set selectedBackground(param1:Rect) : void
      {
         var _loc2_:Object = this._2086543831selectedBackground;
         if(_loc2_ !== param1)
         {
            this._2086543831selectedBackground = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedBackground",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get separator() : Rect
      {
         return this._1732829925separator;
      }
      
      public function set separator(param1:Rect) : void
      {
         var _loc2_:Object = this._1732829925separator;
         if(_loc2_ !== param1)
         {
            this._1732829925separator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"separator",_loc2_,param1));
            }
         }
      }
   }
}

