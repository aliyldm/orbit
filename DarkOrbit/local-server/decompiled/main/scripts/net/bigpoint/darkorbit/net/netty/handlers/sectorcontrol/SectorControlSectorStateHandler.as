package net.bigpoint.darkorbit.net.netty.handlers.sectorcontrol
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.SectorControlSectorStateCommand;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   import net.bigpoint.darkorbit.mvc.sectorControl.SectorControlNotifications;
   import net.bigpoint.darkorbit.mvc.sectorControl.map.ControlPoint;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.vo.SectorCapturingProgressBarStateVO;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class SectorControlSectorStateHandler extends BaseHandler
   {
      
      public function SectorControlSectorStateHandler()
      {
         super();
      }
      
      public static function run(param1:SectorControlSectorStateCommand) : void
      {
         if(_main.screenManager.map == null)
         {
            return;
         }
         var _loc2_:POIZone = _main.screenManager.map.poiManager.getZoneById(param1.sectorId);
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:int = (_facade.retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy).getControlPointIdByPOIid(param1.sectorId);
         if(_loc3_ == int.MIN_VALUE)
         {
            _loc3_ = Map.NEXT_FREE_ID;
            (_facade.retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy).storePOIControlPointMapping(param1.sectorId,_loc3_);
         }
         var _loc4_:ControlPoint = map.getEntityById(_loc3_) as ControlPoint;
         _loc4_.captureProgress.value = param1.captureProgress;
         _loc4_.progressOwner.value = param1.progressOwner.faction;
         _loc4_.invaders.value = Vector.<Object>(param1.invaders);
         _loc4_.timeTillUnlock = param1.timeTillUnlock;
         var _loc5_:String = InGameCatalog.getInstance().factions_names_by_FactionModule[param1.progressOwner.faction];
         if(_loc5_ == null || !_loc4_.isCaptured.value)
         {
            _loc5_ = "NONE";
         }
         _loc2_.zoneTypeSpecification.value = _loc5_;
         var _loc6_:int = calcDirection(_loc4_,param1);
         _facade.forwardNotification(SectorControlNotifications.UPDATE_PROGRESS_BAR_MODEL_PROGRESS,new SectorCapturingProgressBarStateVO(param1.sectorId,_loc6_,_loc4_.progressOwner.value,_loc4_.capturePercentage * 100));
      }
      
      private static function calcDirection(param1:ControlPoint, param2:SectorControlSectorStateCommand) : int
      {
         var _loc3_:int = -1;
         if(param1.isStable)
         {
            _loc3_ = SectorCapturingProgressBarStateVO.DIRECTION_UNKNOWN;
         }
         else if(param2.actionType == SectorControlSectorStateCommand.ACTIONTYPE_CAPTURING)
         {
            _loc3_ = SectorCapturingProgressBarStateVO.DIRECTION_CAPTURING;
         }
         else if(param2.actionType == SectorControlSectorStateCommand.ACTIONTYPE_NEUTRALIZING)
         {
            _loc3_ = SectorCapturingProgressBarStateVO.DIRECTION_NEUTRALIZING;
         }
         return _loc3_;
      }
   }
}

