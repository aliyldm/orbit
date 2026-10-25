package net.bigpoint.darkorbit.mvc.wordPuzzle.view
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
   import spark.components.Label;
   import spark.components.VGroup;
   
   use namespace mx_internal;
   
   public class WordPuzzleWindowView extends WordPuzzleWindowBase implements IBindingClient
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
      
      private var _1407815606labelPuzzleDescription:Label;
      
      private var _1868688100labelPuzzleStatus:Label;
      
      private var _164702519labelSolutionWord:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function WordPuzzleWindowView()
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
         bindings = this._WordPuzzleWindowView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_wordPuzzle_view_WordPuzzleWindowViewWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return WordPuzzleWindowView[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.styleName = "wordPuzzleWindow";
         this.height = 200;
         this.minHeight = 200;
         this.maxHeight = 230;
         this.width = 280;
         this.minWidth = 280;
         this.maxWidth = 340;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._WordPuzzleWindowView_Array1_c);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         WordPuzzleWindowView._watcherSetupUtil = param1;
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
            this.backgroundAlpha = 0;
         };
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      private function _WordPuzzleWindowView_Array1_c() : Array
      {
         return [this._WordPuzzleWindowView_VGroup1_c()];
      }
      
      private function _WordPuzzleWindowView_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.top = 15;
         _loc1_.paddingBottom = 20;
         _loc1_.paddingLeft = 5;
         _loc1_.paddingRight = 10;
         _loc1_.mxmlContent = [this._WordPuzzleWindowView_Label1_i(),this._WordPuzzleWindowView_Label2_i(),this._WordPuzzleWindowView_Label3_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _WordPuzzleWindowView_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.maxDisplayedLines = 1;
         _loc1_.setStyle("fontSize",12);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",13421772);
         _loc1_.id = "labelPuzzleStatus";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelPuzzleStatus = _loc1_;
         BindingManager.executeBindings(this,"labelPuzzleStatus",this.labelPuzzleStatus);
         return _loc1_;
      }
      
      private function _WordPuzzleWindowView_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.maxDisplayedLines = 1;
         _loc1_.setStyle("paddingTop",6);
         _loc1_.setStyle("fontSize",26);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",16777215);
         _loc1_.id = "labelSolutionWord";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelSolutionWord = _loc1_;
         BindingManager.executeBindings(this,"labelSolutionWord",this.labelSolutionWord);
         return _loc1_;
      }
      
      private function _WordPuzzleWindowView_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.setStyle("color",12303291);
         _loc1_.setStyle("fontSize",12);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("paddingLeft",10);
         _loc1_.setStyle("paddingRight",0);
         _loc1_.setStyle("paddingTop",2);
         _loc1_.setStyle("paddingBottom",12);
         _loc1_.id = "labelPuzzleDescription";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelPuzzleDescription = _loc1_;
         BindingManager.executeBindings(this,"labelPuzzleDescription",this.labelPuzzleDescription);
         return _loc1_;
      }
      
      private function _WordPuzzleWindowView_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = TextAlign.CENTER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            labelPuzzleStatus.setStyle("textAlign",param1);
         },"labelPuzzleStatus.textAlign");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = TextAlign.CENTER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            labelSolutionWord.setStyle("textAlign",param1);
         },"labelSolutionWord.textAlign");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get labelPuzzleDescription() : Label
      {
         return this._1407815606labelPuzzleDescription;
      }
      
      public function set labelPuzzleDescription(param1:Label) : void
      {
         var _loc2_:Object = this._1407815606labelPuzzleDescription;
         if(_loc2_ !== param1)
         {
            this._1407815606labelPuzzleDescription = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelPuzzleDescription",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get labelPuzzleStatus() : Label
      {
         return this._1868688100labelPuzzleStatus;
      }
      
      public function set labelPuzzleStatus(param1:Label) : void
      {
         var _loc2_:Object = this._1868688100labelPuzzleStatus;
         if(_loc2_ !== param1)
         {
            this._1868688100labelPuzzleStatus = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelPuzzleStatus",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get labelSolutionWord() : Label
      {
         return this._164702519labelSolutionWord;
      }
      
      public function set labelSolutionWord(param1:Label) : void
      {
         var _loc2_:Object = this._164702519labelSolutionWord;
         if(_loc2_ !== param1)
         {
            this._164702519labelSolutionWord = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelSolutionWord",_loc2_,param1));
            }
         }
      }
   }
}

