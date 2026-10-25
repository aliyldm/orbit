package net.bigpoint.darkorbit.net.netty.handlers.sectorcontrol
{
   import net.bigpoint.darkorbit.com.module.SectorControlCaptureParticipationCommand;
   import net.bigpoint.darkorbit.mvc.sectorControl.SectorControlNotifications;
   import net.bigpoint.darkorbit.mvc.sectorControl.map.ControlPoint;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.proxy.SectorControlProxy;
   import net.bigpoint.darkorbit.mvc.sectorControl.model.vo.SectorCapturingProgressBarStateVO;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class SectorControlCaptureParticipationHandler extends BaseHandler
   {
      
      public function SectorControlCaptureParticipationHandler()
      {
         super();
      }
      
      public static function run(param1:SectorControlCaptureParticipationCommand) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ControlPoint = null;
         var _loc4_:Number = NaN;
         if(param1.capturing == true)
         {
            _facade.forwardNotification(SectorControlNotifications.UPDATE_PROGRESS_BAR_MODEL_SECTOR,param1.sectorId);
            _loc2_ = (_facade.retrieveProxy(SectorControlProxy.NAME) as SectorControlProxy).getControlPointIdByPOIid(param1.sectorId);
            _loc3_ = map.getEntityById(_loc2_) as ControlPoint;
            if(_loc3_ != null)
            {
               _loc4_ = _loc3_.capturePercentage * 100;
               _facade.forwardNotification(SectorControlNotifications.UPDATE_PROGRESS_BAR_MODEL_PROGRESS,new SectorCapturingProgressBarStateVO(param1.sectorId,SectorCapturingProgressBarStateVO.DIRECTION_UNKNOWN,_loc3_.progressOwner.value,_loc4_));
            }
         }
         else if(param1.capturing == false)
         {
            _facade.forwardNotification(SectorControlNotifications.UPDATE_PROGRESS_BAR_MODEL_SECTOR,null);
         }
      }
   }
}

