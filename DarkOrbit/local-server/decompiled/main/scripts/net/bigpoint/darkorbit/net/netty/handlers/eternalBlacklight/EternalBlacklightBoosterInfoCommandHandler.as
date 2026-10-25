package net.bigpoint.darkorbit.net.netty.handlers.eternalBlacklight
{
   import net.bigpoint.darkorbit.com.module.EternalBlacklightBoosterInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.model.EternalBlacklightUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class EternalBlacklightBoosterInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function EternalBlacklightBoosterInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:EternalBlacklightUIWindowProxy = retrieveProxy(GuiConstants.ETERNAL_BLACKLIGHT) as EternalBlacklightUIWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.ETERNAL_BLACKLIGHT);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.ETERNAL_BLACKLIGHT) as EternalBlacklightUIWindowProxy;
         }
         var _loc3_:EternalBlacklightBoosterInfoCommand = param1.getBody() as EternalBlacklightBoosterInfoCommand;
         _loc2_.updateBoosters(_loc3_);
      }
   }
}

