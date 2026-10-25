package net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.SpaceMapNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.vo.AvailableJumpVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.vo.JumpCpuStatusVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.vo.JumpInfoVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.vo.SpaceMapHardLockVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.vo.SpaceMapsStatusVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.SpaceMapView;
   import net.bigpoint.darkorbit.mvc.spaceMap.vo.SpaceMapStationInfoVO;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SpaceMapWindowMediator extends SimpleWindowMediator
   {
      
      public static const WINDOWS_WIDTH:uint = 805;
      
      public static const JUMP_CPU_CONTROLS_HEIGHT:uint = 610;
      
      public static const JUMP_CPU_CONTROLS_DISABLED_HEIGHT:uint = 525;
      
      private var _spaceMapStationsInitialized:Boolean = false;
      
      private var _spaceMapsView:SpaceMapView;
      
      private var _pendingData:Array;
      
      public function SpaceMapWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         this._pendingData = new Array();
         Settings.displayWindowsBackground.changed.add(this.updateSpaceMapBackground);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         window.setSize(WINDOWS_WIDTH,JUMP_CPU_CONTROLS_DISABLED_HEIGHT);
      }
      
      override public function onRemove() : void
      {
         this._spaceMapsView.jumpBtn.removeEventListener(MouseEvent.CLICK,this.jumpBtnClicked);
         this._spaceMapsView.maps.removeEventListener(SpaceMapView.MAP_ITEM_CLICKED_EVENT,this.mapItemClicked);
         this._spaceMapsView.removeListeners();
         super.onRemove();
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         var _loc2_:SpaceMapComponents = new SpaceMapComponents(window.getUIContainer());
         this._spaceMapsView = new SpaceMapView(_loc2_);
         this.updateSpaceMapBackground();
         this._spaceMapsView.initView();
         this._spaceMapsView.addListeners();
         this._spaceMapsView.jumpBtn.addEventListener(MouseEvent.CLICK,this.jumpBtnClicked);
         this._spaceMapsView.maps.addEventListener(SpaceMapView.MAP_ITEM_CLICKED_EVENT,this.mapItemClicked);
         this.callPendingData();
      }
      
      override public function listNotificationInterests() : Array
      {
         var _loc1_:Array = super.listNotificationInterests();
         _loc1_.push(SpaceMapNotifications.SPACE_MAP_JUMP_CPU_EQUIPPED_STATUS_UPDATED);
         _loc1_.push(SpaceMapNotifications.SPACE_MAP_STATIONS_INFO_UPDATED);
         _loc1_.push(SpaceMapNotifications.SPACE_MAP_MAPS_STATUS_UPDATED);
         _loc1_.push(SpaceMapNotifications.SPACE_MAP_JUMP_STATUS_UPDATED);
         _loc1_.push(SpaceMapNotifications.SPACE_MAP_SET_AVAILABLE_JUMP);
         _loc1_.push(SpaceMapNotifications.SPACE_MAP_HARD_LOCK_UPDATED);
         _loc1_.push(SpaceMapNotifications.SPACE_MAP_JUMP_VOUCHER_UPDATED);
         return _loc1_;
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         super.handleNotification(param1);
         var _loc2_:String = param1.getName();
         switch(_loc2_)
         {
            case SpaceMapNotifications.SPACE_MAP_STATIONS_INFO_UPDATED:
               this.spaceMapStationsUpdated(param1);
               break;
            case SpaceMapNotifications.SPACE_MAP_JUMP_CPU_EQUIPPED_STATUS_UPDATED:
               this.jumpCpuEquippedStatusUpdated(param1);
               break;
            case SpaceMapNotifications.SPACE_MAP_MAPS_STATUS_UPDATED:
               this.spaceMapsStatusUpdated(param1);
               break;
            case SpaceMapNotifications.SPACE_MAP_JUMP_STATUS_UPDATED:
               this.spaceMapJumpStatusUpdated(param1);
               break;
            case SpaceMapNotifications.SPACE_MAP_SET_AVAILABLE_JUMP:
               this.updateSpaceMapJumpStatus(param1);
               break;
            case SpaceMapNotifications.SPACE_MAP_HARD_LOCK_UPDATED:
               this.spaceMapHardLockUpdated(param1);
               break;
            case SpaceMapNotifications.SPACE_MAP_JUMP_VOUCHER_UPDATED:
               this.spaceMapJumpVoucherAmountUpdated(param1);
         }
      }
      
      protected function callPendingData() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Function = null;
         var _loc3_:Object = null;
         for each(_loc1_ in this._pendingData)
         {
            _loc2_ = _loc1_[0];
            _loc3_ = _loc1_[1];
            _loc2_.call(this,_loc3_);
         }
         this._pendingData = [];
      }
      
      protected function jumpCpuEquippedStatusUpdated(param1:INotification) : void
      {
         var _loc2_:JumpCpuStatusVO = JumpCpuStatusVO(param1.getBody());
         if(this._spaceMapsView == null)
         {
            this._pendingData.push([this.updateCpuEquippedStatus,_loc2_]);
         }
         else
         {
            this.updateCpuEquippedStatus(_loc2_);
         }
      }
      
      protected function updateCpuEquippedStatus(param1:JumpCpuStatusVO) : void
      {
         var _loc2_:Boolean = param1.cpuEquipped;
         var _loc3_:Number = _loc2_ ? JUMP_CPU_CONTROLS_HEIGHT : JUMP_CPU_CONTROLS_DISABLED_HEIGHT;
         window.setSize(WINDOWS_WIDTH,_loc3_);
         var _loc4_:Boolean = window.maximized && !window.isTweening();
         if(_loc2_)
         {
            this._spaceMapsView.showCPUJumpControls(_loc4_);
         }
         else
         {
            this._spaceMapsView.hideCPUJumpControls(_loc4_);
         }
         this._spaceMapsView.updateCpuStatus(_loc2_);
         this._spaceMapsView.updateMapLabels(param1.onSpaceMap);
         this.initializeSpaceMapStations(param1.spaceMapStations);
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
      }
      
      protected function spaceMapStationsUpdated(param1:INotification) : void
      {
         var _loc2_:Vector.<SpaceMapStationInfoVO> = Vector.<SpaceMapStationInfoVO>(param1.getBody());
         if(this._spaceMapsView == null)
         {
            this._pendingData.push([this.setSpaceMapStations,_loc2_]);
         }
         else
         {
            this.setSpaceMapStations(_loc2_);
         }
      }
      
      protected function setSpaceMapStations(param1:Vector.<SpaceMapStationInfoVO>) : void
      {
         this._spaceMapsView.setSpaceMapStations(param1);
      }
      
      protected function spaceMapsStatusUpdated(param1:INotification) : void
      {
         var _loc2_:SpaceMapsStatusVO = SpaceMapsStatusVO(param1.getBody());
         if(this._spaceMapsView == null)
         {
            this._pendingData.push([this.setSpaceMapsStatus,_loc2_]);
         }
         else
         {
            this.setSpaceMapsStatus(_loc2_);
         }
      }
      
      protected function setSpaceMapsStatus(param1:SpaceMapsStatusVO) : void
      {
         this.initializeSpaceMapStations(param1.spaceMapStations);
         this._spaceMapsView.setSpaceMapsStatus(param1.mapsStatus);
      }
      
      protected function initializeSpaceMapStations(param1:Vector.<SpaceMapStationInfoVO>) : void
      {
         if(!this._spaceMapStationsInitialized)
         {
            this._spaceMapsView.setSpaceMapStations(param1);
         }
         this._spaceMapStationsInitialized = true;
      }
      
      protected function spaceMapJumpStatusUpdated(param1:INotification) : void
      {
         var _loc2_:JumpInfoVO = JumpInfoVO(param1.getBody());
         var _loc3_:int = _loc2_.duration;
         if(_loc3_ < 0)
         {
            this.minimizeWindow();
            this._spaceMapsView.stopAndResetJumpCountdown();
         }
         else
         {
            this._spaceMapsView.startJumpCountdown(_loc3_);
         }
      }
      
      protected function updateSpaceMapJumpStatus(param1:INotification) : void
      {
         var _loc2_:AvailableJumpVO = AvailableJumpVO(param1.getBody());
         this._spaceMapsView.updateJumpValues(_loc2_);
      }
      
      protected function spaceMapHardLockUpdated(param1:INotification) : void
      {
         var _loc2_:SpaceMapHardLockVO = SpaceMapHardLockVO(param1.getBody());
         if(this._spaceMapsView == null)
         {
            this._pendingData.push([this.setHardLock,_loc2_]);
         }
         else
         {
            this.setHardLock(_loc2_);
         }
      }
      
      protected function setHardLock(param1:SpaceMapHardLockVO) : void
      {
         this._spaceMapsView.setHardLock(param1);
      }
      
      protected function spaceMapJumpVoucherAmountUpdated(param1:INotification) : void
      {
         var _loc2_:int = int(param1.getBody());
         if(this._spaceMapsView == null)
         {
            this._pendingData.push([this.setJumpVoucherAmount,_loc2_]);
         }
         else
         {
            this.setJumpVoucherAmount(_loc2_);
         }
      }
      
      protected function updateSpaceMapBackground() : void
      {
         this._spaceMapsView.updatedMapBg(Settings.displayWindowsBackground.value);
      }
      
      protected function setJumpVoucherAmount(param1:int) : void
      {
         this._spaceMapsView.updateJumpVoucherLabel(param1);
      }
      
      protected function minimizeWindow() : void
      {
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
         if(window.maximized && !window.isTweening())
         {
            window.minimize();
            sendNotification(FeaturesMenuNotifications.TOGGLE_BTN_SELECTION,false,GuiConstants.SPACEMAP_WINDOW);
         }
      }
      
      protected function jumpBtnClicked(param1:MouseEvent) : void
      {
         if(this._spaceMapsView.idleSystem)
         {
            sendNotification(ConnectionNotifications.SEND_COMMAND,[ServerCommands.ADVANCED_JUMP_CPU,[ServerCommands.JUMP_CPU]]);
         }
      }
      
      protected function mapItemClicked(param1:Event) : void
      {
         param1.stopPropagation();
         var _loc2_:Button = Button(param1.target);
         var _loc3_:int = this._spaceMapsView.getMapId(_loc2_);
         sendNotification(ConnectionNotifications.SEND_COMMAND,[ServerCommands.ADVANCED_JUMP_CPU,[ServerCommands.SET_STATUS,_loc3_]]);
      }
   }
}

