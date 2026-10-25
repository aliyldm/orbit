package net.bigpoint.darkorbit.net.netty.handlers.pvpSummer
{
   import net.bigpoint.darkorbit.com.module.PVPSummerEventShuffleInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.pvpSummer.model.PvpSummerUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PVPSummerEventShuffleInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function PVPSummerEventShuffleInfoCommandHandler()
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
            facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.PVP_SUMMER) as PvpSummerUIWindowProxy;
         }
         var _loc3_:PVPSummerEventShuffleInfoCommand = param1.getBody() as PVPSummerEventShuffleInfoCommand;
         _loc2_.updateShuffleInfo(_loc3_);
      }
   }
}

