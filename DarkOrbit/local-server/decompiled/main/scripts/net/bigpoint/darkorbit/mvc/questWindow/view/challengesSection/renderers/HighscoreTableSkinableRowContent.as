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
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.questWindow.model.vo.HighscoreVO;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   
   use namespace mx_internal;
   
   public class HighscoreTableSkinableRowContent extends SkinnableContainer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _25619770rowLabel:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _102727412label:String;
      
      private var _1422950650active:Boolean;
      
      private var _855241956columnIndex:int;
      
      public var epppLink:String;
      
      public var dataVO:HighscoreVO = null;
      
      private var hovered:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function HighscoreTableSkinableRowContent()
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
         bindings = this._HighscoreTableSkinableRowContent_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_questWindow_view_challengesSection_renderers_HighscoreTableSkinableRowContentWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return HighscoreTableSkinableRowContent[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._HighscoreTableSkinableRowContent_Array1_c);
         this.addEventListener("creationComplete",this.___HighscoreTableSkinableRowContent_SkinnableContainer1_creationComplete);
         this.addEventListener("rollOver",this.___HighscoreTableSkinableRowContent_SkinnableContainer1_rollOver);
         this.addEventListener("rollOut",this.___HighscoreTableSkinableRowContent_SkinnableContainer1_rollOut);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         HighscoreTableSkinableRowContent._watcherSetupUtil = param1;
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
         this.rowLabel.setStyle("color",getStyle("fontColorActive"));
      }
      
      private function handleRollOver() : void
      {
         this.hovered = true;
         this.updateColor();
      }
      
      private function handleRollOut() : void
      {
         this.hovered = false;
         this.updateColor();
      }
      
      public function updateColor() : void
      {
         if(this.hovered && this.columnIndex == 1)
         {
            this.rowLabel.setStyle("color",getStyle("fontColorHover"));
            this.rowLabel.toolTip = BPLocale.getItem("ttip_questwin_link_eppp");
         }
         else if(this.dataVO != null && this.dataVO.isHero)
         {
            this.rowLabel.setStyle("color",getStyle("fontColor"));
         }
         else
         {
            this.rowLabel.setStyle("color",getStyle("fontColorActive"));
         }
      }
      
      private function _HighscoreTableSkinableRowContent_Array1_c() : Array
      {
         return [this._HighscoreTableSkinableRowContent_Label1_i()];
      }
      
      private function _HighscoreTableSkinableRowContent_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.verticalCenter = 0;
         _loc1_.setStyle("fontSize",11);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("verticalAlign","middle");
         _loc1_.id = "rowLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.rowLabel = _loc1_;
         BindingManager.executeBindings(this,"rowLabel",this.rowLabel);
         return _loc1_;
      }
      
      public function ___HighscoreTableSkinableRowContent_SkinnableContainer1_creationComplete(param1:FlexEvent) : void
      {
         this.creationCompleteHandler(param1);
      }
      
      public function ___HighscoreTableSkinableRowContent_SkinnableContainer1_rollOver(param1:MouseEvent) : void
      {
         this.handleRollOver();
      }
      
      public function ___HighscoreTableSkinableRowContent_SkinnableContainer1_rollOut(param1:MouseEvent) : void
      {
         this.handleRollOut();
      }
      
      private function _HighscoreTableSkinableRowContent_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,null,null,"rowLabel.text","label");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = getStyle("column" + (columnIndex + 1) + "align") || "left";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            rowLabel.setStyle("textAlign",param1);
         },"rowLabel.textAlign");
         result[2] = new Binding(this,function():Number
         {
            return Number(getStyle("paddingTop")) || 0;
         },function(param1:Number):void
         {
            rowLabel.setStyle("paddingTop",param1);
         },"rowLabel.paddingTop");
         result[3] = new Binding(this,function():Number
         {
            return Number(getStyle("paddingRight")) || 0;
         },function(param1:Number):void
         {
            rowLabel.setStyle("paddingRight",param1);
         },"rowLabel.paddingRight");
         result[4] = new Binding(this,function():Number
         {
            return Number(getStyle("paddingBottom")) || 0;
         },function(param1:Number):void
         {
            rowLabel.setStyle("paddingBottom",param1);
         },"rowLabel.paddingBottom");
         result[5] = new Binding(this,function():Number
         {
            return Number(getStyle("paddingLeft")) || 0;
         },function(param1:Number):void
         {
            rowLabel.setStyle("paddingLeft",param1);
         },"rowLabel.paddingLeft");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get rowLabel() : Label
      {
         return this._25619770rowLabel;
      }
      
      public function set rowLabel(param1:Label) : void
      {
         var _loc2_:Object = this._25619770rowLabel;
         if(_loc2_ !== param1)
         {
            this._25619770rowLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get label() : String
      {
         return this._102727412label;
      }
      
      public function set label(param1:String) : void
      {
         var _loc2_:Object = this._102727412label;
         if(_loc2_ !== param1)
         {
            this._102727412label = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"label",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get active() : Boolean
      {
         return this._1422950650active;
      }
      
      public function set active(param1:Boolean) : void
      {
         var _loc2_:Object = this._1422950650active;
         if(_loc2_ !== param1)
         {
            this._1422950650active = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"active",_loc2_,param1));
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

