package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items
{
   import com.bigpoint.utils.BitmapAtlas;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.vo.SynthesisStartLevelUtil;
   
   public class StarLevelDisplayHelper
   {
      
      private static var _starBitmapData:BitmapData;
      
      private static const STAR_TEXTURE_KEY:String = "starUp_ui_texture";
      
      private static const STAR_ATLAS_XML_KEY:String = "starUp_ui_atlasXml";
      
      private static const STAR_ASSET_ID:String = "item_start_30x30";
      
      private static const MAX_STAR_COUNT:int = 5;
      
      private static const STARS_PER_COLUMN:int = 3;
      
      private static const STAR_SIZE:Number = 8;
      
      private static const STAR_GAP:Number = 0;
      
      private static const STAR_RIGHT_MARGIN:Number = 0;
      
      private static const STAR_BOTTOM_MARGIN:Number = 0;
      
      public function StarLevelDisplayHelper()
      {
         super();
      }
      
      public static function render(param1:DisplayObjectContainer, param2:Object) : void
      {
         var startLevel:Number = NaN;
         var starCount:int = 0;
         var starBitmapData:BitmapData = null;
         var layerWidth:Number = NaN;
         var layerHeight:Number = NaN;
         var index:int = 0;
         var row:int = 0;
         var column:int = 0;
         var x:Number = NaN;
         var y:Number = NaN;
         var star:Bitmap = null;
         var starLayer:DisplayObjectContainer = param1;
         var itemDataVO:Object = param2;
         if(!starLayer)
         {
            return;
         }
         while(starLayer.numChildren > 0)
         {
            starLayer.removeChildAt(0);
         }
         try
         {
            startLevel = SynthesisStartLevelUtil.normalizeMappedStartLevel(itemDataVO);
            if(startLevel <= 0)
            {
               return;
            }
            starCount = Math.min(int(startLevel),MAX_STAR_COUNT);
            if(starCount <= 0)
            {
               return;
            }
            starBitmapData = getStarBitmapData();
            if(!starBitmapData)
            {
               return;
            }
            layerWidth = starLayer.width;
            layerHeight = starLayer.height;
            index = 0;
            while(index < starCount)
            {
               row = index % STARS_PER_COLUMN;
               column = int(index / STARS_PER_COLUMN);
               x = layerWidth - STAR_RIGHT_MARGIN - STAR_SIZE - column * (STAR_SIZE + STAR_GAP);
               y = layerHeight - STAR_BOTTOM_MARGIN - STAR_SIZE - row * (STAR_SIZE + STAR_GAP);
               if(!(x < 0 || x + STAR_SIZE > layerWidth || y < 0 || y + STAR_SIZE > layerHeight))
               {
                  star = new Bitmap(starBitmapData);
                  star.width = STAR_SIZE;
                  star.height = STAR_SIZE;
                  star.x = x;
                  star.y = y;
                  starLayer.addChild(star);
               }
               index++;
            }
         }
         catch(error:Error)
         {
            return;
         }
      }
      
      private static function getStarBitmapData() : BitmapData
      {
         if(_starBitmapData)
         {
            return _starBitmapData;
         }
         if(!ResourceManager.fileCollection)
         {
            return null;
         }
         var _loc1_:ImageFinisher = ResourceManager.fileCollection.getFinisher(STAR_TEXTURE_KEY) as ImageFinisher;
         var _loc2_:XMLFinisher = ResourceManager.fileCollection.getFinisher(STAR_ATLAS_XML_KEY) as XMLFinisher;
         if(!_loc1_ || !_loc2_)
         {
            return null;
         }
         var _loc3_:Bitmap = _loc1_.getBitmap();
         var _loc4_:XML = _loc2_.getXML();
         if(!_loc3_ || !_loc4_)
         {
            return null;
         }
         var _loc5_:BitmapAtlas = new BitmapAtlas(_loc3_,_loc4_);
         _starBitmapData = _loc5_.getBitmapDataByName(STAR_ASSET_ID);
         return _starBitmapData;
      }
   }
}

