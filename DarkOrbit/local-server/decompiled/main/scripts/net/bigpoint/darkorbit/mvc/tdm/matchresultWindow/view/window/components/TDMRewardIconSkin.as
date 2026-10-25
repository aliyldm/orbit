package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components
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
   import spark.components.Group;
   import spark.components.Image;
   import spark.skins.SparkSkin;
   
   use namespace mx_internal;
   
   public class TDMRewardIconSkin extends SparkSkin implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _496438026_TDMRewardIconSkin_SetProperty1:SetProperty;
      
      private var _496438025_TDMRewardIconSkin_SetProperty2:SetProperty;
      
      private var _100313435image:Image;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _1364613368stdImage:BitmapData;
      
      private var _249714047hoverImage:BitmapData;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function TDMRewardIconSkin()
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
         bindings = this._TDMRewardIconSkin_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_tdm_matchresultWindow_view_window_components_TDMRewardIconSkinWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return TDMRewardIconSkin[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContent = [this._TDMRewardIconSkin_Group1_c()];
         this.currentState = "normal";
         this.addEventListener("creationComplete",this.___TDMRewardIconSkin_SparkSkin1_creationComplete);
         this.addEventListener("mouseOver",this.___TDMRewardIconSkin_SparkSkin1_mouseOver);
         this.addEventListener("mouseOut",this.___TDMRewardIconSkin_SparkSkin1_mouseOut);
         states = [new State({
            "name":"normal",
            "overrides":[this._TDMRewardIconSkin_SetProperty1 = SetProperty(new SetProperty().initializeFromObject({
               "target":"image",
               "name":"source",
               "value":undefined
            }))]
         }),new State({
            "name":"hover",
            "overrides":[this._TDMRewardIconSkin_SetProperty2 = SetProperty(new SetProperty().initializeFromObject({
               "target":"image",
               "name":"source",
               "value":undefined
            }))]
         })];
         BindingManager.executeBindings(this,"_TDMRewardIconSkin_SetProperty1",this._TDMRewardIconSkin_SetProperty1);
         BindingManager.executeBindings(this,"_TDMRewardIconSkin_SetProperty2",this._TDMRewardIconSkin_SetProperty2);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         TDMRewardIconSkin._watcherSetupUtil = param1;
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
      
      private function handleCreationComplete() : void
      {
         var _loc1_:String = getStyle("libID");
         var _loc2_:String = getStyle("hoverKey");
         var _loc3_:String = getStyle("normalKey");
         this.stdImage = ResourceManager.getBitmapData(_loc1_,_loc3_);
         this.hoverImage = ResourceManager.getBitmapData(_loc1_,_loc2_);
      }
      
      private function _TDMRewardIconSkin_Group1_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._TDMRewardIconSkin_Image1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _TDMRewardIconSkin_Image1_i() : Image
      {
         var _loc1_:Image = new Image();
         _loc1_.id = "image";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.image = _loc1_;
         BindingManager.executeBindings(this,"image",this.image);
         return _loc1_;
      }
      
      public function ___TDMRewardIconSkin_SparkSkin1_creationComplete(param1:FlexEvent) : void
      {
         this.handleCreationComplete();
      }
      
      public function ___TDMRewardIconSkin_SparkSkin1_mouseOver(param1:MouseEvent) : void
      {
         currentState = "hover";
      }
      
      public function ___TDMRewardIconSkin_SparkSkin1_mouseOut(param1:MouseEvent) : void
      {
         currentState = "normal";
      }
      
      private function _TDMRewardIconSkin_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():*
         {
            return stdImage;
         },null,"_TDMRewardIconSkin_SetProperty1.value");
         result[1] = new Binding(this,function():*
         {
            return hoverImage;
         },null,"_TDMRewardIconSkin_SetProperty2.value");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMRewardIconSkin_SetProperty1() : SetProperty
      {
         return this._496438026_TDMRewardIconSkin_SetProperty1;
      }
      
      public function set _TDMRewardIconSkin_SetProperty1(param1:SetProperty) : void
      {
         var _loc2_:Object = this._496438026_TDMRewardIconSkin_SetProperty1;
         if(_loc2_ !== param1)
         {
            this._496438026_TDMRewardIconSkin_SetProperty1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMRewardIconSkin_SetProperty1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _TDMRewardIconSkin_SetProperty2() : SetProperty
      {
         return this._496438025_TDMRewardIconSkin_SetProperty2;
      }
      
      public function set _TDMRewardIconSkin_SetProperty2(param1:SetProperty) : void
      {
         var _loc2_:Object = this._496438025_TDMRewardIconSkin_SetProperty2;
         if(_loc2_ !== param1)
         {
            this._496438025_TDMRewardIconSkin_SetProperty2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TDMRewardIconSkin_SetProperty2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get image() : Image
      {
         return this._100313435image;
      }
      
      public function set image(param1:Image) : void
      {
         var _loc2_:Object = this._100313435image;
         if(_loc2_ !== param1)
         {
            this._100313435image = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"image",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get stdImage() : BitmapData
      {
         return this._1364613368stdImage;
      }
      
      private function set stdImage(param1:BitmapData) : void
      {
         var _loc2_:Object = this._1364613368stdImage;
         if(_loc2_ !== param1)
         {
            this._1364613368stdImage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stdImage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get hoverImage() : BitmapData
      {
         return this._249714047hoverImage;
      }
      
      private function set hoverImage(param1:BitmapData) : void
      {
         var _loc2_:Object = this._249714047hoverImage;
         if(_loc2_ !== param1)
         {
            this._249714047hoverImage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hoverImage",_loc2_,param1));
            }
         }
      }
   }
}

