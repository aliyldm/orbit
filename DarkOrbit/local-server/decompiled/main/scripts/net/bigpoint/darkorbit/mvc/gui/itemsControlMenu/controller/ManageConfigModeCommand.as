package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.controller
{
   import flash.display.Shape;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.ItemsControlMenuProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ManageConfigModeCommand extends DOAbstractSimpleCommand
   {
      
      public function ManageConfigModeCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Boolean = this.menuProxy.configMode = param1.getBody() as Boolean;
         this.manageConfigMode(_loc2_);
      }
      
      protected function manageConfigMode(param1:Boolean) : void
      {
         sendNotification(GuiNotifications.ADD_REMOVE_MENUS_CONFIG_GRID,param1 ? this.grid : null);
         this.windowsTint = param1;
      }
      
      private function get grid() : Shape
      {
         var _loc1_:Shape = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:int = 1;
         if(_loc1_ == null || _loc1_.parent == null)
         {
            _loc1_ = new Shape();
            _loc1_.graphics.lineStyle(_loc2_,16777215,0.2);
            _loc3_ = 0;
            while(_loc3_ < ScreenManager.getScreenHeight() / Settings.gridSize)
            {
               _loc1_.graphics.moveTo(0,_loc3_ * Settings.gridSize);
               _loc1_.graphics.lineTo(ScreenManager.getScreenWidth(),_loc3_ * Settings.gridSize);
               _loc3_++;
            }
            _loc4_ = 0;
            while(_loc4_ < ScreenManager.getScreenWidth() / Settings.gridSize)
            {
               _loc1_.graphics.moveTo(_loc4_ * Settings.gridSize,0);
               _loc1_.graphics.lineTo(_loc4_ * Settings.gridSize,ScreenManager.getScreenHeight());
               _loc4_++;
            }
            _loc1_.cacheAsBitmap = true;
         }
         return _loc1_;
      }
      
      protected function set windowsTint(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         var _loc3_:SimpleWindow = null;
         for(_loc2_ in guiManager.windows)
         {
            _loc3_ = guiManager.windows[_loc2_] as SimpleWindow;
            if(param1)
            {
               _loc3_.createFullDragger();
            }
            else
            {
               _loc3_.removeFullDragger();
            }
         }
      }
      
      protected function get menuProxy() : ItemsControlMenuProxy
      {
         return retrieveProxy(ItemsControlMenuProxy.NAME) as ItemsControlMenuProxy;
      }
   }
}

