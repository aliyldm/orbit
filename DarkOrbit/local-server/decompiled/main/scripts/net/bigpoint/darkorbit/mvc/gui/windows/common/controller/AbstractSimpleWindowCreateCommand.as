package net.bigpoint.darkorbit.mvc.gui.windows.common.controller
{
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   
   public class AbstractSimpleWindowCreateCommand extends DOAbstractSimpleCommand
   {
      
      public function AbstractSimpleWindowCreateCommand()
      {
         super();
      }
      
      protected function createWindow(param1:SimpleWindowCreationVO) : IWindow
      {
         var _loc3_:IWindow = null;
         var _loc2_:String = param1.windowID;
         if(_loc2_)
         {
            _loc3_ = guiManager.getWindow(_loc2_);
            if(_loc3_ == null)
            {
               _loc3_ = guiManager.createWindow(_loc2_,param1) as SimpleWindow;
            }
            return _loc3_;
         }
         throw new Error("Tried to create a window instance but failed because the windowID was set to NULL.");
      }
   }
}

