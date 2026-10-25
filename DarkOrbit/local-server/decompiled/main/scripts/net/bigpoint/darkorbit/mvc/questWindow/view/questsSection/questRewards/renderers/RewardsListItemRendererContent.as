package net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.questRewards.renderers
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
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   
   use namespace mx_internal;
   
   public class RewardsListItemRendererContent extends SkinnableContainer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _1229015684amountLabel:Label;
      
      private var _1675520186rewardNameLabel:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _1691029082rewardName:String;
      
      private var _646772409amountStr:String;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function RewardsListItemRendererContent()
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
         bindings = this._RewardsListItemRendererContent_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_questWindow_view_questsSection_questRewards_renderers_RewardsListItemRendererContentWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return RewardsListItemRendererContent[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._RewardsListItemRendererContent_Array1_c);
         this.addEventListener("creationComplete",this.___RewardsListItemRendererContent_SkinnableContainer1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         RewardsListItemRendererContent._watcherSetupUtil = param1;
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
         this.rewardNameLabel.setStyle("color",getStyle("rewardNameFontColor"));
         this.amountLabel.setStyle("color",getStyle("amountFontColor"));
      }
      
      private function _RewardsListItemRendererContent_Array1_c() : Array
      {
         return [this._RewardsListItemRendererContent_HGroup1_c()];
      }
      
      private function _RewardsListItemRendererContent_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [this._RewardsListItemRendererContent_Label1_i(),this._RewardsListItemRendererContent_Label2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _RewardsListItemRendererContent_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.id = "rewardNameLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.rewardNameLabel = _loc1_;
         BindingManager.executeBindings(this,"rewardNameLabel",this.rewardNameLabel);
         return _loc1_;
      }
      
      private function _RewardsListItemRendererContent_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.id = "amountLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.amountLabel = _loc1_;
         BindingManager.executeBindings(this,"amountLabel",this.amountLabel);
         return _loc1_;
      }
      
      public function ___RewardsListItemRendererContent_SkinnableContainer1_creationComplete(param1:FlexEvent) : void
      {
         this.creationCompleteHandler(param1);
      }
      
      private function _RewardsListItemRendererContent_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,null,null,"rewardNameLabel.text","rewardName");
         result[1] = new Binding(this,function():uint
         {
            return getStyle("rewardNameFontColor");
         },function(param1:uint):void
         {
            rewardNameLabel.setStyle("color",param1);
         },"rewardNameLabel.color");
         result[2] = new Binding(this,function():Number
         {
            return getStyle("labelsPaddingTop");
         },function(param1:Number):void
         {
            rewardNameLabel.setStyle("paddingTop",param1);
         },"rewardNameLabel.paddingTop");
         result[3] = new Binding(this,function():Number
         {
            return getStyle("labelsPaddingBottom");
         },function(param1:Number):void
         {
            rewardNameLabel.setStyle("paddingBottom",param1);
         },"rewardNameLabel.paddingBottom");
         result[4] = new Binding(this,null,null,"amountLabel.text","amountStr");
         result[5] = new Binding(this,function():uint
         {
            return getStyle("amountFontColor");
         },function(param1:uint):void
         {
            amountLabel.setStyle("color",param1);
         },"amountLabel.color");
         result[6] = new Binding(this,function():Number
         {
            return getStyle("labelsPaddingTop");
         },function(param1:Number):void
         {
            amountLabel.setStyle("paddingTop",param1);
         },"amountLabel.paddingTop");
         result[7] = new Binding(this,function():Number
         {
            return getStyle("labelsPaddingBottom");
         },function(param1:Number):void
         {
            amountLabel.setStyle("paddingBottom",param1);
         },"amountLabel.paddingBottom");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get amountLabel() : Label
      {
         return this._1229015684amountLabel;
      }
      
      public function set amountLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1229015684amountLabel;
         if(_loc2_ !== param1)
         {
            this._1229015684amountLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"amountLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rewardNameLabel() : Label
      {
         return this._1675520186rewardNameLabel;
      }
      
      public function set rewardNameLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1675520186rewardNameLabel;
         if(_loc2_ !== param1)
         {
            this._1675520186rewardNameLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rewardNameLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rewardName() : String
      {
         return this._1691029082rewardName;
      }
      
      public function set rewardName(param1:String) : void
      {
         var _loc2_:Object = this._1691029082rewardName;
         if(_loc2_ !== param1)
         {
            this._1691029082rewardName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rewardName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get amountStr() : String
      {
         return this._646772409amountStr;
      }
      
      public function set amountStr(param1:String) : void
      {
         var _loc2_:Object = this._646772409amountStr;
         if(_loc2_ !== param1)
         {
            this._646772409amountStr = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"amountStr",_loc2_,param1));
            }
         }
      }
   }
}

