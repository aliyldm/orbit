package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.skins
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
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.components.renderers.TeamDeathMatchLobbyWindowItemListHeaderRenderer;
   import spark.components.gridClasses.GridItemRenderer;
   
   use namespace mx_internal;
   
   public class TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass4 extends GridItemRenderer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass4_TeamDeathMatchLobbyWindowItemListHeaderRenderer1:TeamDeathMatchLobbyWindowItemListHeaderRenderer;
      
      private var _88844982outerDocument:TeamDeathMatchLobbyWindowMatchoverviewSkin;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass4()
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
         bindings = this._TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass4_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_tdm_lobbyWindow_view_skins_TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass4WatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass4[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContent = [this._TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass4_TeamDeathMatchLobbyWindowItemListHeaderRenderer1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass4._watcherSetupUtil = param1;
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
      
      private function _TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass4_TeamDeathMatchLobbyWindowItemListHeaderRenderer1_i() : TeamDeathMatchLobbyWindowItemListHeaderRenderer
      {
         var _loc1_:TeamDeathMatchLobbyWindowItemListHeaderRenderer = new TeamDeathMatchLobbyWindowItemListHeaderRenderer();
         _loc1_.id = "_TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass4_TeamDeathMatchLobbyWindowItemListHeaderRenderer1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass4_TeamDeathMatchLobbyWindowItemListHeaderRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass4_TeamDeathMatchLobbyWindowItemListHeaderRenderer1",this._TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass4_TeamDeathMatchLobbyWindowItemListHeaderRenderer1);
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass4_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = column.headerText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass4_TeamDeathMatchLobbyWindowItemListHeaderRenderer1.headerText");
         result[1] = new Binding(this,function():int
         {
            return column.columnIndex;
         },null,"_TeamDeathMatchLobbyWindowMatchoverviewSkinInnerClass4_TeamDeathMatchLobbyWindowItemListHeaderRenderer1.columnIndex");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get outerDocument() : TeamDeathMatchLobbyWindowMatchoverviewSkin
      {
         return this._88844982outerDocument;
      }
      
      public function set outerDocument(param1:TeamDeathMatchLobbyWindowMatchoverviewSkin) : void
      {
         var _loc2_:Object = this._88844982outerDocument;
         if(_loc2_ !== param1)
         {
            this._88844982outerDocument = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"outerDocument",_loc2_,param1));
            }
         }
      }
   }
}

