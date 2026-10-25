package net.bigpoint.darkorbit.mvc.companyhierarchy.itemrenderers
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
   import net.bigpoint.darkorbit.mvc.companyhierarchy.model.vo.IRankedClanViewData;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.model.vo.RankedClanVO;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.view.components.RankedClanItem;
   import spark.components.supportClasses.ItemRenderer;
   
   use namespace mx_internal;
   
   public class RankedClanItemRenderer extends ItemRenderer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _112728rci:RankedClanItem;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function RankedClanItemRenderer()
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
         bindings = this._RankedClanItemRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_companyhierarchy_itemrenderers_RankedClanItemRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return RankedClanItemRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.percentWidth = 100;
         this.mxmlContent = [this._RankedClanItemRenderer_RankedClanItem1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         RankedClanItemRenderer._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         var factory:IFlexModuleFactory = param1;
         super.moduleFactory = factory;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration(null,styleManager);
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.focusColor = 16711680;
         };
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override protected function set hovered(param1:Boolean) : void
      {
         super.hovered = false;
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = false;
         this.showsCaret = false;
      }
      
      private function _RankedClanItemRenderer_RankedClanItem1_i() : RankedClanItem
      {
         var _loc1_:RankedClanItem = new RankedClanItem();
         _loc1_.percentWidth = 100;
         _loc1_.id = "rci";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.rci = _loc1_;
         BindingManager.executeBindings(this,"rci",this.rci);
         return _loc1_;
      }
      
      private function _RankedClanItemRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():IRankedClanViewData
         {
            return data as RankedClanVO;
         },null,"rci.rankedClanVO");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get rci() : RankedClanItem
      {
         return this._112728rci;
      }
      
      public function set rci(param1:RankedClanItem) : void
      {
         var _loc2_:Object = this._112728rci;
         if(_loc2_ !== param1)
         {
            this._112728rci = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rci",_loc2_,param1));
            }
         }
      }
   }
}

