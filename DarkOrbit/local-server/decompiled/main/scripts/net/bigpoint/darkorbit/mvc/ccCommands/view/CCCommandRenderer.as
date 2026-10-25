package net.bigpoint.darkorbit.mvc.ccCommands.view
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
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.states.SetProperty;
   import mx.states.State;
   import mx.styles.*;
   import net.bigpoint.darkorbit.com.module.CCommandModule;
   import net.bigpoint.darkorbit.mvc.ccCommands.view.comps.CCCRootCommandPanel;
   import spark.components.supportClasses.ItemRenderer;
   
   use namespace mx_internal;
   
   public class CCCommandRenderer extends ItemRenderer implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _1945488765_CCCommandRenderer_CCCRootCommandPanel1:CCCRootCommandPanel;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CCCommandRenderer()
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
         bindings = this._CCCommandRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_ccCommands_view_CCCommandRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return CCCommandRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContent = [this._CCCommandRenderer_CCCRootCommandPanel1_i()];
         this.currentState = "normal";
         states = [new State({
            "name":"normal",
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_CCCommandRenderer_CCCRootCommandPanel1",
               "name":"height",
               "value":33
            })]
         }),new State({
            "name":"selected",
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_CCCommandRenderer_CCCRootCommandPanel1",
               "name":"percentHeight",
               "value":100
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
         CCCommandRenderer._watcherSetupUtil = param1;
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
      protected function get cmdData() : CCommandModule
      {
         return data as CCommandModule;
      }
      
      private function _CCCommandRenderer_CCCRootCommandPanel1_i() : CCCRootCommandPanel
      {
         var _loc1_:CCCRootCommandPanel = new CCCRootCommandPanel();
         _loc1_.percentWidth = 100;
         _loc1_.height = 33;
         _loc1_.id = "_CCCommandRenderer_CCCRootCommandPanel1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._CCCommandRenderer_CCCRootCommandPanel1 = _loc1_;
         BindingManager.executeBindings(this,"_CCCommandRenderer_CCCRootCommandPanel1",this._CCCommandRenderer_CCCRootCommandPanel1);
         return _loc1_;
      }
      
      private function _CCCommandRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():CCommandModule
         {
            return cmdData;
         },null,"_CCCommandRenderer_CCCRootCommandPanel1.rootData");
         result[1] = new Binding(this,null,null,"_CCCommandRenderer_CCCRootCommandPanel1.currentState","currentState");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get _CCCommandRenderer_CCCRootCommandPanel1() : CCCRootCommandPanel
      {
         return this._1945488765_CCCommandRenderer_CCCRootCommandPanel1;
      }
      
      public function set _CCCommandRenderer_CCCRootCommandPanel1(param1:CCCRootCommandPanel) : void
      {
         var _loc2_:Object = this._1945488765_CCCommandRenderer_CCCRootCommandPanel1;
         if(_loc2_ !== param1)
         {
            this._1945488765_CCCommandRenderer_CCCRootCommandPanel1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_CCCommandRenderer_CCCRootCommandPanel1",_loc2_,param1));
            }
         }
      }
   }
}

