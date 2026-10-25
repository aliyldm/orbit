package net.bigpoint.darkorbit.net.netty.handlers.dispatch
{
   import net.bigpoint.darkorbit.com.module.DispatchLootMessageCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.main.model.DispatchUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DispatchLootMessageCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function DispatchLootMessageCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:DispatchUIWindowProxy = retrieveProxy(GuiConstants.DISPATCH) as DispatchUIWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.DISPATCH);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.DISPATCH) as DispatchUIWindowProxy;
         }
         var _loc3_:DispatchLootMessageCommand = param1.getBody() as DispatchLootMessageCommand;
         _loc2_.showLootMessagePopup(_loc3_);
      }
   }
}

