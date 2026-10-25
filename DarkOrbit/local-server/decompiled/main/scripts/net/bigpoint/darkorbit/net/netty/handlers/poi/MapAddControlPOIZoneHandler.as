package net.bigpoint.darkorbit.net.netty.handlers.poi
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.com.module.AssetTypeModule;
   import net.bigpoint.darkorbit.com.module.MapAddControlPOIZoneCommand;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.sectorControl.map.ControlPoint;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import net.bigpoint.darkorbit.net.netty.HandlerLookup;
   import net.bigpoint.darkorbit.net.netty.handlers.MapAddPOIHandler;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class MapAddControlPOIZoneHandler extends DOAbstractSimpleCommand
   {
      
      public function MapAddControlPOIZoneHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:MapAddControlPOIZoneCommand = param1.getBody() as MapAddControlPOIZoneCommand;
         _loc2_.poiTypeSpecification = _loc2_.captured ? InGameCatalog.instance.factions_names_by_FactionModule[_loc2_.progressOwner.faction] : "NONE";
         MapAddPOIHandler.run(_loc2_);
         var _loc3_:SectorControlProxy = facade.retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy;
         var _loc4_:int = _loc3_.getControlPointIdByPOIid(_loc2_.poiId);
         var _loc5_:ControlPoint = map.getEntityById(_loc4_) as ControlPoint;
         if(!_loc5_)
         {
            _loc4_ = Map.NEXT_FREE_ID;
            _loc3_.storePOIControlPointMapping(_loc2_.poiId,_loc4_);
            HandlerLookup.execute(new AssetCreateCommand(new AssetTypeModule(AssetTypeModule.ASSETTYPE_SECTOR_CONTROL_SECTOR_ZONE),"",_loc2_.progressOwner.faction,"",_loc4_,0,0,_loc2_.shapeCoordinates[0],_loc2_.shapeCoordinates[1],0,false,false,false,false,null));
         }
         _loc5_ = map.getEntityById(_loc4_) as ControlPoint;
         _loc5_.captureProgress.value = _loc2_.captureProgress;
         _loc5_.captureThreshold.value = _loc2_.captureThreshold;
         _loc5_.progressOwner.value = _loc2_.progressOwner.faction;
         _loc5_.timeTillUnlock = _loc2_.timeTillUnlock;
         _loc5_.isCaptured.value = _loc2_.captured;
         _loc5_.enabled.value = true;
      }
   }
}

