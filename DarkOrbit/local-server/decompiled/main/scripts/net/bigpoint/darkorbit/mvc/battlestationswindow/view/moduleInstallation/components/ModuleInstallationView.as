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
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.DragEvent;
   import mx.events.FlexEvent;
   import mx.filters.*;
   import mx.styles.*;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   
   use namespace mx_internal;
   
   public class ModuleInstallationView extends ModuleInstallationViewBase implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ModuleInstallationView()
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
         bindings = this._ModuleInstallationView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_battlestationswindow_view_moduleInstallation_components_ModuleInstallationViewWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return ModuleInstallationView[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._ModuleInstallationView_Array1_c);
         this.addEventListener("creationComplete",this.___ModuleInstallationView_ModuleInstallationViewBase1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ModuleInstallationView._watcherSetupUtil = param1;
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
      
      private function _ModuleInstallationView_Array1_c() : Array
      {
         return [this._ModuleInstallationView_SkinnableContainer1_c(),this._ModuleInstallationView_VGroup1_c()];
      }
      
      private function _ModuleInstallationView_SkinnableContainer1_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.styleName = "instalationBackground";
         _loc1_.y = 15;
         _loc1_.width = 225;
         _loc1_.height = 189;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ModuleInstallationView_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.gap = 10;
         _loc1_.mxmlContent = [this._ModuleInstallationView_Label1_i(),this._ModuleInstallationView_VGroup2_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ModuleInstallationView_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.setStyle("fontSize",13);
         _loc1_.setStyle("fontFamily","EurostileTHea");
         _loc1_.setStyle("color",16763904);
         _loc1_.setStyle("paddingBottom",-3);
         _loc1_.id = "titleLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         titleLabel = _loc1_;
         BindingManager.executeBindings(this,"titleLabel",titleLabel);
         return _loc1_;
      }
      
      private function _ModuleInstallationView_VGroup2_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.width = 224;
         _loc1_.gap = -24;
         _loc1_.horizontalCenter = 0;
         _loc1_.mxmlContent = [this._ModuleInstallationView_Group1_c(),this._ModuleInstallationView_Group2_c(),this._ModuleInstallationView_Group3_c(),this._ModuleInstallationView_Group4_c(),this._ModuleInstallationView_Group5_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ModuleInstallationView_Group1_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._ModuleInstallationView_ModuleHolster1_i(),this._ModuleInstallationView_ModuleHolster2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ModuleInstallationView_ModuleHolster1_i() : ModuleHolster
      {
         var _loc1_:ModuleHolster = new ModuleHolster();
         _loc1_.slotId = 9;
         _loc1_.addEventListener("dragEnter",this.__leftInner1_dragEnter);
         _loc1_.addEventListener("dragExit",this.__leftInner1_dragExit);
         _loc1_.addEventListener("dragDrop",this.__leftInner1_dragDrop);
         _loc1_.addEventListener("click",this.__leftInner1_click);
         _loc1_.addEventListener("rollOver",this.__leftInner1_rollOver);
         _loc1_.addEventListener("rollOut",this.__leftInner1_rollOut);
         _loc1_.id = "leftInner1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         leftInner1 = _loc1_;
         BindingManager.executeBindings(this,"leftInner1",leftInner1);
         return _loc1_;
      }
      
      public function __leftInner1_dragEnter(param1:DragEvent) : void
      {
         handleDragEntered(param1);
      }
      
      public function __leftInner1_dragExit(param1:DragEvent) : void
      {
         handleDragExit(param1);
      }
      
      public function __leftInner1_dragDrop(param1:DragEvent) : void
      {
         handleDroppedModule(param1);
      }
      
      public function __leftInner1_click(param1:MouseEvent) : void
      {
         handleModuleClicked(param1);
      }
      
      public function __leftInner1_rollOver(param1:MouseEvent) : void
      {
         handleModuleRoll(param1);
      }
      
      public function __leftInner1_rollOut(param1:MouseEvent) : void
      {
         handleModuleRoll(param1);
      }
      
      private function _ModuleInstallationView_ModuleHolster2_i() : ModuleHolster
      {
         var _loc1_:ModuleHolster = new ModuleHolster();
         _loc1_.slotId = 2;
         _loc1_.addEventListener("dragEnter",this.__rightInner1_dragEnter);
         _loc1_.addEventListener("dragExit",this.__rightInner1_dragExit);
         _loc1_.addEventListener("dragDrop",this.__rightInner1_dragDrop);
         _loc1_.addEventListener("click",this.__rightInner1_click);
         _loc1_.addEventListener("rollOver",this.__rightInner1_rollOver);
         _loc1_.addEventListener("rollOut",this.__rightInner1_rollOut);
         _loc1_.id = "rightInner1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         rightInner1 = _loc1_;
         BindingManager.executeBindings(this,"rightInner1",rightInner1);
         return _loc1_;
      }
      
      public function __rightInner1_dragEnter(param1:DragEvent) : void
      {
         handleDragEntered(param1);
      }
      
      public function __rightInner1_dragExit(param1:DragEvent) : void
      {
         handleDragExit(param1);
      }
      
      public function __rightInner1_dragDrop(param1:DragEvent) : void
      {
         handleDroppedModule(param1);
      }
      
      public function __rightInner1_click(param1:MouseEvent) : void
      {
         handleModuleClicked(param1);
      }
      
      public function __rightInner1_rollOver(param1:MouseEvent) : void
      {
         handleModuleRoll(param1);
      }
      
      public function __rightInner1_rollOut(param1:MouseEvent) : void
      {
         handleModuleRoll(param1);
      }
      
      private function _ModuleInstallationView_Group2_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._ModuleInstallationView_ModuleHolster3_i(),this._ModuleInstallationView_ModuleHolster4_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ModuleInstallationView_ModuleHolster3_i() : ModuleHolster
      {
         var _loc1_:ModuleHolster = new ModuleHolster();
         _loc1_.slotId = 8;
         _loc1_.addEventListener("dragEnter",this.__leftOuter1_dragEnter);
         _loc1_.addEventListener("dragExit",this.__leftOuter1_dragExit);
         _loc1_.addEventListener("dragDrop",this.__leftOuter1_dragDrop);
         _loc1_.addEventListener("click",this.__leftOuter1_click);
         _loc1_.addEventListener("rollOver",this.__leftOuter1_rollOver);
         _loc1_.addEventListener("rollOut",this.__leftOuter1_rollOut);
         _loc1_.id = "leftOuter1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         leftOuter1 = _loc1_;
         BindingManager.executeBindings(this,"leftOuter1",leftOuter1);
         return _loc1_;
      }
      
      public function __leftOuter1_dragEnter(param1:DragEvent) : void
      {
         handleDragEntered(param1);
      }
      
      public function __leftOuter1_dragExit(param1:DragEvent) : void
      {
         handleDragExit(param1);
      }
      
      public function __leftOuter1_dragDrop(param1:DragEvent) : void
      {
         handleDroppedModule(param1);
      }
      
      public function __leftOuter1_click(param1:MouseEvent) : void
      {
         handleModuleClicked(param1);
      }
      
      public function __leftOuter1_rollOver(param1:MouseEvent) : void
      {
         handleModuleRoll(param1);
      }
      
      public function __leftOuter1_rollOut(param1:MouseEvent) : void
      {
         handleModuleRoll(param1);
      }
      
      private function _ModuleInstallationView_ModuleHolster4_i() : ModuleHolster
      {
         var _loc1_:ModuleHolster = new ModuleHolster();
         _loc1_.slotId = 3;
         _loc1_.addEventListener("dragEnter",this.__rightOuter1_dragEnter);
         _loc1_.addEventListener("dragExit",this.__rightOuter1_dragExit);
         _loc1_.addEventListener("dragDrop",this.__rightOuter1_dragDrop);
         _loc1_.addEventListener("click",this.__rightOuter1_click);
         _loc1_.addEventListener("rollOver",this.__rightOuter1_rollOver);
         _loc1_.addEventListener("rollOut",this.__rightOuter1_rollOut);
         _loc1_.id = "rightOuter1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         rightOuter1 = _loc1_;
         BindingManager.executeBindings(this,"rightOuter1",rightOuter1);
         return _loc1_;
      }
      
      public function __rightOuter1_dragEnter(param1:DragEvent) : void
      {
         handleDragEntered(param1);
      }
      
      public function __rightOuter1_dragExit(param1:DragEvent) : void
      {
         handleDragExit(param1);
      }
      
      public function __rightOuter1_dragDrop(param1:DragEvent) : void
      {
         handleDroppedModule(param1);
      }
      
      public function __rightOuter1_click(param1:MouseEvent) : void
      {
         handleModuleClicked(param1);
      }
      
      public function __rightOuter1_rollOver(param1:MouseEvent) : void
      {
         handleModuleRoll(param1);
      }
      
      public function __rightOuter1_rollOut(param1:MouseEvent) : void
      {
         handleModuleRoll(param1);
      }
      
      private function _ModuleInstallationView_Group3_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._ModuleInstallationView_ModuleHolster5_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ModuleInstallationView_ModuleHolster5_i() : ModuleHolster
      {
         var _loc1_:ModuleHolster = new ModuleHolster();
         _loc1_.slotId = 0;
         _loc1_.slotId2 = 1;
         _loc1_.horizontalCenter = 0;
         _loc1_.addEventListener("dragEnter",this.__hub_dragEnter);
         _loc1_.addEventListener("dragExit",this.__hub_dragExit);
         _loc1_.id = "hub";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         hub = _loc1_;
         BindingManager.executeBindings(this,"hub",hub);
         return _loc1_;
      }
      
      public function __hub_dragEnter(param1:DragEvent) : void
      {
         handleDragEntered(param1);
      }
      
      public function __hub_dragExit(param1:DragEvent) : void
      {
         handleDragExit(param1);
      }
      
      private function _ModuleInstallationView_Group4_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._ModuleInstallationView_ModuleHolster6_i(),this._ModuleInstallationView_ModuleHolster7_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ModuleInstallationView_ModuleHolster6_i() : ModuleHolster
      {
         var _loc1_:ModuleHolster = new ModuleHolster();
         _loc1_.slotId = 7;
         _loc1_.addEventListener("dragEnter",this.__leftOuter2_dragEnter);
         _loc1_.addEventListener("dragExit",this.__leftOuter2_dragExit);
         _loc1_.addEventListener("dragDrop",this.__leftOuter2_dragDrop);
         _loc1_.addEventListener("click",this.__leftOuter2_click);
         _loc1_.addEventListener("rollOver",this.__leftOuter2_rollOver);
         _loc1_.addEventListener("rollOut",this.__leftOuter2_rollOut);
         _loc1_.id = "leftOuter2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         leftOuter2 = _loc1_;
         BindingManager.executeBindings(this,"leftOuter2",leftOuter2);
         return _loc1_;
      }
      
      public function __leftOuter2_dragEnter(param1:DragEvent) : void
      {
         handleDragEntered(param1);
      }
      
      public function __leftOuter2_dragExit(param1:DragEvent) : void
      {
         handleDragExit(param1);
      }
      
      public function __leftOuter2_dragDrop(param1:DragEvent) : void
      {
         handleDroppedModule(param1);
      }
      
      public function __leftOuter2_click(param1:MouseEvent) : void
      {
         handleModuleClicked(param1);
      }
      
      public function __leftOuter2_rollOver(param1:MouseEvent) : void
      {
         handleModuleRoll(param1);
      }
      
      public function __leftOuter2_rollOut(param1:MouseEvent) : void
      {
         handleModuleRoll(param1);
      }
      
      private function _ModuleInstallationView_ModuleHolster7_i() : ModuleHolster
      {
         var _loc1_:ModuleHolster = new ModuleHolster();
         _loc1_.slotId = 4;
         _loc1_.addEventListener("dragEnter",this.__rightOuter2_dragEnter);
         _loc1_.addEventListener("dragExit",this.__rightOuter2_dragExit);
         _loc1_.addEventListener("dragDrop",this.__rightOuter2_dragDrop);
         _loc1_.addEventListener("click",this.__rightOuter2_click);
         _loc1_.addEventListener("rollOver",this.__rightOuter2_rollOver);
         _loc1_.addEventListener("rollOut",this.__rightOuter2_rollOut);
         _loc1_.id = "rightOuter2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         rightOuter2 = _loc1_;
         BindingManager.executeBindings(this,"rightOuter2",rightOuter2);
         return _loc1_;
      }
      
      public function __rightOuter2_dragEnter(param1:DragEvent) : void
      {
         handleDragEntered(param1);
      }
      
      public function __rightOuter2_dragExit(param1:DragEvent) : void
      {
         handleDragExit(param1);
      }
      
      public function __rightOuter2_dragDrop(param1:DragEvent) : void
      {
         handleDroppedModule(param1);
      }
      
      public function __rightOuter2_click(param1:MouseEvent) : void
      {
         handleModuleClicked(param1);
      }
      
      public function __rightOuter2_rollOver(param1:MouseEvent) : void
      {
         handleModuleRoll(param1);
      }
      
      public function __rightOuter2_rollOut(param1:MouseEvent) : void
      {
         handleModuleRoll(param1);
      }
      
      private function _ModuleInstallationView_Group5_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._ModuleInstallationView_ModuleHolster8_i(),this._ModuleInstallationView_ModuleHolster9_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ModuleInstallationView_ModuleHolster8_i() : ModuleHolster
      {
         var _loc1_:ModuleHolster = new ModuleHolster();
         _loc1_.slotId = 6;
         _loc1_.addEventListener("dragEnter",this.__leftInner2_dragEnter);
         _loc1_.addEventListener("dragExit",this.__leftInner2_dragExit);
         _loc1_.addEventListener("dragDrop",this.__leftInner2_dragDrop);
         _loc1_.addEventListener("click",this.__leftInner2_click);
         _loc1_.addEventListener("rollOver",this.__leftInner2_rollOver);
         _loc1_.addEventListener("rollOut",this.__leftInner2_rollOut);
         _loc1_.id = "leftInner2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         leftInner2 = _loc1_;
         BindingManager.executeBindings(this,"leftInner2",leftInner2);
         return _loc1_;
      }
      
      public function __leftInner2_dragEnter(param1:DragEvent) : void
      {
         handleDragEntered(param1);
      }
      
      public function __leftInner2_dragExit(param1:DragEvent) : void
      {
         handleDragExit(param1);
      }
      
      public function __leftInner2_dragDrop(param1:DragEvent) : void
      {
         handleDroppedModule(param1);
      }
      
      public function __leftInner2_click(param1:MouseEvent) : void
      {
         handleModuleClicked(param1);
      }
      
      public function __leftInner2_rollOver(param1:MouseEvent) : void
      {
         handleModuleRoll(param1);
      }
      
      public function __leftInner2_rollOut(param1:MouseEvent) : void
      {
         handleModuleRoll(param1);
      }
      
      private function _ModuleInstallationView_ModuleHolster9_i() : ModuleHolster
      {
         var _loc1_:ModuleHolster = new ModuleHolster();
         _loc1_.slotId = 5;
         _loc1_.addEventListener("dragEnter",this.__rightInner2_dragEnter);
         _loc1_.addEventListener("dragExit",this.__rightInner2_dragExit);
         _loc1_.addEventListener("dragDrop",this.__rightInner2_dragDrop);
         _loc1_.addEventListener("click",this.__rightInner2_click);
         _loc1_.addEventListener("rollOver",this.__rightInner2_rollOver);
         _loc1_.addEventListener("rollOut",this.__rightInner2_rollOut);
         _loc1_.id = "rightInner2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         rightInner2 = _loc1_;
         BindingManager.executeBindings(this,"rightInner2",rightInner2);
         return _loc1_;
      }
      
      public function __rightInner2_dragEnter(param1:DragEvent) : void
      {
         handleDragEntered(param1);
      }
      
      public function __rightInner2_dragExit(param1:DragEvent) : void
      {
         handleDragExit(param1);
      }
      
      public function __rightInner2_dragDrop(param1:DragEvent) : void
      {
         handleDroppedModule(param1);
      }
      
      public function __rightInner2_click(param1:MouseEvent) : void
      {
         handleModuleClicked(param1);
      }
      
      public function __rightInner2_rollOver(param1:MouseEvent) : void
      {
         handleModuleRoll(param1);
      }
      
      public function __rightInner2_rollOut(param1:MouseEvent) : void
      {
         handleModuleRoll(param1);
      }
      
      public function ___ModuleInstallationView_ModuleInstallationViewBase1_creationComplete(param1:FlexEvent) : void
      {
         creationCompleteHandler();
      }
      
      private function _ModuleInstallationView_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return -xOffsetInnerModules;
         },null,"leftInner1.horizontalCenter");
         result[1] = new Binding(this,function():Object
         {
            return xOffsetInnerModules;
         },null,"rightInner1.horizontalCenter");
         result[2] = new Binding(this,function():Object
         {
            return -xOffsetOuterModules;
         },null,"leftOuter1.horizontalCenter");
         result[3] = new Binding(this,function():Object
         {
            return xOffsetOuterModules;
         },null,"rightOuter1.horizontalCenter");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = ModuleHolsterBase.DOUBLE_MODULE_MODE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"hub.holsterMode");
         result[5] = new Binding(this,function():Function
         {
            return handleDroppedModule;
         },null,"hub.droppingCallback");
         result[6] = new Binding(this,function():Function
         {
            return handleModuleClicked;
         },null,"hub.clickCallback");
         result[7] = new Binding(this,function():Function
         {
            return handleModuleRoll;
         },null,"hub.rollCallback");
         result[8] = new Binding(this,function():Object
         {
            return -xOffsetOuterModules;
         },null,"leftOuter2.horizontalCenter");
         result[9] = new Binding(this,function():Object
         {
            return xOffsetOuterModules;
         },null,"rightOuter2.horizontalCenter");
         result[10] = new Binding(this,function():Object
         {
            return -xOffsetInnerModules;
         },null,"leftInner2.horizontalCenter");
         result[11] = new Binding(this,function():Object
         {
            return xOffsetInnerModules;
         },null,"rightInner2.horizontalCenter");
         return result;
      }
   }
}

