package net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui
{
   import com.bigpoint.utils.TextFormatter;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.vo.AvailableJumpVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.vo.SpaceMapHardLockVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.SpaceMapComponents;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.icons.SpaceMapStationIcon;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.icons.SpaceMapStatusIcon;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.meta.SpaceMapData;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.meta.SpaceMapDataItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.tooltip.SpaceMapToolTipAssigner;
   import net.bigpoint.darkorbit.mvc.spaceMap.vo.SpaceMapStationInfoVO;
   
   public class SpaceMapView
   {
      
      public static const SMALL_MAP_SIZE_SUM:uint = 115;
      
      public static const JUMP_LOCATOR_SMALL_SIZE:uint = 40;
      
      public static const JUMP_LOCATOR_BIG_SIZE:uint = 50;
      
      public static const SPACE_MAP_LIBRARY_ID:String = "spaceMapWindow";
      
      public static const MAP_ITEM_CLICKED_EVENT:String = "mapItemClicked";
      
      public static const STATUS_ICON:int = 0;
      
      public static const STATION_ICON:int = 1;
      
      public static const COUNTDOWN_TEXT_FORMAT:TextFormat = new TextFormat(Styles.corporateFontHeavy,Styles.h2FontHeight,15327936,null,null,null,null,null,TextFormatAlign.CENTER);
      
      private var _mapIcons:Object;
      
      private var _comps:SpaceMapComponents;
      
      private var _blinkTween:TweenMax = null;
      
      private var _countDownTween:TweenLite = null;
      
      private var _countDownText:TextField;
      
      private var _jumpLocator:Sprite;
      
      private var _mapData:SpaceMapData;
      
      private var _cpuEquipped:Boolean;
      
      private var _idleSystem:Boolean;
      
      public function SpaceMapView(param1:SpaceMapComponents)
      {
         super();
         this._mapIcons = {};
         this._comps = param1;
         this._idleSystem = true;
      }
      
      public function get idleSystem() : Boolean
      {
         return this._idleSystem;
      }
      
      public function get jumpBtn() : Button
      {
         return this._comps.jumpBtn;
      }
      
      public function get maps() : Coreponent
      {
         return this._comps.maps;
      }
      
      public function get currentMapId() : int
      {
         return GuiManager.instance.getMain().screenManager.map.getMapID();
      }
      
      public function getMapId(param1:Button) : int
      {
         return this._comps.getMapId(param1);
      }
      
      public function startJumpCountdown(param1:Number) : *
      {
         this.stopAndResetJumpCountdown();
         this._idleSystem = false;
         this._countDownTween = TweenLite.to(this._jumpLocator,param1,{
            "transformAroundCenter":{"rotation":-180 * param1},
            "onUpdate":this.setCounterText
         });
      }
      
      public function stopAndResetJumpCountdown() : void
      {
         this._idleSystem = true;
         this._countDownText.text = "";
         if(this._countDownTween != null)
         {
            this._countDownTween.kill();
            TweenLite.to(this._jumpLocator,0,{"transformAroundCenter":{"rotation":0}});
         }
      }
      
      public function initView() : void
      {
         this.initMapButtons();
         this.initJumpCountDownAssets();
      }
      
      public function updateJumpVoucherLabel(param1:int, param2:int = 0) : void
      {
         this._comps.jumpVoucherAmount.text = TextFormatter.roundInteger(param1);
         var _loc3_:String = param1 > 0 ? "space_map_enoughVouchers" : "space_map_notEnoughVouchers";
         this._comps.jumpVoucherAmount.registeredTextStyleName = _loc3_;
         _loc3_ = param1 > 0 ? "space_map_enough_vouchers_info" : "space_map_not_enough_vouchers_info";
         this._comps.jumpVoucherInfo.registeredTextStyleName = _loc3_;
         if(param1 > 0)
         {
            this._comps.jumpPriceInfo.text = BPLocale.getItem("attribute_free_cpu_jump");
         }
         else if(param2 > 0)
         {
            this._comps.jumpPriceInfo.text = BPLocale.getItem("pricetag_uridium_compact").replace("%VALUE%",TextFormatter.roundInteger(param2));
         }
         else
         {
            this._comps.jumpPriceInfo.text = "-";
         }
      }
      
      public function addListeners() : void
      {
         var _loc1_:Vector.<Button> = this._comps.getAllMaps();
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_[_loc3_].addEventListener(MouseEvent.CLICK,this.handleMapItemClicked);
            _loc1_[_loc3_].addEventListener(MouseEvent.ROLL_OVER,this.handleMapItemRollOver);
            _loc1_[_loc3_].addEventListener(MouseEvent.ROLL_OUT,this.handleMapItemRollOut);
            _loc3_++;
         }
      }
      
      public function removeListeners() : void
      {
         var _loc1_:Vector.<Button> = this._comps.getAllMaps();
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_[_loc3_].removeEventListener(MouseEvent.CLICK,this.handleMapItemClicked);
            _loc1_[_loc3_].removeEventListener(MouseEvent.ROLL_OVER,this.handleMapItemRollOver);
            _loc1_[_loc3_].removeEventListener(MouseEvent.ROLL_OUT,this.handleMapItemRollOut);
            _loc3_++;
         }
      }
      
      public function updateCpuStatus(param1:Boolean) : void
      {
         this._cpuEquipped = param1;
         if(!param1)
         {
            this._jumpLocator.visible = false;
            this.unLockAndRemoveJumpStatusIcons();
         }
         this.updateMapBlinker();
      }
      
      public function updateJumpValues(param1:AvailableJumpVO) : void
      {
         var _loc2_:int = param1.mapID;
         var _loc3_:int = param1.price;
         var _loc4_:int = param1.feedBack;
         var _loc5_:int = param1.jumpVoucherAmount;
         this._comps.selectedMapIdLabel.text = Map.getMapName(_loc2_);
         this.jumpBtn.enabled = Boolean(_loc4_);
         this.updateJumpVoucherLabel(_loc5_,_loc3_);
      }
      
      public function showCPUJumpControls(param1:Boolean) : void
      {
         this._comps.cpuJumpControls.visible = true;
      }
      
      public function hideCPUJumpControls(param1:Boolean) : void
      {
         this._comps.cpuJumpControls.visible = false;
      }
      
      public function setHardLock(param1:SpaceMapHardLockVO) : void
      {
         if(param1.status)
         {
            this.activateHardLock(param1.obfuscateMapData);
         }
         else
         {
            this.deActivateHardLock();
         }
      }
      
      public function setSpaceMapsStatus(param1:Object) : *
      {
         var _loc2_:int = 0;
         var _loc3_:Button = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<Button> = null;
         this._jumpLocator.visible = false;
         _loc5_ = this._comps.getAllMaps();
         var _loc6_:uint = _loc5_.length;
         var _loc7_:uint = 0;
         while(_loc7_ < _loc6_)
         {
            _loc3_ = _loc5_[_loc7_];
            _loc2_ = this.getMapId(_loc3_);
            if(_loc2_ == this.currentMapId)
            {
               this.unLockMap(_loc3_);
            }
            else if(param1[_loc2_] != null)
            {
               _loc4_ = int(param1[_loc2_]);
               this.setMapStatus(_loc4_,_loc3_);
            }
            else
            {
               this.lockMap(_loc3_,SpaceMapDataItem.LOCKED);
            }
            _loc7_++;
         }
         this._idleSystem = true;
      }
      
      public function updateMapLabels(param1:Boolean) : void
      {
         var _loc2_:String = param1 ? Map.getMapName(this.currentMapId) : "-";
         this._comps.currentMapIdLabel.text = _loc2_;
         this._comps.selectedMapIdLabel.text = "-";
      }
      
      public function setSpaceMapStations(param1:Vector.<SpaceMapStationInfoVO>) : void
      {
         var _loc2_:SpaceMapStationInfoVO = null;
         var _loc3_:int = 0;
         var _loc4_:Button = null;
         var _loc7_:Vector.<Button> = null;
         var _loc5_:uint = param1.length;
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            _loc2_ = param1[_loc6_];
            _loc3_ = _loc2_.mapId;
            _loc4_ = this._comps.getMapById(_loc3_);
            if(_loc4_)
            {
               this.addJumpDataToMap(_loc4_,_loc2_);
            }
            _loc6_++;
         }
         _loc7_ = this._comps.getAllMaps();
         var _loc8_:uint = _loc7_.length;
         _loc6_ = 0;
         while(_loc6_ < _loc8_)
         {
            _loc4_ = _loc7_[_loc6_];
            _loc3_ = this.getMapId(_loc4_);
            _loc6_++;
         }
      }
      
      public function updatedMapBg(param1:Boolean) : void
      {
         if(this._comps.getMapBg().visible != param1)
         {
            this._comps.getMapBg().visible = param1;
            this._comps.getControlsBG().visible = param1;
         }
      }
      
      protected function unLockAndRemoveJumpStatusIcons() : void
      {
         var _loc1_:Button = null;
         var _loc2_:Vector.<Button> = null;
         _loc2_ = this._comps.getAllMaps();
         var _loc3_:uint = _loc2_.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc1_ = _loc2_[_loc4_];
            if(!this._mapData.getMapDataItem(_loc1_.name).hardLock)
            {
               this.unLockMap(_loc1_);
            }
            _loc4_++;
         }
      }
      
      protected function activateHardLock(param1:Boolean) : void
      {
         var _loc2_:Button = null;
         var _loc3_:Vector.<Button> = null;
         this._jumpLocator.visible = false;
         _loc3_ = this._comps.getAllMaps();
         var _loc4_:uint = _loc3_.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = _loc3_[_loc5_];
            this.lockMap(_loc2_,SpaceMapDataItem.HARD_LOCKED);
            this._mapData.getMapDataItem(_loc2_.name).obfuscateMap = param1;
            _loc2_.tooltipData = this._mapData.getMapDataItem(_loc2_.name);
            _loc5_++;
         }
      }
      
      protected function deActivateHardLock() : void
      {
         var _loc1_:Button = null;
         var _loc2_:Vector.<Button> = null;
         _loc2_ = this._comps.getAllMaps();
         var _loc3_:uint = _loc2_.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc1_ = _loc2_[_loc4_];
            this.unLockMap(_loc1_);
            this._mapData.getMapDataItem(_loc1_.name).obfuscateMap = false;
            _loc1_.tooltipData = this._mapData.getMapDataItem(_loc1_.name);
            _loc4_++;
         }
      }
      
      protected function setMapStatus(param1:int, param2:Button) : void
      {
         var _loc3_:Boolean = param1 <= SpaceMapDataItem.MAX_LOCKED_STATE;
         if(_loc3_)
         {
            this.lockMap(param2,param1);
            return;
         }
         this.unLockMap(param2);
         if(param1 == SpaceMapDataItem.NO_ICON)
         {
            return;
         }
         var _loc4_:SpaceMapStatusIcon = new SpaceMapStatusIcon(param1);
         this.addMapIcon(_loc4_,param2,STATUS_ICON);
      }
      
      protected function updateMapBlinker() : void
      {
         this._comps.blinkerSmall.visible = false;
         this._comps.blinkerBig.visible = false;
         this.jumpBtn.enabled = false;
         var _loc1_:Button = this._comps.getMapById(this.currentMapId);
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:Boolean = _loc1_.width + _loc1_.height <= SMALL_MAP_SIZE_SUM;
         var _loc3_:Coreponent = _loc2_ ? this._comps.blinkerSmall : this._comps.blinkerBig;
         _loc3_.x = _loc1_.x;
         _loc3_.y = _loc1_.y;
         _loc3_.visible = true;
         if(this._blinkTween != null)
         {
            this._blinkTween.kill();
            _loc3_.alpha = 1;
         }
         this._blinkTween = TweenMax.to(_loc3_,0.4,{
            "alpha":0,
            "repeatDelay":0.5,
            "repeat":-1,
            "yoyo":true
         });
      }
      
      protected function addJumpDataToMap(param1:Button, param2:SpaceMapStationInfoVO) : void
      {
         this._mapData.getMapDataItem(param1.name).stationInfo = param2;
         param1.tooltipData = this._mapData.getMapDataItem(param1.name);
         var _loc3_:SpaceMapStationIcon = new SpaceMapStationIcon(param2.status);
         this.addMapIcon(_loc3_,param1,STATION_ICON);
      }
      
      protected function initMapButtons() : void
      {
         var _loc2_:Button = null;
         var _loc3_:int = 0;
         var _loc1_:Vector.<Button> = this._comps.getAllMaps();
         this._mapData = new SpaceMapData(this._comps);
         var _loc4_:int = int(_loc1_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = _loc1_[_loc5_];
            _loc2_.tooltipDataAssigner = new SpaceMapToolTipAssigner();
            _loc3_ = this.getMapId(_loc2_);
            this._mapData.getMapDataItem(_loc2_.name).mapId = _loc3_;
            _loc2_.tooltipData = this._mapData.getMapDataItem(_loc2_.name);
            this._mapIcons[_loc2_.name] = [];
            this._mapIcons[_loc2_.name][STATUS_ICON] = null;
            this._mapIcons[_loc2_.name][STATION_ICON] = null;
            _loc2_.text = Map.getMapName(_loc3_);
            _loc5_++;
         }
      }
      
      protected function initJumpCountDownAssets() : void
      {
         var _loc1_:Bitmap = new Bitmap(SWFFinisher(ResourceManager.fileCollection.getFinisher(SPACE_MAP_LIBRARY_ID)).getEmbeddedBitmapData("jump_locator"));
         _loc1_.smoothing = true;
         this._jumpLocator = new Sprite();
         this._jumpLocator.addChild(_loc1_);
         this._jumpLocator.visible = false;
         this._comps.content.addChild(this._jumpLocator);
         this._countDownText = new TextField();
         this._countDownText.defaultTextFormat = COUNTDOWN_TEXT_FORMAT;
         this._countDownText.type = TextFieldType.DYNAMIC;
         this._countDownText.embedFonts = Styles.baseEmbed;
         this._countDownText.antiAliasType = AntiAliasType.ADVANCED;
         this._countDownText.selectable = false;
         this._countDownText.width = _loc1_.width;
         this._countDownText.height = Styles.h2FontHeight;
         this._countDownText.visible = false;
         this._comps.content.addChild(this._countDownText);
      }
      
      protected function setCounterText() : void
      {
         this._countDownText.text = (this._countDownTween.duration - Math.round(this._countDownTween.currentTime)).toString();
         if(this._countDownText.text == "0")
         {
            this._countDownText.text = "";
         }
      }
      
      protected function lockMap(param1:Button, param2:int) : void
      {
         var _loc3_:SpaceMapStatusIcon = new SpaceMapStatusIcon(param2);
         this.addMapIcon(_loc3_,param1,STATUS_ICON);
         this._mapData.getMapDataItem(param1.name).setMapProperty(param2,true);
         param1.tooltipData = this._mapData.getMapDataItem(param1.name);
      }
      
      protected function unLockMap(param1:Button) : void
      {
         this.removeMapIcon(param1,STATUS_ICON);
         this._mapData.getMapDataItem(param1.name).unlockFull();
      }
      
      protected function addMapIcon(param1:Sprite, param2:Sprite, param3:int) : void
      {
         var _loc8_:Sprite = null;
         var _loc9_:int = 0;
         var _loc10_:Sprite = null;
         param1.y = (param2.height >> 1) + (param1.height >> 2);
         param1.x = (param2.width >> 1) - (param1.width >> 1);
         var _loc4_:* = param2.name;
         var _loc5_:Array = [];
         _loc5_[STATUS_ICON] = this._mapIcons[_loc4_][STATUS_ICON];
         _loc5_[STATION_ICON] = this._mapIcons[_loc4_][STATION_ICON];
         var _loc6_:int = (param3 + 1) % 2;
         if(Boolean(_loc5_[STATUS_ICON]) && Boolean(_loc5_[STATION_ICON]))
         {
            param1.x = (param2.width >> 1) - param1.width * _loc6_;
         }
         else
         {
            _loc8_ = _loc5_[param3];
            if(_loc8_ != null)
            {
               param1.x = _loc8_.x;
            }
            _loc9_ = (param3 + 1) % 2;
            _loc10_ = _loc5_[_loc9_];
            if(_loc10_ != null)
            {
               param1.x = (param2.width >> 1) - param1.width * _loc6_;
               _loc10_.x = (param2.width >> 1) - _loc10_.width * param3;
            }
         }
         var _loc7_:Coreponent = this._comps.getMapIconsByName(param2.name);
         if(_loc5_[param3] != null)
         {
            _loc7_.removeChild(_loc5_[param3]);
         }
         _loc7_.addChild(param1);
         this._mapIcons[param2.name][param3] = param1;
      }
      
      protected function removeMapIcon(param1:Sprite, param2:int) : void
      {
         var _loc6_:Sprite = null;
         var _loc3_:* = param1.name;
         if(this._mapIcons[_loc3_][param2] == null)
         {
            return;
         }
         var _loc4_:int = (param2 + 1) % 2;
         if(this._mapIcons[_loc3_][_loc4_] != null)
         {
            _loc6_ = this._mapIcons[_loc3_][_loc4_];
            _loc6_.x = (param1.width >> 1) - (_loc6_.width >> 1);
         }
         var _loc5_:Coreponent = this._comps.getMapIconsByName(param1.name);
         _loc5_.removeChild(this._mapIcons[_loc3_][param2]);
         this._mapIcons[param1.name][param2] = null;
      }
      
      protected function updateSelectedMapJumpAssets(param1:Button) : void
      {
         var _loc2_:Boolean = param1.width + param1.height <= SMALL_MAP_SIZE_SUM;
         var _loc3_:int = _loc2_ ? int(JUMP_LOCATOR_SMALL_SIZE) : int(JUMP_LOCATOR_BIG_SIZE);
         this._jumpLocator.width = this._jumpLocator.height = _loc3_;
         this._jumpLocator.x = param1.x + (param1.width >> 1) - (this._jumpLocator.width >> 1);
         this._jumpLocator.y = param1.y + (param1.height >> 1) - (this._jumpLocator.height >> 1);
         this._jumpLocator.visible = true;
         this._countDownText.x = param1.x + (param1.width >> 1) - (this._countDownText.width >> 1);
         this._countDownText.y = param1.y + (param1.height >> 1) - (this._countDownText.height >> 1) - (this._countDownText.height >> 3);
         this._countDownText.visible = true;
      }
      
      protected function handleMapItemClicked(param1:MouseEvent) : void
      {
         if(!this.idleSystem || !this._cpuEquipped)
         {
            return;
         }
         var _loc2_:Button = Button(param1.target);
         if(this._mapData.getMapDataItem(_loc2_.name).jumpNotAllowed)
         {
            return;
         }
         var _loc3_:int = this.getMapId(_loc2_);
         if(this.currentMapId == _loc3_)
         {
            return;
         }
         this.updateSelectedMapJumpAssets(_loc2_);
         _loc2_.dispatchEvent(new Event(MAP_ITEM_CLICKED_EVENT,true,true));
      }
      
      protected function handleMapItemRollOver(param1:MouseEvent) : void
      {
         var _loc2_:Button = Button(param1.target);
         var _loc3_:SpaceMapDataItem = this._mapData.getMapDataItem(_loc2_.name);
         if(!this.idleSystem || !this._cpuEquipped || _loc3_.hardLock)
         {
            return;
         }
         var _loc4_:Boolean = _loc3_.pirateMap;
         this.jumpBtn.visible = !_loc4_;
         this._comps.jumpLockedInfo.visible = _loc4_;
      }
      
      protected function handleMapItemRollOut(param1:MouseEvent) : void
      {
         if(!this.idleSystem || !this._cpuEquipped)
         {
            return;
         }
         var _loc2_:Button = Button(param1.target);
         this.jumpBtn.visible = true;
         this._comps.jumpLockedInfo.visible = false;
      }
   }
}

