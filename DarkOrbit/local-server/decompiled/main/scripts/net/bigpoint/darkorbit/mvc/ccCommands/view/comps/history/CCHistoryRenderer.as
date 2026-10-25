package net.bigpoint.darkorbit.mvc.ccCommands.view.comps.history
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
   import net.bigpoint.darkorbit.mvc.ccCommands.model.CCHistoryEntry;
   import spark.components.supportClasses.ItemRenderer;
   
   use namespace mx_internal;
   
   public class CCHistoryRenderer extends ItemRenderer implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _735025053_CCHistoryRenderer_CCCRootHistoryPanel1:CCCRootHistoryPanel;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CCHistoryRenderer()
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
         bindings = this._CCHistoryRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_ccCommands_view_comps_history_CCHistoryRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return CCHistoryRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContent = [this._CCHistoryRenderer_CCCRootHistoryPanel1_i()];
         this.currentState = "normal";
         states = [new State({
            "name":"normal",
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_CCHistoryRenderer_CCCRootHistoryPanel1",
               "name":"height",
               "value":33
            })]
         }),new State({
            "name":"selected",
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_CCHistoryRenderer_CCCRootHistoryPanel1",
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
         CCHistoryRenderer._watcherSetupUtil = param1;
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
      protected function get cmdData() : CCHistoryEntry
      {
         return data as CCHistoryEntry;
      }
      
      private function _CCHistoryRenderer_CCCRootHistoryPanel1_i() : CCCRootHistoryPanel
      {
         var _loc1_:CCCRootHistoryPanel = new CCCRootHistoryPanel();
         _loc1_.percentWidth = 100;
         _loc1_.height = 33;
         _loc1_.id = "_CCHistoryRenderer_CCCRootHistoryPanel1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._CCHistoryRenderer_CCCRootHistoryPanel1 = _loc1_;
         BindingManager.executeBindings(this,"_CCHistoryRenderer_CCCRootHistoryPanel1",this._CCHistoryRenderer_CCCRootHistoryPanel1);
         return _loc1_;
      }
      
      private function _CCHistoryRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():CCHistoryEntry
         {
            return cmdData;
         },null,"_CCHistoryRenderer_CCCRootHistoryPanel1.rootData");
         result[1] = new Binding(this,null,null,"_CCHistoryRenderer_CCCRootHistoryPanel1.currentState","currentState");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get _CCHistoryRenderer_CCCRootHistoryPanel1() : CCCRootHistoryPanel
      {
         return this._735025053_CCHistoryRenderer_CCCRootHistoryPanel1;
      }
      
      public function set _CCHistoryRenderer_CCCRootHistoryPanel1(param1:CCCRootHistoryPanel) : void
      {
         var _loc2_:Object = this._735025053_CCHistoryRenderer_CCCRootHistoryPanel1;
         if(_loc2_ !== param1)
         {
            this._735025053_CCHistoryRenderer_CCCRootHistoryPanel1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_CCHistoryRenderer_CCCRootHistoryPanel1",_loc2_,param1));
            }
         }
      }
   }
}

