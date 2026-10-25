package net.bigpoint.darkorbit.map.view2D.backgrounds.view
{
   import flash.geom.Rectangle;
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.view2D.backgrounds.model.BackgroundVO;
   import net.bigpoint.darkorbit.mvc.display.IDisplayObject;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class BasicElement2D extends AbstractBackgroundElement2D
   {
      
      public var offsetX:int = 0;
      
      public var offsetY:int = 0;
      
      private var _tiles:Vector.<BasicElementTile> = new Vector.<BasicElementTile>();
      
      public function BasicElement2D(param1:IDisplayObject, param2:BackgroundVO)
      {
         super(param1,param2);
         this.offsetX = param2.shiftX + param2.pattern.offsetX;
         this.offsetY = param2.shiftY + param2.pattern.offsetY;
      }
      
      override public function update(param1:int, param2:int, param3:int, param4:int) : void
      {
         view.x = int(-param1 / this.backgroundVO.parallaxFactor + param3 + this.offsetX);
         view.y = int(-param2 / this.backgroundVO.parallaxFactor + param4 + this.offsetY);
      }
      
      public function get backgroundVO() : BackgroundVO
      {
         return data as BackgroundVO;
      }
      
      override protected function meetsQualitySettings() : Boolean
      {
         return Settings.qualityBackground.value == Settings.QUALITY_HIGH || this.backgroundVO.isMain && Settings.qualityBackground.value > Settings.QUALITY_LOW;
      }
      
      override protected function loadView() : void
      {
         var _loc1_:String = null;
         var _loc2_:FileCollection = null;
         super.loadView();
         if(this.backgroundVO.pattern.showInStarlingMode || !Settings.gpuSupport)
         {
            _loc1_ = this.backgroundVO.pattern.resKey;
            _loc2_ = ResourceManager.fileCollection;
            if(_loc2_.fileExists(_loc1_ + "_01") && _loc2_.fileExists(_loc1_ + "_02") && _loc2_.fileExists(_loc1_ + "_03") && _loc2_.fileExists(_loc1_ + "_04"))
            {
               this._tiles.push(new BasicElementTile(_loc1_ + "_01",view,0,0,this.fixRegion(this.backgroundVO.region,0,0)));
               this._tiles.push(new BasicElementTile(_loc1_ + "_02",view,2048,0,this.fixRegion(this.backgroundVO.region,2048,0)));
               this._tiles.push(new BasicElementTile(_loc1_ + "_03",view,0,2048,this.fixRegion(this.backgroundVO.region,0,2048)));
               this._tiles.push(new BasicElementTile(_loc1_ + "_04",view,2048,2048,this.fixRegion(this.backgroundVO.region,2048,2048)));
            }
            else if(_loc2_.fileExists(_loc1_))
            {
               this._tiles.push(new BasicElementTile(_loc1_,view,0,0,this.backgroundVO.region));
            }
         }
      }
      
      private function fixRegion(param1:Rectangle, param2:int, param3:int) : Rectangle
      {
         if(param1)
         {
            param1 = param1.clone();
            param1.width = Math.min(2048,param1.width - param2);
            param1.height = Math.min(2048,param1.height - param3);
         }
         return param1;
      }
      
      override protected function unloadView() : void
      {
         while(this._tiles.length > 0)
         {
            this._tiles.pop().unloadView();
         }
         super.unloadView();
      }
   }
}

