package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view
{
   import flash.events.IEventDispatcher;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchDetailCommand;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchOverviewCommand;
   
   public interface ITeamDeathMatchLobbywindow extends IEventDispatcher
   {
      
      function updateMatchDetailData(param1:TeamDeathMatchDetailCommand) : void;
      
      function updateMatchOverviewData(param1:TeamDeathMatchOverviewCommand) : void;
      
      function updateLevelrange(param1:uint, param2:uint) : void;
      
      function updateMatchTime(param1:String) : void;
      
      function clearMatchTime() : void;
      
      function enableUserInteraction(param1:Boolean) : void;
   }
}

