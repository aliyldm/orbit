package net.bigpoint.darkorbit.net.netty.handlers.rogueLite
{
   import net.bigpoint.darkorbit.com.module.RogueLiteSelectShipCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.RogueLiteSelectionUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RogueLiteSelectShipCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function RogueLiteSelectShipCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:RogueLiteSelectionUIWindowProxy = retrieveProxy(GuiConstants.ROGUE_LITE_SELECTION) as RogueLiteSelectionUIWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.ROGUE_LITE_SELECTION);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.ROGUE_LITE_SELECTION) as RogueLiteSelectionUIWindowProxy;
         }
         else
         {
            sendNotification(GuiNotifications.MAXIMIZE_WINDOW_BY_ID,GuiConstants.ROGUE_LITE_SELECTION);
         }
         var _loc3_:RogueLiteSelectShipCommand = param1.getBody() as RogueLiteSelectShipCommand;
         _loc2_.updateShipList(_loc3_);
      }
   }
}

