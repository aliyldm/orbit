package net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInstallation.components
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
   import mx.controls.ProgressBar;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.ModuleItem;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInstallation.skins.DOProgressBarBlackSkin;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInstallation.skins.DOProgressBarBlueSkin;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInstallation.skins.DOProgressBarGreenSkin;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInstallation.skins.DOProgressTrackTransparentSkin;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.VGroup;
   
   use namespace mx_internal;
   
   public class ModuleHolster extends ModuleHolsterBase implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _1081044640installingModuleBar:spark.components.Group;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ModuleHolster()
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
         bindings = this._ModuleHolster_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_battlestationswindow_view_moduleInstallation_components_ModuleHolsterWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return ModuleHolster[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 38;
         this.height = 55;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._ModuleHolster_Array1_c);
         this.addEventListener("creationComplete",this.___ModuleHolster_ModuleHolsterBase1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ModuleHolster._watcherSetupUtil = param1;
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
      
      private function _ModuleHolster_Array1_c() : Array
      {
         return [this._ModuleHolster_HGroup1_i(),this._ModuleHolster_Group1_i(),this._ModuleHolster_VGroup1_i()];
      }
      
      private function _ModuleHolster_HGroup1_i() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.gap = -1;
         _loc1_.top = 6;
         _loc1_.left = 3;
         _loc1_.mxmlContent = [this._ModuleHolster_ModuleItem1_i()];
         _loc1_.id = "modules";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         modules = _loc1_;
         BindingManager.executeBindings(this,"modules",modules);
         return _loc1_;
      }
      
      private function _ModuleHolster_ModuleItem1_i() : ModuleItem
      {
         var _loc1_:ModuleItem = new ModuleItem();
         _loc1_.moduleType = 0;
         _loc1_.id = "moduleItem";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         moduleItem = _loc1_;
         BindingManager.executeBindings(this,"moduleItem",moduleItem);
         return _loc1_;
      }
      
      private function _ModuleHolster_Group1_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.visible = false;
         _loc1_.horizontalCenter = 0;
         _loc1_.bottom = 5;
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._ModuleHolster_ProgressBar1_i()];
         _loc1_.id = "installingModuleBar";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.installingModuleBar = _loc1_;
         BindingManager.executeBindings(this,"installingModuleBar",this.installingModuleBar);
         return _loc1_;
      }
      
      private function _ModuleHolster_ProgressBar1_i() : ProgressBar
      {
         var _loc1_:ProgressBar = new ProgressBar();
         _loc1_.height = 8;
         _loc1_.label = "";
         _loc1_.horizontalCenter = 0;
         _loc1_.mode = "manual";
         _loc1_.percentWidth = 80;
         _loc1_.visible = false;
         _loc1_.setStyle("trackHeight",9);
         _loc1_.setStyle("maskSkin",DOProgressBarBlackSkin);
         _loc1_.setStyle("barSkin",DOProgressBarBlueSkin);
         _loc1_.id = "progressBar";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         progressBar = _loc1_;
         BindingManager.executeBindings(this,"progressBar",progressBar);
         return _loc1_;
      }
      
      private function _ModuleHolster_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.gap = 0;
         _loc1_.visible = false;
         _loc1_.top = 39;
         _loc1_.percentWidth = 100;
         _loc1_.right = 4;
         _loc1_.left = 4;
         _loc1_.mxmlContent = [this._ModuleHolster_ProgressBar2_i(),this._ModuleHolster_ProgressBar3_i()];
         _loc1_.id = "installedModuleBars";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         installedModuleBars = _loc1_;
         BindingManager.executeBindings(this,"installedModuleBars",installedModuleBars);
         return _loc1_;
      }
      
      private function _ModuleHolster_ProgressBar2_i() : ProgressBar
      {
         var _loc1_:ProgressBar = new ProgressBar();
         _loc1_.height = 4;
         _loc1_.percentWidth = 100;
         _loc1_.label = "";
         _loc1_.mode = "manual";
         _loc1_.setStyle("barSkin",DOProgressBarGreenSkin);
         _loc1_.setStyle("trackSkin",DOProgressTrackTransparentSkin);
         _loc1_.id = "healthBar";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         healthBar = _loc1_;
         BindingManager.executeBindings(this,"healthBar",healthBar);
         return _loc1_;
      }
      
      private function _ModuleHolster_ProgressBar3_i() : ProgressBar
      {
         var _loc1_:ProgressBar = new ProgressBar();
         _loc1_.height = 4;
         _loc1_.percentWidth = 100;
         _loc1_.label = "";
         _loc1_.mode = "manual";
         _loc1_.setStyle("barSkin",DOProgressBarBlueSkin);
         _loc1_.setStyle("trackSkin",DOProgressTrackTransparentSkin);
         _loc1_.id = "sheildBar";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         sheildBar = _loc1_;
         BindingManager.executeBindings(this,"sheildBar",sheildBar);
         return _loc1_;
      }
      
      public function ___ModuleHolster_ModuleHolsterBase1_creationComplete(param1:FlexEvent) : void
      {
         handleCreationComplete();
      }
      
      private function _ModuleHolster_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():int
         {
            return _slotId;
         },null,"moduleItem.slotId");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get installingModuleBar() : spark.components.Group
      {
         return this._1081044640installingModuleBar;
      }
      
      public function set installingModuleBar(param1:spark.components.Group) : void
      {
         var _loc2_:Object = this._1081044640installingModuleBar;
         if(_loc2_ !== param1)
         {
            this._1081044640installingModuleBar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"installingModuleBar",_loc2_,param1));
            }
         }
      }
   }
}

