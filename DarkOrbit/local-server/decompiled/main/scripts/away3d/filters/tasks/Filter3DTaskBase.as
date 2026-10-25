package away3d.filters.tasks
{
   import away3d.cameras.Camera3D;
   import away3d.core.managers.Stage3DProxy;
   import away3d.debug.Debug;
   import away3d.errors.AbstractMethodError;
   import com.adobe.utils.AGALMiniAssembler;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DTextureFormat;
   import flash.display3D.Program3D;
   import flash.display3D.textures.Texture;
   import flash.display3D.textures.TextureBase;
   
   public class Filter3DTaskBase
   {
      
      protected var _mainInputTexture:TextureBase;
      
      protected var _mainInputTextureContext:Context3D;
      
      protected var _scaledTextureWidth:int = -1;
      
      protected var _scaledTextureHeight:int = -1;
      
      protected var _textureWidth:int = -1;
      
      protected var _textureHeight:int = -1;
      
      protected var _textureDimensionsInvalid:Boolean = true;
      
      private var _program3DInvalid:Boolean = true;
      
      private var _program3D:Program3D;
      
      private var _program3DContext:Context3D;
      
      private var _target:TextureBase;
      
      private var _requireDepthRender:Boolean;
      
      protected var _textureScale:int = 0;
      
      public function Filter3DTaskBase(param1:Boolean = false)
      {
         super();
         this._requireDepthRender = param1;
      }
      
      public function get textureScale() : int
      {
         return this._textureScale;
      }
      
      public function set textureScale(param1:int) : void
      {
         if(this._textureScale == param1)
         {
            return;
         }
         this._textureScale = param1;
         this._scaledTextureWidth = this._textureWidth >> this._textureScale;
         this._scaledTextureHeight = this._textureHeight >> this._textureScale;
         this._textureDimensionsInvalid = true;
      }
      
      public function get target() : TextureBase
      {
         return this._target;
      }
      
      public function set target(param1:TextureBase) : void
      {
         this._target = param1;
      }
      
      public function get textureWidth() : int
      {
         return this._textureWidth;
      }
      
      public function set textureWidth(param1:int) : void
      {
         if(this._textureWidth == param1)
         {
            return;
         }
         this._textureWidth = param1;
         this._scaledTextureWidth = this._textureWidth >> this._textureScale;
         if(this._scaledTextureWidth < 1)
         {
            this._scaledTextureWidth = 1;
         }
         this._textureDimensionsInvalid = true;
      }
      
      public function get textureHeight() : int
      {
         return this._textureHeight;
      }
      
      public function set textureHeight(param1:int) : void
      {
         if(this._textureHeight == param1)
         {
            return;
         }
         this._textureHeight = param1;
         this._scaledTextureHeight = this._textureHeight >> this._textureScale;
         if(this._scaledTextureHeight < 1)
         {
            this._scaledTextureHeight = 1;
         }
         this._textureDimensionsInvalid = true;
      }
      
      public function getMainInputTexture(param1:Stage3DProxy) : TextureBase
      {
         if(param1.context3D != this._mainInputTextureContext)
         {
            this._textureDimensionsInvalid = true;
         }
         if(this._textureDimensionsInvalid)
         {
            this.updateTextures(param1);
         }
         return this._mainInputTexture;
      }
      
      public function dispose() : void
      {
         if(this._mainInputTexture)
         {
            this._mainInputTexture.dispose();
         }
         if(this._program3D)
         {
            this._program3D.dispose();
         }
         this._program3DContext = null;
      }
      
      protected function invalidateProgram3D() : void
      {
         this._program3DInvalid = true;
      }
      
      protected function updateProgram3D(param1:Stage3DProxy) : void
      {
         if(this._program3D)
         {
            this._program3D.dispose();
         }
         this._program3DContext = param1.context3D;
         this._program3D = this._program3DContext.createProgram();
         this._program3D.upload(new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.VERTEX,this.getVertexCode()),new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.FRAGMENT,this.getFragmentCode()));
         this._program3DInvalid = false;
      }
      
      protected function getVertexCode() : String
      {
         return "mov op, va0\n" + "mov v0, va1\n";
      }
      
      protected function getFragmentCode() : String
      {
         throw new AbstractMethodError();
      }
      
      protected function updateTextures(param1:Stage3DProxy) : void
      {
         if(this._mainInputTexture)
         {
            this._mainInputTexture.dispose();
         }
         this._mainInputTextureContext = param1.context3D;
         this._mainInputTexture = this._mainInputTextureContext.createTexture(this._scaledTextureWidth,this._scaledTextureHeight,Context3DTextureFormat.BGRA,true);
         this._textureDimensionsInvalid = false;
      }
      
      public function getProgram3D(param1:Stage3DProxy) : Program3D
      {
         if(this._program3DContext != param1.context3D)
         {
            this._program3DInvalid = true;
         }
         if(this._program3DInvalid)
         {
            this.updateProgram3D(param1);
         }
         return this._program3D;
      }
      
      public function activate(param1:Stage3DProxy, param2:Camera3D, param3:Texture) : void
      {
      }
      
      public function deactivate(param1:Stage3DProxy) : void
      {
      }
      
      public function get requireDepthRender() : Boolean
      {
         return this._requireDepthRender;
      }
   }
}

