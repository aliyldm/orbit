package net.bigpoint.darkorbit.mvc.gui.windows.common.controller
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DestroySimpleWindowCommand extends DOAbstractSimpleCommand
   {
      
      public function DestroySimpleWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:SimpleWindowCreationVO = param1.getBody() as SimpleWindowCreationVO;
         var _loc3_:String = param1.getBody() as String;
         if(!_loc2_)
         {
            _loc2_ = SimpleWindowCreationMap.getById(_loc3_);
         }
         if(_loc2_)
         {
            this.destroyWindowByWindowCreationVO(_loc2_);
         }
         else if(_loc3_)
         {
            this.destroyWindowByWindowID(_loc3_);
         }
      }
      
      private function destroyWindowByWindowID(param1:String) : void
      {
         this._removeProxy(param1);
         this._removeMediator(param1);
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_ID,param1);
         sendNotification(GuiNotifications.DELETE_WINDOW_BY_ID,param1);
      }
      
      private function destroyWindowByWindowCreationVO(param1:SimpleWindowCreationVO) : void
      {
         sendNotification(GuiNotifications.CLOSE_WINDOW_BY_ID,param1.windowID);
         sendNotification(GuiNotifications.DELETE_WINDOW_BY_ID,param1.windowID);
         this._removeMediator(param1.windowID);
         this._unregisterCommands(param1.commandMap);
         this._removeProxy(param1.windowID);
      }
      
      private function _unregisterCommands(param1:Dictionary) : *
      {
         var _loc2_:String = null;
         if(param1)
         {
            for(_loc2_ in param1)
            {
               if(!hasCommand(_loc2_))
               {
                  facade.removeCommand(_loc2_);
               }
            }
         }
      }
      
      private function _removeMediator(param1:String) : void
      {
         if(hasMediator(param1))
         {
            removeMediator(param1) as SimpleWindowMediator;
         }
      }
      
      private function _removeProxy(param1:String) : void
      {
         var _loc2_:SimpleWindowProxy = null;
         if(hasProxy(param1))
         {
            _loc2_ = removeProxy(param1) as SimpleWindowProxy;
         }
      }
   }
}

