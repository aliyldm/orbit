package net.bigpoint.darkorbit.mvc.battlestationswindow.view.components
{
   import com.bigpoint.utils.TimeFormatter;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ToolTipEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.catalog.SysItem;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationConstants;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.ModuleVO;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOHtmlTooltip;
   import spark.components.Group;
   import spark.components.Image;
   import spark.components.Label;
   import spark.primitives.BitmapImage;
   import spark.primitives.Rect;
   
   public class ModuleItemBase extends spark.components.Group
   {
      
      protected static const ITEM_WIDTH:int = 30;
      
      protected static const ITEM_HEIGHT:int = 30;
      
      public static const INSTALLING_STATE:String = "INSTALLING_STATE";
      
      public static const INSTALLED_STATE:String = "INSTALLED_STATE";
      
      private var _1292595405backgroundImage:BitmapImage;
      
      private var _1290000376iconContainer:spark.components.Group;
      
      private var _1289795426backgroundFlash:Rect;
      
      private var _1532066773hoverIcon:BitmapImage;
      
      private var _1754800716selectedIcon:BitmapImage;
      
      private var _108402434installationProgressTimer:Label;
      
      private var _2131378598repairIcon:Image;
      
      private var _1486492957repairAnimContainer:spark.components.Group;
      
      private var _1942777294destroyedIcon:BitmapImage;
      
      public var state:String;
      
      private var _repairAnim:MovieClip;
      
      private var _selected:Boolean;
      
      private var _moduleType:int;
      
      private var _slotId:int;
      
      private var _itemId:int;
      
      private var _moduleVO:ModuleVO;
      
      private var _mask:Sprite;
      
      private var _progressVisibility:Boolean = false;
      
      private var _asteroidMode:Boolean;
      
      private var _iconResKey:String;
      
      private var _repairStarted:Boolean = false;
      
      private var _newData:Boolean = true;
      
      private var _destroyed:Boolean = true;
      
      private var _buildTimer:Timer;
      
      private var _isInstalling:Boolean;
      
      private var _isInstallingTimer:uint;
      
      public function ModuleItemBase()
      {
         super();
      }
      
      protected function handleCreationComplete() : void
      {
         callLater(this.initIcon);
         callLater(this.initIconBackground);
         this.repairIcon.buttonMode = true;
         addEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStageListener);
      }
      
      public function initIconBackground() : void
      {
         if(!this._asteroidMode)
         {
            this.backgroundImage.source = BattleStationConstants.getBitmapData("itemslot_empty");
            this.backgroundImage.visible = true;
         }
      }
      
      public function initIcon() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:UIComponent = null;
         if(this.initialized)
         {
            this.hovered = false;
            this.selected = false;
            if(this.iconContainer.numChildren)
            {
               this.iconContainer.removeAllElements();
            }
            if(!this.isEmpty)
            {
               this._iconResKey = this.moduleResFromKeyLookup;
               _loc1_ = ResourceManager.getMovieClip("battleStationsUI",this._iconResKey);
               _loc1_.width = ITEM_WIDTH;
               _loc1_.height = ITEM_HEIGHT;
               this.repairAnimContainer.x = this.repairIcon.x = _loc1_.x = 1;
               this.repairAnimContainer.y = this.repairIcon.y = _loc1_.y = 1;
               _loc2_ = this.wrapDisplayObject(_loc1_);
               this.iconContainer.addElement(_loc2_);
               this.iconContainer.visible = true;
               this.initProgressBar();
               toolTip = this.moduleFullName + " (" + this.moduleSysItem.name + ") ";
               this.checkRepairStatus();
            }
            else
            {
               toolTip = null;
               this.repairIcon.visible = false;
               this.repairAnimContainer.visible = false;
               if(this._asteroidMode)
               {
                  this.backgroundImage.visible = false;
               }
               this.stopRepair();
               this.clearBuildTimer();
            }
            this.updateRepairIcon();
         }
      }
      
      private function updateRepairIcon() : void
      {
         if(this._asteroidMode == false)
         {
            if(!this.destroyedIcon.source)
            {
               this.destroyedIcon.source = BattleStationConstants.getBitmapData("inventory_slot_destroyed");
               this.destroyedIcon.visible = true;
            }
            if(this.isEmpty)
            {
               this.destroyedIcon.visible = false;
               this.destroyedIcon.alpha = 0;
            }
            else
            {
               this.destroyedIcon.visible = this._moduleVO.destroyed;
               this.destroyedIcon.alpha = this._moduleVO.destroyed ? 0.7 : 0;
            }
         }
      }
      
      private function checkRepairStatus() : void
      {
         if(this._moduleVO.emergencyRepairSecondsLeft == 0)
         {
            this.stopRepair();
         }
         else
         {
            this.startRepair();
         }
      }
      
      public function initProgressBar() : void
      {
         var _loc1_:String = BattleStationConstants.moduleResKeyLookup[this._moduleVO.type];
         var _loc2_:MovieClip = ResourceManager.getMovieClip("battleStationsUI",_loc1_);
         TweenLite.to(_loc2_,0,{"colorMatrixFilter":{
            "brightness":0,
            "saturation":0
         }});
         this._mask = new Sprite();
         this._mask.graphics.beginFill(16777215);
         this._mask.graphics.drawRect(0,0,_loc2_.width,_loc2_.height);
         this._mask.graphics.endFill();
         this._mask.scaleY = 0;
         _loc2_.addChild(this._mask);
         _loc2_.width = ITEM_WIDTH;
         _loc2_.height = ITEM_HEIGHT;
         _loc2_.x = this._mask.x = 1;
         _loc2_.y = this._mask.y = 1;
         _loc2_.mask = this._mask;
         var _loc3_:UIComponent = this.wrapDisplayObject(_loc2_);
         this.iconContainer.addElement(_loc3_);
         this.iconContainer.visible = true;
      }
      
      public function setProgressBarProgress(param1:int, param2:int) : void
      {
         this._moduleVO.installationSecondsLeft = param1;
         this._moduleVO.installationSecondsTotal = param2;
         if(this.initialized)
         {
            this.addProgressBarCountdown(null);
         }
         else
         {
            addEventListener("creationComplete",this.addProgressBarCountdown);
         }
      }
      
      private function addProgressBarCountdown(param1:Event) : void
      {
         this.clearBuildTimer();
         if(this.installationProgressTimer.filters.length == 0)
         {
            TweenMax.to(this.installationProgressTimer,0,{"dropShadowFilter":{
               "blurX":2,
               "blurY":2,
               "distance":0,
               "alpha":1
            }});
            TweenMax.to(this.installationProgressTimer,0,{"glowFilter":{
               "color":0,
               "blurX":2,
               "blurY":2,
               "strength":5,
               "alpha":1
            }});
         }
         if(this._moduleVO.installationSecondsLeft > 0)
         {
            this.updateProgress();
            if(this._buildTimer)
            {
               this.clearBuildTimer();
            }
            if(this._moduleVO.buildStartTime == 0)
            {
               this._moduleVO.buildStartTime = new Date().getTime();
            }
            this._buildTimer = new Timer(200);
            this._buildTimer.addEventListener(TimerEvent.TIMER,this.buildTimerTick);
            this._buildTimer.start();
         }
      }
      
      private function buildTimerTick(param1:TimerEvent) : void
      {
         var _loc3_:int = 0;
         this._moduleVO.instalationDuration = new Date().getTime() - this._moduleVO.buildStartTime;
         var _loc2_:int = this._moduleVO.installationSecondsLeft * 1000 - this._moduleVO.instalationDuration;
         if(_loc2_ > 0 && this._moduleVO.buildStartTime > 0)
         {
            _loc3_ = Math.ceil(_loc2_ / 1000);
            this.updateProgress(_loc3_);
         }
         else
         {
            this._moduleVO.buildStartTime = 0;
            this.handleTimerComplete();
         }
      }
      
      private function handleTimerComplete() : void
      {
         this.progressVisibility = false;
         this.backgroundFlash.alpha = 1;
         this.backgroundFlash.visible = true;
         TweenLite.to(this.backgroundFlash,0.3,{"autoAlpha":0});
         this.iconContainer.alpha = 0;
         TweenLite.to(this.iconContainer,0.8,{
            "alpha":1,
            "onComplete":this.removeFlash
         });
         this.isInstalling = false;
         this.clearBuildTimer();
      }
      
      private function removeFlash() : void
      {
         this.backgroundFlash.alpha = 0;
      }
      
      private function updateProgress(param1:int = 0) : void
      {
         var _loc2_:Number = param1 / this._moduleVO.installationSecondsTotal;
         if(Boolean(this._mask) && this._progressVisibility)
         {
            this._mask.scaleY = _loc2_;
            this._mask.y = 1;
         }
         this.installationProgressTimer.visible = param1 > 0;
         this.installationProgressTimer.text = param1 ? TimeFormatter.formatTime(param1) : "";
      }
      
      public function set duringRepair(param1:Boolean) : void
      {
         this._repairStarted = param1;
      }
      
      public function startRepair() : void
      {
         this._repairStarted = true;
         this.animRepairIcon();
      }
      
      private function animRepairIcon(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.checkRepairIconSource();
         }
         if(this._repairStarted)
         {
            this.repairAnimContainer.visible = true;
            this._repairAnim.play();
         }
         else
         {
            this.stopRepair();
         }
      }
      
      public function checkRepairIconSource() : void
      {
         var _loc1_:UIComponent = null;
         if(this._asteroidMode && !this.repairIcon.source)
         {
            this.repairIcon.source = BattleStationConstants.getBitmapData("repair_hover");
            this._repairAnim = ResourceManager.getMovieClip("battleStationsUI","repair_progress_anim");
            this._repairAnim.gotoAndStop(0);
            _loc1_ = this.wrapDisplayObject(this._repairAnim);
            this.repairAnimContainer.addElement(_loc1_);
         }
      }
      
      public function stopRepair() : void
      {
         this._repairStarted = false;
         TweenLite.killTweensOf(this.repairAnimContainer);
         TweenLite.killDelayedCallsTo(this.repairAnimContainer);
         this.repairAnimContainer.visible = false;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this._newData)
         {
            this._newData = false;
            callLater(this.initIcon);
         }
      }
      
      protected function toolTipCreateHandler(param1:ToolTipEvent) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc2_:DOHtmlTooltip = new DOHtmlTooltip();
         var _loc3_:String = "";
         if(this.moduleSymbol)
         {
            if(this.moduleSysItem)
            {
               _loc3_ += this.moduleFullName + " (" + this.moduleSysItem.name + ")";
               _loc3_ += "<br>";
               _loc4_ = BattleStationConstants.CATEGORIES_IDS_MAP[this._moduleVO.type];
               _loc5_ = BPLocale.getItem("popup_bswin_module_filter_" + _loc4_);
               _loc3_ += BPLocale.getItem("ttip_module_type").replace("%TYPE%",_loc5_);
               _loc3_ += "<br>";
               _loc3_ += BPLocale.getItem("ttip_upgrade_level").replace("%COUNT%",this._moduleVO.upgradeLevel);
               _loc3_ += "<br>";
               if(this._asteroidMode)
               {
                  _loc3_ += BPLocale.getItem("ttip_module_owner").replace("%NAME%",this._moduleVO.ownerName);
               }
               _loc2_.htmlText = _loc3_;
               param1.toolTip = _loc2_;
            }
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         if(this._selected && this.isEmpty == false)
         {
            if(!this.selectedIcon.source)
            {
               this.selectedIcon.source = BattleStationConstants.getBitmapData("inventory_slot_selected");
               this.selectedIcon.visible = true;
            }
            this.selectedIcon.visible = true;
         }
         else
         {
            this.selectedIcon.visible = false;
         }
      }
      
      public function set progressVisibility(param1:Boolean) : void
      {
         if(!param1)
         {
            if(this._mask)
            {
               this._mask.scaleY = 0;
            }
         }
         this._progressVisibility = param1;
      }
      
      public function set moduleVO(param1:ModuleVO) : void
      {
         if(param1 != this._moduleVO)
         {
            this._newData = true;
            this._moduleVO = param1;
            this._moduleType = this._moduleVO.type;
            invalidateProperties();
         }
      }
      
      private function wrapDisplayObject(param1:DisplayObject) : UIComponent
      {
         var _loc2_:UIComponent = new UIComponent();
         _loc2_.addChild(param1);
         return _loc2_;
      }
      
      private function get moduleResFromKeyLookup() : String
      {
         if(this._moduleVO)
         {
            return BattleStationConstants.moduleResKeyLookup[this._moduleVO.type];
         }
         return BattleStationConstants.moduleResKeyLookup[this._moduleType];
      }
      
      public function get duringRepair() : Boolean
      {
         if(this._repairStarted)
         {
            return true;
         }
         if(Boolean(this._moduleVO) && this._moduleVO.emergencyRepairSecondsLeft > 0)
         {
            return true;
         }
         return false;
      }
      
      private function clearBuildTimer() : void
      {
         if(this._buildTimer)
         {
            this._buildTimer.removeEventListener(TimerEvent.TIMER,this.buildTimerTick);
            this._buildTimer.stop();
            this._buildTimer = null;
         }
         if(this._moduleVO)
         {
            this._moduleVO.instalationDuration = 0;
         }
         this.installationProgressTimer.text = "";
      }
      
      public function set asteroidMode(param1:Boolean) : void
      {
         this._asteroidMode = param1;
      }
      
      public function get moduleFullName() : String
      {
         if(this.moduleSymbol)
         {
            return BPLocale.getItemInCategory("items","items_" + this.moduleSymbol + "_fullname");
         }
         return null;
      }
      
      private function get moduleSysItem() : SysItem
      {
         if(this.moduleSymbol)
         {
            return InGameCatalog.instance.sysItems[this.moduleSymbol];
         }
         return null;
      }
      
      private function get moduleSymbol() : String
      {
         return BattleStationConstants.MODULES_IDS_MAP[this._moduleVO.type];
      }
      
      protected function mouseRollHandler(param1:MouseEvent) : void
      {
         if(!this.isEmpty)
         {
            this.hovered = param1.type == MouseEvent.ROLL_OVER;
         }
      }
      
      public function set hovered(param1:Boolean) : void
      {
         if(param1 && this.state == INSTALLED_STATE)
         {
            return;
         }
         if(!this.hoverIcon.source && param1)
         {
            this.hoverIcon.source = BattleStationConstants.getBitmapData("inventory_slot_hover");
            this.hoverIcon.visible = true;
         }
         TweenLite.to(this.hoverIcon,0.3,{"autoAlpha":int(param1)});
      }
      
      private function removeFromStageListener(param1:Event) : void
      {
         this.clearBuildTimer();
         this.stopRepair();
      }
      
      public function get destroyed() : Boolean
      {
         return this._destroyed;
      }
      
      public function set destroyed(param1:Boolean) : void
      {
         this._destroyed = param1;
         this.repairIcon.visible = true;
         this.repairIcon.alpha = 1;
      }
      
      public function get isEmpty() : Boolean
      {
         if(this._moduleVO)
         {
            return this._moduleVO.type == ModuleVO.NONE;
         }
         return this._moduleType == ModuleVO.NONE;
      }
      
      public function get moduleType() : int
      {
         return this._moduleType;
      }
      
      public function set moduleType(param1:int) : void
      {
         if(param1 != this._moduleType)
         {
            callLater(this.initIcon);
         }
         this._moduleType = param1;
      }
      
      public function get slotId() : int
      {
         return this._slotId;
      }
      
      public function set slotId(param1:int) : void
      {
         this._slotId = param1;
      }
      
      public function get itemId() : int
      {
         return this._itemId;
      }
      
      public function set itemId(param1:int) : void
      {
         this._itemId = param1;
      }
      
      public function get moduleVO() : ModuleVO
      {
         return this._moduleVO;
      }
      
      public function get repairAnim() : MovieClip
      {
         return this._repairAnim;
      }
      
      public function get isInstalling() : Boolean
      {
         return this._isInstalling;
      }
      
      public function set isInstalling(param1:Boolean) : void
      {
         clearTimeout(this._isInstallingTimer);
         if(param1)
         {
            this._isInstallingTimer = setTimeout(this.resetInstalling,3000);
         }
         this._isInstalling = param1;
      }
      
      private function resetInstalling() : void
      {
         this._isInstalling = false;
      }
      
      [Bindable(event="propertyChange")]
      public function get backgroundImage() : BitmapImage
      {
         return this._1292595405backgroundImage;
      }
      
      public function set backgroundImage(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._1292595405backgroundImage;
         if(_loc2_ !== param1)
         {
            this._1292595405backgroundImage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"backgroundImage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get iconContainer() : spark.components.Group
      {
         return this._1290000376iconContainer;
      }
      
      public function set iconContainer(param1:spark.components.Group) : void
      {
         var _loc2_:Object = this._1290000376iconContainer;
         if(_loc2_ !== param1)
         {
            this._1290000376iconContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"iconContainer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get backgroundFlash() : Rect
      {
         return this._1289795426backgroundFlash;
      }
      
      public function set backgroundFlash(param1:Rect) : void
      {
         var _loc2_:Object = this._1289795426backgroundFlash;
         if(_loc2_ !== param1)
         {
            this._1289795426backgroundFlash = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"backgroundFlash",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hoverIcon() : BitmapImage
      {
         return this._1532066773hoverIcon;
      }
      
      public function set hoverIcon(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._1532066773hoverIcon;
         if(_loc2_ !== param1)
         {
            this._1532066773hoverIcon = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hoverIcon",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedIcon() : BitmapImage
      {
         return this._1754800716selectedIcon;
      }
      
      public function set selectedIcon(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._1754800716selectedIcon;
         if(_loc2_ !== param1)
         {
            this._1754800716selectedIcon = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedIcon",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get installationProgressTimer() : Label
      {
         return this._108402434installationProgressTimer;
      }
      
      public function set installationProgressTimer(param1:Label) : void
      {
         var _loc2_:Object = this._108402434installationProgressTimer;
         if(_loc2_ !== param1)
         {
            this._108402434installationProgressTimer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"installationProgressTimer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get repairIcon() : Image
      {
         return this._2131378598repairIcon;
      }
      
      public function set repairIcon(param1:Image) : void
      {
         var _loc2_:Object = this._2131378598repairIcon;
         if(_loc2_ !== param1)
         {
            this._2131378598repairIcon = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"repairIcon",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get repairAnimContainer() : spark.components.Group
      {
         return this._1486492957repairAnimContainer;
      }
      
      public function set repairAnimContainer(param1:spark.components.Group) : void
      {
         var _loc2_:Object = this._1486492957repairAnimContainer;
         if(_loc2_ !== param1)
         {
            this._1486492957repairAnimContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"repairAnimContainer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get destroyedIcon() : BitmapImage
      {
         return this._1942777294destroyedIcon;
      }
      
      public function set destroyedIcon(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._1942777294destroyedIcon;
         if(_loc2_ !== param1)
         {
            this._1942777294destroyedIcon = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"destroyedIcon",_loc2_,param1));
            }
         }
      }
   }
}

