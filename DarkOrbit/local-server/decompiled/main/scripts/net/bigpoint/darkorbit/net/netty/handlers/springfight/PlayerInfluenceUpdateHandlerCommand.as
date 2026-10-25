package net.bigpoint.darkorbit.net.netty.handlers.springfight
{
   import net.bigpoint.darkorbit.com.module.PlayerInfluenceUpdateCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.influenceWindow.InfluenceWindowNotifications;
   import net.bigpoint.darkorbit.mvc.influenceWindow.model.InfluenceWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PlayerInfluenceUpdateHandlerCommand extends DOAbstractSimpleCommand
   {
      
      public function PlayerInfluenceUpdateHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         sendNotification(InfluenceWindowNotifications.INIT);
         var _loc2_:InfluenceWindowProxy = retrieveProxy(InfluenceWindowProxy.NAME) as InfluenceWindowProxy;
         var _loc3_:PlayerInfluenceUpdateCommand = param1.getBody() as PlayerInfluenceUpdateCommand;
         _loc2_.updatePlayerInfluence(_loc3_.playerScore);
      }
   }
}

