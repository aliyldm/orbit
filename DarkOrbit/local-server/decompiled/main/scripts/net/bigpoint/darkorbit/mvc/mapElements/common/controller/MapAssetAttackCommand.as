package net.bigpoint.darkorbit.mvc.mapElements.common.controller
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.AttackLaserRequest;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class MapAssetAttackCommand extends DOAbstractSimpleCommand
   {
      
      public function MapAssetAttackCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:int = 0;
         super.execute(param1);
         var _loc2_:MapEntity = map.lockManager.target;
         if(_loc2_)
         {
            _loc3_ = _loc2_.id;
            if(_loc3_ != -1)
            {
               this.startLaserAttack(_loc3_);
            }
         }
      }
      
      private function startLaserAttack(param1:int) : void
      {
         var _loc2_:AttackLaserRequest = null;
         _loc2_ = new AttackLaserRequest();
         var _loc3_:MapEntity = map.getShipManager().getSelectedShip();
         var _loc4_:PointLite = new PointLite(0,0);
         if(_loc3_)
         {
            _loc4_ = _loc3_.position;
         }
         _loc2_.targetId = param1;
         _loc2_.targetX = _loc4_.x;
         _loc2_.targetY = _loc4_.y;
         if((_loc2_.targetX + _loc2_.targetY) % 3 == 0)
         {
            ++_loc2_.targetX;
         }
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc2_);
         AttackerTrait(map.hero.getFirstTrait(AttackerTrait)).target = _loc3_.getFirstTrait(AttackTargetTrait) as AttackTargetTrait;
      }
   }
}

