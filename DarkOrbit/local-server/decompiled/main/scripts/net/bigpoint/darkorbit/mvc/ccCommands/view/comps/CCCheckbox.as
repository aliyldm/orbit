package net.bigpoint.darkorbit.mvc.ccCommands.view.comps
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
   import mx.styles.*;
   import net.bigpoint.darkorbit.com.module.CCBooleanValueModule;
   import net.bigpoint.darkorbit.com.module.CCValueModule;
   import spark.components.CheckBox;
   import spark.components.Label;
   import spark.components.VGroup;
   
   use namespace mx_internal;
   
   public class CCCheckbox extends CCAbstractComponent implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _CCCheckbox_Label1:Label;
      
      private var _1536861091checkBox:CheckBox;
      
      private var _1281495508localGroup:VGroup;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CCCheckbox()
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
         bindings = this._CCCheckbox_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_ccCommands_view_comps_CCCheckboxWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return CCCheckbox[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this._CCCheckbox_VGroup1_i();
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         CCCheckbox._watcherSetupUtil = param1;
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
      
      override public function get currentData() : CCValueModule
      {
         return new CCBooleanValueModule(_data.name,this.checkBox.selected);
      }
      
      override public function set data(param1:Object) : void
      {
         group.addElement(this.localGroup);
         super.data = param1;
      }
      
      private function _CCCheckbox_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.mxmlContent = [this._CCCheckbox_Label1_i(),this._CCCheckbox_CheckBox1_i()];
         _loc1_.id = "localGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.localGroup = _loc1_;
         BindingManager.executeBindings(this,"localGroup",this.localGroup);
         return _loc1_;
      }
      
      private function _CCCheckbox_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "_CCCheckbox_Label1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._CCCheckbox_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_CCCheckbox_Label1",this._CCCheckbox_Label1);
         return _loc1_;
      }
      
      private function _CCCheckbox_CheckBox1_i() : CheckBox
      {
         var _loc1_:CheckBox = new CheckBox();
         _loc1_.id = "checkBox";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.checkBox = _loc1_;
         BindingManager.executeBindings(this,"checkBox",this.checkBox);
         return _loc1_;
      }
      
      private function _CCCheckbox_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = _data.name;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CCCheckbox_Label1.text");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get checkBox() : CheckBox
      {
         return this._1536861091checkBox;
      }
      
      public function set checkBox(param1:CheckBox) : void
      {
         var _loc2_:Object = this._1536861091checkBox;
         if(_loc2_ !== param1)
         {
            this._1536861091checkBox = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"checkBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get localGroup() : VGroup
      {
         return this._1281495508localGroup;
      }
      
      public function set localGroup(param1:VGroup) : void
      {
         var _loc2_:Object = this._1281495508localGroup;
         if(_loc2_ !== param1)
         {
            this._1281495508localGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"localGroup",_loc2_,param1));
            }
         }
      }
   }
}

