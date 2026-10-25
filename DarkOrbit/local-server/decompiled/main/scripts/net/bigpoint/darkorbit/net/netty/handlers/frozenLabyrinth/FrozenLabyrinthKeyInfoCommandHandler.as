package net.bigpoint.darkorbit.net.netty.handlers.frozenLabyrinth
{
   import net.bigpoint.darkorbit.com.module.FrozenLabyrinthKeyInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.frozenLabyrinth.model.FrozenLabyrinthUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class FrozenLabyrinthKeyInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function FrozenLabyrinthKeyInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:FrozenLabyrinthUIWindowProxy = retrieveProxy(GuiConstants.FROZEN_LABYRINTH) as FrozenLabyrinthUIWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.FROZEN_LABYRINTH);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.FROZEN_LABYRINTH) as FrozenLabyrinthUIWindowProxy;
         }
         var _loc3_:FrozenLabyrinthKeyInfoCommand = param1.getBody() as FrozenLabyrinthKeyInfoCommand;
         _loc2_.updateKeys(_loc3_);
      }
   }
}

