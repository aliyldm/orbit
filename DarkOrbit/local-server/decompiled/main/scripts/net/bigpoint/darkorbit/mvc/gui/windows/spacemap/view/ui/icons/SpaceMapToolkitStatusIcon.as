package net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.icons
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.SpaceMapView;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.view.ui.meta.SpaceMapDataItem;
   
   public class SpaceMapToolkitStatusIcon extends Sprite
   {
      
      private static const _spaceMapData:Object = getSpaceMapData();
      
      private var _bitmapIcon:Bitmap;
      
      public function SpaceMapToolkitStatusIcon(param1:int)
      {
         super();
         this.initIcon(param1);
      }
      
      protected static function getSpaceMapData() : Object
      {
         var _loc1_:Object = {};
         _loc1_[SpaceMapDataItem.LEVEL_LOCKED] = "mapIcon_lock_big";
         _loc1_[SpaceMapDataItem.LOCKED] = "mapIcon_lock_big";
         _loc1_[SpaceMapDataItem.URI_LOCKED] = "mapIcon_lock_big";
         _loc1_[SpaceMapDataItem.ENEMY_MAP] = "mapIcon_lock_big";
         _loc1_[SpaceMapDataItem.PIRATE_MAP] = "mapIcon_skull_big";
         return _loc1_;
      }
      
      protected function initIcon(param1:int) : void
      {
         var _loc2_:String = _spaceMapData[param1];
         if(_loc2_ != null)
         {
            this._bitmapIcon = new Bitmap(SWFFinisher(ResourceManager.fileCollection.getFinisher(SpaceMapView.SPACE_MAP_LIBRARY_ID)).getEmbeddedBitmapData(_loc2_));
            this._bitmapIcon.smoothing = true;
            addChild(this._bitmapIcon);
         }
      }
   }
}

