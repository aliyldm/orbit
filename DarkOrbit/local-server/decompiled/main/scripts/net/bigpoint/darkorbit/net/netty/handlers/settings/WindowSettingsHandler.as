package net.bigpoint.darkorbit.net.netty.handlers.settings
{
   import net.bigpoint.darkorbit.com.module.WindowSettingsModule;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.ItemsControlMenuProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class WindowSettingsHandler extends DOAbstractSimpleCommand
   {
      
      public function WindowSettingsHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:WindowSettingsModule = param1.getBody() as WindowSettingsModule;
         screenManager.minimap.scaleFactor = _loc2_.minmapScale;
         guiProxy.setBarStatesFromString(_loc2_.barStatus);
      }
      
      protected function get menuProxy() : ItemsControlMenuProxy
      {
         return facade.retrieveProxy(ItemsControlMenuProxy.NAME) as ItemsControlMenuProxy;
      }
   }
}

