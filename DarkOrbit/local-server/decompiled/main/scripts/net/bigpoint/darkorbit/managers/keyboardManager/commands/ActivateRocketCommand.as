package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.AttackRocketRequest;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   
   public class ActivateRocketCommand implements IKeyboardCommand
   {
      
      public static const NAME:String = "activateRocket";
      
      public function ActivateRocketCommand()
      {
         super();
      }
      
      public function execute(param1:Map, param2:Vector.<String>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:PointLite = null;
         var _loc6_:AttackRocketRequest = null;
         var _loc3_:MapEntity = param1.getShipManager().getSelectedShip() as MapEntity;
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.id;
            if(_loc4_ != -1)
            {
               _loc5_ = _loc3_.position;
               _loc6_ = new AttackRocketRequest(_loc4_);
               _loc6_.targetX = _loc5_.x;
               _loc6_.targetY = _loc5_.y;
               if((_loc6_.targetX + _loc6_.targetY) % 3 == 0)
               {
                  ++_loc6_.targetY;
               }
               GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc6_);
            }
         }
      }
   }
}

