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
   import mx.controls.DateChooser;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.com.module.CCDateValueModule;
   import net.bigpoint.darkorbit.com.module.CCValueModule;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.VGroup;
   
   use namespace mx_internal;
   
   public class CCDate extends CCAbstractComponent implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _CCDate_Label1:Label;
      
      public var _CCDate_Label2:Label;
      
      private var _3076014date:DateChooser;
      
      private var _1281495508localGroup:HGroup;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CCDate()
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
         bindings = this._CCDate_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_ccCommands_view_comps_CCDateWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return CCDate[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this._CCDate_HGroup1_i();
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         CCDate._watcherSetupUtil = param1;
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
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         group.addElement(this.localGroup);
         group.invalidateSize();
      }
      
      override public function get currentData() : CCValueModule
      {
         var _loc1_:Date = this.date.selectedDate;
         var _loc2_:Number = _loc1_.timezoneOffset * 60000;
         return new CCDateValueModule(_data.name,_loc1_.getTime() + _loc2_);
      }
      
      private function _CCDate_HGroup1_i() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._CCDate_VGroup1_c(),this._CCDate_DateChooser1_i()];
         _loc1_.id = "localGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.localGroup = _loc1_;
         BindingManager.executeBindings(this,"localGroup",this.localGroup);
         return _loc1_;
      }
      
      private function _CCDate_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.mxmlContent = [this._CCDate_Label1_i(),this._CCDate_Label2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CCDate_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "_CCDate_Label1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._CCDate_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_CCDate_Label1",this._CCDate_Label1);
         return _loc1_;
      }
      
      private function _CCDate_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "_CCDate_Label2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._CCDate_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_CCDate_Label2",this._CCDate_Label2);
         return _loc1_;
      }
      
      private function _CCDate_DateChooser1_i() : DateChooser
      {
         var _loc1_:DateChooser = new DateChooser();
         _loc1_.id = "date";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.date = _loc1_;
         BindingManager.executeBindings(this,"date",this.date);
         return _loc1_;
      }
      
      private function _CCDate_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = _data.name;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CCDate_Label1.text");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = "TimeOffset: " + new Date().timezoneOffset / 60 + "h";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CCDate_Label2.text");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get date() : DateChooser
      {
         return this._3076014date;
      }
      
      public function set date(param1:DateChooser) : void
      {
         var _loc2_:Object = this._3076014date;
         if(_loc2_ !== param1)
         {
            this._3076014date = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"date",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get localGroup() : HGroup
      {
         return this._1281495508localGroup;
      }
      
      public function set localGroup(param1:HGroup) : void
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

