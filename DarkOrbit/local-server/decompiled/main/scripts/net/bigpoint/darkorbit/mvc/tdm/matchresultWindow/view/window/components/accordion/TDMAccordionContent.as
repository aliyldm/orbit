package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.accordion
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
   import flashx.textLayout.formats.TextAlign;
   import mx.binding.*;
   import mx.controls.Text;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.graphics.SolidColor;
   import mx.styles.*;
   import net.bigpoint.darkorbit.Styles;
   import spark.components.Group;
   import spark.primitives.Rect;
   
   use namespace mx_internal;
   
   public class TDMAccordionContent extends spark.components.Group implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _TDMAccordionContent_SolidColor1:SolidColor;
      
      public var _TDMAccordionContent_Text1:Text;
      
      public var _TDMAccordionContent_Text2:Text;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _2112049921_bgcolor:uint;
      
      private var _1551885010_padding:int;
      
      private var _1808936755_leftText:String;
      
      private var _1236928490_rightText:String;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function TDMAccordionContent()
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
         bindings = this._TDMAccordionContent_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_tdm_matchresultWindow_view_window_components_accordion_TDMAccordionContentWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return TDMAccordionContent[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.percentWidth = 100;
         this.mxmlContent = [this._TDMAccordionContent_Rect1_c(),this._TDMAccordionContent_Text1_i(),this._TDMAccordionContent_Text2_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         TDMAccordionContent._watcherSetupUtil = param1;
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
      
      public function set bgcolor(param1:uint) : void
      {
         this._bgcolor = param1;
      }
      
      public function set padding(param1:int) : void
      {
         this._padding = param1;
      }
      
      public function set leftText(param1:String) : void
      {
         this._leftText = param1;
      }
      
      public function set rightText(param1:String) : void
      {
         this._rightText = param1;
      }
      
      private function _TDMAccordionContent_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.fill = this._TDMAccordionContent_SolidColor1_i();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _TDMAccordionContent_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         this._TDMAccordionContent_SolidColor1 = _loc1_;
         BindingManager.executeBindings(this,"_TDMAccordionContent_SolidColor1",this._TDMAccordionContent_SolidColor1);
         return _loc1_;
      }
      
      private function _TDMAccordionContent_Text1_i() : Text
      {
         var _loc1_:Text = new Text();
         _loc1_.left = 0;
         _loc1_.percentWidth = 100;
         _loc1_.setStyle("fontSize",11);
         _loc1_.id = "_TDMAccordionContent_Text1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._TDMAccordionContent_Text1 = _loc1_;
         BindingManager.executeBindings(this,"_TDMAccordionContent_Text1",this._TDMAccordionContent_Text1);
         return _loc1_;
      }
      
      private function _TDMAccordionContent_Text2_i() : Text
      {
         var _loc1_:Text = new Text();
         _loc1_.right = 0;
         _loc1_.percentWidth = 100;
         _loc1_.setStyle("fontSize",11);
         _loc1_.id = "_TDMAccordionContent_Text2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._TDMAccordionContent_Text2 = _loc1_;
         BindingManager.executeBindings(this,"_TDMAccordionContent_Text2",this._TDMAccordionContent_Text2);
         return _loc1_;
      }
      
      private function _TDMAccordionContent_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():uint
         {
            return _bgcolor;
         },null,"_TDMAccordionContent_SolidColor1.color");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = TextAlign.LEFT;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TDMAccordionContent_Text1.setStyle("textAlign",param1);
         },"_TDMAccordionContent_Text1.textAlign");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = _leftText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TDMAccordionContent_Text1.htmlText");
         result[3] = new Binding(this,function():Boolean
         {
            return false;
         },null,"_TDMAccordionContent_Text1.selectable");
         result[4] = new Binding(this,function():Number
         {
            return _padding;
         },function(param1:Number):void
         {
            _TDMAccordionContent_Text1.setStyle("paddingLeft",param1);
         },"_TDMAccordionContent_Text1.paddingLeft");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontHeavyFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TDMAccordionContent_Text1.setStyle("fontFamily",param1);
         },"_TDMAccordionContent_Text1.fontFamily");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = TextAlign.RIGHT;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TDMAccordionContent_Text2.setStyle("textAlign",param1);
         },"_TDMAccordionContent_Text2.textAlign");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = _rightText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TDMAccordionContent_Text2.htmlText");
         result[8] = new Binding(this,function():Boolean
         {
            return false;
         },null,"_TDMAccordionContent_Text2.selectable");
         result[9] = new Binding(this,function():Number
         {
            return _padding;
         },function(param1:Number):void
         {
            _TDMAccordionContent_Text2.setStyle("paddingRight",param1);
         },"_TDMAccordionContent_Text2.paddingRight");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontHeavyFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _TDMAccordionContent_Text2.setStyle("fontFamily",param1);
         },"_TDMAccordionContent_Text2.fontFamily");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      private function get _bgcolor() : uint
      {
         return this._2112049921_bgcolor;
      }
      
      private function set _bgcolor(param1:uint) : void
      {
         var _loc2_:Object = this._2112049921_bgcolor;
         if(_loc2_ !== param1)
         {
            this._2112049921_bgcolor = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_bgcolor",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _padding() : int
      {
         return this._1551885010_padding;
      }
      
      private function set _padding(param1:int) : void
      {
         var _loc2_:Object = this._1551885010_padding;
         if(_loc2_ !== param1)
         {
            this._1551885010_padding = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_padding",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _leftText() : String
      {
         return this._1808936755_leftText;
      }
      
      private function set _leftText(param1:String) : void
      {
         var _loc2_:Object = this._1808936755_leftText;
         if(_loc2_ !== param1)
         {
            this._1808936755_leftText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_leftText",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _rightText() : String
      {
         return this._1236928490_rightText;
      }
      
      private function set _rightText(param1:String) : void
      {
         var _loc2_:Object = this._1236928490_rightText;
         if(_loc2_ !== param1)
         {
            this._1236928490_rightText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_rightText",_loc2_,param1));
            }
         }
      }
   }
}

