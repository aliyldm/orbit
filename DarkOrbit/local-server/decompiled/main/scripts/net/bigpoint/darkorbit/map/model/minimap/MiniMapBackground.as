package net.bigpoint.darkorbit.map.model.minimap
{
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class MiniMapBackground extends Bitmap
   {
      
      private var _width:int = 0;
      
      private var _height:int = 0;
      
      private var _resKey:String;
      
      private var _mapId:int;
      
      public function MiniMapBackground()
      {
         super();
      }
      
      public function update(param1:Map, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         this._width = param2;
         this._height = param3;
         if(this._mapId != param1.mapID)
         {
            this._mapId = param1.mapID;
            this._resKey = null;
            bitmapData = null;
         }
         if(Settings.displayMiniMapBackgroundImage.value)
         {
            _loc4_ = 700;
            if(param2 <= 400)
            {
               _loc4_ = 300;
            }
            _loc5_ = String(param1.mapXml.@minimap).length ? "minimap-" + String(param1.mapXml.@minimap) : "";
            if(!ResourceManager.fileCollection.fileExists(_loc5_))
            {
               _loc5_ = "minimap-" + (String(param1.mapXml.@minimap).length ? String(param1.mapXml.@minimap) : "") + "-" + _loc4_;
            }
            if(!ResourceManager.fileCollection.fileExists(_loc5_))
            {
               _loc5_ = "minimap-" + param1.mapID + "-" + _loc4_;
            }
            if(!ResourceManager.fileCollection.fileExists(_loc5_))
            {
               _loc5_ = "minimap-" + param1.mapID;
            }
            if(this._resKey != _loc5_)
            {
               this._resKey = _loc5_;
               ResourceManager.fileCollection.load(this._resKey,this.handleFileLoadComplete);
            }
            else
            {
               this.updateScale();
            }
         }
         else
         {
            this._resKey = null;
            bitmapData = new BitmapData(1,1,false,592137);
            this.updateScale();
         }
      }
      
      private function handleFileLoadComplete(param1:ImageFinisher) : void
      {
         if(bitmapData)
         {
            bitmapData.dispose();
         }
         var _loc2_:Boolean = bitmapData == null;
         bitmapData = param1.getBitmap().bitmapData.clone();
         smoothing = true;
         this.updateScale();
         if(_loc2_)
         {
            alpha = 0;
            TweenLite.to(this,0.3,{"alpha":1});
         }
         param1.dispose();
      }
      
      private function updateScale() : void
      {
         if(bitmapData)
         {
            scaleX = scaleY = this._width / bitmapData.width;
         }
      }
   }
}

