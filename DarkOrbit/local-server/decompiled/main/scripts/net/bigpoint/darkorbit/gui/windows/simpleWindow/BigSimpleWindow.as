package net.bigpoint.darkorbit.gui.windows.simpleWindow
{
   import flash.display.MovieClip;
   
   public class BigSimpleWindow extends SimpleWindow
   {
      
      public function BigSimpleWindow()
      {
         super();
      }
      
      override protected function setWindowContainerMask() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         _loc1_ = _windowContainer[WINDOWCONTAINER_MASK];
         _loc1_.mouseEnabled = false;
         _loc1_.cacheAsBitmap = true;
         _windowMask = _loc1_["windowMask"];
         _windowMask.mouseEnabled = false;
         _loc2_ = _windowContainer[WINDOWCONTAINER_PATTERN];
         _loc2_.mouseEnabled = false;
         _loc2_.cacheAsBitmap = true;
         _loc2_.mask = _loc1_;
      }
   }
}

