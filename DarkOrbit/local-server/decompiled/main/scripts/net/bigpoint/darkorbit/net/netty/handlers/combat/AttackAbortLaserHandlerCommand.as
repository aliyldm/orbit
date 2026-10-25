package net.bigpoint.darkorbit.net.netty.handlers.combat
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.AttackAbortLaserCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class AttackAbortLaserHandlerCommand extends DOAbstractSimpleCommand
   {
      
      public function AttackAbortLaserHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:AttackAbortLaserCommand = param1.getBody() as AttackAbortLaserCommand;
         facade.sendNotification(MapAssetNotification.ABORT_LASER_ATTACK,[false,_loc2_.uid,_loc2_.uid == Hero.userID]);
      }
   }
}

