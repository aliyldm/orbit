package net.bigpoint.darkorbit.net.netty.handlers.tdm
{
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchDraftConfirmationCommand;
   import net.bigpoint.darkorbit.mvc.tdm.popups.TeamDeathMatchPopupNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class TeamDeathMatchDraftConfirmationHandler extends SimpleCommand
   {
      
      public function TeamDeathMatchDraftConfirmationHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:TeamDeathMatchDraftConfirmationCommand = param1.getBody() as TeamDeathMatchDraftConfirmationCommand;
         var _loc3_:int = _loc2_.seconds;
         sendNotification(TeamDeathMatchPopupNotifications.OPEN_PARTICIPATION_POPUP,_loc3_);
      }
   }
}

