package away3d.materials.compilation
{
   public class ShaderRegisterCache
   {
      
      private var _fragmentTempCache:RegisterPool;
      
      private var _vertexTempCache:RegisterPool;
      
      private var _varyingCache:RegisterPool;
      
      private var _fragmentConstantsCache:RegisterPool;
      
      private var _vertexConstantsCache:RegisterPool;
      
      private var _textureCache:RegisterPool;
      
      private var _vertexAttributesCache:RegisterPool;
      
      protected var _vertexConstantOffset:uint;
      
      private var _vertexAttributesOffset:uint;
      
      private var _varyingsOffset:uint;
      
      protected var _fragmentConstantOffset:uint;
      
      private var _fragmentOutputRegister:ShaderRegisterElement;
      
      private var _vertexOutputRegister:ShaderRegisterElement;
      
      protected var _numUsedVertexConstants:uint;
      
      protected var _numUsedFragmentConstants:uint;
      
      private var _numUsedStreams:uint;
      
      private var _numUsedTextures:uint;
      
      private var _numUsedVaryings:uint;
      
      private var _profile:String;
      
      public function ShaderRegisterCache(param1:String)
      {
         super();
         this._profile = param1;
      }
      
      public function reset() : void
      {
         var _loc1_:int = 0;
         this._fragmentTempCache = new RegisterPool("ft",8,false);
         this._vertexTempCache = new RegisterPool("vt",8,false);
         this._varyingCache = new RegisterPool("v",8);
         this._textureCache = new RegisterPool("fs",8);
         this._vertexAttributesCache = new RegisterPool("va",8);
         this._fragmentConstantsCache = new RegisterPool("fc",28);
         this._vertexConstantsCache = new RegisterPool("vc",128);
         this._fragmentOutputRegister = new ShaderRegisterElement("oc",-1);
         this._vertexOutputRegister = new ShaderRegisterElement("op",-1);
         this._numUsedVertexConstants = 0;
         this._numUsedStreams = 0;
         this._numUsedTextures = 0;
         this._numUsedVaryings = 0;
         this._numUsedFragmentConstants = 0;
         _loc1_ = 0;
         while(_loc1_ < this._vertexAttributesOffset)
         {
            this.getFreeVertexAttribute();
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._vertexConstantOffset)
         {
            this.getFreeVertexConstant();
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._varyingsOffset)
         {
            this.getFreeVarying();
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._fragmentConstantOffset)
         {
            this.getFreeFragmentConstant();
            _loc1_++;
         }
      }
      
      public function dispose() : void
      {
         this._fragmentTempCache.dispose();
         this._vertexTempCache.dispose();
         this._varyingCache.dispose();
         this._fragmentConstantsCache.dispose();
         this._vertexAttributesCache.dispose();
         this._fragmentTempCache = null;
         this._vertexTempCache = null;
         this._varyingCache = null;
         this._fragmentConstantsCache = null;
         this._vertexAttributesCache = null;
         this._fragmentOutputRegister = null;
         this._vertexOutputRegister = null;
      }
      
      public function addFragmentTempUsages(param1:ShaderRegisterElement, param2:uint) : void
      {
         this._fragmentTempCache.addUsage(param1,param2);
      }
      
      public function removeFragmentTempUsage(param1:ShaderRegisterElement) : void
      {
         this._fragmentTempCache.removeUsage(param1);
      }
      
      public function addVertexTempUsages(param1:ShaderRegisterElement, param2:uint) : void
      {
         this._vertexTempCache.addUsage(param1,param2);
      }
      
      public function removeVertexTempUsage(param1:ShaderRegisterElement) : void
      {
         this._vertexTempCache.removeUsage(param1);
      }
      
      public function getFreeFragmentVectorTemp() : ShaderRegisterElement
      {
         return this._fragmentTempCache.requestFreeVectorReg();
      }
      
      public function getFreeFragmentSingleTemp() : ShaderRegisterElement
      {
         return this._fragmentTempCache.requestFreeRegComponent();
      }
      
      public function getFreeVarying() : ShaderRegisterElement
      {
         var _loc1_:ShaderRegisterElement = this._varyingCache.requestFreeVectorReg();
         ++this._numUsedVaryings;
         return _loc1_;
      }
      
      public function getFreeFragmentConstant() : ShaderRegisterElement
      {
         var _loc1_:ShaderRegisterElement = this._fragmentConstantsCache.requestFreeVectorReg();
         ++this._numUsedFragmentConstants;
         return _loc1_;
      }
      
      public function getFreeVertexConstant() : ShaderRegisterElement
      {
         var _loc1_:ShaderRegisterElement = this._vertexConstantsCache.requestFreeVectorReg();
         ++this._numUsedVertexConstants;
         return _loc1_;
      }
      
      public function getFreeVertexVectorTemp() : ShaderRegisterElement
      {
         return this._vertexTempCache.requestFreeVectorReg();
      }
      
      public function getFreeVertexSingleTemp() : ShaderRegisterElement
      {
         return this._vertexTempCache.requestFreeRegComponent();
      }
      
      public function getFreeVertexAttribute() : ShaderRegisterElement
      {
         var _loc1_:ShaderRegisterElement = this._vertexAttributesCache.requestFreeVectorReg();
         ++this._numUsedStreams;
         return _loc1_;
      }
      
      public function getFreeTextureReg() : ShaderRegisterElement
      {
         var _loc1_:ShaderRegisterElement = this._textureCache.requestFreeVectorReg();
         ++this._numUsedTextures;
         return _loc1_;
      }
      
      public function get vertexConstantOffset() : uint
      {
         return this._vertexConstantOffset;
      }
      
      public function set vertexConstantOffset(param1:uint) : void
      {
         this._vertexConstantOffset = param1;
      }
      
      public function get vertexAttributesOffset() : uint
      {
         return this._vertexAttributesOffset;
      }
      
      public function set vertexAttributesOffset(param1:uint) : void
      {
         this._vertexAttributesOffset = param1;
      }
      
      public function get varyingsOffset() : uint
      {
         return this._varyingsOffset;
      }
      
      public function set varyingsOffset(param1:uint) : void
      {
         this._varyingsOffset = param1;
      }
      
      public function get fragmentConstantOffset() : uint
      {
         return this._fragmentConstantOffset;
      }
      
      public function set fragmentConstantOffset(param1:uint) : void
      {
         this._fragmentConstantOffset = param1;
      }
      
      public function get fragmentOutputRegister() : ShaderRegisterElement
      {
         return this._fragmentOutputRegister;
      }
      
      public function get numUsedVertexConstants() : uint
      {
         return this._numUsedVertexConstants;
      }
      
      public function get numUsedFragmentConstants() : uint
      {
         return this._numUsedFragmentConstants;
      }
      
      public function get numUsedStreams() : uint
      {
         return this._numUsedStreams;
      }
      
      public function get numUsedTextures() : uint
      {
         return this._numUsedTextures;
      }
      
      public function get numUsedVaryings() : uint
      {
         return this._numUsedVaryings;
      }
   }
}

