package net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.renderers
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
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.SectorControlConstants;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   
   use namespace mx_internal;
   
   public class SectorControlLobbyWindowItemListHeaderRenderer extends SkinnableContainer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _1166031975headerLabel:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _1977519450headerText:String;
      
      private var _855241956columnIndex:int;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SectorControlLobbyWindowItemListHeaderRenderer()
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
         bindings = this._SectorControlLobbyWindowItemListHeaderRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_sectorControlWindow_view_components_renderers_SectorControlLobbyWindowItemListHeaderRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return SectorControlLobbyWindowItemListHeaderRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.percentWidth = 100;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._SectorControlLobbyWindowItemListHeaderRenderer_Array1_c);
         this.addEventListener("creationComplete",this.___SectorControlLobbyWindowItemListHeaderRenderer_SkinnableContainer1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SectorControlLobbyWindowItemListHeaderRenderer._watcherSetupUtil = param1;
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
      }
      
      private function _SectorControlLobbyWindowItemListHeaderRenderer_Array1_c() : Array
      {
         return [this._SectorControlLobbyWindowItemListHeaderRenderer_Label1_i()];
      }
      
      private function _SectorControlLobbyWindowItemListHeaderRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.verticalCenter = 2;
         _loc1_.setStyle("fontSize",12);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("verticalAlign","middle");
         _loc1_.id = "headerLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.headerLabel = _loc1_;
         BindingManager.executeBindings(this,"headerLabel",this.headerLabel);
         return _loc1_;
      }
      
      public function ___SectorControlLobbyWindowItemListHeaderRenderer_SkinnableContainer1_creationComplete(param1:FlexEvent) : void
      {
         this.creationCompleteHandler(param1);
      }
      
      private function _SectorControlLobbyWindowItemListHeaderRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,null,null,"headerLabel.text","headerText");
         result[1] = new Binding(this,function():uint
         {
            return SectorControlConstants.LOBBY_LABEL_GRIDHEADER_COLOR;
         },function(param1:uint):void
         {
            headerLabel.setStyle("color",param1);
         },"headerLabel.color");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get headerLabel() : Label
      {
         return this._1166031975headerLabel;
      }
      
      public function set headerLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1166031975headerLabel;
         if(_loc2_ !== param1)
         {
            this._1166031975headerLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get headerText() : String
      {
         return this._1977519450headerText;
      }
      
      public function set headerText(param1:String) : void
      {
         var _loc2_:Object = this._1977519450headerText;
         if(_loc2_ !== param1)
         {
            this._1977519450headerText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerText",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get columnIndex() : int
      {
         return this._855241956columnIndex;
      }
      
      public function set columnIndex(param1:int) : void
      {
         var _loc2_:Object = this._855241956columnIndex;
         if(_loc2_ !== param1)
         {
            this._855241956columnIndex = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnIndex",_loc2_,param1));
            }
         }
      }
   }
}

