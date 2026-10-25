package away3d.textures
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3D;
   import flash.display3D.textures.Texture;
   import flash.display3D.textures.TextureBase;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.osflash.signals.Promise;
   
   use namespace arcane;
   
   public class ATFTexture extends Texture2DBase
   {
      
      public const ready:Promise = new Promise();
      
      private var _atfData:ATFData;
      
      private var _texturesReady:Vector.<Boolean> = new Vector.<Boolean>(8);
      
      private var _async:Boolean;
      
      public function ATFTexture(param1:ByteArray, param2:Boolean = true)
      {
         this._async = param2;
         super();
         this.atfData = new ATFData(param1);
         _format = this.atfData.format;
         _hasMipmaps = this._atfData.numTextures > 1;
      }
      
      public function get atfData() : ATFData
      {
         return this._atfData;
      }
      
      public function set atfData(param1:ATFData) : void
      {
         this._atfData = param1;
         invalidateContent();
         setSize(param1.width,param1.height);
      }
      
      override public function getTextureForStage3D(param1:Stage3DProxy) : TextureBase
      {
         var _loc2_:int = param1._stage3DIndex;
         var _loc3_:Texture = _textures[_loc2_] as Texture;
         var _loc4_:Context3D = param1._context3D;
         if(!_loc3_ || _dirty[_loc2_] != _loc4_)
         {
            this.ready.reset();
            _textures[_loc2_] = _loc3_ = _loc4_.createTexture(_width,_height,this.atfData.format,false);
            _dirty[_loc2_] = _loc4_;
            if(this._async)
            {
               _loc3_.addEventListener(Event.TEXTURE_READY,this.handleTextureReady);
            }
            else
            {
               this._texturesReady[_loc2_] = true;
            }
            _loc3_.uploadCompressedTextureFromByteArray(this._atfData.data,0,this._async);
         }
         return this._texturesReady[_loc2_] ? _loc3_ : null;
      }
      
      override protected function invalidateSize() : void
      {
         super.invalidateSize();
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            this._texturesReady[_loc1_] = null;
            _loc1_++;
         }
      }
      
      private function handleTextureReady(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(Event.TEXTURE_READY,this.handleTextureReady);
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            if(_textures[_loc2_] == param1.currentTarget)
            {
               this._texturesReady[_loc2_] = true;
               break;
            }
            _loc2_++;
         }
         this.ready.dispatch();
      }
      
      public function get async() : Boolean
      {
         return this._async;
      }
   }
}

