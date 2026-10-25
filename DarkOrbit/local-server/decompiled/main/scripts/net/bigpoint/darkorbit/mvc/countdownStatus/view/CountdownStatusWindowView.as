package net.bigpoint.darkorbit.mvc.countdownStatus.view
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
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import spark.components.HGroup;
   import spark.components.Label;
   
   use namespace mx_internal;
   
   public class CountdownStatusWindowView extends CountdownStatusWindowBase implements IBindingClient
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
      
      private var _1221030109countDownLabel:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CountdownStatusWindowView()
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
         bindings = this._CountdownStatusWindowView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_countdownStatus_view_CountdownStatusWindowViewWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return CountdownStatusWindowView[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.styleName = "countDownStatusWindow";
         this.height = 110;
         this.minHeight = 110;
         this.maxHeight = 110;
         this.width = 320;
         this.minWidth = 320;
         this.maxWidth = 320;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._CountdownStatusWindowView_Array1_c);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         CountdownStatusWindowView._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         var factory:IFlexModuleFactory = param1;
         super.moduleFactory = factory;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration(null,styleManager);
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.resizable = false;
            this.backgroundAlpha = 0;
         };
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      private function _CountdownStatusWindowView_Array1_c() : Array
      {
         return [this._CountdownStatusWindowView_HGroup1_c()];
      }
      
      private function _CountdownStatusWindowView_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.top = 15;
         _loc1_.paddingBottom = 20;
         _loc1_.paddingLeft = 5;
         _loc1_.paddingRight = 10;
         _loc1_.verticalAlign = "middle";
         _loc1_.mxmlContent = [this._CountdownStatusWindowView_Label1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CountdownStatusWindowView_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.setStyle("fontSize",12);
         _loc1_.setStyle("fontFamily","EurostileTHea");
         _loc1_.setStyle("color",15262143);
         _loc1_.id = "countDownLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.countDownLabel = _loc1_;
         BindingManager.executeBindings(this,"countDownLabel",this.countDownLabel);
         return _loc1_;
      }
      
      private function _CountdownStatusWindowView_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = TextAlign.CENTER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            countDownLabel.setStyle("textAlign",param1);
         },"countDownLabel.textAlign");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("label_countdownHalloweenNpcs");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"countDownLabel.text");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get countDownLabel() : Label
      {
         return this._1221030109countDownLabel;
      }
      
      public function set countDownLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1221030109countDownLabel;
         if(_loc2_ !== param1)
         {
            this._1221030109countDownLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"countDownLabel",_loc2_,param1));
            }
         }
      }
   }
}

