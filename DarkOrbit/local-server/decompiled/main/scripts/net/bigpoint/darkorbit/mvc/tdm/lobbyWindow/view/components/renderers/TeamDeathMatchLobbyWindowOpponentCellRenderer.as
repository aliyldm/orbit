package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.components.renderers
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
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchOverviewModule;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.TeamDeathMatchLobbyWindowConstants;
   import spark.components.VGroup;
   import spark.primitives.BitmapImage;
   
   public class TeamDeathMatchLobbyWindowOpponentCellRenderer extends TeamDeathMatchLobbyWindowAbstractCellRenderer
   {
      
      public static var _QUEUED_MATCH_ID:int = -100;
      
      private var _572333447imageMatchState:BitmapImage;
      
      private var _1120056619imageStateContainer:VGroup;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      protected var _notStartedStateBitmapData:BitmapData;
      
      protected var _queueStateBitmapData:BitmapData;
      
      protected var _runningStateBitmapData:BitmapData;
      
      public function TeamDeathMatchLobbyWindowOpponentCellRenderer()
      {
         super();
         mx_internal::_document = this;
         this.mxmlContent = [this._TeamDeathMatchLobbyWindowOpponentCellRenderer_VGroup1_i()];
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
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:String = TeamDeathMatchLobbyWindowConstants.LIBRARY_NAME;
         var _loc2_:FileCollectionFinisher = ResourceManager.fileCollection.getFinisher(_loc1_);
         if(_loc2_)
         {
            this._notStartedStateBitmapData = ResourceManager.getBitmapData(_loc1_,TeamDeathMatchLobbyWindowConstants.LIBRARY_ASSET_NAME__MATCH_NOT_STARTED);
            this._queueStateBitmapData = ResourceManager.getBitmapData(_loc1_,TeamDeathMatchLobbyWindowConstants.LIBRARY_ASSET_NAME__QUEUED);
            this._runningStateBitmapData = ResourceManager.getBitmapData(_loc1_,TeamDeathMatchLobbyWindowConstants.LIBRARY_ASSET_NAME__MATCH_IS_RUNNING);
         }
         columnLabelContainer.toolTip = "";
         columnLabelContainer.horizontalCenter = -14;
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:TeamDeathMatchOverviewModule = param1 as TeamDeathMatchOverviewModule;
         var _loc3_:String = InGameCatalog.getInstance().factions_names_by_FactionModule[_loc2_.opponent.faction];
         var _loc4_:String = TeamDeathMatchLobbyWindowConstants.LOBBY_LABEL_COLOR_DEFAULTVALUE;
         rowLabel.htmlText = "<font size=\'12\' color=\'#" + _loc4_ + "\'>" + _loc3_ + "</font>";
         if(_loc2_.matchId == _QUEUED_MATCH_ID)
         {
            this.imageMatchState.source = this._notStartedStateBitmapData;
            columnLabelContainer.toolTip = "";
            this.imageStateContainer.toolTip = "";
         }
         else
         {
            switch(_loc2_.matchState)
            {
               case TeamDeathMatchOverviewModule.MATCHSTATE_RUNNING:
                  this.imageMatchState.source = this._runningStateBitmapData;
                  columnLabelContainer.toolTip = BPLocale.getItem("ttip_teamdeathmatch_lobbywindow_column_icon_running");
                  this.imageStateContainer.toolTip = BPLocale.getItem("ttip_teamdeathmatch_lobbywindow_column_icon_running");
                  break;
               case TeamDeathMatchOverviewModule.MATCHSTATE_MATCH_MAKING:
                  this.imageMatchState.source = this._queueStateBitmapData;
                  columnLabelContainer.toolTip = BPLocale.getItem("ttip_teamdeathmatch_lobbywindow_column_icon_not_started");
                  this.imageStateContainer.toolTip = BPLocale.getItem("ttip_teamdeathmatch_lobbywindow_column_icon_not_started");
            }
         }
      }
      
      private function _TeamDeathMatchLobbyWindowOpponentCellRenderer_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.horizontalCenter = 12;
         _loc1_.horizontalAlign = "center";
         _loc1_.verticalCenter = -1;
         _loc1_.verticalAlign = "middle";
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._TeamDeathMatchLobbyWindowOpponentCellRenderer_BitmapImage1_i()];
         _loc1_.id = "imageStateContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.imageStateContainer = _loc1_;
         BindingManager.executeBindings(this,"imageStateContainer",this.imageStateContainer);
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbyWindowOpponentCellRenderer_BitmapImage1_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.horizontalAlign = "center";
         _loc1_.initialized(this,"imageMatchState");
         this.imageMatchState = _loc1_;
         BindingManager.executeBindings(this,"imageMatchState",this.imageMatchState);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get imageMatchState() : BitmapImage
      {
         return this._572333447imageMatchState;
      }
      
      public function set imageMatchState(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._572333447imageMatchState;
         if(_loc2_ !== param1)
         {
            this._572333447imageMatchState = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"imageMatchState",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get imageStateContainer() : VGroup
      {
         return this._1120056619imageStateContainer;
      }
      
      public function set imageStateContainer(param1:VGroup) : void
      {
         var _loc2_:Object = this._1120056619imageStateContainer;
         if(_loc2_ !== param1)
         {
            this._1120056619imageStateContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"imageStateContainer",_loc2_,param1));
            }
         }
      }
   }
}

