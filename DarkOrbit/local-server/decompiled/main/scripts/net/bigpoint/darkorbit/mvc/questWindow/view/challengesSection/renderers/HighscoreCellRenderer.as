package net.bigpoint.darkorbit.mvc.questWindow.view.challengesSection.renderers
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
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.mvc.questWindow.model.vo.HighscoreVO;
   import spark.components.gridClasses.GridItemRenderer;
   
   use namespace mx_internal;
   
   public class HighscoreCellRenderer extends GridItemRenderer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _2113160650rendererContent:HighscoreTableSkinableRowContent;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function HighscoreCellRenderer()
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
         bindings = this._HighscoreCellRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_questWindow_view_challengesSection_renderers_HighscoreCellRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return HighscoreCellRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.clipAndEnableScrolling = true;
         this.mxmlContent = [this._HighscoreCellRenderer_HighscoreTableSkinableRowContent1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         HighscoreCellRenderer._watcherSetupUtil = param1;
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
      
      private function updateColor() : void
      {
         this.rendererContent.updateColor();
      }
      
      private function _HighscoreCellRenderer_HighscoreTableSkinableRowContent1_i() : HighscoreTableSkinableRowContent
      {
         var _loc1_:HighscoreTableSkinableRowContent = new HighscoreTableSkinableRowContent();
         _loc1_.styleName = "skinnedDataGridRow";
         _loc1_.percentWidth = 105555550;
         _loc1_.addEventListener("render",this.__rendererContent_render);
         _loc1_.id = "rendererContent";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.rendererContent = _loc1_;
         BindingManager.executeBindings(this,"rendererContent",this.rendererContent);
         return _loc1_;
      }
      
      public function __rendererContent_render(param1:Event) : void
      {
         this.updateColor();
      }
      
      private function _HighscoreCellRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = HighscoreVO(data).getField(column.dataField);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"rendererContent.label");
         result[1] = new Binding(this,function():Boolean
         {
            return HighscoreVO(data).active;
         },null,"rendererContent.active");
         result[2] = new Binding(this,function():int
         {
            return column.columnIndex;
         },null,"rendererContent.columnIndex");
         result[3] = new Binding(this,function():HighscoreVO
         {
            return HighscoreVO(data);
         },null,"rendererContent.dataVO");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get rendererContent() : HighscoreTableSkinableRowContent
      {
         return this._2113160650rendererContent;
      }
      
      public function set rendererContent(param1:HighscoreTableSkinableRowContent) : void
      {
         var _loc2_:Object = this._2113160650rendererContent;
         if(_loc2_ !== param1)
         {
            this._2113160650rendererContent = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rendererContent",_loc2_,param1));
            }
         }
      }
   }
}

