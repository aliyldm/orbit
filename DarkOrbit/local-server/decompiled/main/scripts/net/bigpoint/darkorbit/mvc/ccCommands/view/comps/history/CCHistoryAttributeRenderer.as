package net.bigpoint.darkorbit.mvc.ccCommands.view.comps.history
{
   import com.bealearts.collection.VectorCollection;
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
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.com.module.CCRequestAttributeModule;
   import net.bigpoint.darkorbit.mvc.ccCommands.view.comps.CCModuleTranslater;
   import spark.components.Label;
   import spark.components.List;
   import spark.components.VGroup;
   import spark.components.supportClasses.ItemRenderer;
   import spark.layouts.VerticalLayout;
   
   use namespace mx_internal;
   
   public class CCHistoryAttributeRenderer extends ItemRenderer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _106934lbl:Label;
      
      private var _107469lst:List;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _attributes:VectorCollection;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CCHistoryAttributeRenderer()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._attributes = new VectorCollection();
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._CCHistoryAttributeRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_ccCommands_view_comps_history_CCHistoryAttributeRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return CCHistoryAttributeRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContent = [this._CCHistoryAttributeRenderer_VGroup1_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         CCHistoryAttributeRenderer._watcherSetupUtil = param1;
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
      protected function get cmdData() : CCRequestAttributeModule
      {
         return data as CCRequestAttributeModule;
      }
      
      private function _CCHistoryAttributeRenderer_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.autoLayout = true;
         _loc1_.mxmlContent = [this._CCHistoryAttributeRenderer_Label1_i(),this._CCHistoryAttributeRenderer_List1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CCHistoryAttributeRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "lbl";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.lbl = _loc1_;
         BindingManager.executeBindings(this,"lbl",this.lbl);
         return _loc1_;
      }
      
      private function _CCHistoryAttributeRenderer_List1_i() : List
      {
         var _loc1_:List = new List();
         _loc1_.autoLayout = true;
         _loc1_.percentWidth = 100;
         _loc1_.left = 10;
         _loc1_.itemRenderer = this._CCHistoryAttributeRenderer_ClassFactory1_c();
         _loc1_.layout = this._CCHistoryAttributeRenderer_VerticalLayout1_c();
         _loc1_.id = "lst";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.lst = _loc1_;
         BindingManager.executeBindings(this,"lst",this.lst);
         return _loc1_;
      }
      
      private function _CCHistoryAttributeRenderer_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = CCHistoryAttributeRenderer;
         return _loc1_;
      }
      
      private function _CCHistoryAttributeRenderer_VerticalLayout1_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.useVirtualLayout = false;
         _loc1_.requestedMinRowCount = 1;
         return _loc1_;
      }
      
      private function _CCHistoryAttributeRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = CCModuleTranslater.toHistoryString(cmdData.value);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"lbl.text");
         result[1] = new Binding(this,function():Boolean
         {
            return cmdData.subAttributes.length > 0;
         },null,"lst.visible");
         result[2] = new Binding(this,function():uint
         {
            return 9487316;
         },function(param1:uint):void
         {
            lst.setStyle("contentBackgroundColor",param1);
         },"lst.contentBackgroundColor");
         result[3] = new Binding(this,function():IList
         {
            return _attributes;
         },null,"lst.dataProvider");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get lbl() : Label
      {
         return this._106934lbl;
      }
      
      public function set lbl(param1:Label) : void
      {
         var _loc2_:Object = this._106934lbl;
         if(_loc2_ !== param1)
         {
            this._106934lbl = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lbl",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lst() : List
      {
         return this._107469lst;
      }
      
      public function set lst(param1:List) : void
      {
         var _loc2_:Object = this._107469lst;
         if(_loc2_ !== param1)
         {
            this._107469lst = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lst",_loc2_,param1));
            }
         }
      }
   }
}

