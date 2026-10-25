package net.bigpoint.darkorbit.map.view2D.backgrounds.view
{
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.view2D.backgrounds.model.BackgroundElementVO;
   import net.bigpoint.darkorbit.mvc.display.IDisplayObject;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class AbstractBackgroundElement2D
   {
      
      private var _view:IDisplayObject;
      
      private var _data:BackgroundElementVO;
      
      private var _prevMeetsQualitySettings:Boolean = false;
      
      public function AbstractBackgroundElement2D(param1:IDisplayObject, param2:BackgroundElementVO = null)
      {
         super();
         this._view = param1;
         this._data = param2;
         Settings.qualityBackground.changed.add(this.handleBackgroundQualityChanged);
         setTimeout(this.handleBackgroundQualityChanged,1);
      }
      
      public static function compare(param1:AbstractBackgroundElement2D, param2:AbstractBackgroundElement2D) : int
      {
         return param1.data.depth - param2.data.depth;
      }
      
      public function get view() : IDisplayObject
      {
         return this._view;
      }
      
      public function get data() : BackgroundElementVO
      {
         return this._data;
      }
      
      public function testLensFlareCollision(param1:int, param2:int) : Boolean
      {
         return false;
      }
      
      public function dispose() : void
      {
         Settings.qualityBackground.changed.remove(this.handleBackgroundQualityChanged);
         this.unloadView();
      }
      
      public function update(param1:int, param2:int, param3:int, param4:int) : void
      {
      }
      
      public function setViewportSize(param1:int, param2:int) : void
      {
      }
      
      protected function handleBackgroundQualityChanged() : void
      {
         var _loc1_:Boolean = this.meetsQualitySettings();
         if(this._prevMeetsQualitySettings != _loc1_)
         {
            this._prevMeetsQualitySettings = _loc1_;
            if(_loc1_)
            {
               this.loadView();
            }
            else
            {
               this.unloadView();
            }
         }
      }
      
      protected function loadView() : void
      {
      }
      
      protected function unloadView() : void
      {
         if(this.view.numChildren > 0)
         {
            while(this.view.numChildren)
            {
               this.view.removeUntypedChildAt(0);
            }
         }
      }
      
      protected function meetsQualitySettings() : Boolean
      {
         return true;
      }
   }
}

