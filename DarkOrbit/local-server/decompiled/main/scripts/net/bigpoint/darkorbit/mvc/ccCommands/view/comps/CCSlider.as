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
   import mx.controls.HSlider;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.com.module.CCIntValueModule;
   import net.bigpoint.darkorbit.com.module.CCNumericRangeModule;
   import net.bigpoint.darkorbit.com.module.CCValueModule;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.TextInput;
   import spark.components.VGroup;
   
   use namespace mx_internal;
   
   public class CCSlider extends CCAbstractComponent implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _CCSlider_Label1:Label;
      
      private var _100358090input:TextInput;
      
      private var _1281495508localGroup:VGroup;
      
      private var _899647263slider:HSlider;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CCSlider()
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
         bindings = this._CCSlider_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_ccCommands_view_comps_CCSliderWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return CCSlider[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this._CCSlider_VGroup1_i();
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         CCSlider._watcherSetupUtil = param1;
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
         group.addElement(this.localGroup);
         super.data = param1;
         this.slider.labels = [(_data.range as CCNumericRangeModule).min,_data.name,(_data.range as CCNumericRangeModule).max];
         this.slider.value = (_data.range as CCNumericRangeModule).min;
      }
      
      override public function get currentData() : CCValueModule
      {
         return new CCIntValueModule(_data.name,this.slider.value);
      }
      
      private function _CCSlider_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.mxmlContent = [this._CCSlider_HGroup1_c(),this._CCSlider_HSlider1_i()];
         _loc1_.id = "localGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.localGroup = _loc1_;
         BindingManager.executeBindings(this,"localGroup",this.localGroup);
         return _loc1_;
      }
      
      private function _CCSlider_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.mxmlContent = [this._CCSlider_Label1_i(),this._CCSlider_TextInput1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CCSlider_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "_CCSlider_Label1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._CCSlider_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_CCSlider_Label1",this._CCSlider_Label1);
         return _loc1_;
      }
      
      private function _CCSlider_TextInput1_i() : TextInput
      {
         var _loc1_:TextInput = new TextInput();
         _loc1_.restrict = "0-9";
         _loc1_.id = "input";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.input = _loc1_;
         BindingManager.executeBindings(this,"input",this.input);
         return _loc1_;
      }
      
      private function _CCSlider_HSlider1_i() : HSlider
      {
         var _loc1_:HSlider = new HSlider();
         _loc1_.snapInterval = 1;
         _loc1_.setStyle("dataTipPlacement","top");
         _loc1_.id = "slider";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.slider = _loc1_;
         BindingManager.executeBindings(this,"slider",this.slider);
         return _loc1_;
      }
      
      private function _CCSlider_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = _data.name + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CCSlider_Label1.text");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = slider.value;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"input.text");
         result[2] = new Binding(this,function():Number
         {
            return (_data.range as CCNumericRangeModule).min;
         },null,"slider.minimum");
         result[3] = new Binding(this,function():Number
         {
            return (_data.range as CCNumericRangeModule).max;
         },null,"slider.maximum");
         result[4] = new Binding(this,function():Number
         {
            return int(input.text);
         },null,"slider.value");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get input() : TextInput
      {
         return this._100358090input;
      }
      
      public function set input(param1:TextInput) : void
      {
         var _loc2_:Object = this._100358090input;
         if(_loc2_ !== param1)
         {
            this._100358090input = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"input",_loc2_,param1));
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
      
      [Bindable(event="propertyChange")]
      public function get slider() : HSlider
      {
         return this._899647263slider;
      }
      
      public function set slider(param1:HSlider) : void
      {
         var _loc2_:Object = this._899647263slider;
         if(_loc2_ !== param1)
         {
            this._899647263slider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"slider",_loc2_,param1));
            }
         }
      }
   }
}

