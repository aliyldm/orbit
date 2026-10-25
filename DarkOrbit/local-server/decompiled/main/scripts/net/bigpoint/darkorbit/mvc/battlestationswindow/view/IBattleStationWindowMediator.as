package net.bigpoint.darkorbit.mvc.battlestationswindow.view
{
   public interface IBattleStationWindowMediator
   {
      
      function equipModuleToSlot(param1:int, param2:int, param3:int, param4:Boolean = false) : void;
      
      function removeEquippedModule(param1:int, param2:int) : void;
      
      function requestBuildBattleStation(param1:int, param2:int) : void;
      
      function requestDeactivationDeflector(param1:int, param2:int) : void;
      
      function sendRepairModuleRequest(param1:int, param2:int) : void;
   }
}

