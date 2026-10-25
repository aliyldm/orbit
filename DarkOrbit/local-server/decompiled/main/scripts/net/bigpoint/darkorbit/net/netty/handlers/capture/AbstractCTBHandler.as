package net.bigpoint.darkorbit.net.netty.handlers.capture
{
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AbstractCTBHandler extends BaseHandler
   {
      
      public function AbstractCTBHandler()
      {
         super();
      }
      
      protected static function get guiManager() : GuiManager
      {
         return GuiManager.instance;
      }
   }
}

