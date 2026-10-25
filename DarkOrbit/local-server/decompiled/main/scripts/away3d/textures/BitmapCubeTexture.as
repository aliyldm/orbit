package away3d.textures
{
   import away3d.arcane;
   import away3d.materials.utils.MipmapGenerator;
   import away3d.tools.utils.TextureUtils;
   import flash.display.BitmapData;
   import flash.display3D.textures.TextureBase;
   
   use namespace arcane;
   
   public class BitmapCubeTexture extends CubeTextureBase
   {
      
      private var _bitmapDatas:Vector.<BitmapData>;
      
      public function BitmapCubeTexture(param1:BitmapData, param2:BitmapData, param3:BitmapData, param4:BitmapData, param5:BitmapData, param6:BitmapData)
      {
         super();
         this._bitmapDatas = new Vector.<BitmapData>(6,true);
         this.testSize(this._bitmapDatas[0] = param1);
         this.testSize(this._bitmapDatas[1] = param2);
         this.testSize(this._bitmapDatas[2] = param3);
         this.testSize(this._bitmapDatas[3] = param4);
         this.testSize(this._bitmapDatas[4] = param5);
         this.testSize(this._bitmapDatas[5] = param6);
         setSize(param1.width,param1.height);
      }
      
      public function get positiveX() : BitmapData
      {
         return this._bitmapDatas[0];
      }
      
      public function set positiveX(param1:BitmapData) : void
      {
         this.testSize(param1);
         invalidateContent();
         setSize(param1.width,param1.height);
         this._bitmapDatas[0] = param1;
      }
      
      public function get negativeX() : BitmapData
      {
         return this._bitmapDatas[1];
      }
      
      public function set negativeX(param1:BitmapData) : void
      {
         this.testSize(param1);
         invalidateContent();
         setSize(param1.width,param1.height);
         this._bitmapDatas[1] = param1;
      }
      
      public function get positiveY() : BitmapData
      {
         return this._bitmapDatas[2];
      }
      
      public function set positiveY(param1:BitmapData) : void
      {
         this.testSize(param1);
         invalidateContent();
         setSize(param1.width,param1.height);
         this._bitmapDatas[2] = param1;
      }
      
      public function get negativeY() : BitmapData
      {
         return this._bitmapDatas[3];
      }
      
      public function set negativeY(param1:BitmapData) : void
      {
         this.testSize(param1);
         invalidateContent();
         setSize(param1.width,param1.height);
         this._bitmapDatas[3] = param1;
      }
      
      public function get positiveZ() : BitmapData
      {
         return this._bitmapDatas[4];
      }
      
      public function set positiveZ(param1:BitmapData) : void
      {
         this.testSize(param1);
         invalidateContent();
         setSize(param1.width,param1.height);
         this._bitmapDatas[4] = param1;
      }
      
      public function get negativeZ() : BitmapData
      {
         return this._bitmapDatas[5];
      }
      
      public function set negativeZ(param1:BitmapData) : void
      {
         this.testSize(param1);
         invalidateContent();
         setSize(param1.width,param1.height);
         this._bitmapDatas[5] = param1;
      }
      
      private function testSize(param1:BitmapData) : void
      {
         if(param1.width != param1.height)
         {
            throw new Error("BitmapData should have equal width and height!");
         }
         if(!TextureUtils.isBitmapDataValid(param1))
         {
            throw new Error("Invalid bitmapData: Width and height must be power of 2 and cannot exceed 2048");
         }
      }
      
      override protected function uploadContent(param1:TextureBase) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 6)
         {
            MipmapGenerator.generateMipMaps(this._bitmapDatas[_loc2_],param1,null,this._bitmapDatas[_loc2_].transparent,_loc2_);
            _loc2_++;
         }
      }
   }
}

