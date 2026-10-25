package net.bigpoint.darkorbit.mvc.crafting.reroll.control
{
   import net.bigpoint.darkorbit.com.module.UnstableModuleRestabilizeResultCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.model.RerollResultWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UnstableModuleRestabilizeResultCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function UnstableModuleRestabilizeResultCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:RerollResultWindowProxy = retrieveProxy(GuiConstants.REROLL_POPUP) as RerollResultWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.REROLL_POPUP);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.REROLL_POPUP) as RerollResultWindowProxy;
         }
         else
         {
            sendNotification(GuiNotifications.MAXIMIZE_WINDOW_BY_ID,GuiConstants.REROLL_POPUP);
         }
         var _loc3_:UnstableModuleRestabilizeResultCommand = param1.getBody() as UnstableModuleRestabilizeResultCommand;
         _loc2_.updateResults(_loc3_);
      }
   }
}

