package net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.renderers
{
   import flash.display.BitmapData;
   import mx.binding.BindingManager;
   import mx.core.IFlexModuleFactory;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.model.vo.SectorControlItemlistOverviewVO;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.SectorControlConstants;
   import spark.components.VGroup;
   import spark.primitives.BitmapImage;
   
   public class SectorControlLobbyWindowItemListMatchCellRenderer extends SectorControlLobbyWindowItemListAbstractCellRenderer
   {
      
      private var _1453863946imageState:BitmapImage;
      
      private var _1120056619imageStateContainer:VGroup;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      protected var _845564253_notStartedStateBitmapData:BitmapData;
      
      protected var _2008111736_queueStateBitmapData:BitmapData;
      
      protected var _1191407690_runningStateBitmapData:BitmapData;
      
      public function SectorControlLobbyWindowItemListMatchCellRenderer()
      {
         super();
         mx_internal::_document = this;
         this.mxmlContent = [this._SectorControlLobbyWindowItemListMatchCellRenderer_VGroup1_i()];
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
         var _loc1_:FileCollectionFinisher = ResourceManager.fileCollection.getFinisher(SectorControlConstants.LIBRARY_NAME);
         if(_loc1_)
         {
            this._notStartedStateBitmapData = ResourceManager.getBitmapData(SectorControlConstants.LIBRARY_NAME,"iconMatchState_notstarted");
            this._queueStateBitmapData = ResourceManager.getBitmapData(SectorControlConstants.LIBRARY_NAME,"iconMatchState_queue");
            this._runningStateBitmapData = ResourceManager.getBitmapData(SectorControlConstants.LIBRARY_NAME,"iconMatchState_running");
         }
         columnLabelContainer.horizontalCenter = "-15";
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:SectorControlItemlistOverviewVO = param1 as SectorControlItemlistOverviewVO;
         rowLabel.htmlText = "<font size=\'12\' color=\'#" + SectorControlConstants.LOBBY_LABEL_COLOR_DEFAULTVALUE + "\'>" + _loc2_.matchID.toString() + "." + "</font>";
         switch(_loc2_.matchState)
         {
            case SectorControlItemlistOverviewVO.RUNNING:
               this.imageState.source = this._runningStateBitmapData;
               this.imageStateContainer.toolTip = BPLocale.getItem("ttip_sectorcontrol_lobbywindow_column_icon_running");
               break;
            case SectorControlItemlistOverviewVO.MATCH_MAKING:
               this.imageState.source = this._notStartedStateBitmapData;
               this.imageStateContainer.toolTip = BPLocale.getItem("ttip_sectorcontrol_lobbywindow_column_icon_notstarted");
               break;
            case SectorControlItemlistOverviewVO.QUEUED:
               this.imageState.source = this._queueStateBitmapData;
               this.imageStateContainer.toolTip = BPLocale.getItem("ttip_sectorcontrol_lobbywindow_column_icon_queued");
         }
         this.imageState.verticalCenter = 0;
      }
      
      private function _SectorControlLobbyWindowItemListMatchCellRenderer_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.horizontalCenter = 10;
         _loc1_.horizontalAlign = "center";
         _loc1_.verticalCenter = -1;
         _loc1_.verticalAlign = "middle";
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._SectorControlLobbyWindowItemListMatchCellRenderer_BitmapImage1_i()];
         _loc1_.id = "imageStateContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.imageStateContainer = _loc1_;
         BindingManager.executeBindings(this,"imageStateContainer",this.imageStateContainer);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowItemListMatchCellRenderer_BitmapImage1_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.initialized(this,"imageState");
         this.imageState = _loc1_;
         BindingManager.executeBindings(this,"imageState",this.imageState);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get imageState() : BitmapImage
      {
         return this._1453863946imageState;
      }
      
      public function set imageState(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._1453863946imageState;
         if(_loc2_ !== param1)
         {
            this._1453863946imageState = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"imageState",_loc2_,param1));
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
      
      [Bindable(event="propertyChange")]
      protected function get _notStartedStateBitmapData() : BitmapData
      {
         return this._845564253_notStartedStateBitmapData;
      }
      
      protected function set _notStartedStateBitmapData(param1:BitmapData) : void
      {
         var _loc2_:Object = this._845564253_notStartedStateBitmapData;
         if(_loc2_ !== param1)
         {
            this._845564253_notStartedStateBitmapData = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_notStartedStateBitmapData",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get _queueStateBitmapData() : BitmapData
      {
         return this._2008111736_queueStateBitmapData;
      }
      
      protected function set _queueStateBitmapData(param1:BitmapData) : void
      {
         var _loc2_:Object = this._2008111736_queueStateBitmapData;
         if(_loc2_ !== param1)
         {
            this._2008111736_queueStateBitmapData = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_queueStateBitmapData",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get _runningStateBitmapData() : BitmapData
      {
         return this._1191407690_runningStateBitmapData;
      }
      
      protected function set _runningStateBitmapData(param1:BitmapData) : void
      {
         var _loc2_:Object = this._1191407690_runningStateBitmapData;
         if(_loc2_ !== param1)
         {
            this._1191407690_runningStateBitmapData = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_runningStateBitmapData",_loc2_,param1));
            }
         }
      }
   }
}

