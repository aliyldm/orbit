package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.update
{
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchDetailCommand;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.model.TeamDeathMatchLobbywindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class TeamDeathMatchLobbywindowUpdateMatchDetailCommand extends SimpleCommand
   {
      
      public function TeamDeathMatchLobbywindowUpdateMatchDetailCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:TeamDeathMatchDetailCommand = param1.getBody() as TeamDeathMatchDetailCommand;
         var _loc3_:TeamDeathMatchLobbywindowProxy = facade.retrieveProxy(TeamDeathMatchLobbywindowProxy.NAME) as TeamDeathMatchLobbywindowProxy;
         _loc3_.setMatchDetailData(_loc2_);
      }
   }
}

