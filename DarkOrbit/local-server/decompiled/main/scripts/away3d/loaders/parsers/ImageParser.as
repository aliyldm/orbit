package away3d.loaders.parsers
{
   import away3d.arcane;
   import away3d.events.AssetEvent;
   import away3d.library.assets.BitmapDataAsset;
   import away3d.library.assets.IAsset;
   import away3d.textures.ATFCubeTexture;
   import away3d.textures.ATFData;
   import away3d.textures.ATFTexture;
   import away3d.textures.BitmapTexture;
   import away3d.tools.utils.TextureUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.utils.ByteArray;
   
   use namespace arcane;
   
   public class ImageParser extends ParserBase
   {
      
      private var _byteData:ByteArray;
      
      private var _startedParsing:Boolean;
      
      private var _doneParsing:Boolean;
      
      private var _loader:Loader;
      
      public function ImageParser()
      {
         super(ParserDataFormat.BINARY);
      }
      
      public static function supportsType(param1:String) : Boolean
      {
         param1 = param1.toLowerCase();
         return param1 == "jpg" || param1 == "jpeg" || param1 == "png" || param1 == "gif" || param1 == "bmp" || param1 == "atf";
      }
      
      public static function supportsData(param1:*) : Boolean
      {
         if(param1 is Bitmap)
         {
            return true;
         }
         if(param1 is BitmapData)
         {
            return true;
         }
         if(!(param1 is ByteArray))
         {
            return false;
         }
         var _loc2_:ByteArray = param1 as ByteArray;
         _loc2_.position = 0;
         if(_loc2_.readUnsignedShort() == 65496)
         {
            return true;
         }
         _loc2_.position = 0;
         if(_loc2_.readShort() == 16973)
         {
            return true;
         }
         _loc2_.position = 1;
         if(_loc2_.readUTFBytes(3) == "PNG")
         {
            return true;
         }
         _loc2_.position = 0;
         if(_loc2_.readUTFBytes(3) == "GIF" && _loc2_.readShort() == 14393 && _loc2_.readByte() == 97)
         {
            return true;
         }
         _loc2_.position = 0;
         if(_loc2_.readUTFBytes(3) == "ATF")
         {
            return true;
         }
         return false;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:IAsset = null;
         var _loc2_:ATFData = null;
         if(_data is Bitmap)
         {
            _loc1_ = new BitmapTexture(Bitmap(_data).bitmapData);
            finalizeAsset(_loc1_,_fileName);
            return PARSING_DONE;
         }
         if(_data is BitmapData)
         {
            _loc1_ = new BitmapTexture(_data as BitmapData);
            finalizeAsset(_loc1_,_fileName);
            return PARSING_DONE;
         }
         this._byteData = getByteData();
         if(!this._startedParsing)
         {
            this._byteData.position = 0;
            if(this._byteData.readUTFBytes(3) == "ATF")
            {
               this._byteData.position = 0;
               _loc2_ = new ATFData(this._byteData);
               this._byteData.position = 0;
               switch(_loc2_.type)
               {
                  case 0:
                     _loc1_ = new ATFTexture(this._byteData);
                     break;
                  case 1:
                     _loc1_ = new ATFCubeTexture(this._byteData);
                     break;
                  default:
                     throw new Error("Invalid ATF type");
               }
               if(_loc1_)
               {
                  finalizeAsset(_loc1_,_fileName);
               }
               return PARSING_DONE;
            }
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
            this._loader.loadBytes(this._byteData);
            this._startedParsing = true;
         }
         return this._doneParsing;
      }
      
      private function onLoadComplete(param1:Event) : void
      {
         var _loc3_:BitmapTexture = null;
         var _loc4_:BitmapDataAsset = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc2_:BitmapData = Bitmap(this._loader.content).bitmapData;
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         if(!TextureUtils.isBitmapDataValid(_loc2_))
         {
            _loc4_ = new BitmapDataAsset(_loc2_);
            _loc4_.name = _fileName;
            dispatchEvent(new AssetEvent(AssetEvent.TEXTURE_SIZE_ERROR,_loc4_));
            _loc2_ = new BitmapData(8,8,false,0);
            _loc5_ = 0;
            while(_loc5_ < 8)
            {
               _loc6_ = 0;
               while(_loc6_ < 8)
               {
                  if(_loc6_ & 1 ^ _loc5_ & 1)
                  {
                     _loc2_.setPixel(_loc5_,_loc6_,16777215);
                  }
                  _loc6_++;
               }
               _loc5_++;
            }
         }
         _loc3_ = new BitmapTexture(_loc2_);
         finalizeAsset(_loc3_,_fileName);
         this._doneParsing = true;
      }
   }
}

