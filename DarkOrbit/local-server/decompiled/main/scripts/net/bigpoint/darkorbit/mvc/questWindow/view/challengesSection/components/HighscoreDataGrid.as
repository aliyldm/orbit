package net.bigpoint.darkorbit.mvc.questWindow.view.challengesSection.components
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
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ResizeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import spark.components.DataGrid;
   import spark.components.gridClasses.GridColumn;
   
   use namespace mx_internal;
   
   public class HighscoreDataGrid extends DataGrid implements IBindingClient
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
      
      private var _949720987column1:GridColumn;
      
      private var _949720988column2:GridColumn;
      
      private var _949720989column3:GridColumn;
      
      private var _949720990column4:GridColumn;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function HighscoreDataGrid()
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
         bindings = this._HighscoreDataGrid_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_questWindow_view_challengesSection_components_HighscoreDataGridWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return HighscoreDataGrid[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.resizableColumns = false;
         this.columns = this._HighscoreDataGrid_ArrayList1_c();
         this.addEventListener("creationComplete",this.___HighscoreDataGrid_DataGrid1_creationComplete);
         this.addEventListener("resize",this.___HighscoreDataGrid_DataGrid1_resize);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         HighscoreDataGrid._watcherSetupUtil = param1;
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
         this.resizeHandler();
      }
      
      private function resizeHandler(param1:ResizeEvent = null) : void
      {
         this.column1.width = this.width * 0.08;
         this.column2.width = this.width * 0.35;
         this.column3.width = this.width * 0.3;
         this.column4.width = this.width * 0.265;
      }
      
      private function _HighscoreDataGrid_ArrayList1_c() : ArrayList
      {
         var _loc1_:ArrayList = new ArrayList();
         _loc1_.source = [this._HighscoreDataGrid_GridColumn1_i(),this._HighscoreDataGrid_GridColumn2_i(),this._HighscoreDataGrid_GridColumn3_i(),this._HighscoreDataGrid_GridColumn4_i()];
         return _loc1_;
      }
      
      private function _HighscoreDataGrid_GridColumn1_i() : GridColumn
      {
         var _loc1_:GridColumn = new GridColumn();
         _loc1_.dataField = "position";
         _loc1_.headerText = "#";
         this.column1 = _loc1_;
         BindingManager.executeBindings(this,"column1",this.column1);
         return _loc1_;
      }
      
      private function _HighscoreDataGrid_GridColumn2_i() : GridColumn
      {
         var _loc1_:GridColumn = new GridColumn();
         _loc1_.dataField = "playername";
         this.column2 = _loc1_;
         BindingManager.executeBindings(this,"column2",this.column2);
         return _loc1_;
      }
      
      private function _HighscoreDataGrid_GridColumn3_i() : GridColumn
      {
         var _loc1_:GridColumn = new GridColumn();
         _loc1_.dataField = "points";
         this.column3 = _loc1_;
         BindingManager.executeBindings(this,"column3",this.column3);
         return _loc1_;
      }
      
      private function _HighscoreDataGrid_GridColumn4_i() : GridColumn
      {
         var _loc1_:GridColumn = new GridColumn();
         _loc1_.dataField = "difference";
         this.column4 = _loc1_;
         BindingManager.executeBindings(this,"column4",this.column4);
         return _loc1_;
      }
      
      public function ___HighscoreDataGrid_DataGrid1_creationComplete(param1:FlexEvent) : void
      {
         this.creationCompleteHandler(param1);
      }
      
      public function ___HighscoreDataGrid_DataGrid1_resize(param1:ResizeEvent) : void
      {
         this.resizeHandler(param1);
      }
      
      private function _HighscoreDataGrid_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("label_header_playername");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"column2.headerText");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("label_header_points");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"column3.headerText");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = BPLocale.getItem("label_header_difference");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"column4.headerText");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get column1() : GridColumn
      {
         return this._949720987column1;
      }
      
      public function set column1(param1:GridColumn) : void
      {
         var _loc2_:Object = this._949720987column1;
         if(_loc2_ !== param1)
         {
            this._949720987column1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"column1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get column2() : GridColumn
      {
         return this._949720988column2;
      }
      
      public function set column2(param1:GridColumn) : void
      {
         var _loc2_:Object = this._949720988column2;
         if(_loc2_ !== param1)
         {
            this._949720988column2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"column2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get column3() : GridColumn
      {
         return this._949720989column3;
      }
      
      public function set column3(param1:GridColumn) : void
      {
         var _loc2_:Object = this._949720989column3;
         if(_loc2_ !== param1)
         {
            this._949720989column3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"column3",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get column4() : GridColumn
      {
         return this._949720990column4;
      }
      
      public function set column4(param1:GridColumn) : void
      {
         var _loc2_:Object = this._949720990column4;
         if(_loc2_ !== param1)
         {
            this._949720990column4 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"column4",_loc2_,param1));
            }
         }
      }
   }
}

