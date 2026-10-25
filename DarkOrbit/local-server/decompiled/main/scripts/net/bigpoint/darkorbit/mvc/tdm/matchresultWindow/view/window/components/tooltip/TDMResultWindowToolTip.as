package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.tooltip
{
   import com.bealearts.collection.VectorCollection;
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
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
   import mx.core.ClassFactory;
   import mx.core.IFlexModuleFactory;
   import mx.core.IToolTip;
   import mx.core.ScrollPolicy;
   import mx.core.mx_internal;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.consts.TDMResultWindowConstants;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo.TDMRewardsModel;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import spark.components.DataGrid;
   import spark.components.gridClasses.GridColumn;
   
   use namespace mx_internal;
   
   public class TDMResultWindowToolTip extends DataGrid implements IBindingClient, IToolTip
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
      
      public var _TDMResultWindowToolTip_GridColumn1:GridColumn;
      
      public var _TDMResultWindowToolTip_GridColumn2:GridColumn;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _rewards:TDMRewardsModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function TDMResultWindowToolTip()
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
         bindings = this._TDMResultWindowToolTip_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_tdm_matchresultWindow_view_window_components_tooltip_TDMResultWindowToolTipWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return TDMResultWindowToolTip[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.styleName = "skinnedListTDM";
         this.variableRowHeight = true;
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.columns = this._TDMResultWindowToolTip_ArrayList1_c();
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         TDMResultWindowToolTip._watcherSetupUtil = param1;
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
      
      public function get text() : String
      {
         return "";
      }
      
      public function set text(param1:String) : void
      {
      }
      
      public function setTitle(param1:String) : void
      {
         (skin as DOToolTipListSkinTDM).headerText = param1;
      }
      
      public function setMessage(param1:String) : void
      {
         (skin as DOToolTipListSkinTDM).messageText = param1;
      }
      
      public function set rewards(param1:TDMRewardsModel) : void
      {
         this._rewards = param1;
         dataProvider = new VectorCollection(this._rewards.rewardList);
      }
      
      private function _TDMResultWindowToolTip_ArrayList1_c() : ArrayList
      {
         var _loc1_:ArrayList = new ArrayList();
         _loc1_.source = [this._TDMResultWindowToolTip_GridColumn1_i(),this._TDMResultWindowToolTip_GridColumn2_i()];
         return _loc1_;
      }
      
      private function _TDMResultWindowToolTip_GridColumn1_i() : GridColumn
      {
         var _loc1_:GridColumn = new GridColumn();
         _loc1_.dataField = "stats";
         _loc1_.minWidth = 150;
         _loc1_.itemRenderer = this._TDMResultWindowToolTip_ClassFactory1_c();
         this._TDMResultWindowToolTip_GridColumn1 = _loc1_;
         BindingManager.executeBindings(this,"_TDMResultWindowToolTip_GridColumn1",this._TDMResultWindowToolTip_GridColumn1);
         return _loc1_;
      }
      
      private function _TDMResultWindowToolTip_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = TDMToolTipRewardItemGridRenderer;
         return _loc1_;
      }
      
      private function _TDMResultWindowToolTip_GridColumn2_i() : GridColumn
      {
         var _loc1_:GridColumn = new GridColumn();
         _loc1_.dataField = "hero";
         _loc1_.minWidth = 150;
         _loc1_.itemRenderer = this._TDMResultWindowToolTip_ClassFactory2_c();
         this._TDMResultWindowToolTip_GridColumn2 = _loc1_;
         BindingManager.executeBindings(this,"_TDMResultWindowToolTip_GridColumn2",this._TDMResultWindowToolTip_GridColumn2);
         return _loc1_;
      }
      
      private function _TDMResultWindowToolTip_ClassFactory2_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = TDMToolTipAmmountGridRenderer;
         return _loc1_;
      }
      
      private function _TDMResultWindowToolTip_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = ScrollPolicy.OFF;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            this.setStyle("verticalScrollPolicy",param1);
         },"this.verticalScrollPolicy");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = ScrollPolicy.OFF;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            this.setStyle("horizontalScrollPolicy",param1);
         },"this.horizontalScrollPolicy");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = HtmlTextUtils.coloriseText(TDMResultWindowConstants.TOOL_TIP_COL_HEADER_COLOR,BPLocale.getItem(TDMResultWindowConstants.TOOLTIP_ITEM_COLUMN_HEADER_TEXT_KEY));
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TDMResultWindowToolTip_GridColumn1.headerText");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = HtmlTextUtils.coloriseText(TDMResultWindowConstants.TOOL_TIP_COL_HEADER_COLOR,BPLocale.getItem(TDMResultWindowConstants.TOOLTIP_AMOUNT_COLUMN_HEADER_TEXT_KEY));
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TDMResultWindowToolTip_GridColumn2.headerText");
         return result;
      }
   }
}

