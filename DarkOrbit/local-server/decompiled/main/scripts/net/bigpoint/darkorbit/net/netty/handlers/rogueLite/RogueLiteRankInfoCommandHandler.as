package net.bigpoint.darkorbit.net.netty.handlers.rogueLite
{
   import net.bigpoint.darkorbit.com.module.RogueLiteRankInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.RogueLiteUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RogueLiteRankInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function RogueLiteRankInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:RogueLiteUIWindowProxy = retrieveProxy(GuiConstants.ROGUE_LITE) as RogueLiteUIWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.ROGUE_LITE);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.ROGUE_LITE) as RogueLiteUIWindowProxy;
         }
         var _loc3_:RogueLiteRankInfoCommand = param1.getBody() as RogueLiteRankInfoCommand;
         _loc2_.updateRanking(_loc3_);
      }
   }
}

