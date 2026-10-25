package net.bigpoint.darkorbit.mvc.questWindow.view.challengesSection.renderers
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
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   
   use namespace mx_internal;
   
   public class HighscoreTableSkinableHeaderContent extends SkinnableContainer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _1166031975headerLabel:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _1977519450headerText:String;
      
      private var _855241956columnIndex:int;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function HighscoreTableSkinableHeaderContent()
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
         bindings = this._HighscoreTableSkinableHeaderContent_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_questWindow_view_challengesSection_renderers_HighscoreTableSkinableHeaderContentWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return HighscoreTableSkinableHeaderContent[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._HighscoreTableSkinableHeaderContent_Array1_c);
         this.addEventListener("creationComplete",this.___HighscoreTableSkinableHeaderContent_SkinnableContainer1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         HighscoreTableSkinableHeaderContent._watcherSetupUtil = param1;
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
      
      private function creationCompleteHandler(param1:FlexEvent) : void
      {
         this.headerLabel.setStyle("color",getStyle("fontColor"));
      }
      
      private function _HighscoreTableSkinableHeaderContent_Array1_c() : Array
      {
         return [this._HighscoreTableSkinableHeaderContent_Label1_i()];
      }
      
      private function _HighscoreTableSkinableHeaderContent_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.verticalCenter = 0;
         _loc1_.setStyle("fontSize",10);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("verticalAlign","middle");
         _loc1_.id = "headerLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.headerLabel = _loc1_;
         BindingManager.executeBindings(this,"headerLabel",this.headerLabel);
         return _loc1_;
      }
      
      public function ___HighscoreTableSkinableHeaderContent_SkinnableContainer1_creationComplete(param1:FlexEvent) : void
      {
         this.creationCompleteHandler(param1);
      }
      
      private function _HighscoreTableSkinableHeaderContent_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,null,null,"headerLabel.text","headerText");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = getStyle("column" + (columnIndex + 1) + "align") || "left";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            headerLabel.setStyle("textAlign",param1);
         },"headerLabel.textAlign");
         result[2] = new Binding(this,function():Number
         {
            return Number(getStyle("paddingTop")) || 0;
         },function(param1:Number):void
         {
            headerLabel.setStyle("paddingTop",param1);
         },"headerLabel.paddingTop");
         result[3] = new Binding(this,function():Number
         {
            return Number(getStyle("paddingRight")) || 0;
         },function(param1:Number):void
         {
            headerLabel.setStyle("paddingRight",param1);
         },"headerLabel.paddingRight");
         result[4] = new Binding(this,function():Number
         {
            return Number(getStyle("paddingBottom")) || 0;
         },function(param1:Number):void
         {
            headerLabel.setStyle("paddingBottom",param1);
         },"headerLabel.paddingBottom");
         result[5] = new Binding(this,function():Number
         {
            return Number(getStyle("paddingLeft")) || 0;
         },function(param1:Number):void
         {
            headerLabel.setStyle("paddingLeft",param1);
         },"headerLabel.paddingLeft");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get headerLabel() : Label
      {
         return this._1166031975headerLabel;
      }
      
      public function set headerLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1166031975headerLabel;
         if(_loc2_ !== param1)
         {
            this._1166031975headerLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get headerText() : String
      {
         return this._1977519450headerText;
      }
      
      public function set headerText(param1:String) : void
      {
         var _loc2_:Object = this._1977519450headerText;
         if(_loc2_ !== param1)
         {
            this._1977519450headerText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerText",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get columnIndex() : int
      {
         return this._855241956columnIndex;
      }
      
      public function set columnIndex(param1:int) : void
      {
         var _loc2_:Object = this._855241956columnIndex;
         if(_loc2_ !== param1)
         {
            this._855241956columnIndex = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnIndex",_loc2_,param1));
            }
         }
      }
   }
}

