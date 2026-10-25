package net.bigpoint.darkorbit.net.netty.handlers.pvpSummer
{
   import net.bigpoint.darkorbit.com.module.PVPSummerEventReputationUpdateCommand;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PVPSummerEventReputationUpdateCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function PVPSummerEventReputationUpdateCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:Ship = null;
         var _loc4_:Number = NaN;
         super.execute(param1);
         var _loc2_:PVPSummerEventReputationUpdateCommand = param1.getBody() as PVPSummerEventReputationUpdateCommand;
         if(map != null)
         {
            _loc3_ = map.getShipManager().getShip(_loc2_.uid);
            if(_loc3_)
            {
               _loc4_ = _loc2_.reputation;
               _loc3_.info.pvpReputation.value = _loc4_;
            }
         }
      }
   }
}

