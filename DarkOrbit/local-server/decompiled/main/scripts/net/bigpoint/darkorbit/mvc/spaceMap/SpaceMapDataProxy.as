package net.bigpoint.darkorbit.mvc.spaceMap
{
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.com.module.StarmapStationInfo;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.SpaceMapNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.SpaceMapConfig;
   import net.bigpoint.darkorbit.mvc.spaceMap.vo.SpaceMapStationInfoVO;
   import net.bigpoint.darkorbit.utils.XMLUtils;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class SpaceMapDataProxy extends Proxy implements IProxy
   {
      
      public static const NAME:String = "SpaceMapDataProxy";
      
      public static const SPACE_MAP_CONFIG:String = "spacemap-config";
      
      private var _callback:Function;
      
      private var _spaceMapStations:Vector.<SpaceMapStationInfoVO> = new Vector.<SpaceMapStationInfoVO>();
      
      public function SpaceMapDataProxy()
      {
         super(NAME);
      }
      
      public function get spaceMapStations() : Vector.<SpaceMapStationInfoVO>
      {
         return this._spaceMapStations;
      }
      
      public function updateSpaceMapStations(param1:Vector.<StarmapStationInfo>, param2:Number) : void
      {
         var _loc3_:StarmapStationInfo = null;
         var _loc4_:Number = NaN;
         this._spaceMapStations = new Vector.<SpaceMapStationInfoVO>();
         for each(_loc3_ in param1)
         {
            _loc4_ = param2 - _loc3_.lastChangedTimestamp;
            this._spaceMapStations.push(new SpaceMapStationInfoVO(_loc3_.mapId,_loc3_.xPositionPercentage,_loc3_.yPositionPercentage,_loc3_.status,_loc3_.lastChangedTimestamp,_loc4_,_loc3_.clanName,_loc3_.asteroidName,_loc3_.owningFaction.faction));
         }
         sendNotification(SpaceMapNotifications.SPACE_MAP_STATIONS_INFO_UPDATED,this._spaceMapStations);
      }
      
      public function getStationInfoByMapId(param1:int) : SpaceMapStationInfoVO
      {
         var _loc2_:int = int(this._spaceMapStations.length);
         var _loc3_:int = 0;
         while(_loc3_ != _loc2_)
         {
            if(this._spaceMapStations[_loc3_].mapId == param1)
            {
               return this._spaceMapStations[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function loadConfig(param1:Function = null) : void
      {
         this._callback = param1;
         ResourceManager.fileCollection.load(SPACE_MAP_CONFIG,this.handleSpaceMapConfigXMLLoaded);
      }
      
      private function handleSpaceMapConfigXMLLoaded(param1:XMLFinisher) : void
      {
         SpaceMapConfig.spaceMapConfig = XMLUtils.resolveReferences(param1.getXML());
         param1.dispose();
         this._callback();
         this._callback = null;
      }
   }
}

