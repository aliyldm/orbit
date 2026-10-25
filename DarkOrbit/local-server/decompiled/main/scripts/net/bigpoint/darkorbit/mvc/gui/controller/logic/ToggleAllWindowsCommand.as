package net.bigpoint.darkorbit.mvc.gui.controller.logic
{
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ToggleAllWindowsCommand extends DOAbstractSimpleCommand
   {
      
      public function ToggleAllWindowsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:FeatureWindowVO = param1.getBody() as FeatureWindowVO;
         if(_loc2_)
         {
            if(_loc2_.maximized)
            {
               guiProxy.addVisibleWindow(_loc2_);
            }
            else
            {
               guiProxy.removeVisibleWindow(_loc2_);
            }
         }
         else
         {
            this.toggleAllVisibleWindows(true);
         }
      }
      
      private function toggleAllVisibleWindows(param1:Boolean) : void
      {
         var _loc2_:FeatureWindowVO = null;
         var _loc3_:SimpleWindow = null;
         this.resetToogleMaximizedInfo();
         if(!param1)
         {
            this.updateCurrentlyVisibleWinowsList();
         }
         for each(_loc2_ in guiProxy.visibleWindows)
         {
            _loc3_ = guiProxy.getWindowById(_loc2_.id);
            if(_loc3_)
            {
               if(param1)
               {
                  _loc3_.maximize(false);
               }
               else
               {
                  _loc3_.minimize(false);
               }
               _loc2_.toggleMaximize = param1;
            }
         }
      }
      
      private function updateCurrentlyVisibleWinowsList() : void
      {
         var _loc1_:FeatureWindowVO = null;
         guiProxy.visibleWindows = new Vector.<FeatureWindowVO>();
         for each(_loc1_ in guiProxy.featureWindows)
         {
            if(_loc1_.saveSettingsOnServer)
            {
               if(_loc1_.maximized)
               {
                  guiProxy.addVisibleWindow(_loc1_);
               }
            }
         }
      }
      
      private function resetToogleMaximizedInfo() : void
      {
         var _loc1_:FeatureWindowVO = null;
         for each(_loc1_ in guiProxy.featureWindows)
         {
            _loc1_.toggleMaximize = false;
         }
      }
   }
}

