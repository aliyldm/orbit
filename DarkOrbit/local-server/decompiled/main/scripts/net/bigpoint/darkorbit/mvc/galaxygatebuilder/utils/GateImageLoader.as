package net.bigpoint.darkorbit.mvc.galaxygatebuilder.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.utils.BitmapUtils;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class GateImageLoader
   {
      
      public const loaded:ISignal = new Signal(int,Boolean);
      
      private const _rec:Rectangle = new Rectangle(0,0,235,290);
      
      private const _pt:Point = new Point(0,0);
      
      private var _gateID:int;
      
      private var _fromGetPartsCmd:Boolean;
      
      private var _gateBitmap:Bitmap;
      
      private var _gateBitmapData:BitmapData;
      
      private var _lastPartBitmap:Bitmap;
      
      private var _lastPartBitmapData:BitmapData;
      
      private var _gatePartBitmapArray:Array;
      
      private var _maxParts:int;
      
      private var _currPart:int;
      
      private var _partIds:Vector.<int>;
      
      private var _hasChanges:Boolean;
      
      private var _isLoading:Boolean;
      
      public function GateImageLoader(param1:int, param2:int)
      {
         super();
         this.createBitmaps();
         this._gateID = param1;
         this._maxParts = param2;
         this._currPart = 0;
         this._partIds = new Vector.<int>();
         this._fromGetPartsCmd = true;
         this._hasChanges = true;
         this._isLoading = false;
      }
      
      public static function sort(param1:int, param2:int) : int
      {
         return param1 - param2;
      }
      
      public function get isLoading() : Boolean
      {
         return this._isLoading;
      }
      
      public function get gateBitmap() : Bitmap
      {
         return this._gateBitmap;
      }
      
      public function get lastPartBitmap() : Bitmap
      {
         return this._lastPartBitmap;
      }
      
      public function set partIds(param1:Vector.<int>) : void
      {
         this._hasChanges = this._partIds != null && param1 != null && this._partIds.length != param1.length;
         if(!this._hasChanges)
         {
            return;
         }
         this._partIds = param1;
      }
      
      public function set fromGetPartsCmd(param1:Boolean) : void
      {
         this._fromGetPartsCmd = param1;
      }
      
      private function createBitmaps() : void
      {
         if(this._gateBitmap != null && this._gateBitmap.bitmapData != null)
         {
            this._gateBitmap.bitmapData.dispose();
            this._gateBitmap.bitmapData = null;
         }
         this._gateBitmapData = new BitmapData(this._rec.width,this._rec.height,true,0);
         this._gateBitmap = new Bitmap(this._gateBitmapData);
         if(this._lastPartBitmap != null && this._lastPartBitmap.bitmapData != null)
         {
            this._lastPartBitmap.bitmapData.dispose();
            this._lastPartBitmap.bitmapData = null;
         }
         this._lastPartBitmapData = new BitmapData(this._rec.width,this._rec.height,true,0);
         this._lastPartBitmap = new Bitmap(this._lastPartBitmapData);
      }
      
      public function load() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(!this._hasChanges && BitmapUtils.isValidBitmapData(this._gateBitmapData) && BitmapUtils.isValidBitmapData(this._lastPartBitmapData))
         {
            this.loaded.dispatch(this._gateID,this._fromGetPartsCmd);
            return;
         }
         this.createBitmaps();
         if(this._partIds == null || this._partIds.length == 0)
         {
            this._hasChanges = false;
            this.loaded.dispatch(this._gateID,this._fromGetPartsCmd);
            return;
         }
         this._isLoading = true;
         this._gatePartBitmapArray = [];
         var _loc1_:String = "gate_" + this._gateID;
         if(this._partIds.length < this._maxParts)
         {
            this._currPart = 0;
            _loc2_ = int(this._partIds.length);
            _loc3_ = this._partIds[0];
            this._partIds.sort(GateImageLoader.sort);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc5_ = this._partIds[_loc4_];
               this.loadImage(_loc1_ + "_" + _loc5_,_loc5_ == _loc3_ ? this.handleLastPartImageLoaded : this.handleGateImageLoaded);
               _loc4_++;
            }
         }
         else
         {
            this._currPart = this._maxParts;
            this.loadImage(_loc1_,this.handleGateImageLoaded);
         }
      }
      
      private function loadImage(param1:String, param2:Function) : void
      {
         var _loc5_:ImageFinisher = null;
         var _loc3_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         var _loc4_:FileCollection = _loc3_.getFileCollectionByInstanceName(AssetsProxy.JUMPGATE);
         if(!_loc3_.isLoaded(param1,AssetsProxy.JUMPGATE))
         {
            _loc3_.load(param1,param2,this.handleImageLoadError,AssetsProxy.JUMPGATE);
         }
         else
         {
            _loc5_ = _loc4_.getFinisher(param1) as ImageFinisher;
            param2(_loc5_);
         }
      }
      
      private function handleGateImageLoaded(param1:ImageFinisher = null) : void
      {
         this.handleImageLoaded(param1,false);
      }
      
      private function handleLastPartImageLoaded(param1:ImageFinisher = null) : void
      {
         this.handleImageLoaded(param1,true);
      }
      
      private function handleImageLoaded(param1:ImageFinisher = null, param2:Boolean = false) : void
      {
         var bitmapData:BitmapData = null;
         var resKey:String = null;
         var id:int = 0;
         var length:int = 0;
         var i:int = 0;
         var data:BitmapData = null;
         var finisher:ImageFinisher = param1;
         var loadLastPart:Boolean = param2;
         try
         {
            bitmapData = finisher.getBitmap().bitmapData;
            if(!BitmapUtils.isValidBitmapData(this._gateBitmapData) || !BitmapUtils.isValidBitmapData(this._lastPartBitmapData))
            {
               this.createBitmaps();
            }
            if(this._partIds.length < this._maxParts)
            {
               resKey = finisher.fileVO.name;
               id = parseInt(resKey.substr(resKey.lastIndexOf("_") + 1));
               this._gatePartBitmapArray[id] = bitmapData;
            }
            else
            {
               this._gateBitmapData.copyPixels(bitmapData,this._rec,this._pt,bitmapData,null,true);
            }
            if(loadLastPart)
            {
               this._lastPartBitmapData.copyPixels(bitmapData,this._rec,this._pt,bitmapData,null,true);
            }
            if(++this._currPart >= this._partIds.length)
            {
               if(this._partIds.length < this._maxParts)
               {
                  length = int(this._partIds.length);
                  i = 0;
                  while(i < length)
                  {
                     data = this._gatePartBitmapArray[this._partIds[i]];
                     this._gateBitmapData.copyPixels(data,this._rec,this._pt,data,null,true);
                     i++;
                  }
               }
               this._gateBitmap = new Bitmap(this._gateBitmapData);
               this._lastPartBitmap = new Bitmap(this._lastPartBitmapData);
               this._hasChanges = false;
               this._isLoading = false;
               this.loaded.dispatch(this._gateID,this._fromGetPartsCmd);
            }
         }
         catch(e:Error)
         {
            createBitmaps();
            _hasChanges = false;
            _isLoading = false;
            loaded.dispatch(_gateID,_fromGetPartsCmd);
         }
      }
      
      private function handleImageLoadError(param1:*) : void
      {
         if(!BitmapUtils.isValidBitmapData(this._gateBitmapData) || !BitmapUtils.isValidBitmapData(this._lastPartBitmapData))
         {
            this.createBitmaps();
         }
         this._gateBitmap = new Bitmap(this._gateBitmapData);
         this._lastPartBitmap = new Bitmap(this._lastPartBitmapData);
         this._hasChanges = false;
         this._isLoading = false;
         this.loaded.dispatch(this._gateID,this._fromGetPartsCmd);
      }
   }
}

