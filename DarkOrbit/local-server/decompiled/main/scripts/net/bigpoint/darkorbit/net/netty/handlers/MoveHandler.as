package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.MoveCommand;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class MoveHandler extends BaseHandler
   {
      
      public function MoveHandler()
      {
         super();
      }
      
      public static function run(param1:MoveCommand) : void
      {
         moveShip(param1.userId,param1.x,param1.y,param1.timeToTarget);
      }
      
      private static function moveShip(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:Ship = map.getEntityById(param1) as Ship;
         if(_loc5_ == null)
         {
            GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_COMMAND,[ServerCommands.REQUEST_SHIP,[param1]]);
         }
         else if(param4 == 0)
         {
            _loc5_.moveTrait.stopMoving();
            _loc5_.position.setTo(param2,param3,0);
         }
         else
         {
            _loc5_.moveTrait.goto(param2,param3,null,null,param4 * 0.001);
         }
      }
   }
}

