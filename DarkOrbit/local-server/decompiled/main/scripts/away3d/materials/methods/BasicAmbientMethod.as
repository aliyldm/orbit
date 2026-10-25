package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.textures.Texture2DBase;
   
   use namespace arcane;
   
   public class BasicAmbientMethod extends ShadingMethodBase
   {
      
      protected var _useTexture:Boolean;
      
      private var _texture:Texture2DBase;
      
      protected var _ambientInputRegister:ShaderRegisterElement;
      
      private var _ambientColor:uint = 16777215;
      
      private var _ambientR:Number = 0;
      
      private var _ambientG:Number = 0;
      
      private var _ambientB:Number = 0;
      
      private var _ambient:Number = 1;
      
      arcane var _lightAmbientR:Number = 0;
      
      arcane var _lightAmbientG:Number = 0;
      
      arcane var _lightAmbientB:Number = 0;
      
      public function BasicAmbientMethod()
      {
         super();
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         param1.needsUV = this._useTexture;
      }
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         param1.fragmentData[param1.fragmentConstantsIndex + 3] = 1;
      }
      
      public function get ambient() : Number
      {
         return this._ambient;
      }
      
      public function set ambient(param1:Number) : void
      {
         this._ambient = param1;
      }
      
      public function get ambientColor() : uint
      {
         return this._ambientColor;
      }
      
      public function set ambientColor(param1:uint) : void
      {
         this._ambientColor = param1;
      }
      
      public function get texture() : Texture2DBase
      {
         return this._texture;
      }
      
      public function set texture(param1:Texture2DBase) : void
      {
         if(Boolean(param1) != this._useTexture || Boolean(param1 && this._texture) && (Boolean(param1.hasMipMaps != this._texture.hasMipMaps || param1.format != this._texture.format)))
         {
            invalidateShaderProgram();
         }
         this._useTexture = Boolean(param1);
         this._texture = param1;
      }
      
      override public function copyFrom(param1:ShadingMethodBase) : void
      {
         var _loc2_:BasicAmbientMethod = BasicAmbientMethod(param1);
         this.ambient = _loc2_.ambient;
         this.ambientColor = _loc2_.ambientColor;
      }
      
      override arcane function cleanCompilationData() : void
      {
         super.arcane::cleanCompilationData();
         this._ambientInputRegister = null;
      }
      
      arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:String = "";
         if(this._useTexture)
         {
            this._ambientInputRegister = param2.getFreeTextureReg();
            param1.texturesIndex = this._ambientInputRegister.index;
            _loc4_ += getTex2DSampleCode(param1,param3,this._ambientInputRegister,this._texture) + "div " + param3 + ".xyz, " + param3 + ".xyz, " + param3 + ".w\n";
         }
         else
         {
            this._ambientInputRegister = param2.getFreeFragmentConstant();
            param1.fragmentConstantsIndex = this._ambientInputRegister.index * 4;
            _loc4_ += "mov " + param3 + ", " + this._ambientInputRegister + "\n";
         }
         return _loc4_;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         if(this._useTexture)
         {
            param2._context3D.setTextureAt(param1.texturesIndex,this._texture.getTextureForStage3D(param2));
         }
      }
      
      private function updateAmbient() : void
      {
         this._ambientR = (this._ambientColor >> 16 & 0xFF) / 255 * this._ambient * this._lightAmbientR;
         this._ambientG = (this._ambientColor >> 8 & 0xFF) / 255 * this._ambient * this._lightAmbientG;
         this._ambientB = (this._ambientColor & 0xFF) / 255 * this._ambient * this._lightAmbientB;
      }
      
      override arcane function setRenderState(param1:MethodVO, param2:IRenderable, param3:Stage3DProxy, param4:Camera3D) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Vector.<Number> = null;
         this.updateAmbient();
         if(!this._useTexture)
         {
            _loc5_ = param1.fragmentConstantsIndex;
            _loc6_ = param1.fragmentData;
            _loc6_[_loc5_] = this._ambientR;
            _loc6_[_loc5_ + 1] = this._ambientG;
            _loc6_[_loc5_ + 2] = this._ambientB;
         }
      }
   }
}

