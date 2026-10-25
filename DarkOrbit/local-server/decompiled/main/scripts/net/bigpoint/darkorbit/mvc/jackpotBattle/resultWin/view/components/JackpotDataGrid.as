package net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.view.components
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
   import mx.collections.ArrayList;
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.view.renderer.HeroGridRenderer;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.view.renderer.OpponentGridRenderer;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.view.renderer.StatisticsRenderer;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import spark.components.DataGrid;
   import spark.components.gridClasses.GridColumn;
   
   use namespace mx_internal;
   
   public class JackpotDataGrid extends DataGrid implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _skinParts:Object = {
         "rowBackground":false,
         "selectionIndicator":false,
         "editorIndicator":false,
         "columnHeaderGroup":false,
         "caretIndicator":false,
         "grid":false,
         "rowSeparator":false,
         "alternatingRowColorsBackground":false,
         "columnSeparator":false,
         "scroller":false,
         "hoverIndicator":false
      };
      
      public var _JackpotDataGrid_GridColumn1:GridColumn;
      
      public var _JackpotDataGrid_GridColumn2:GridColumn;
      
      public var _JackpotDataGrid_GridColumn3:GridColumn;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _356943468_statsHeadline:String;
      
      private var _1034127536_opponentHeadline:String;
      
      private var _885625293_heroHeadline:String;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function JackpotDataGrid()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._356943468_statsHeadline = HtmlTextUtils.coloriseText(10066329,"Stats");
         this._1034127536_opponentHeadline = HtmlTextUtils.coloriseText(16509188,"opponent");
         this._885625293_heroHeadline = HtmlTextUtils.coloriseText(16509188,"hero");
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         bindings = this._JackpotDataGrid_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_jackpotBattle_resultWin_view_components_JackpotDataGridWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return JackpotDataGrid[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.columns = this._JackpotDataGrid_ArrayList1_c();
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         JackpotDataGrid._watcherSetupUtil = param1;
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
      
      public function set statsHeadline(param1:String) : void
      {
         this._statsHeadline = param1;
      }
      
      public function set opponentHeadline(param1:String) : void
      {
         this._opponentHeadline = param1;
      }
      
      public function set heroHeadline(param1:String) : void
      {
         this._heroHeadline = param1;
      }
      
      override public function set dataProvider(param1:IList) : void
      {
         super.dataProvider = param1;
      }
      
      private function _JackpotDataGrid_ArrayList1_c() : ArrayList
      {
         var _loc1_:ArrayList = new ArrayList();
         _loc1_.source = [this._JackpotDataGrid_GridColumn1_i(),this._JackpotDataGrid_GridColumn2_i(),this._JackpotDataGrid_GridColumn3_i()];
         return _loc1_;
      }
      
      private function _JackpotDataGrid_GridColumn1_i() : GridColumn
      {
         var _loc1_:GridColumn = new GridColumn();
         _loc1_.dataField = "stats";
         _loc1_.itemRenderer = this._JackpotDataGrid_ClassFactory1_c();
         this._JackpotDataGrid_GridColumn1 = _loc1_;
         BindingManager.executeBindings(this,"_JackpotDataGrid_GridColumn1",this._JackpotDataGrid_GridColumn1);
         return _loc1_;
      }
      
      private function _JackpotDataGrid_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = StatisticsRenderer;
         return _loc1_;
      }
      
      private function _JackpotDataGrid_GridColumn2_i() : GridColumn
      {
         var _loc1_:GridColumn = new GridColumn();
         _loc1_.dataField = "hero";
         _loc1_.itemRenderer = this._JackpotDataGrid_ClassFactory2_c();
         this._JackpotDataGrid_GridColumn2 = _loc1_;
         BindingManager.executeBindings(this,"_JackpotDataGrid_GridColumn2",this._JackpotDataGrid_GridColumn2);
         return _loc1_;
      }
      
      private function _JackpotDataGrid_ClassFactory2_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = HeroGridRenderer;
         return _loc1_;
      }
      
      private function _JackpotDataGrid_GridColumn3_i() : GridColumn
      {
         var _loc1_:GridColumn = new GridColumn();
         _loc1_.dataField = "opponent";
         _loc1_.itemRenderer = this._JackpotDataGrid_ClassFactory3_c();
         this._JackpotDataGrid_GridColumn3 = _loc1_;
         BindingManager.executeBindings(this,"_JackpotDataGrid_GridColumn3",this._JackpotDataGrid_GridColumn3);
         return _loc1_;
      }
      
      private function _JackpotDataGrid_ClassFactory3_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = OpponentGridRenderer;
         return _loc1_;
      }
      
      private function _JackpotDataGrid_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = _statsHeadline;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_JackpotDataGrid_GridColumn1.headerText");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = _heroHeadline;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_JackpotDataGrid_GridColumn2.headerText");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = _opponentHeadline;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_JackpotDataGrid_GridColumn3.headerText");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      private function get _statsHeadline() : String
      {
         return this._356943468_statsHeadline;
      }
      
      private function set _statsHeadline(param1:String) : void
      {
         var _loc2_:Object = this._356943468_statsHeadline;
         if(_loc2_ !== param1)
         {
            this._356943468_statsHeadline = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_statsHeadline",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _opponentHeadline() : String
      {
         return this._1034127536_opponentHeadline;
      }
      
      private function set _opponentHeadline(param1:String) : void
      {
         var _loc2_:Object = this._1034127536_opponentHeadline;
         if(_loc2_ !== param1)
         {
            this._1034127536_opponentHeadline = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_opponentHeadline",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _heroHeadline() : String
      {
         return this._885625293_heroHeadline;
      }
      
      private function set _heroHeadline(param1:String) : void
      {
         var _loc2_:Object = this._885625293_heroHeadline;
         if(_loc2_ !== param1)
         {
            this._885625293_heroHeadline = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_heroHeadline",_loc2_,param1));
            }
         }
      }
   }
}

