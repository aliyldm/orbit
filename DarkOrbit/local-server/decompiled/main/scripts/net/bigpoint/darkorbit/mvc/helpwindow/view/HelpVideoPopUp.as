package net.bigpoint.darkorbit.mvc.helpwindow.view
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
   import mx.controls.Text;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOViewContainerBase;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOOuterViewContainerSkin;
   import spark.components.Group;
   import spark.components.VGroup;
   import spark.components.VideoPlayer;
   import spark.layouts.HorizontalAlign;
   
   use namespace mx_internal;
   
   public class HelpVideoPopUp extends DOWindow implements IBindingClient
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
      
      public var _HelpVideoPopUp_Text1:Text;
      
      public var _HelpVideoPopUp_VGroup1:VGroup;
      
      public var _HelpVideoPopUp_VGroup2:VGroup;
      
      public var _HelpVideoPopUp_VideoPlayer1:VideoPlayer;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _1771279564_helpVideoURL:String;
      
      private var _91291148_text:String;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function HelpVideoPopUp()
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
         bindings = this._HelpVideoPopUp_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_helpwindow_view_HelpVideoPopUpWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return HelpVideoPopUp[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 600;
         this.height = 400;
         this.styleName = "questWindow";
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._HelpVideoPopUp_Array1_c);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         HelpVideoPopUp._watcherSetupUtil = param1;
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
      
      public function set helpVideo(param1:String) : void
      {
         this._helpVideoURL = param1;
      }
      
      public function set text(param1:String) : void
      {
         this._text = param1;
      }
      
      private function _HelpVideoPopUp_Array1_c() : Array
      {
         return [this._HelpVideoPopUp_VGroup1_i()];
      }
      
      private function _HelpVideoPopUp_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._HelpVideoPopUp_VGroup2_i()];
         _loc1_.id = "_HelpVideoPopUp_VGroup1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._HelpVideoPopUp_VGroup1 = _loc1_;
         BindingManager.executeBindings(this,"_HelpVideoPopUp_VGroup1",this._HelpVideoPopUp_VGroup1);
         return _loc1_;
      }
      
      private function _HelpVideoPopUp_VGroup2_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 95;
         _loc1_.percentHeight = 90;
         _loc1_.mxmlContent = [this._HelpVideoPopUp_Group1_c(),this._HelpVideoPopUp_VideoPlayer1_i()];
         _loc1_.id = "_HelpVideoPopUp_VGroup2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._HelpVideoPopUp_VGroup2 = _loc1_;
         BindingManager.executeBindings(this,"_HelpVideoPopUp_VGroup2",this._HelpVideoPopUp_VGroup2);
         return _loc1_;
      }
      
      private function _HelpVideoPopUp_Group1_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._HelpVideoPopUp_DOViewContainerBase1_c(),this._HelpVideoPopUp_Text1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _HelpVideoPopUp_DOViewContainerBase1_c() : DOViewContainerBase
      {
         var _loc1_:DOViewContainerBase = new DOViewContainerBase();
         _loc1_.styleName = "questWindowOuter";
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.setStyle("skinClass",DOOuterViewContainerSkin);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _HelpVideoPopUp_Text1_i() : Text
      {
         var _loc1_:Text = new Text();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.setStyle("fontSize",11);
         _loc1_.setStyle("paddingTop",4);
         _loc1_.setStyle("paddingBottom",4);
         _loc1_.setStyle("paddingLeft",6);
         _loc1_.setStyle("paddingRight",6);
         _loc1_.id = "_HelpVideoPopUp_Text1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._HelpVideoPopUp_Text1 = _loc1_;
         BindingManager.executeBindings(this,"_HelpVideoPopUp_Text1",this._HelpVideoPopUp_Text1);
         return _loc1_;
      }
      
      private function _HelpVideoPopUp_VideoPlayer1_i() : VideoPlayer
      {
         var _loc1_:VideoPlayer = new VideoPlayer();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.loop = true;
         _loc1_.scaleMode = "letterbox";
         _loc1_.id = "_HelpVideoPopUp_VideoPlayer1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._HelpVideoPopUp_VideoPlayer1 = _loc1_;
         BindingManager.executeBindings(this,"_HelpVideoPopUp_VideoPlayer1",this._HelpVideoPopUp_VideoPlayer1);
         return _loc1_;
      }
      
      private function _HelpVideoPopUp_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = HorizontalAlign.CENTER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_HelpVideoPopUp_VGroup1.horizontalAlign");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = HorizontalAlign.CENTER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_HelpVideoPopUp_VGroup2.horizontalAlign");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = _text;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_HelpVideoPopUp_Text1.text");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.baseFont;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _HelpVideoPopUp_Text1.setStyle("fontFamily",param1);
         },"_HelpVideoPopUp_Text1.fontFamily");
         result[4] = new Binding(this,function():uint
         {
            return 16777215;
         },function(param1:uint):void
         {
            _HelpVideoPopUp_Text1.setStyle("color",param1);
         },"_HelpVideoPopUp_Text1.color");
         result[5] = new Binding(this,function():Object
         {
            return _helpVideoURL;
         },null,"_HelpVideoPopUp_VideoPlayer1.source");
         result[6] = new Binding(this,function():uint
         {
            return Styles.WHITE;
         },function(param1:uint):void
         {
            _HelpVideoPopUp_VideoPlayer1.setStyle("color",param1);
         },"_HelpVideoPopUp_VideoPlayer1.color");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      private function get _helpVideoURL() : String
      {
         return this._1771279564_helpVideoURL;
      }
      
      private function set _helpVideoURL(param1:String) : void
      {
         var _loc2_:Object = this._1771279564_helpVideoURL;
         if(_loc2_ !== param1)
         {
            this._1771279564_helpVideoURL = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_helpVideoURL",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _text() : String
      {
         return this._91291148_text;
      }
      
      private function set _text(param1:String) : void
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
   }
}

