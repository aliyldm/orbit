package net.bigpoint.darkorbit.net.netty.handlers.plutus
{
   import net.bigpoint.darkorbit.com.module.PlutusInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.plutus.model.PlutusUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PlutusInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function PlutusInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:PlutusUIWindowProxy = retrieveProxy(GuiConstants.GAUNTLET_OF_PLUTUS) as PlutusUIWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.GAUNTLET_OF_PLUTUS);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.GAUNTLET_OF_PLUTUS) as PlutusUIWindowProxy;
         }
         var _loc3_:PlutusInfoCommand = param1.getBody() as PlutusInfoCommand;
         _loc2_.updateInfo(_loc3_);
      }
   }
}

