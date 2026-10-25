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
   import mx.collections.IList;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.states.SetProperty;
   import mx.states.State;
   import mx.styles.*;
   import net.bigpoint.darkorbit.com.module.CCRequestAttributeModule;
   import net.bigpoint.darkorbit.com.module.CCommandModule;
   import net.bigpoint.darkorbit.com.module.CCommandRequest;
   import spark.components.Button;
   import spark.components.DataGroup;
   import spark.components.Group;
   import spark.components.List;
   import spark.components.Panel;
   import spark.layouts.BasicLayout;
   import spark.layouts.VerticalLayout;
   
   use namespace mx_internal;
   
   public class CCCRootCommandPanel extends spark.components.Group implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _1377687758button:Button;
      
      private var _98629247group:spark.components.Group;
      
      private var _3322014list:List;
      
      private var _106433028panel:Panel;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _90810505_data:CCommandModule;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CCCRootCommandPanel()
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
         bindings = this._CCCRootCommandPanel_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_ccCommands_view_comps_CCCRootCommandPanelWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return CCCRootCommandPanel[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.top = 0;
         this.left = 0;
         this.right = 0;
         this.mxmlContent = [this._CCCRootCommandPanel_Panel1_i()];
         this.currentState = "normal";
         states = [new State({
            "name":"normal",
            "overrides":[new SetProperty().initializeFromObject({
               "target":"panel",
               "name":"height",
               "value":3
            }),new SetProperty().initializeFromObject({
               "target":"group",
               "name":"height",
               "value":0
            }),new SetProperty().initializeFromObject({
               "target":"group",
               "name":"visible",
               "value":false
            }),new SetProperty().initializeFromObject({
               "target":"group",
               "name":"layout",
               "value":this._CCCRootCommandPanel_BasicLayout1_c()
            })]
         }),new State({
            "name":"selected",
            "overrides":[new SetProperty().initializeFromObject({
               "target":"panel",
               "name":"percentHeight",
               "value":100
            }),new SetProperty().initializeFromObject({
               "target":"group",
               "name":"percentHeight",
               "value":100
            }),new SetProperty().initializeFromObject({
               "target":"group",
               "name":"visible",
               "value":true
            }),new SetProperty().initializeFromObject({
               "target":"group",
               "name":"layout",
               "value":this._CCCRootCommandPanel_VerticalLayout1_c()
            }),new SetProperty().initializeFromObject({
               "target":"list",
               "name":"layout",
               "value":this._CCCRootCommandPanel_VerticalLayout2_c()
            })]
         })];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         CCCRootCommandPanel._watcherSetupUtil = param1;
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
      
      public function set rootData(param1:CCommandModule) : void
      {
         this._data = param1;
         this.panel.title = param1.name;
         this.button.addEventListener(MouseEvent.CLICK,this.listener);
      }
      
      override public function set currentState(param1:String) : void
      {
         super.currentState = param1;
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
      
      private function listener(param1:MouseEvent) : void
      {
         var _loc3_:Vector.<CCRequestAttributeModule> = null;
         var _loc2_:CCAbstractComponent = this.getItemRenderer(this.list,this.list.selectedItem);
         if(_loc2_)
         {
            _loc3_ = _loc2_.getAttributes();
         }
         var _loc4_:CCommandRequest = new CCommandRequest(this._data.name,_loc3_);
         dispatchEvent(new CCEvent(CCEvent.ACTIVATE,_loc4_,true,false));
      }
      
      private function _CCCRootCommandPanel_Panel1_i() : Panel
      {
         var _loc1_:Panel = new Panel();
         _loc1_.percentWidth = 100;
         _loc1_.height = 3;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._CCCRootCommandPanel_Array3_c);
         _loc1_.id = "panel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.panel = _loc1_;
         BindingManager.executeBindings(this,"panel",this.panel);
         return _loc1_;
      }
      
      private function _CCCRootCommandPanel_Array3_c() : Array
      {
         return [this._CCCRootCommandPanel_Group2_i()];
      }
      
      private function _CCCRootCommandPanel_Group2_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.height = 0;
         _loc1_.layout = this._CCCRootCommandPanel_BasicLayout2_c();
         _loc1_.mxmlContent = [this._CCCRootCommandPanel_Button1_i(),this._CCCRootCommandPanel_List1_i()];
         _loc1_.id = "group";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.group = _loc1_;
         BindingManager.executeBindings(this,"group",this.group);
         return _loc1_;
      }
      
      private function _CCCRootCommandPanel_BasicLayout2_c() : BasicLayout
      {
         return new BasicLayout();
      }
      
      private function _CCCRootCommandPanel_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.label = "RUN";
         _loc1_.id = "button";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.button = _loc1_;
         BindingManager.executeBindings(this,"button",this.button);
         return _loc1_;
      }
      
      private function _CCCRootCommandPanel_List1_i() : List
      {
         var _loc1_:List = new List();
         _loc1_.percentWidth = 100;
         _loc1_.selectedIndex = 0;
         _loc1_.id = "list";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.list = _loc1_;
         BindingManager.executeBindings(this,"list",this.list);
         return _loc1_;
      }
      
      private function _CCCRootCommandPanel_BasicLayout1_c() : BasicLayout
      {
         return new BasicLayout();
      }
      
      private function _CCCRootCommandPanel_VerticalLayout1_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 0;
         return _loc1_;
      }
      
      private function _CCCRootCommandPanel_VerticalLayout2_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.requestedMinRowCount = 1;
         _loc1_.useVirtualLayout = false;
         return _loc1_;
      }
      
      private function _CCCRootCommandPanel_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = _data.toolTip;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"this.toolTip");
         result[1] = new Binding(this,function():IList
         {
            return new VectorCollection(_data.args);
         },null,"list.dataProvider");
         result[2] = new Binding(this,function():Boolean
         {
            return false;
         },function(param1:Boolean):void
         {
            list.setStyle("borderVisible",param1);
         },"list.borderVisible");
         result[3] = new Binding(this,function():Function
         {
            return CCComponentFactorySingleton.getRendererForType;
         },null,"list.itemRendererFunction");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get button() : Button
      {
         return this._1377687758button;
      }
      
      public function set button(param1:Button) : void
      {
         var _loc2_:Object = this._1377687758button;
         if(_loc2_ !== param1)
         {
            this._1377687758button = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"button",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get group() : spark.components.Group
      {
         return this._98629247group;
      }
      
      public function set group(param1:spark.components.Group) : void
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
      public function get list() : List
      {
         return this._3322014list;
      }
      
      public function set list(param1:List) : void
      {
         var _loc2_:Object = this._3322014list;
         if(_loc2_ !== param1)
         {
            this._3322014list = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"list",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get panel() : Panel
      {
         return this._106433028panel;
      }
      
      public function set panel(param1:Panel) : void
      {
         var _loc2_:Object = this._106433028panel;
         if(_loc2_ !== param1)
         {
            this._106433028panel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"panel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _data() : CCommandModule
      {
         return this._90810505_data;
      }
      
      private function set _data(param1:CCommandModule) : void
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

