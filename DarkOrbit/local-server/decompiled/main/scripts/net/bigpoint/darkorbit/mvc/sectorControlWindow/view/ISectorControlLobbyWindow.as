package net.bigpoint.darkorbit.mvc.sectorControlWindow.view
{
   import flash.events.IEventDispatcher;
   import net.bigpoint.darkorbit.com.module.SectorControlMatchDetailCommand;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.model.vo.SectorControlItemlistOverviewVO;
   
   public interface ISectorControlLobbyWindow extends IEventDispatcher
   {
      
      function initialize() : void;
      
      function updateItemlist(param1:Vector.<SectorControlItemlistOverviewVO>) : void;
      
      function updateMatchStatePanel(param1:SectorControlMatchDetailCommand) : void;
      
      function updateUserLevel(param1:int, param2:uint, param3:uint) : void;
      
      function updateUserMinPlayerPerTeam(param1:int) : void;
      
      function updateMatchTime(param1:String) : void;
      
      function clearMatchTime() : void;
      
      function enableUserInteraction(param1:Boolean) : void;
      
      function updateActionButtonLable(param1:String) : void;
      
      function updateMessageLable(param1:Boolean, param2:Boolean) : void;
   }
}

