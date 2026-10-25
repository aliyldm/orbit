package net.bigpoint.darkorbit.mvc.mapElements.common.controller
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.AttackAbortLaserRequest;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.StopLaserEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class AbortLaserAttackCommand extends DOAbstractSimpleCommand
   {
      
      public function AbortLaserAttackCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc8_:String = null;
         var _loc2_:Boolean = Boolean(param1.getBody()[0]);
         var _loc3_:int = int(param1.getBody()[1]);
         var _loc4_:Boolean = Boolean(param1.getBody()[2]);
         var _loc5_:Ship = map.getShipManager().getShip(_loc3_);
         if(!_loc5_)
         {
            return;
         }
         map.effects.playEffect(new StopLaserEffect(_loc5_));
         if(_loc2_)
         {
            facade.sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new AttackAbortLaserRequest());
         }
         var _loc6_:Ship = map.lockManager.target as Ship;
         if(_loc4_ && Boolean(_loc6_))
         {
            _loc8_ = BPLocale.getItem("attstop").replace(/%!/,_loc6_.info.username.value);
            facade.sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(_loc8_));
         }
         var _loc7_:AttackerTrait = _loc5_.getFirstTrait(AttackerTrait) as AttackerTrait;
         if(_loc7_)
         {
            _loc7_.target = null;
         }
      }
   }
}

