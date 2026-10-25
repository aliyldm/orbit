package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.SpacePlagueStatusCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.plagueWindow.PlagueWindowNotifications;
   import net.bigpoint.darkorbit.mvc.plagueWindow.model.PlagueWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SpacePlagueStatusHandler extends DOAbstractSimpleCommand
   {
      
      public function SpacePlagueStatusHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         sendNotification(PlagueWindowNotifications.INIT);
         var _loc2_:SpacePlagueStatusCommand = param1.getBody() as SpacePlagueStatusCommand;
         var _loc3_:PlagueWindowProxy = facade.retrieveProxy(PlagueWindowProxy.NAME) as PlagueWindowProxy;
         _loc3_.setBossSummoningInfos(_loc2_.bossSummoningInfos);
         _loc3_.setInfection(_loc2_.infection);
         _loc3_.setRating(_loc2_.rating);
         _loc3_.updateView();
      }
   }
}

