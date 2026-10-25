package net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.icons
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.com.module.StarmapStationInfo;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.SpaceMapView;
   
   public class SpaceMapStationIcon extends Sprite
   {
      
      private static const _spaceMapStationInfo:Object = getSpaceMapStationInfo();
      
      private var _bitmapIcon:Bitmap;
      
      public function SpaceMapStationIcon(param1:int)
      {
         super();
         this.initIcon(param1);
      }
      
      protected static function getSpaceMapStationInfo() : Object
      {
         var _loc1_:Object = {};
         _loc1_[StarmapStationInfo.STATIONSTATUS_OWN_STATION] = "mapIcon_battlestation_own";
         _loc1_[StarmapStationInfo.STATIONSTATUS_NEUTRAL_STATION] = "mapIcon_battlestation_allied";
         _loc1_[StarmapStationInfo.STATIONSTATUS_HOSTILE_STATION] = "mapIcon_battlestation_hostile";
         _loc1_[StarmapStationInfo.STATIONSTATUS_ASTEROID] = "mapIcon_battlestation_not_developed";
         return _loc1_;
      }
      
      protected function initIcon(param1:int) : void
      {
         var _loc2_:String = _spaceMapStationInfo[param1];
         if(_loc2_ != null)
         {
            this._bitmapIcon = new Bitmap(SWFFinisher(ResourceManager.fileCollection.getFinisher(SpaceMapView.SPACE_MAP_LIBRARY_ID)).getEmbeddedBitmapData(_loc2_));
            this._bitmapIcon.smoothing = true;
            addChild(this._bitmapIcon);
         }
      }
   }
}

