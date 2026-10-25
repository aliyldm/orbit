package net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.tooltip
{
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.BlurFilter;
   import flash.geom.Point;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.tooltip.DefaultTooltipDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.SpaceMapConfig;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.icons.SpaceMapStationIcon;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.icons.SpaceMapToolTipGateIcon;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.icons.SpaceMapToolkitStatusIcon;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.meta.SpaceMapDataItem;
   import net.bigpoint.darkorbit.mvc.spaceMap.vo.SpaceMapStationInfoVO;
   
   public class SpaceMapToolTipAssigner extends DefaultTooltipDataAssigner
   {
      
      public static const MINI_MAP_IMAGE:String = "minimap-%ID%-300";
      
      public static const LOCKED_MAP_BLUR_VALUE:Number = 16;
      
      public static const LOCKED_MAP_BLUR_QUALITY:int = BitmapFilterQuality.MEDIUM;
      
      public static const SATURATION_AMOUNT:Number = 0.2;
      
      private static const _lockedTextKeys:Object = createLockedTextLookup();
      
      private static const _indentation:String = "  ";
      
      private static const _newLine:String = "\n";
      
      private static const _newLineDouble:String = "\n\n";
      
      public static const blur:BlurFilter = new BlurFilter(LOCKED_MAP_BLUR_VALUE,LOCKED_MAP_BLUR_VALUE,LOCKED_MAP_BLUR_QUALITY);
      
      private var _mapImage:Bitmap;
      
      public function SpaceMapToolTipAssigner()
      {
         super();
      }
      
      private static function createLockedTextLookup() : Object
      {
         var _loc1_:Object = {};
         _loc1_[SpaceMapDataItem.LEVEL_LOCKED] = "ttip_level_locked_info";
         _loc1_[SpaceMapDataItem.LOCKED] = "ttip_locked_info";
         _loc1_[SpaceMapDataItem.URI_LOCKED] = "ttip_uri_locked_info";
         _loc1_[SpaceMapDataItem.HARD_LOCKED] = "ttip_hard_locked_info";
         _loc1_[SpaceMapDataItem.HARD_LOCKED_NO_OBFUSCATE] = "ttip_hard_lock_no_obfuscate_info";
         _loc1_[SpaceMapDataItem.PIRATE_MAP] = "ttip_pirate_map_info";
         _loc1_[SpaceMapDataItem.ENEMY_MAP] = "ttip_enemy_map_info";
         return _loc1_;
      }
      
      public function get mapData() : SpaceMapDataItem
      {
         return SpaceMapDataItem(data);
      }
      
      override public function assign() : void
      {
         this.setMapIdLabel();
         this.setMapLockedInfo();
         this.addStationInfo();
         this.setMapNPCsInfo();
         this.initMapImage();
         super.assign();
      }
      
      protected function setMapIdLabel() : void
      {
         var _loc1_:Label = Label(FuiComponentSelectorUtil.selectComponent("wrapper.mapIdLabel",target));
         var _loc2_:int = this.mapData.mapId;
         _loc1_.text = BPLocale.getItem("map_map") + " " + Map.getMapName(_loc2_).toString();
      }
      
      protected function setMapLockedInfo() : void
      {
         if(this.mapData.hardLock)
         {
            if(this.mapData.obfuscateMap)
            {
               this.addLockedInfo(SpaceMapDataItem.HARD_LOCKED);
            }
            else
            {
               this.addLockedInfo(SpaceMapDataItem.HARD_LOCKED_NO_OBFUSCATE);
            }
         }
         else if(this.mapData.enemyMap)
         {
            this.addLockedInfo(SpaceMapDataItem.ENEMY_MAP);
         }
         else if(this.mapData.pirateMap)
         {
            this.addLockedInfo(SpaceMapDataItem.PIRATE_MAP);
         }
         else if(this.mapData.levelLocked)
         {
            this.addLockedInfo(SpaceMapDataItem.LEVEL_LOCKED);
         }
         else if(this.mapData.uriLocked)
         {
            this.addLockedInfo(SpaceMapDataItem.URI_LOCKED);
         }
         else if(this.mapData.locked)
         {
            this.addLockedInfo(SpaceMapDataItem.LOCKED);
         }
         else
         {
            this.addLockedInfo();
         }
      }
      
      protected function addLockedInfo(param1:int = -1) : void
      {
         var _loc2_:Label = Label(FuiComponentSelectorUtil.selectComponent("wrapper.toolTipInfo",target));
         if(param1 < 0)
         {
            _loc2_.text = "";
            return;
         }
         _loc2_.text = _newLine + BPLocale.getItem(_lockedTextKeys[param1]);
         var _loc3_:SpaceMapToolkitStatusIcon = new SpaceMapToolkitStatusIcon(param1);
         var _loc4_:Coreponent = Coreponent(FuiComponentSelectorUtil.selectComponent("wrapper.mapImageContainer.mapStatusImage",target));
         _loc4_.addChild(_loc3_);
      }
      
      protected function addStationInfo() : void
      {
         if(this.mapData.stationInfo == null || this.mapData.hardLock && this.mapData.obfuscateMap)
         {
            return;
         }
         var _loc1_:Label = Label(FuiComponentSelectorUtil.selectComponent("wrapper.toolTipInfo",target));
         var _loc2_:SpaceMapStationInfoVO = SpaceMapStationInfoVO(this.mapData.stationInfo);
         _loc1_.text += _loc1_.text == "" ? _newLine : _newLineDouble;
         if(_loc2_.clanName != null && _loc2_.clanName.length > 0)
         {
            _loc1_.text += this.addMapStationInfoText(_loc2_);
         }
         else
         {
            _loc1_.text += this.addAsteroidInfoText(_loc2_);
         }
      }
      
      protected function addMapStationInfoText(param1:SpaceMapStationInfoVO) : String
      {
         var _loc2_:String = BPLocale.getItem("ttip_cbs");
         _loc2_ += _newLine + _indentation + param1.asteroidName;
         _loc2_ += _newLine + BPLocale.getItem("ttip_owner");
         _loc2_ += _newLine + _indentation + param1.clanName + " ";
         _loc2_ += BPLocale.getItem("ttip_since") + " " + param1.lastChangedTimeTextInfo;
         _loc2_ += _newLine + BPLocale.getItem("ttip_company");
         var _loc3_:String = InGameCatalog.instance.factions_names[param1.owningFactionId] || BPLocale.getItem("ttip_all");
         return _loc2_ + (_newLine + _indentation + " " + _loc3_ + " ");
      }
      
      protected function addAsteroidInfoText(param1:SpaceMapStationInfoVO) : String
      {
         var _loc2_:String = BPLocale.getItem("ttip_cbs");
         _loc2_ += _newLine + _indentation + param1.asteroidName;
         _loc2_ += _newLine + BPLocale.getItem("ttip_free_since");
         return _loc2_ + (_newLine + _indentation + param1.lastChangedTimeTextInfo);
      }
      
      protected function setMapNPCsInfo() : void
      {
         var _loc5_:int = 0;
         if(this.mapData.hardLock && this.mapData.obfuscateMap)
         {
            return;
         }
         var _loc1_:Array = SpaceMapConfig.getMapNPCs(this.mapData.mapId);
         var _loc2_:int = int(_loc1_.length);
         if(_loc2_ == 0)
         {
            return;
         }
         var _loc3_:Label = FuiComponentSelectorUtil.selectComponent("wrapper.toolTipInfo",target) as Label;
         var _loc4_:String = _loc3_.text == "" ? _newLine : _newLineDouble;
         _loc4_ = _loc4_ + BPLocale.getItem("ttip_map_npc_info");
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_)
         {
            _loc5_ = int(_loc1_[_loc6_]);
            _loc4_ += _newLine + _indentation + InGameCatalog.getInstance().getNpcName(_loc5_);
            _loc6_++;
         }
         _loc3_.text += _loc4_;
      }
      
      protected function initMapImage() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(this._mapImage == null)
         {
            _loc1_ = this.mapData.mapId;
            _loc2_ = MINI_MAP_IMAGE.replace("%ID%",_loc1_);
            ResourceManager.fileCollection.load(_loc2_,this.handleFileLoadComplete);
         }
         else
         {
            this.addMapImage(this._mapImage);
         }
      }
      
      protected function handleFileLoadComplete(param1:ImageFinisher) : void
      {
         param1.dispose();
         var _loc2_:BitmapData = param1.getBitmap().bitmapData.clone();
         var _loc3_:Bitmap = new Bitmap(_loc2_);
         _loc3_.smoothing = true;
         this._mapImage = _loc3_;
         this.addMapImage(this._mapImage);
      }
      
      protected function addMapImage(param1:Bitmap) : void
      {
         var _loc2_:Coreponent = Coreponent(FuiComponentSelectorUtil.selectComponent("wrapper.mapImageContainer.mapImage",target));
         if(_loc2_ == null)
         {
            return;
         }
         param1.width = _loc2_.width;
         param1.height = _loc2_.height;
         this.setMapVisibility(param1);
         _loc2_.addChild(param1);
         if(this.mapData.obfuscateMap)
         {
            return;
         }
         if(this.mapData.stationInfo != null)
         {
            this.addStationIcon(param1,_loc2_);
         }
         this.addMapGates(_loc2_);
      }
      
      protected function setMapVisibility(param1:Bitmap) : void
      {
         if(this.mapData.obfuscateMap)
         {
            param1.filters = [blur];
            TweenMax.to(param1,0,{"colorMatrixFilter":{"saturation":SATURATION_AMOUNT}});
         }
         else
         {
            param1.filters = null;
            TweenMax.to(param1,0,{"colorMatrixFilter":{"saturation":1}});
         }
      }
      
      protected function addStationIcon(param1:Bitmap, param2:Coreponent) : void
      {
         var _loc3_:SpaceMapStationInfoVO = SpaceMapStationInfoVO(this.mapData.stationInfo);
         var _loc4_:SpaceMapStationIcon = new SpaceMapStationIcon(_loc3_.status);
         _loc4_.x = param1.width * _loc3_.xPositionPercentage / 100;
         _loc4_.y = param1.height * _loc3_.yPositionPercentage / 100;
         param2.addChild(_loc4_);
      }
      
      protected function addMapGates(param1:Coreponent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Point = null;
         var _loc5_:SpaceMapToolTipGateIcon = null;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc2_:Array = SpaceMapConfig.getGatesOnMap(this.mapData.mapId);
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = SpaceMapConfig.getGatePosition(_loc3_);
            _loc5_ = new SpaceMapToolTipGateIcon();
            _loc5_.x = _loc4_.x - (_loc5_.bitmapIcon.width >> 1);
            _loc5_.y = _loc4_.y - (_loc5_.bitmapIcon.height >> 1);
            _loc6_ = SpaceMapConfig.gateVisibleToFaction(_loc3_);
            if(_loc6_)
            {
               _loc7_ = SpaceMapConfig.getGateFactionName(_loc3_);
               if(Hero.factionName != _loc7_)
               {
                  continue;
               }
            }
            _loc5_.setGateLabelText(_loc3_);
            param1.addChild(_loc5_);
         }
      }
   }
}

