package net.bigpoint.darkorbit.mvc.battlestationswindow.view
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
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.installationStatus.components.InstallationStatusView;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInstallation.components.ModuleInstallationView;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.components.ModuleInventoryView;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.ratings.components.RatingsView;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOButtonBaseSkin;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOViewContainerSkin;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   
   use namespace mx_internal;
   
   public class BattleStationBuildWindowView extends BattleStationBuildWindowBase implements IBindingClient
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
      
      private var _1719531403bigTopLevelHoldingGroupObjectThingy:spark.components.Group;
      
      private var _315970861groupDepth1:VGroup;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function BattleStationBuildWindowView()
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
         bindings = this._BattleStationBuildWindowView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_battlestationswindow_view_BattleStationBuildWindowViewWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return BattleStationBuildWindowView[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.styleName = "battleStationBuildWindow";
         this.title = "Battle Station Installation";
         this.width = 250;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._BattleStationBuildWindowView_Array1_c);
         this.addEventListener("creationComplete",this.___BattleStationBuildWindowView_BattleStationBuildWindowBase1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         BattleStationBuildWindowView._watcherSetupUtil = param1;
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
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
      }
      
      private function _BattleStationBuildWindowView_Array1_c() : Array
      {
         return [this._BattleStationBuildWindowView_Group1_i()];
      }
      
      private function _BattleStationBuildWindowView_Group1_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.top = 0;
         _loc1_.left = 13;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._BattleStationBuildWindowView_VGroup1_i()];
         _loc1_.id = "bigTopLevelHoldingGroupObjectThingy";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.bigTopLevelHoldingGroupObjectThingy = _loc1_;
         BindingManager.executeBindings(this,"bigTopLevelHoldingGroupObjectThingy",this.bigTopLevelHoldingGroupObjectThingy);
         return _loc1_;
      }
      
      private function _BattleStationBuildWindowView_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.gap = 10;
         _loc1_.mxmlContent = [this._BattleStationBuildWindowView_ModuleInventoryView1_i(),this._BattleStationBuildWindowView_ModuleInstallationView1_i(),this._BattleStationBuildWindowView_Group2_c()];
         _loc1_.id = "groupDepth1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.groupDepth1 = _loc1_;
         BindingManager.executeBindings(this,"groupDepth1",this.groupDepth1);
         return _loc1_;
      }
      
      private function _BattleStationBuildWindowView_ModuleInventoryView1_i() : ModuleInventoryView
      {
         var _loc1_:ModuleInventoryView = new ModuleInventoryView();
         _loc1_.percentWidth = 100;
         _loc1_.id = "moduleInventoryView";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         moduleInventoryView = _loc1_;
         BindingManager.executeBindings(this,"moduleInventoryView",moduleInventoryView);
         return _loc1_;
      }
      
      private function _BattleStationBuildWindowView_ModuleInstallationView1_i() : ModuleInstallationView
      {
         var _loc1_:ModuleInstallationView = new ModuleInstallationView();
         _loc1_.percentWidth = 100;
         _loc1_.id = "moduleInstallationView";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         moduleInstallationView = _loc1_;
         BindingManager.executeBindings(this,"moduleInstallationView",moduleInstallationView);
         return _loc1_;
      }
      
      private function _BattleStationBuildWindowView_Group2_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._BattleStationBuildWindowView_InstallationStatusView1_i(),this._BattleStationBuildWindowView_RatingsView1_i(),this._BattleStationBuildWindowView_VGroup2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _BattleStationBuildWindowView_InstallationStatusView1_i() : InstallationStatusView
      {
         var _loc1_:InstallationStatusView = new InstallationStatusView();
         _loc1_.percentHeight = 100;
         _loc1_.visible = true;
         _loc1_.id = "installationStatusView";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         installationStatusView = _loc1_;
         BindingManager.executeBindings(this,"installationStatusView",installationStatusView);
         return _loc1_;
      }
      
      private function _BattleStationBuildWindowView_RatingsView1_i() : RatingsView
      {
         var _loc1_:RatingsView = new RatingsView();
         _loc1_.percentHeight = 100;
         _loc1_.visible = false;
         _loc1_.id = "ratingsView";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         ratingsView = _loc1_;
         BindingManager.executeBindings(this,"ratingsView",ratingsView);
         return _loc1_;
      }
      
      private function _BattleStationBuildWindowView_VGroup2_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.bottom = 5;
         _loc1_.mxmlContent = [this._BattleStationBuildWindowView_Label1_i(),this._BattleStationBuildWindowView_SkinnableContainer1_c()];
         _loc1_.id = "oreTradeSection";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         oreTradeSection = _loc1_;
         BindingManager.executeBindings(this,"oreTradeSection",oreTradeSection);
         return _loc1_;
      }
      
      private function _BattleStationBuildWindowView_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "Erzhandel";
         _loc1_.setStyle("fontSize",13);
         _loc1_.setStyle("fontFamily","EurostileTHea");
         _loc1_.setStyle("color",16763904);
         _loc1_.setStyle("paddingBottom",-4);
         _loc1_.id = "oreTradeTitle";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         oreTradeTitle = _loc1_;
         BindingManager.executeBindings(this,"oreTradeTitle",oreTradeTitle);
         return _loc1_;
      }
      
      private function _BattleStationBuildWindowView_SkinnableContainer1_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._BattleStationBuildWindowView_Array6_c);
         _loc1_.setStyle("skinClass",DOViewContainerSkin);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _BattleStationBuildWindowView_Array6_c() : Array
      {
         return [this._BattleStationBuildWindowView_VGroup3_c()];
      }
      
      private function _BattleStationBuildWindowView_VGroup3_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.gap = -5;
         _loc1_.top = 3;
         _loc1_.mxmlContent = [this._BattleStationBuildWindowView_DOButtonBase1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _BattleStationBuildWindowView_DOButtonBase1_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.percentWidth = 100;
         _loc1_.enabled = true;
         _loc1_.styleName = "scalableGreenConfirmButton";
         _loc1_.mouseChildren = false;
         _loc1_.buttonMode = true;
         _loc1_.label = "Verkaufe Erze";
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("skinClass",DOButtonBaseSkin);
         _loc1_.addEventListener("click",this.__oreTradeButton_click);
         _loc1_.id = "oreTradeButton";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         oreTradeButton = _loc1_;
         BindingManager.executeBindings(this,"oreTradeButton",oreTradeButton);
         return _loc1_;
      }
      
      public function __oreTradeButton_click(param1:MouseEvent) : void
      {
         requestOreTrade();
      }
      
      public function ___BattleStationBuildWindowView_BattleStationBuildWindowBase1_creationComplete(param1:FlexEvent) : void
      {
         handleComponentReady();
      }
      
      private function _BattleStationBuildWindowView_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Number
         {
            return _windowHeight;
         },null,"this.height");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get bigTopLevelHoldingGroupObjectThingy() : spark.components.Group
      {
         return this._1719531403bigTopLevelHoldingGroupObjectThingy;
      }
      
      public function set bigTopLevelHoldingGroupObjectThingy(param1:spark.components.Group) : void
      {
         var _loc2_:Object = this._1719531403bigTopLevelHoldingGroupObjectThingy;
         if(_loc2_ !== param1)
         {
            this._1719531403bigTopLevelHoldingGroupObjectThingy = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bigTopLevelHoldingGroupObjectThingy",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get groupDepth1() : VGroup
      {
         return this._315970861groupDepth1;
      }
      
      public function set groupDepth1(param1:VGroup) : void
      {
         var _loc2_:Object = this._315970861groupDepth1;
         if(_loc2_ !== param1)
         {
            this._315970861groupDepth1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"groupDepth1",_loc2_,param1));
            }
         }
      }
   }
}

