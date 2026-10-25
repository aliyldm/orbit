package net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components
{
   import net.bigpoint.darkorbit.com.module.SectorControlMatchDetailCommand;
   
   public interface ISectorControlLobbyWindowMatchDetailsPanel
   {
      
      function init() : void;
      
      function update(param1:SectorControlMatchDetailCommand) : void;
      
      function updateMinPlayersPerFaction(param1:int) : void;
      
      function updateMessageLable(param1:Boolean, param2:Boolean) : void;
   }
}

