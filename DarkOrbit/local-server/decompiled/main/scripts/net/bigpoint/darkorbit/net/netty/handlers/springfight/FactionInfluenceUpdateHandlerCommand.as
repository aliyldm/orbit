package net.bigpoint.darkorbit.net.netty.handlers.springfight
{
   import net.bigpoint.darkorbit.com.module.FactionInfluenceUpdateCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.influenceWindow.InfluenceWindowNotifications;
   import net.bigpoint.darkorbit.mvc.influenceWindow.model.InfluenceWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class FactionInfluenceUpdateHandlerCommand extends DOAbstractSimpleCommand
   {
      
      public function FactionInfluenceUpdateHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         sendNotification(InfluenceWindowNotifications.INIT);
         var _loc2_:FactionInfluenceUpdateCommand = param1.getBody() as FactionInfluenceUpdateCommand;
         var _loc3_:InfluenceWindowProxy = retrieveProxy(InfluenceWindowProxy.NAME) as InfluenceWindowProxy;
         _loc3_.updateFactionInfluence(_loc2_.mmoScore,_loc2_.eicScore,_loc2_.vruScore);
      }
   }
}

