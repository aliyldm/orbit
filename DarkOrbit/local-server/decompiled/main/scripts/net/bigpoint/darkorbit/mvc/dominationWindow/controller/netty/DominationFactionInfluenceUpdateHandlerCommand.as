package net.bigpoint.darkorbit.mvc.dominationWindow.controller.netty
{
   import net.bigpoint.darkorbit.com.module.DominationFactionInfluenceUpdateCommand;
   import net.bigpoint.darkorbit.mvc.dominationWindow.DominationNotificationNames;
   import net.bigpoint.darkorbit.mvc.dominationWindow.model.DominationWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class DominationFactionInfluenceUpdateHandlerCommand extends SimpleCommand
   {
      
      public function DominationFactionInfluenceUpdateHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         sendNotification(DominationNotificationNames.INIT);
         var _loc2_:DominationFactionInfluenceUpdateCommand = param1.getBody() as DominationFactionInfluenceUpdateCommand;
         var _loc3_:DominationWindowProxy = facade.retrieveProxy(DominationWindowProxy.NAME) as DominationWindowProxy;
         _loc3_.updateDominationPoints(_loc2_.mmoScore,_loc2_.eicScore,_loc2_.vruScore,_loc2_.mmoDominationPoints,_loc2_.eicDominationPoints,_loc2_.vruDominationPoints);
      }
   }
}

