package net.bigpoint.darkorbit.net.netty.handlers.tieredArena
{
   import net.bigpoint.darkorbit.com.module.TieredArenaEventReputationUpdateCommand;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TieredArenaEventReputationUpdateCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function TieredArenaEventReputationUpdateCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:Ship = null;
         var _loc4_:Number = NaN;
         super.execute(param1);
         var _loc2_:TieredArenaEventReputationUpdateCommand = param1.getBody() as TieredArenaEventReputationUpdateCommand;
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

