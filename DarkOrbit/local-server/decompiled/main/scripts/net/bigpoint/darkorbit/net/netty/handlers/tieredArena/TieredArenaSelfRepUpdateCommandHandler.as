package net.bigpoint.darkorbit.net.netty.handlers.tieredArena
{
   import net.bigpoint.darkorbit.com.module.TieredArenaEventSelfReputationUpdateCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.tieredArena.model.TieredArenaUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class TieredArenaSelfRepUpdateCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function TieredArenaSelfRepUpdateCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:TieredArenaUIWindowProxy = retrieveProxy(GuiConstants.TIERED_ARENA) as TieredArenaUIWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.TIERED_ARENA);
            facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.TIERED_ARENA) as TieredArenaUIWindowProxy;
         }
         var _loc3_:TieredArenaEventSelfReputationUpdateCommand = param1.getBody() as TieredArenaEventSelfReputationUpdateCommand;
         _loc2_.updateSelfReputation(_loc3_);
      }
   }
}

