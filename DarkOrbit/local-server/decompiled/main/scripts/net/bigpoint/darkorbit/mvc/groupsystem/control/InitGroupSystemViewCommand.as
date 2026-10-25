package net.bigpoint.darkorbit.mvc.groupsystem.control
{
   import flash.geom.Point;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.proxy.GroupProxy;
   import net.bigpoint.darkorbit.mvc.groupsystem.notification.GroupSystemNotification;
   import net.bigpoint.darkorbit.mvc.groupsystem.view.GroupSystemMediator;
   import net.bigpoint.darkorbit.mvc.groupsystem.view.ui.GroupUI;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitGroupSystemViewCommand extends DOAbstractSimpleCommand
   {
      
      public function InitGroupSystemViewCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         this.createMediator();
      }
      
      private function createMediator() : void
      {
         var _loc1_:SimpleWindow = null;
         var _loc2_:GroupUI = null;
         var _loc3_:GroupProxy = null;
         if(!facade.hasMediator(GroupSystemMediator.NAME))
         {
            _loc1_ = guiProxy.getWindowById(GuiConstants.GROUP_SYSTEM_WINDOW);
            if(!_loc1_)
            {
               sendNotification(GuiNotifications.CREATE_WINDOW,GuiConstants.GROUP_SYSTEM_WINDOW);
               _loc1_ = guiProxy.getWindowById(GuiConstants.GROUP_SYSTEM_WINDOW);
            }
            _loc2_ = new GroupUI();
            _loc1_.addContainer(_loc2_);
            _loc2_.addPredefinedPosition(new Point(15,30));
            _loc2_.setPredefinedPosition();
            _loc2_.parentWindow = _loc1_;
            facade.registerMediator(new GroupSystemMediator(_loc2_));
            _loc3_ = facade.retrieveProxy(GroupProxy.NAME) as GroupProxy;
            sendNotification(GroupSystemNotification.UPDATE_UI,_loc3_.getData());
         }
      }
   }
}

