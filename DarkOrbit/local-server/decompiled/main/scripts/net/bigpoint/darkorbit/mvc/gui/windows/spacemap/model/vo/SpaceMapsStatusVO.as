package net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.vo
{
   import net.bigpoint.darkorbit.mvc.spaceMap.vo.SpaceMapStationInfoVO;
   
   public class SpaceMapsStatusVO
   {
      
      private var _mapsStatus:Object;
      
      private var _spaceMapStations:Vector.<SpaceMapStationInfoVO>;
      
      public function SpaceMapsStatusVO(param1:Object, param2:Vector.<SpaceMapStationInfoVO>)
      {
         super();
         this._mapsStatus = param1;
         this._spaceMapStations = param2;
      }
      
      public function get mapsStatus() : Object
      {
         return this._mapsStatus;
      }
      
      public function get spaceMapStations() : Vector.<SpaceMapStationInfoVO>
      {
         return this._spaceMapStations;
      }
   }
}

