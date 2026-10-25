package net.bigpoint.darkorbit.mvc.ccCommands.view.comps.history
{
   import com.bealearts.collection.VectorCollection;
   import com.greensock.TweenMax;
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
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.states.SetProperty;
   import mx.states.State;
   import mx.styles.*;
   import net.bigpoint.darkorbit.mvc.ccCommands.model.CCHistoryEntry;
   import net.bigpoint.darkorbit.mvc.ccCommands.view.comps.CCEvent;
   import net.bigpoint.darkorbit.utils.BPLocaleUtils;
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.List;
   import spark.components.Panel;
   import spark.layouts.BasicLayout;
   import spark.layouts.VerticalLayout;
   
   use namespace mx_internal;
   
   public class CCCRootHistoryPanel extends spark.components.Group implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _931209014_CCCRootHistoryPanel_List1:List;
      
      private var _1377687758button:Button;
      
      private var _98629247group:spark.components.Group;
      
      private var _1201180862hotKeyLabel:Label;
      
      private var _1211462926hotkey:Button;
      
      private var _106433028panel:Panel;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _90810505_data:CCHistoryEntry;
      
      private var _1493958390_attributes:VectorCollection;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CCCRootHistoryPanel()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._1493958390_attributes = new VectorCollection();
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._CCCRootHistoryPanel_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_ccCommands_view_comps_history_CCCRootHistoryPanelWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return CCCRootHistoryPanel[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.top = 0;
         this.left = 0;
         this.right = 0;
         this.mxmlContent = [this._CCCRootHistoryPanel_Panel1_i()];
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
               "value":this._CCCRootHistoryPanel_BasicLayout1_c()
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
               "value":this._CCCRootHistoryPanel_VerticalLayout1_c()
            }),new SetProperty().initializeFromObject({
               "target":"_CCCRootHistoryPanel_List1",
               "name":"layout",
               "value":this._CCCRootHistoryPanel_VerticalLayout2_c()
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
         CCCRootHistoryPanel._watcherSetupUtil = param1;
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
      
      public function set rootData(param1:CCHistoryEntry) : void
      {
         this._data = param1;
         this._attributes.source = this._data.request.attributes;
         toolTip = this._data.request.name;
         this.panel.title = param1.request.name;
         this.hotKeyLabel.text = this._data.key == -1 ? "NO-KEY" : BPLocaleUtils.getKeyboardChar(this._data.key);
         this.button.addEventListener(MouseEvent.CLICK,this.run);
         this.hotkey.addEventListener(MouseEvent.CLICK,this.assingHotkey);
      }
      
      private function run(param1:MouseEvent) : void
      {
         dispatchEvent(new CCEvent(CCEvent.ACTIVATE,this._data.request,true,false));
      }
      
      private function assingHotkey(param1:MouseEvent) : void
      {
         TweenMax.to(this.hotkey,0.2,{
            "yoyo":true,
            "repeat":-1,
            "glowFilter":{
               "color":16711680,
               "alpha":1,
               "blurX":20,
               "blurY":20
            }
         });
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
      }
      
      private function handleKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:CCEvent = new CCEvent(CCEvent.HOTKEY,this._data.request,true,false);
         _loc2_.data = param1.keyCode == Keyboard.ESCAPE ? -1 : param1.keyCode;
         dispatchEvent(_loc2_);
         TweenMax.killTweensOf(this.hotkey,true);
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
      }
      
      private function _CCCRootHistoryPanel_Panel1_i() : Panel
      {
         var _loc1_:Panel = new Panel();
         _loc1_.percentWidth = 100;
         _loc1_.height = 3;
         _loc1_.title = "test";
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._CCCRootHistoryPanel_Array3_c);
         _loc1_.id = "panel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.panel = _loc1_;
         BindingManager.executeBindings(this,"panel",this.panel);
         return _loc1_;
      }
      
      private function _CCCRootHistoryPanel_Array3_c() : Array
      {
         return [this._CCCRootHistoryPanel_Group2_i()];
      }
      
      private function _CCCRootHistoryPanel_Group2_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.percentWidth = 100;
         _loc1_.height = 0;
         _loc1_.layout = this._CCCRootHistoryPanel_BasicLayout2_c();
         _loc1_.mxmlContent = [this._CCCRootHistoryPanel_HGroup1_c(),this._CCCRootHistoryPanel_List1_i()];
         _loc1_.id = "group";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.group = _loc1_;
         BindingManager.executeBindings(this,"group",this.group);
         return _loc1_;
      }
      
      private function _CCCRootHistoryPanel_BasicLayout2_c() : BasicLayout
      {
         return new BasicLayout();
      }
      
      private function _CCCRootHistoryPanel_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.mxmlContent = [this._CCCRootHistoryPanel_Button1_i(),this._CCCRootHistoryPanel_Button2_i(),this._CCCRootHistoryPanel_Label1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _CCCRootHistoryPanel_Button1_i() : Button
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
      
      private function _CCCRootHistoryPanel_Button2_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.label = "HOTKEY";
         _loc1_.toolTip = "to remove the hotkey assign it to [esc]";
         _loc1_.id = "hotkey";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.hotkey = _loc1_;
         BindingManager.executeBindings(this,"hotkey",this.hotkey);
         return _loc1_;
      }
      
      private function _CCCRootHistoryPanel_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.id = "hotKeyLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.hotKeyLabel = _loc1_;
         BindingManager.executeBindings(this,"hotKeyLabel",this.hotKeyLabel);
         return _loc1_;
      }
      
      private function _CCCRootHistoryPanel_List1_i() : List
      {
         var _loc1_:List = new List();
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         _loc1_.minHeight = 0;
         _loc1_.percentWidth = 100;
         _loc1_.itemRenderer = this._CCCRootHistoryPanel_ClassFactory1_c();
         _loc1_.id = "_CCCRootHistoryPanel_List1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._CCCRootHistoryPanel_List1 = _loc1_;
         BindingManager.executeBindings(this,"_CCCRootHistoryPanel_List1",this._CCCRootHistoryPanel_List1);
         return _loc1_;
      }
      
      private function _CCCRootHistoryPanel_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = CCHistoryAttributeRenderer;
         return _loc1_;
      }
      
      private function _CCCRootHistoryPanel_BasicLayout1_c() : BasicLayout
      {
         return new BasicLayout();
      }
      
      private function _CCCRootHistoryPanel_VerticalLayout1_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 0;
         return _loc1_;
      }
      
      private function _CCCRootHistoryPanel_VerticalLayout2_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.requestedMinRowCount = 1;
         _loc1_.useVirtualLayout = false;
         return _loc1_;
      }
      
      private function _CCCRootHistoryPanel_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():IList
         {
            return _attributes;
         },null,"_CCCRootHistoryPanel_List1.dataProvider");
         result[1] = new Binding(this,function():Boolean
         {
            return true;
         },function(param1:Boolean):void
         {
            _CCCRootHistoryPanel_List1.setStyle("borderVisible",param1);
         },"_CCCRootHistoryPanel_List1.borderVisible");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get _CCCRootHistoryPanel_List1() : List
      {
         return this._931209014_CCCRootHistoryPanel_List1;
      }
      
      public function set _CCCRootHistoryPanel_List1(param1:List) : void
      {
         var _loc2_:Object = this._931209014_CCCRootHistoryPanel_List1;
         if(_loc2_ !== param1)
         {
            this._931209014_CCCRootHistoryPanel_List1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_CCCRootHistoryPanel_List1",_loc2_,param1));
            }
         }
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
      public function get hotKeyLabel() : Label
      {
         return this._1201180862hotKeyLabel;
      }
      
      public function set hotKeyLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1201180862hotKeyLabel;
         if(_loc2_ !== param1)
         {
            this._1201180862hotKeyLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hotKeyLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hotkey() : Button
      {
         return this._1211462926hotkey;
      }
      
      public function set hotkey(param1:Button) : void
      {
         var _loc2_:Object = this._1211462926hotkey;
         if(_loc2_ !== param1)
         {
            this._1211462926hotkey = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hotkey",_loc2_,param1));
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
      private function get _data() : CCHistoryEntry
      {
         return this._90810505_data;
      }
      
      private function set _data(param1:CCHistoryEntry) : void
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
      
      [Bindable(event="propertyChange")]
      private function get _attributes() : VectorCollection
      {
         return this._1493958390_attributes;
      }
      
      private function set _attributes(param1:VectorCollection) : void
      {
         var _loc2_:Object = this._1493958390_attributes;
         if(_loc2_ !== param1)
         {
            this._1493958390_attributes = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_attributes",_loc2_,param1));
            }
         }
      }
   }
}

