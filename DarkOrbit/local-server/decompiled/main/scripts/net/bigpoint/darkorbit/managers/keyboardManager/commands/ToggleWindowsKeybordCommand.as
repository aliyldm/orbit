package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.common.model.GuiProxy;
   
   public class ToggleWindowsKeybordCommand implements IKeyboardCommand
   {
      
      public static const NAME:String = "ToggleWindowsCommand";
      
      public function ToggleWindowsKeybordCommand()
      {
         super();
      }
      
      public function execute(param1:Map, param2:Vector.<String>) : void
      {
         this.guiProxy.toggleVisibilityWindows();
      }
      
      private function get guiProxy() : GuiProxy
      {
         return GameFacade.getInstance().retrieveProxy(GuiProxy.NAME) as GuiProxy;
      }
   }
}

