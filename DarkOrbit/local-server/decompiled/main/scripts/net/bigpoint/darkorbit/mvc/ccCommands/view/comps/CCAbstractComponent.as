package net.bigpoint.darkorbit.mvc.ccCommands.view.comps
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
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.com.module.CCAttributeModule;
   import net.bigpoint.darkorbit.com.module.CCRequestAttributeModule;
   import net.bigpoint.darkorbit.com.module.CCValueModule;
   import spark.components.DataGroup;
   import spark.components.List;
   import spark.components.VGroup;
   import spark.components.supportClasses.ItemRenderer;
   import spark.layouts.VerticalLayout;
   
   use namespace mx_internal;
   
   public class CCAbstractComponent extends ItemRenderer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _98629247group:VGroup;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      protected var _90810505_data:CCAttributeModule;
      
      protected var _list:List;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CCAbstractComponent()
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
         bindings = this._CCAbstractComponent_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_ccCommands_view_comps_CCAbstractComponentWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return CCAbstractComponent[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.percentWidth = 100;
         this.mxmlContent = [this._CCAbstractComponent_VGroup1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         CCAbstractComponent._watcherSetupUtil = param1;
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
         var _loc2_:VerticalLayout = null;
         super.data = param1;
         this._data = param1 as CCAttributeModule;
         if(this._data.subAttributes.length > 0)
         {
            this._list = new List();
            this._list.selectedIndex = 0;
            this._list.setStyle("contentBackgroundAlpha",0.5);
            _loc2_ = new VerticalLayout();
            _loc2_.useVirtualLayout = false;
            _loc2_.requestedMinRowCount = 1;
            this._list.layout = _loc2_;
            this._list.itemRendererFunction = CCComponentFactorySingleton.getRendererForType;
            this._list.dataProvider = new VectorCollection(this._data.subAttributes);
            if(!this._data.singleAttributeSelection)
            {
               this._list.setStyle("contentBackgroundAlpha",1);
               this._list.setStyle("selectionColor",16777215);
               this._list.setStyle("contentBackgroundColor",16777215);
               this._list.setStyle("rollOverColor",16777215);
            }
            this.group.addElement(this._list);
         }
      }
      
      public function get currentData() : CCValueModule
      {
         return null;
      }
      
      public function getItemRenderer(param1:List, param2:Object) : CCAbstractComponent
      {
         var _loc6_:CCAbstractComponent = null;
         var _loc3_:DataGroup = param1.dataGroup;
         var _loc4_:int = _loc3_.numElements;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_.getElementAt(_loc5_) as CCAbstractComponent;
            if((Boolean(_loc6_)) && _loc6_.data == param2)
            {
               return _loc6_;
            }
            _loc5_++;
         }
         return null;
      }
      
      public function getAttributes() : Vector.<CCRequestAttributeModule>
      {
         var _loc1_:Vector.<CCRequestAttributeModule> = null;
         var _loc2_:Vector.<CCRequestAttributeModule> = null;
         var _loc3_:Vector.<CCRequestAttributeModule> = null;
         var _loc4_:CCAbstractComponent = null;
         var _loc5_:DataGroup = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(this._list)
         {
            if(this._data.singleAttributeSelection)
            {
               _loc1_ = this.getItemRenderer(this._list,this._list.selectedItem).getAttributes();
            }
            else
            {
               _loc1_ = new Vector.<CCRequestAttributeModule>();
               _loc5_ = this._list.dataGroup;
               _loc6_ = _loc5_.numElements;
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc4_ = _loc5_.getElementAt(_loc7_) as CCAbstractComponent;
                  if(_loc4_)
                  {
                     _loc3_ = _loc4_.getAttributes();
                     _loc8_ = int(_loc3_.length);
                     _loc9_ = 0;
                     while(_loc9_ < _loc8_)
                     {
                        _loc1_.push(_loc3_[_loc9_]);
                        _loc9_++;
                     }
                  }
                  _loc7_++;
               }
            }
         }
         _loc2_ = new Vector.<CCRequestAttributeModule>();
         _loc2_.push(new CCRequestAttributeModule(_loc1_,this._data.name,this.currentData));
         return _loc2_;
      }
      
      private function _CCAbstractComponent_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.paddingLeft = 15;
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.paddingTop = 5;
         _loc1_.id = "group";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.group = _loc1_;
         BindingManager.executeBindings(this,"group",this.group);
         return _loc1_;
      }
      
      private function _CCAbstractComponent_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = _data.toolTip;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"this.toolTip");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get group() : VGroup
      {
         return this._98629247group;
      }
      
      public function set group(param1:VGroup) : void
      {
         var _loc2_:Object = this._98629247group;
         if(_loc2_ !== param1)
         {
            this._98629247group = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"group",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get _data() : CCAttributeModule
      {
         return this._90810505_data;
      }
      
      protected function set _data(param1:CCAttributeModule) : void
      {
         var _loc2_:Object = this._90810505_data;
         if(_loc2_ !== param1)
         {
            this._90810505_data = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_data",_loc2_,param1));
            }
         }
      }
   }
}

