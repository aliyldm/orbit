package net.bigpoint.darkorbit.fui.builder.xml.factories
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.builder.xml.creators.AbstractCreator;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.BitmapLayer;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.FilledBoxLayer;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.ISkinLayer;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.MovieClipButtonLayer;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.MovieClipLayer;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.Scale15XBitmapLayer;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.Scale15YBitmapLayer;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.Scale9BitmapLayer;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.Scale9RepeatedXYFilledBitmapLayer;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   
   public class SkinLayerFactory
   {
      
      protected static var skinLayerMap:Dictionary;
      
      public static const ZERO:Point = new Point();
      
      public static const BITMAP_SKINLAYER:String = "BitmapLayer";
      
      public static const SCALE9BITMAP_SKINLAYER:String = "Scale9BitmapLayer";
      
      public static const SCALE15YBITMAP_SKINLAYER:String = "Scale15YBitmapLayer";
      
      public static const SCALE15XBITMAP_SKINLAYER:String = "Scale15XBitmapLayer";
      
      public static const FILLBOX_SKINLAYER:String = "FilledBoxLayer";
      
      public static const MOVIECLIP_SKINLAYER:String = "MovieClipLayer";
      
      public static const MOVIECLIPBUTTON_SKINLAYER:String = "MovieClipButtonLayer";
      
      public function SkinLayerFactory()
      {
         super();
      }
      
      protected static function initSkinLayerMapping() : void
      {
         if(skinLayerMap == null)
         {
            skinLayerMap = new Dictionary();
            skinLayerMap[BITMAP_SKINLAYER] = createBitmapLayer;
            skinLayerMap[SCALE9BITMAP_SKINLAYER] = createBitmapLayer;
            skinLayerMap[SCALE15XBITMAP_SKINLAYER] = createScale15XBitmapLayer;
            skinLayerMap[SCALE15YBITMAP_SKINLAYER] = createScale15YBitmapLayer;
            skinLayerMap[FILLBOX_SKINLAYER] = createFilledBoxLayer;
            skinLayerMap[MOVIECLIP_SKINLAYER] = createMovieClipLayer;
            skinLayerMap[MOVIECLIPBUTTON_SKINLAYER] = createMovieClipButtonLayer;
         }
      }
      
      public static function create(param1:XML, param2:String) : ISkinLayer
      {
         var _loc5_:ISkinLayer = null;
         initSkinLayerMapping();
         var _loc3_:String = param1.@classname;
         var _loc4_:Function = skinLayerMap[_loc3_];
         if(_loc4_ != null)
         {
            _loc5_ = _loc4_(param1,param2);
            _loc5_.name = param1.text();
            applyAttributesByReflection(_loc5_,param1);
         }
         else
         {
            UISystem.log("A SkinLayerClass with the name= {" + _loc3_ + "} doesn´t exist.",UISystem.LOG_LEVEL_WARN);
         }
         return _loc5_;
      }
      
      protected static function createBitmapLayer(param1:XML, param2:String) : ISkinLayer
      {
         var _loc7_:ISkinLayer = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc3_:String = param1.attribute(AbstractCreator.ATTRIBUTENAME_LIBRARYID);
         var _loc4_:String = param1.@scale9grid;
         var _loc5_:String = param1.@region;
         var _loc6_:BitmapData = getBitmapData(param2,_loc3_,_loc5_);
         if(_loc4_)
         {
            _loc9_ = _loc4_.split(",");
            if(_loc9_.length == 4)
            {
               _loc7_ = new Scale9BitmapLayer(_loc6_,_loc9_[0],_loc9_[1],_loc9_[2],_loc9_[3]);
            }
            else if(_loc9_.length == 5 && Boolean(_loc9_[4]))
            {
               _loc10_ = _loc9_[4];
               switch(_loc10_)
               {
                  case Scale9RepeatedXYFilledBitmapLayer.REPEAT_X:
                  case Scale9RepeatedXYFilledBitmapLayer.REPEAT_Y:
                  case Scale9RepeatedXYFilledBitmapLayer.REPEAT_XY:
                     _loc7_ = new Scale9RepeatedXYFilledBitmapLayer(_loc6_,_loc9_[0],_loc9_[1],_loc9_[2],_loc9_[3],_loc10_);
                     break;
                  default:
                     _loc7_ = new BitmapLayer(_loc6_);
                     UISystem.log("Specified wrong 9scale {FillMode}.");
               }
            }
            else
            {
               _loc7_ = new BitmapLayer(_loc6_);
               UISystem.log("Wrong scale9Grid definitions. Please check parameters. Set skin without scale9Grid defintions as fallback.",UISystem.LOG_LEVEL_WARN);
            }
         }
         else
         {
            _loc7_ = new BitmapLayer(_loc6_);
         }
         var _loc8_:DisplayObject = _loc7_ as DisplayObject;
         _loc8_.name = _loc3_;
         return _loc7_;
      }
      
      private static function getBitmapData(param1:String, param2:String, param3:String = null) : BitmapData
      {
         var _loc4_:Array = null;
         var _loc5_:Rectangle = null;
         var _loc6_:BitmapData = null;
         if(param3)
         {
            param3 = param3.replace(" ");
            _loc4_ = param3.split(",");
            if(_loc4_.length == 4)
            {
               _loc5_ = new Rectangle(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3]);
               _loc6_ = new BitmapData(_loc5_.width,_loc5_.height,true,0);
               _loc6_.copyPixels(ResourceManager.getBitmapData(param1,param2),_loc5_,ZERO);
               return _loc6_;
            }
         }
         return ResourceManager.getBitmapData(param1,param2);
      }
      
      protected static function createScale15YBitmapLayer(param1:XML, param2:String) : ISkinLayer
      {
         var _loc7_:ISkinLayer = null;
         var _loc8_:Array = null;
         var _loc3_:String = param1.@libraryID;
         var _loc4_:String = param1.@scale15grid;
         var _loc5_:String = param1.@region;
         var _loc6_:BitmapData = getBitmapData(param2,_loc3_,_loc5_);
         if(_loc4_)
         {
            _loc8_ = _loc4_.split(",");
            if(_loc8_.length == 6)
            {
               _loc7_ = new Scale15YBitmapLayer(_loc6_,_loc8_[0],_loc8_[1],_loc8_[2],_loc8_[3],_loc8_[4],_loc8_[5]);
            }
            else
            {
               _loc7_ = new BitmapLayer(_loc6_);
               UISystem.log("Wrong scale15Grid definitions. Please check parameters. Set skin without scale15Grid defintions as fallback.",UISystem.LOG_LEVEL_WARN);
            }
         }
         return _loc7_;
      }
      
      protected static function createScale15XBitmapLayer(param1:XML, param2:String) : ISkinLayer
      {
         var _loc7_:ISkinLayer = null;
         var _loc8_:Array = null;
         var _loc3_:String = param1.@libraryID;
         var _loc4_:String = param1.@scale15grid;
         var _loc5_:String = param1.@region;
         var _loc6_:BitmapData = getBitmapData(param2,_loc3_,_loc5_);
         if(_loc4_)
         {
            _loc8_ = _loc4_.split(",");
            if(_loc8_.length == 6)
            {
               _loc7_ = new Scale15XBitmapLayer(_loc6_,_loc8_[0],_loc8_[1],_loc8_[2],_loc8_[3],_loc8_[4],_loc8_[5]);
            }
            else
            {
               _loc7_ = new BitmapLayer(_loc6_);
               UISystem.log("Wrong scale15Grid definitions. Please check parameters. Set skin without scale15Grid defintions as fallback.",UISystem.LOG_LEVEL_WARN);
            }
         }
         return _loc7_;
      }
      
      protected static function createFilledBoxLayer(param1:XML, param2:String = null) : ISkinLayer
      {
         var _loc3_:FilledBoxLayer = new FilledBoxLayer();
         if(param1.@lineAlpha)
         {
            _loc3_.lineAlpha = param1.@lineAlpha;
         }
         if(param1.@lineColor)
         {
            _loc3_.lineColor = param1.@lineColor;
         }
         if(param1.@fillColor)
         {
            _loc3_.fillColor = param1.@fillColor;
         }
         if(param1.@fillAlpha)
         {
            _loc3_.fillAlpha = param1.@fillAlpha;
         }
         return _loc3_;
      }
      
      protected static function createMovieClipLayer(param1:XML, param2:String = null) : ISkinLayer
      {
         var _loc3_:String = param1.attribute(AbstractCreator.ATTRIBUTENAME_LIBRARYID);
         var _loc4_:MovieClip = ResourceManager.getMovieClip(param2,_loc3_);
         return new MovieClipLayer(_loc4_);
      }
      
      protected static function createMovieClipButtonLayer(param1:XML, param2:String = null) : ISkinLayer
      {
         var _loc3_:String = param1.attribute(AbstractCreator.ATTRIBUTENAME_LIBRARYID);
         var _loc4_:MovieClip = ResourceManager.getMovieClip(param2,_loc3_);
         var _loc5_:MovieClipButtonLayer = new MovieClipButtonLayer(_loc4_);
         if(param1.@child)
         {
            _loc5_.child = param1.@child;
         }
         if(Boolean(param1.@frame) && param1.@frame > 0)
         {
            _loc5_.frame = param1.@frame;
         }
         return _loc5_;
      }
      
      private static function applyAttributesByReflection(param1:Object, param2:XML) : void
      {
         var _loc4_:XML = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc3_:XMLList = param2.attributes();
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = _loc4_.name();
            if(param1.hasOwnProperty(_loc5_))
            {
               _loc6_ = _loc4_.valueOf();
               _loc6_ = _loc6_ == "true" ? true : (_loc6_ == "false" ? false : _loc6_);
               param1[_loc5_] = _loc6_;
            }
            else
            {
               UISystem.log("Couldn´t map attribute {" + _loc5_ + "} with the following value={" + _loc4_.valueOf() + "}",UISystem.LOG_LEVEL_WARN);
            }
         }
      }
   }
}

