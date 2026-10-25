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
   import flashx.textLayout.formats.TextAlign;
   import mx.binding.*;
   import mx.controls.Text;
   import mx.core.IFlexModuleFactory;
   import mx.core.IVisualElement;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.Styles;
   import spark.components.VGroup;
   import spark.components.gridClasses.GridItemRenderer;
   import spark.layouts.VerticalAlign;
   
   use namespace mx_internal;
   
   public class TDMToolTipGridHeadRenderer extends GridItemRenderer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _1095790365columnLabelContainer:VGroup;
      
      private var _25619770rowLabel:Text;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _1977519450headerText:String;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function TDMToolTipGridHeadRenderer()
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
         bindings = this._TDMToolTipGridHeadRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_tdm_matchresultWindow_view_window_components_tooltip_TDMToolTipGridHeadRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return TDMToolTipGridHeadRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.clipAndEnableScrolling = true;
         this.percentWidth = 100;
         this.mxmlContent = [this._TDMToolTipGridHeadRenderer_VGroup1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         TDMToolTipGridHeadRenderer._watcherSetupUtil = param1;
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
         super.data = param1;
      }
      
      override public function set mxmlContent(param1:Array) : void
      {
         var _loc4_:IVisualElement = null;
         var _loc2_:Boolean = true;
         var _loc3_:int = 0;
         while(_loc2_)
         {
            _loc4_ = null;
            try
            {
               _loc4_ = super.getElementAt(_loc3_);
            }
            catch(e:Error)
            {
            }
            if(_loc4_ != null)
            {
               param1.push(_loc4_);
               _loc3_ += 1;
            }
            else
            {
               _loc2_ = false;
            }
         }
         param1.reverse();
         super.mxmlContent = param1;
      }
      
      private function _TDMToolTipGridHeadRenderer_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.height = 24;
         _loc1_.percentWidth = 100;
         _loc1_.verticalCenter = -1;
         _loc1_.mxmlContent = [this._TDMToolTipGridHeadRenderer_Text1_i()];
         _loc1_.id = "columnLabelContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.columnLabelContainer = _loc1_;
         BindingManager.executeBindings(this,"columnLabelContainer",this.columnLabelContainer);
         return _loc1_;
      }
      
      private function _TDMToolTipGridHeadRenderer_Text1_i() : Text
      {
         var _loc1_:Text = new Text();
         _loc1_.percentWidth = 100;
         _loc1_.selectable = false;
         _loc1_.setStyle("fontSize",13);
         _loc1_.id = "rowLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.rowLabel = _loc1_;
         BindingManager.executeBindings(this,"rowLabel",this.rowLabel);
         return _loc1_;
      }
      
      private function _TDMToolTipGridHeadRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = VerticalAlign.MIDDLE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"columnLabelContainer.verticalAlign");
         result[1] = new Binding(this,null,null,"rowLabel.htmlText","headerText");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = TextAlign.CENTER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            rowLabel.setStyle("textAlign",param1);
         },"rowLabel.textAlign");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = Styles.corporateFontRegularFlex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            rowLabel.setStyle("fontFamily",param1);
         },"rowLabel.fontFamily");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get columnLabelContainer() : VGroup
      {
         return this._1095790365columnLabelContainer;
      }
      
      public function set columnLabelContainer(param1:VGroup) : void
      {
         var _loc2_:Object = this._1095790365columnLabelContainer;
         if(_loc2_ !== param1)
         {
            this._1095790365columnLabelContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnLabelContainer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rowLabel() : Text
      {
         return this._25619770rowLabel;
      }
      
      public function set rowLabel(param1:Text) : void
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
   }
}

