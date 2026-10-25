package away3d.core.render
{
   import away3d.core.managers.Stage3DProxy;
   import away3d.debug.Debug;
   import away3d.textures.Texture2DBase;
   import com.adobe.utils.AGALMiniAssembler;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DBlendFactor;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DTextureFormat;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.display3D.IndexBuffer3D;
   import flash.display3D.Program3D;
   import flash.display3D.VertexBuffer3D;
   
   public class BackgroundImageRenderer
   {
      
      private var _program3d:Program3D;
      
      private var _texture:Texture2DBase;
      
      private var _indexBuffer:IndexBuffer3D;
      
      private var _vertexBuffer:VertexBuffer3D;
      
      private var _stage3DProxy:Stage3DProxy;
      
      private var _context:Context3D;
      
      public function BackgroundImageRenderer(param1:Stage3DProxy)
      {
         super();
         this.stage3DProxy = param1;
      }
      
      public function get stage3DProxy() : Stage3DProxy
      {
         return this._stage3DProxy;
      }
      
      public function set stage3DProxy(param1:Stage3DProxy) : void
      {
         if(param1 == this._stage3DProxy)
         {
            return;
         }
         this._stage3DProxy = param1;
         this.removeBuffers();
      }
      
      private function removeBuffers() : void
      {
         if(this._vertexBuffer)
         {
            this._vertexBuffer.dispose();
            this._vertexBuffer = null;
            this._program3d.dispose();
            this._program3d = null;
            this._indexBuffer.dispose();
            this._indexBuffer = null;
         }
      }
      
      private function getVertexCode() : String
      {
         return "mov op, va0\n" + "mov v0, va1";
      }
      
      private function getFragmentCode() : String
      {
         var _loc1_:String = null;
         switch(this._texture.format)
         {
            case Context3DTextureFormat.COMPRESSED:
               _loc1_ = "dxt1,";
               break;
            case "compressedAlpha":
               _loc1_ = "dxt5,";
               break;
            default:
               _loc1_ = "";
         }
         return "tex ft0, v0, fs0 <2d, " + _loc1_ + "linear>\t\n" + "mov oc, ft0";
      }
      
      public function dispose() : void
      {
         this.removeBuffers();
      }
      
      public function render() : void
      {
         var _loc1_:Context3D = this._stage3DProxy.context3D;
         if(_loc1_ != this._context)
         {
            this.removeBuffers();
            this._context = _loc1_;
         }
         if(!_loc1_)
         {
            return;
         }
         if(!this._vertexBuffer)
         {
            this.initBuffers(_loc1_);
         }
         _loc1_.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
         _loc1_.setProgram(this._program3d);
         _loc1_.setTextureAt(0,this._texture.getTextureForStage3D(this._stage3DProxy));
         _loc1_.setVertexBufferAt(0,this._vertexBuffer,0,Context3DVertexBufferFormat.FLOAT_2);
         _loc1_.setVertexBufferAt(1,this._vertexBuffer,2,Context3DVertexBufferFormat.FLOAT_2);
         _loc1_.drawTriangles(this._indexBuffer,0,2);
         _loc1_.setVertexBufferAt(0,null);
         _loc1_.setVertexBufferAt(1,null);
         _loc1_.setTextureAt(0,null);
      }
      
      private function initBuffers(param1:Context3D) : void
      {
         this._vertexBuffer = param1.createVertexBuffer(4,4);
         this._program3d = param1.createProgram();
         this._indexBuffer = param1.createIndexBuffer(6);
         this._indexBuffer.uploadFromVector(Vector.<uint>([2,1,0,3,2,0]),0,6);
         this._program3d.upload(new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.VERTEX,this.getVertexCode()),new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.FRAGMENT,this.getFragmentCode()));
         var _loc2_:Number = 2;
         var _loc3_:Number = 2;
         var _loc4_:Number = -1;
         var _loc5_:Number = 1;
         if(this._stage3DProxy.scissorRect)
         {
            _loc4_ = (this._stage3DProxy.scissorRect.x * 2 - this._stage3DProxy.viewPort.width) / this._stage3DProxy.viewPort.width;
            _loc5_ = (this._stage3DProxy.scissorRect.y * 2 - this._stage3DProxy.viewPort.height) / this._stage3DProxy.viewPort.height * -1;
            _loc2_ = 2 / (this._stage3DProxy.viewPort.width / this._stage3DProxy.scissorRect.width);
            _loc3_ = 2 / (this._stage3DProxy.viewPort.height / this._stage3DProxy.scissorRect.height);
         }
         this._vertexBuffer.uploadFromVector(Vector.<Number>([_loc4_,_loc5_ - _loc3_,0,1,_loc4_ + _loc2_,_loc5_ - _loc3_,1,1,_loc4_ + _loc2_,_loc5_,1,0,_loc4_,_loc5_,0,0]),0,4);
      }
      
      public function get texture() : Texture2DBase
      {
         return this._texture;
      }
      
      public function set texture(param1:Texture2DBase) : void
      {
         this._texture = param1;
      }
   }
}

