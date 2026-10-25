package net.bigpoint.darkorbit.net.netty.handlers.pvpSummer
{
   import net.bigpoint.darkorbit.com.module.PVPSummerEventInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.model.PvpSummerUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PVPSummerEventInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function PVPSummerEventInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:PvpSummerUIWindowProxy = retrieveProxy(GuiConstants.PVP_SUMMER) as PvpSummerUIWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.PVP_SUMMER);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.PVP_SUMMER) as PvpSummerUIWindowProxy;
         }
         var _loc3_:PVPSummerEventInfoCommand = param1.getBody() as PVPSummerEventInfoCommand;
         _loc2_.updateInfo(_loc3_);
      }
   }
}

