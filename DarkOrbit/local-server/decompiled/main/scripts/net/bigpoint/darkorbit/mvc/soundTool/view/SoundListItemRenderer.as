package net.bigpoint.darkorbit.mvc.soundTool.view
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
   import mx.events.SliderEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.audio.AudioMultiPattern;
   import spark.components.Button;
   import spark.components.Label;
   import spark.components.VGroup;
   import spark.components.supportClasses.ItemRenderer;
   
   use namespace mx_internal;
   
   public class SoundListItemRenderer extends ItemRenderer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _SoundListItemRenderer_Button1:Button;
      
      public var _SoundListItemRenderer_Label1:Label;
      
      public var _SoundListItemRenderer_Label2:Label;
      
      public var _SoundListItemRenderer_Label3:Label;
      
      private var _290289513hSlider:HSlider;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SoundListItemRenderer()
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
         bindings = this._SoundListItemRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_soundTool_view_SoundListItemRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return SoundListItemRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.minWidth = 0;
         this.percentWidth = 100;
         this.mxmlContent = [this._SoundListItemRenderer_VGroup1_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SoundListItemRenderer._watcherSetupUtil = param1;
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
      
      [Bindable(event="dataChange")]
      protected function get pattern() : AudioMultiPattern
      {
         return data as AudioMultiPattern;
      }
      
      protected function changeSize() : void
      {
         this.pattern.setVolume(this.hSlider.value);
      }
      
      protected function playSound() : void
      {
         if(this.pattern)
         {
            AudioManager.playSoundEffect(this.pattern.getPatternID());
         }
      }
      
      protected function getButtonText() : String
      {
         return "Play";
      }
      
      private function _SoundListItemRenderer_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._SoundListItemRenderer_Label1_i(),this._SoundListItemRenderer_Label2_i(),this._SoundListItemRenderer_Label3_i(),this._SoundListItemRenderer_Button1_i(),this._SoundListItemRenderer_HSlider1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _SoundListItemRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "_SoundListItemRenderer_Label1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._SoundListItemRenderer_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_SoundListItemRenderer_Label1",this._SoundListItemRenderer_Label1);
         return _loc1_;
      }
      
      private function _SoundListItemRenderer_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "_SoundListItemRenderer_Label2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._SoundListItemRenderer_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_SoundListItemRenderer_Label2",this._SoundListItemRenderer_Label2);
         return _loc1_;
      }
      
      private function _SoundListItemRenderer_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "_SoundListItemRenderer_Label3";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._SoundListItemRenderer_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_SoundListItemRenderer_Label3",this._SoundListItemRenderer_Label3);
         return _loc1_;
      }
      
      private function _SoundListItemRenderer_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.addEventListener("click",this.___SoundListItemRenderer_Button1_click);
         _loc1_.id = "_SoundListItemRenderer_Button1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._SoundListItemRenderer_Button1 = _loc1_;
         BindingManager.executeBindings(this,"_SoundListItemRenderer_Button1",this._SoundListItemRenderer_Button1);
         return _loc1_;
      }
      
      public function ___SoundListItemRenderer_Button1_click(param1:MouseEvent) : void
      {
         this.playSound();
      }
      
      private function _SoundListItemRenderer_HSlider1_i() : HSlider
      {
         var _loc1_:HSlider = new HSlider();
         _loc1_.percentWidth = 100;
         _loc1_.minimum = 0;
         _loc1_.maximum = 10;
         _loc1_.snapInterval = 0.1;
         _loc1_.tickInterval = 10;
         _loc1_.labels = [0,10];
         _loc1_.allowTrackClick = true;
         _loc1_.liveDragging = true;
         _loc1_.setStyle("dataTipPlacement","top");
         _loc1_.setStyle("tickColor",3289650);
         _loc1_.addEventListener("change",this.__hSlider_change);
         _loc1_.id = "hSlider";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.hSlider = _loc1_;
         BindingManager.executeBindings(this,"hSlider",this.hSlider);
         return _loc1_;
      }
      
      public function __hSlider_change(param1:SliderEvent) : void
      {
         this.changeSize();
      }
      
      private function _SoundListItemRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = "SoundBank: " + pattern.soundbank;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SoundListItemRenderer_Label1.text");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = "Key: " + pattern.resKeyList;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SoundListItemRenderer_Label2.text");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = "Volume: " + hSlider.value;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SoundListItemRenderer_Label3.text");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = getButtonText();
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SoundListItemRenderer_Button1.label");
         result[4] = new Binding(this,function():Number
         {
            return pattern.getVolume();
         },null,"hSlider.value");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get hSlider() : HSlider
      {
         return this._290289513hSlider;
      }
      
      public function set hSlider(param1:HSlider) : void
      {
         var _loc2_:Object = this._290289513hSlider;
         if(_loc2_ !== param1)
         {
            this._290289513hSlider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hSlider",_loc2_,param1));
            }
         }
      }
   }
}

