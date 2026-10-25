package net.bigpoint.darkorbit.net.netty.handlers.filter
{
   import net.bigpoint.darkorbit.com.module.BattlePassWindowSettingsModule;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.battlePass.model.BattlePassWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class BattlePassWindowSettingsHandler extends DOAbstractSimpleCommand
   {
      
      public function BattlePassWindowSettingsHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:BattlePassWindowSettingsModule = param1.getBody() as BattlePassWindowSettingsModule;
         this.setBattlePassFilterSettings(_loc2_.battlePassItemFilters);
      }
      
      protected function setBattlePassFilterSettings(param1:Vector.<String>) : void
      {
         var _loc3_:SimpleWindowCreationVO = null;
         var _loc2_:BattlePassWindowProxy = retrieveProxy(GuiConstants.BATTLE_PASS) as BattlePassWindowProxy;
         if(!_loc2_)
         {
            _loc3_ = SimpleWindowCreationMap.getById(GuiConstants.BATTLE_PASS);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc3_);
            _loc2_ = retrieveProxy(GuiConstants.BATTLE_PASS) as BattlePassWindowProxy;
         }
         _loc2_.updateFilter(param1);
      }
   }
}

