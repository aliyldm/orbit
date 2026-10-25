package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.controller
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.CPUInitializationCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.spacemap.model.SpaceMapWindowProxy;
   import net.bigpoint.darkorbit.mvc.spaceMap.SpaceMapDataProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CpuInitializationCommand extends DOAbstractSimpleCommand
   {
      
      public function CpuInitializationCommand()
      {
         super();
      }
      
      private static function get spaceMapProxy() : SpaceMapWindowProxy
      {
         return GameFacade.getInstance().retrieveProxy(GuiConstants.SPACEMAP_WINDOW) as SpaceMapWindowProxy;
      }
      
      private static function get spaceMapBattleStationIconProxy() : SpaceMapDataProxy
      {
         return GameFacade.getInstance().retrieveProxy(SpaceMapDataProxy.NAME) as SpaceMapDataProxy;
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:CPUInitializationCommand = param1.getBody() as CPUInitializationCommand;
         Hero.advancedJumpCPUEquipped.value = _loc2_.advancedJumpCPUEquipped;
         Hero.radarCPUEquipped.value = _loc2_.radarCPUEquipped;
         spaceMapProxy.updateJumpCPUEquippedStatus(_loc2_.advancedJumpCPUEquipped,spaceMapBattleStationIconProxy.spaceMapStations);
      }
   }
}

