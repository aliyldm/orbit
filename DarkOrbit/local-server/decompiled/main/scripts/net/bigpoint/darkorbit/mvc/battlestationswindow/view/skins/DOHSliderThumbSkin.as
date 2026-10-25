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
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.states.SetProperty;
   import mx.states.State;
   import mx.styles.*;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import spark.components.Button;
   import spark.components.Group;
   import spark.primitives.BitmapImage;
   import spark.skins.SparkSkin;
   
   use namespace mx_internal;
   
   public class DOHSliderThumbSkin extends SparkSkin implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _1219450256_DOHSliderThumbSkin_BitmapImage1:BitmapImage;
      
      private var _234567909_DOHSliderThumbSkin_SetProperty1:SetProperty;
      
      private var _234567910_DOHSliderThumbSkin_SetProperty2:SetProperty;
      
      private var _234567911_DOHSliderThumbSkin_SetProperty3:SetProperty;
      
      private var _234567912_DOHSliderThumbSkin_SetProperty4:SetProperty;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _1007567046_normalStateBitmap:Bitmap;
      
      private var _503895376_rollOverStateBitmap:Bitmap;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _213507019hostComponent:Button;
      
      public function DOHSliderThumbSkin()
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
         bindings = this._DOHSliderThumbSkin_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_battlestationswindow_view_skins_DOHSliderThumbSkinWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return DOHSliderThumbSkin[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContent = [this._DOHSliderThumbSkin_Group1_c()];
         this.currentState = "up";
         this.addEventListener("creationComplete",this.___DOHSliderThumbSkin_SparkSkin1_creationComplete);
         states = [new State({
            "name":"up",
            "overrides":[this._DOHSliderThumbSkin_SetProperty1 = SetProperty(new SetProperty().initializeFromObject({
               "target":"_DOHSliderThumbSkin_BitmapImage1",
               "name":"source",
               "value":undefined
            }))]
         }),new State({
            "name":"over",
            "overrides":[this._DOHSliderThumbSkin_SetProperty2 = SetProperty(new SetProperty().initializeFromObject({
               "target":"_DOHSliderThumbSkin_BitmapImage1",
               "name":"source",
               "value":undefined
            }))]
         }),new State({
            "name":"down",
            "overrides":[this._DOHSliderThumbSkin_SetProperty3 = SetProperty(new SetProperty().initializeFromObject({
               "target":"_DOHSliderThumbSkin_BitmapImage1",
               "name":"source",
               "value":undefined
            }))]
         }),new State({
            "name":"disabled",
            "overrides":[this._DOHSliderThumbSkin_SetProperty4 = SetProperty(new SetProperty().initializeFromObject({
               "target":"_DOHSliderThumbSkin_BitmapImage1",
               "name":"source",
               "value":undefined
            }))]
         })];
         BindingManager.executeBindings(this,"_DOHSliderThumbSkin_SetProperty1",this._DOHSliderThumbSkin_SetProperty1);
         BindingManager.executeBindings(this,"_DOHSliderThumbSkin_SetProperty2",this._DOHSliderThumbSkin_SetProperty2);
         BindingManager.executeBindings(this,"_DOHSliderThumbSkin_SetProperty3",this._DOHSliderThumbSkin_SetProperty3);
         BindingManager.executeBindings(this,"_DOHSliderThumbSkin_SetProperty4",this._DOHSliderThumbSkin_SetProperty4);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         DOHSliderThumbSkin._watcherSetupUtil = param1;
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
      
      private function creationCompleteHandler(param1:FlexEvent) : void
      {
         this._normalStateBitmap = ResourceManager.getBitmap("battleStationsUI","slider_handle_normal");
         this._rollOverStateBitmap = ResourceManager.getBitmap("battleStationsUI","slider_handle_hover");
      }
      
      override protected function initializationComplete() : void
      {
         useChromeColor = true;
         super.initializationComplete();
      }
      
      private function _DOHSliderThumbSkin_Group1_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.mxmlContent = [this._DOHSliderThumbSkin_BitmapImage1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DOHSliderThumbSkin_BitmapImage1_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.initialized(this,"_DOHSliderThumbSkin_BitmapImage1");
         this._DOHSliderThumbSkin_BitmapImage1 = _loc1_;
         BindingManager.executeBindings(this,"_DOHSliderThumbSkin_BitmapImage1",this._DOHSliderThumbSkin_BitmapImage1);
         return _loc1_;
      }
      
      public function ___DOHSliderThumbSkin_SparkSkin1_creationComplete(param1:FlexEvent) : void
      {
         this.creationCompleteHandler(param1);
      }
      
      private function _DOHSliderThumbSkin_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():*
         {
            return _normalStateBitmap;
         },null,"_DOHSliderThumbSkin_SetProperty1.value");
         result[1] = new Binding(this,function():*
         {
            return _rollOverStateBitmap;
         },null,"_DOHSliderThumbSkin_SetProperty2.value");
         result[2] = new Binding(this,function():*
         {
            return _normalStateBitmap;
         },null,"_DOHSliderThumbSkin_SetProperty3.value");
         result[3] = new Binding(this,function():*
         {
            return _normalStateBitmap;
         },null,"_DOHSliderThumbSkin_SetProperty4.value");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get _DOHSliderThumbSkin_BitmapImage1() : BitmapImage
      {
         return this._1219450256_DOHSliderThumbSkin_BitmapImage1;
      }
      
      public function set _DOHSliderThumbSkin_BitmapImage1(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._1219450256_DOHSliderThumbSkin_BitmapImage1;
         if(_loc2_ !== param1)
         {
            this._1219450256_DOHSliderThumbSkin_BitmapImage1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_DOHSliderThumbSkin_BitmapImage1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _DOHSliderThumbSkin_SetProperty1() : SetProperty
      {
         return this._234567909_DOHSliderThumbSkin_SetProperty1;
      }
      
      public function set _DOHSliderThumbSkin_SetProperty1(param1:SetProperty) : void
      {
         var _loc2_:Object = this._234567909_DOHSliderThumbSkin_SetProperty1;
         if(_loc2_ !== param1)
         {
            this._234567909_DOHSliderThumbSkin_SetProperty1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_DOHSliderThumbSkin_SetProperty1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _DOHSliderThumbSkin_SetProperty2() : SetProperty
      {
         return this._234567910_DOHSliderThumbSkin_SetProperty2;
      }
      
      public function set _DOHSliderThumbSkin_SetProperty2(param1:SetProperty) : void
      {
         var _loc2_:Object = this._234567910_DOHSliderThumbSkin_SetProperty2;
         if(_loc2_ !== param1)
         {
            this._234567910_DOHSliderThumbSkin_SetProperty2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_DOHSliderThumbSkin_SetProperty2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _DOHSliderThumbSkin_SetProperty3() : SetProperty
      {
         return this._234567911_DOHSliderThumbSkin_SetProperty3;
      }
      
      public function set _DOHSliderThumbSkin_SetProperty3(param1:SetProperty) : void
      {
         var _loc2_:Object = this._234567911_DOHSliderThumbSkin_SetProperty3;
         if(_loc2_ !== param1)
         {
            this._234567911_DOHSliderThumbSkin_SetProperty3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_DOHSliderThumbSkin_SetProperty3",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _DOHSliderThumbSkin_SetProperty4() : SetProperty
      {
         return this._234567912_DOHSliderThumbSkin_SetProperty4;
      }
      
      public function set _DOHSliderThumbSkin_SetProperty4(param1:SetProperty) : void
      {
         var _loc2_:Object = this._234567912_DOHSliderThumbSkin_SetProperty4;
         if(_loc2_ !== param1)
         {
            this._234567912_DOHSliderThumbSkin_SetProperty4 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_DOHSliderThumbSkin_SetProperty4",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _normalStateBitmap() : Bitmap
      {
         return this._1007567046_normalStateBitmap;
      }
      
      private function set _normalStateBitmap(param1:Bitmap) : void
      {
         var _loc2_:Object = this._1007567046_normalStateBitmap;
         if(_loc2_ !== param1)
         {
            this._1007567046_normalStateBitmap = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_normalStateBitmap",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _rollOverStateBitmap() : Bitmap
      {
         return this._503895376_rollOverStateBitmap;
      }
      
      private function set _rollOverStateBitmap(param1:Bitmap) : void
      {
         var _loc2_:Object = this._503895376_rollOverStateBitmap;
         if(_loc2_ !== param1)
         {
            this._503895376_rollOverStateBitmap = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_rollOverStateBitmap",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hostComponent() : Button
      {
         return this._213507019hostComponent;
      }
      
      public function set hostComponent(param1:Button) : void
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

