package net.bigpoint.darkorbit.net.netty.handlers.battlePass
{
   import net.bigpoint.darkorbit.com.module.BattlePassInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.battlePass.model.BattlePassWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class BattlePassInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function BattlePassInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:BattlePassWindowProxy = retrieveProxy(GuiConstants.BATTLE_PASS) as BattlePassWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.BATTLE_PASS);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.BATTLE_PASS) as BattlePassWindowProxy;
         }
         var _loc3_:BattlePassInfoCommand = param1.getBody() as BattlePassInfoCommand;
         _loc2_.updateInfo(_loc3_);
      }
   }
}

