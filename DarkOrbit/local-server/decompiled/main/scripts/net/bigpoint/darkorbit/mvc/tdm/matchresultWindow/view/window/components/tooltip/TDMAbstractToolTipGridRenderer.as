package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.tooltip
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
   import spark.components.Label;
   import spark.components.gridClasses.GridItemRenderer;
   
   use namespace mx_internal;
   
   public class TDMAbstractToolTipGridRenderer extends GridItemRenderer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _TDMAbstractToolTipGridRenderer_Label1:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      protected var _91291148_text:String;
      
      protected var _1480355228_color:uint;
      
      protected var _456118863_fontSize:uint = 11;
      
      protected var _90883374_font:String = "EurostileT";
      
      protected var _1740542041_textAlign:String = "left";
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function TDMAbstractToolTipGridRenderer()
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
         bindings = this._TDMAbstractToolTipGridRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_tdm_matchresultWindow_view_window_components_tooltip_TDMAbstractToolTipGridRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return TDMAbstractToolTipGridRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.percentWidth = 100;
         this.mxmlContent = [this._TDMAbstractToolTipGridRenderer_Label1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         TDMAbstractToolTipGridRenderer._watcherSetupUtil = param1;
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
      
      private function _TDMAbstractToolTipGridRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.setStyle("paddingLeft",5);
         _loc1_.setStyle("paddingRight",5);
         _loc1_.setStyle("paddingTop",5);
         _loc1_.id = "_TDMAbstractToolTipGridRenderer_Label1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._TDMAbstractToolTipGridRenderer_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_TDMAbstractToolTipGridRenderer_Label1",this._TDMAbstractToolTipGridRenderer_Label1);
         return _loc1_;
      }
      
      private function _TDMAbstractToolTipGridRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Number
         {
            return _fontSize;
         },function(param1:Number):void
         {
            _TDMAbstractToolTipGridRenderer_Label1.setStyle("fontSize",param1);
         },"_TDMAbstractToolTipGridRenderer_Label1.fontSize");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = _font;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TDMAbstractToolTipGridRenderer_Label1.setStyle("fontFamily",param1);
         },"_TDMAbstractToolTipGridRenderer_Label1.fontFamily");
         result[2] = new Binding(this,function():uint
         {
            return _color;
         },function(param1:uint):void
         {
            _TDMAbstractToolTipGridRenderer_Label1.setStyle("color",param1);
         },"_TDMAbstractToolTipGridRenderer_Label1.color");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = _textAlign;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TDMAbstractToolTipGridRenderer_Label1.setStyle("textAlign",param1);
         },"_TDMAbstractToolTipGridRenderer_Label1.textAlign");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = _text;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TDMAbstractToolTipGridRenderer_Label1.text");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      protected function get _text() : String
      {
         return this._91291148_text;
      }
      
      protected function set _text(param1:String) : void
      {
         var _loc2_:Object = this._91291148_text;
         if(_loc2_ !== param1)
         {
            this._91291148_text = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_text",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get _color() : uint
      {
         return this._1480355228_color;
      }
      
      protected function set _color(param1:uint) : void
      {
         var _loc2_:Object = this._1480355228_color;
         if(_loc2_ !== param1)
         {
            this._1480355228_color = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_color",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get _fontSize() : uint
      {
         return this._456118863_fontSize;
      }
      
      protected function set _fontSize(param1:uint) : void
      {
         var _loc2_:Object = this._456118863_fontSize;
         if(_loc2_ !== param1)
         {
            this._456118863_fontSize = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_fontSize",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get _font() : String
      {
         return this._90883374_font;
      }
      
      protected function set _font(param1:String) : void
      {
         var _loc2_:Object = this._90883374_font;
         if(_loc2_ !== param1)
         {
            this._90883374_font = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_font",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get _textAlign() : String
      {
         return this._1740542041_textAlign;
      }
      
      protected function set _textAlign(param1:String) : void
      {
         var _loc2_:Object = this._1740542041_textAlign;
         if(_loc2_ !== param1)
         {
            this._1740542041_textAlign = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_textAlign",_loc2_,param1));
            }
         }
      }
   }
}

