package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.lifecycle
{
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchOverviewCommand;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchOverviewInitCommand;
   import net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.model.TeamDeathMatchLobbywindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class TeamDeathMatchLobbywindowMatchOverviewInitCommand extends SimpleCommand
   {
      
      public function TeamDeathMatchLobbywindowMatchOverviewInitCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:TeamDeathMatchOverviewInitCommand = null;
         var _loc3_:TeamDeathMatchOverviewCommand = null;
         super.execute(param1);
         _loc2_ = param1.getBody() as TeamDeathMatchOverviewInitCommand;
         _loc3_ = new TeamDeathMatchOverviewCommand();
         _loc3_.maxLevel = _loc2_.maxLevel;
         _loc3_.minLevel = _loc2_.minLevel;
         _loc3_.overviewModules = _loc2_.overviewModules;
         _loc3_.queuedForMatch = _loc2_.queuedForMatch;
         var _loc4_:TeamDeathMatchLobbywindowProxy = facade.retrieveProxy(TeamDeathMatchLobbywindowProxy.NAME) as TeamDeathMatchLobbywindowProxy;
         _loc4_.setMatchOverviewData(_loc3_,false);
      }
   }
}

