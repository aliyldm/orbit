package net.bigpoint.darkorbit.mvc.battlestationswindow.view.installationStatus.skins
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
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.graphics.BitmapFill;
   import mx.styles.*;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import spark.primitives.Rect;
   import spark.skins.SparkSkin;
   
   use namespace mx_internal;
   
   public class DOProgressBarSkin extends SparkSkin implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _DOProgressBarSkin_BitmapFill1:BitmapFill;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _93466102_trackBgBitmapData:BitmapData;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function DOProgressBarSkin()
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
         bindings = this._DOProgressBarSkin_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_battlestationswindow_view_installationStatus_skins_DOProgressBarSkinWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return DOProgressBarSkin[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.name = "CustomProgressBarTrackSkin";
         this.height = 3;
         this.mxmlContent = [this._DOProgressBarSkin_Rect1_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         DOProgressBarSkin._watcherSetupUtil = param1;
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
         super.initializationComplete();
         this._trackBgBitmapData = ResourceManager.getBitmapData("battleStationsUI","progress_bar_bg");
      }
      
      private function _DOProgressBarSkin_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 4;
         _loc1_.right = 4;
         _loc1_.top = 2;
         _loc1_.bottom = 1;
         _loc1_.height = 3;
         _loc1_.fill = this._DOProgressBarSkin_BitmapFill1_i();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _DOProgressBarSkin_BitmapFill1_i() : BitmapFill
      {
         var _loc1_:BitmapFill = new BitmapFill();
         this._DOProgressBarSkin_BitmapFill1 = _loc1_;
         BindingManager.executeBindings(this,"_DOProgressBarSkin_BitmapFill1",this._DOProgressBarSkin_BitmapFill1);
         return _loc1_;
      }
      
      private function _DOProgressBarSkin_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return _trackBgBitmapData;
         },null,"_DOProgressBarSkin_BitmapFill1.source");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      private function get _trackBgBitmapData() : BitmapData
      {
         return this._93466102_trackBgBitmapData;
      }
      
      private function set _trackBgBitmapData(param1:BitmapData) : void
      {
         var _loc2_:Object = this._93466102_trackBgBitmapData;
         if(_loc2_ !== param1)
         {
            this._93466102_trackBgBitmapData = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_trackBgBitmapData",_loc2_,param1));
            }
         }
      }
   }
}

