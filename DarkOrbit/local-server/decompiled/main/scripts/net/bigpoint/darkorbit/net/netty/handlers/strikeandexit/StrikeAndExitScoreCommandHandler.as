package net.bigpoint.darkorbit.net.netty.handlers.strikeandexit
{
   import net.bigpoint.darkorbit.com.module.porting.strikeandexit.StrikeAndExitScoreCommand;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class StrikeAndExitScoreCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function StrikeAndExitScoreCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:Ship = null;
         var _loc4_:Number = NaN;
         super.execute(param1);
         var _loc2_:StrikeAndExitScoreCommand = param1.getBody() as StrikeAndExitScoreCommand;
         if(map != null)
         {
            _loc3_ = map.getShipManager().getShip(_loc2_.uid);
            if(_loc3_)
            {
               _loc4_ = _loc2_.score;
               _loc3_.info.saeScore.value = _loc4_;
            }
         }
      }
   }
}

