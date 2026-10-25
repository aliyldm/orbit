package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.components
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
   import mx.core.ClassFactory;
   import mx.core.IFlexModuleFactory;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.SectorControlConstants;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.components.renderers.TeamDeathMatchLobbyWindowOpponentCellRenderer;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.components.renderers.TeamDeathMatchLobbyWindowPlayersCellRenderer;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.components.renderers.TeamDeathMatchLobbyWindowPointsCellRenderer;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.components.renderers.TeamDeathMatchLobbyWindowQueueCellRenderer;
   import spark.components.DataGrid;
   import spark.components.gridClasses.GridColumn;
   
   public class TeamDeathMatchLobbyWindowItemList extends DataGrid
   {
      
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
      
      private var _1067556141columnOpponent:GridColumn;
      
      private var _544210473columnPlayer:GridColumn;
      
      private var _541211687columnPoints:GridColumn;
      
      private var _847643813columnQueue:GridColumn;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function TeamDeathMatchLobbyWindowItemList()
      {
         super();
         this.columns = this._TeamDeathMatchLobbyWindowItemList_ArrayList1_c();
         this.addEventListener("preinitialize",this.___TeamDeathMatchLobbyWindowItemList_DataGrid1_preinitialize);
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
      
      public function preInitialize() : void
      {
         this.columnQueue.headerText = BPLocale.getItem("sectorcontrol_lobby_window_grid_headerlabel_queue");
         var _loc1_:Array = InGameCatalog.getInstance().factions_names;
         var _loc2_:String = _loc1_[Hero.factionID.value];
         var _loc3_:String = BPLocale.getItem("sectorcontrol_lobby_window_grid_headerlabel_faction");
         _loc3_ = _loc3_.replace(SectorControlConstants.LOCALIZATION_PLACEHOLDER__COMPANY,_loc2_);
         var _loc4_:String = BPLocale.getItem("sectorcontrol_lobby_window_grid_headerlabel_tickets");
         _loc4_ = _loc4_.replace(SectorControlConstants.LOCALIZATION_PLACEHOLDER__COMPANY,_loc2_);
      }
      
      private function _TeamDeathMatchLobbyWindowItemList_ArrayList1_c() : ArrayList
      {
         var _loc1_:ArrayList = new ArrayList();
         _loc1_.source = [this._TeamDeathMatchLobbyWindowItemList_GridColumn1_i(),this._TeamDeathMatchLobbyWindowItemList_GridColumn2_i(),this._TeamDeathMatchLobbyWindowItemList_GridColumn3_i(),this._TeamDeathMatchLobbyWindowItemList_GridColumn4_i()];
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbyWindowItemList_GridColumn1_i() : GridColumn
      {
         var _loc1_:GridColumn = new GridColumn();
         _loc1_.headerText = "Opponent";
         _loc1_.itemRenderer = this._TeamDeathMatchLobbyWindowItemList_ClassFactory1_c();
         this.columnOpponent = _loc1_;
         BindingManager.executeBindings(this,"columnOpponent",this.columnOpponent);
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbyWindowItemList_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = TeamDeathMatchLobbyWindowOpponentCellRenderer;
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbyWindowItemList_GridColumn2_i() : GridColumn
      {
         var _loc1_:GridColumn = new GridColumn();
         _loc1_.dataField = "columnPlayer";
         _loc1_.headerText = "Players";
         _loc1_.itemRenderer = this._TeamDeathMatchLobbyWindowItemList_ClassFactory2_c();
         this.columnPlayer = _loc1_;
         BindingManager.executeBindings(this,"columnPlayer",this.columnPlayer);
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbyWindowItemList_ClassFactory2_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = TeamDeathMatchLobbyWindowPlayersCellRenderer;
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbyWindowItemList_GridColumn3_i() : GridColumn
      {
         var _loc1_:GridColumn = new GridColumn();
         _loc1_.headerText = "Points";
         _loc1_.itemRenderer = this._TeamDeathMatchLobbyWindowItemList_ClassFactory3_c();
         this.columnPoints = _loc1_;
         BindingManager.executeBindings(this,"columnPoints",this.columnPoints);
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbyWindowItemList_ClassFactory3_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = TeamDeathMatchLobbyWindowPointsCellRenderer;
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbyWindowItemList_GridColumn4_i() : GridColumn
      {
         var _loc1_:GridColumn = new GridColumn();
         _loc1_.headerText = "Players in Queue";
         _loc1_.itemRenderer = this._TeamDeathMatchLobbyWindowItemList_ClassFactory4_c();
         this.columnQueue = _loc1_;
         BindingManager.executeBindings(this,"columnQueue",this.columnQueue);
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbyWindowItemList_ClassFactory4_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = TeamDeathMatchLobbyWindowQueueCellRenderer;
         return _loc1_;
      }
      
      public function ___TeamDeathMatchLobbyWindowItemList_DataGrid1_preinitialize(param1:FlexEvent) : void
      {
         this.preInitialize();
      }
      
      [Bindable(event="propertyChange")]
      public function get columnOpponent() : GridColumn
      {
         return this._1067556141columnOpponent;
      }
      
      public function set columnOpponent(param1:GridColumn) : void
      {
         var _loc2_:Object = this._1067556141columnOpponent;
         if(_loc2_ !== param1)
         {
            this._1067556141columnOpponent = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnOpponent",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get columnPlayer() : GridColumn
      {
         return this._544210473columnPlayer;
      }
      
      public function set columnPlayer(param1:GridColumn) : void
      {
         var _loc2_:Object = this._544210473columnPlayer;
         if(_loc2_ !== param1)
         {
            this._544210473columnPlayer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnPlayer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get columnPoints() : GridColumn
      {
         return this._541211687columnPoints;
      }
      
      public function set columnPoints(param1:GridColumn) : void
      {
         var _loc2_:Object = this._541211687columnPoints;
         if(_loc2_ !== param1)
         {
            this._541211687columnPoints = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnPoints",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get columnQueue() : GridColumn
      {
         return this._847643813columnQueue;
      }
      
      public function set columnQueue(param1:GridColumn) : void
      {
         var _loc2_:Object = this._847643813columnQueue;
         if(_loc2_ !== param1)
         {
            this._847643813columnQueue = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnQueue",_loc2_,param1));
            }
         }
      }
   }
}

