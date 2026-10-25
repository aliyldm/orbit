package net.bigpoint.darkorbit.net.netty.handlers.plutus
{
   import net.bigpoint.darkorbit.com.module.PlutusPointsUpdateCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.plutus.model.PlutusUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PlutusPointsUpdateCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function PlutusPointsUpdateCommandHandler()
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
            facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.GAUNTLET_OF_PLUTUS) as PlutusUIWindowProxy;
         }
         var _loc3_:PlutusPointsUpdateCommand = param1.getBody() as PlutusPointsUpdateCommand;
         _loc2_.updatePoints(_loc3_);
      }
   }
}

