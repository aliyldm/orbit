package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.update
{
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchOverviewCommand;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.model.TeamDeathMatchLobbywindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class TeamDeathMatchLobbywindowUpdateMatchCommand extends SimpleCommand
   {
      
      public function TeamDeathMatchLobbywindowUpdateMatchCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:TeamDeathMatchOverviewCommand = param1.getBody() as TeamDeathMatchOverviewCommand;
         var _loc3_:TeamDeathMatchLobbywindowProxy = facade.retrieveProxy(TeamDeathMatchLobbywindowProxy.NAME) as TeamDeathMatchLobbywindowProxy;
         _loc3_.setMatchOverviewData(_loc2_);
      }
   }
}

