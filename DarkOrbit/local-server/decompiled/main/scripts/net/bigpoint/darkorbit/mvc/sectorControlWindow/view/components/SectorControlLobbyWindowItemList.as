package net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components
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
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.SectorControlConstants;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.renderers.SectorControlLobbyWindowItemListMatchCellRenderer;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.renderers.SectorControlLobbyWindowItemListPlayersInFactionCellRenderer;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.renderers.SectorControlLobbyWindowItemListPlayersInQueueCellRenderer;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.renderers.SectorControlLobbyWindowItemListTicketsLeftCellRenderer;
   import spark.components.DataGrid;
   import spark.components.gridClasses.GridColumn;
   
   public class SectorControlLobbyWindowItemList extends DataGrid implements ISectorControlLobbyWindowItemList
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
      
      private var _288976410columnFaction:GridColumn;
      
      private var _851919857columnMatch:GridColumn;
      
      private var _847643813columnQueue:GridColumn;
      
      private var _520065359columnTickets:GridColumn;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function SectorControlLobbyWindowItemList()
      {
         super();
         this.columns = this._SectorControlLobbyWindowItemList_ArrayList1_c();
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
      
      public function init() : void
      {
         this.columnMatch.headerText = BPLocale.getItem("sectorcontrol_lobby_window_grid_headerlabel_match");
         this.columnQueue.headerText = BPLocale.getItem("sectorcontrol_lobby_window_grid_headerlabel_queue");
         var _loc1_:Array = InGameCatalog.getInstance().factions_names;
         var _loc2_:String = _loc1_[Hero.factionID.value];
         var _loc3_:String = BPLocale.getItem("sectorcontrol_lobby_window_grid_headerlabel_faction");
         _loc3_ = _loc3_.replace(SectorControlConstants.LOCALIZATION_PLACEHOLDER__COMPANY,_loc2_);
         this.columnFaction.headerText = _loc3_;
         var _loc4_:String = BPLocale.getItem("sectorcontrol_lobby_window_grid_headerlabel_tickets");
         _loc4_ = _loc4_.replace(SectorControlConstants.LOCALIZATION_PLACEHOLDER__COMPANY,_loc2_);
         this.columnTickets.headerText = _loc4_;
      }
      
      private function _SectorControlLobbyWindowItemList_ArrayList1_c() : ArrayList
      {
         var _loc1_:ArrayList = new ArrayList();
         _loc1_.source = [this._SectorControlLobbyWindowItemList_GridColumn1_i(),this._SectorControlLobbyWindowItemList_GridColumn2_i(),this._SectorControlLobbyWindowItemList_GridColumn3_i(),this._SectorControlLobbyWindowItemList_GridColumn4_i()];
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowItemList_GridColumn1_i() : GridColumn
      {
         var _loc1_:GridColumn = new GridColumn();
         _loc1_.headerText = "Match";
         _loc1_.itemRenderer = this._SectorControlLobbyWindowItemList_ClassFactory1_c();
         this.columnMatch = _loc1_;
         BindingManager.executeBindings(this,"columnMatch",this.columnMatch);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowItemList_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = SectorControlLobbyWindowItemListMatchCellRenderer;
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowItemList_GridColumn2_i() : GridColumn
      {
         var _loc1_:GridColumn = new GridColumn();
         _loc1_.dataField = "columnFaction";
         _loc1_.headerText = "Players";
         _loc1_.itemRenderer = this._SectorControlLobbyWindowItemList_ClassFactory2_c();
         this.columnFaction = _loc1_;
         BindingManager.executeBindings(this,"columnFaction",this.columnFaction);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowItemList_ClassFactory2_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = SectorControlLobbyWindowItemListPlayersInFactionCellRenderer;
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowItemList_GridColumn3_i() : GridColumn
      {
         var _loc1_:GridColumn = new GridColumn();
         _loc1_.dataField = "totalTickets";
         _loc1_.headerText = "Tickets left";
         _loc1_.itemRenderer = this._SectorControlLobbyWindowItemList_ClassFactory3_c();
         this.columnTickets = _loc1_;
         BindingManager.executeBindings(this,"columnTickets",this.columnTickets);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowItemList_ClassFactory3_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = SectorControlLobbyWindowItemListTicketsLeftCellRenderer;
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowItemList_GridColumn4_i() : GridColumn
      {
         var _loc1_:GridColumn = new GridColumn();
         _loc1_.dataField = "columnQueue";
         _loc1_.headerText = "Players in Queue";
         _loc1_.itemRenderer = this._SectorControlLobbyWindowItemList_ClassFactory4_c();
         this.columnQueue = _loc1_;
         BindingManager.executeBindings(this,"columnQueue",this.columnQueue);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowItemList_ClassFactory4_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = SectorControlLobbyWindowItemListPlayersInQueueCellRenderer;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get columnFaction() : GridColumn
      {
         return this._288976410columnFaction;
      }
      
      public function set columnFaction(param1:GridColumn) : void
      {
         var _loc2_:Object = this._288976410columnFaction;
         if(_loc2_ !== param1)
         {
            this._288976410columnFaction = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnFaction",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get columnMatch() : GridColumn
      {
         return this._851919857columnMatch;
      }
      
      public function set columnMatch(param1:GridColumn) : void
      {
         var _loc2_:Object = this._851919857columnMatch;
         if(_loc2_ !== param1)
         {
            this._851919857columnMatch = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnMatch",_loc2_,param1));
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
      
      [Bindable(event="propertyChange")]
      public function get columnTickets() : GridColumn
      {
         return this._520065359columnTickets;
      }
      
      public function set columnTickets(param1:GridColumn) : void
      {
         var _loc2_:Object = this._520065359columnTickets;
         if(_loc2_ !== param1)
         {
            this._520065359columnTickets = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnTickets",_loc2_,param1));
            }
         }
      }
   }
}

