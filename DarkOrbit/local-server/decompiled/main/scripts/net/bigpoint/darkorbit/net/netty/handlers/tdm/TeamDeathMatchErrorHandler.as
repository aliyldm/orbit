package net.bigpoint.darkorbit.net.netty.handlers.tdm
{
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchErrorCommand;
   import net.bigpoint.darkorbit.mvc.tdm.popups.TeamDeathMatchPopupNotifications;
   import net.bigpoint.darkorbit.mvc.tdm.popups.view.TeamDeathMatchErrorPopUpMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class TeamDeathMatchErrorHandler extends SimpleCommand
   {
      
      public function TeamDeathMatchErrorHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:TeamDeathMatchErrorCommand = param1.getBody() as TeamDeathMatchErrorCommand;
         var _loc3_:uint = uint(_loc2_.errorType);
         if(!facade.hasMediator(TeamDeathMatchErrorPopUpMediator.NAME))
         {
            facade.registerMediator(new TeamDeathMatchErrorPopUpMediator());
         }
         switch(_loc3_)
         {
            case TeamDeathMatchErrorCommand.ERRORTYPE_LEVEL_TOO_LOW:
               sendNotification(TeamDeathMatchPopupNotifications.OPEN_LEVEL_TOO_LOW_POPUP);
               break;
            case TeamDeathMatchErrorCommand.ERRORTYPE_MATCH_ENDED:
               sendNotification(TeamDeathMatchPopupNotifications.OPEN_MATCH_ENDED_POPUP);
               break;
            case TeamDeathMatchErrorCommand.ERRORTYPE_NO_MATCH_FOR_FACTION:
               sendNotification(TeamDeathMatchPopupNotifications.OPEN_NO_MATCH_FOR_FACTION_POPUP);
         }
      }
   }
}

