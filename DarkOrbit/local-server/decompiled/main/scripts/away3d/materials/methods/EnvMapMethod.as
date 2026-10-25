package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.textures.CubeTextureBase;
   import away3d.textures.Texture2DBase;
   import flash.display3D.Context3D;
   
   use namespace arcane;
   
   public class EnvMapMethod extends EffectMethodBase
   {
      
      private var _cubeTexture:CubeTextureBase;
      
      private var _alpha:Number;
      
      private var _mask:Texture2DBase;
      
      public function EnvMapMethod(param1:CubeTextureBase, param2:Number = 1)
      {
         super();
         this._cubeTexture = param1;
         this._alpha = param2;
      }
      
      public function get mask() : Texture2DBase
      {
         return this._mask;
      }
      
      public function set mask(param1:Texture2DBase) : void
      {
         if(Boolean(param1) != Boolean(this._mask) || Boolean(param1 && this._mask) && (Boolean(param1.hasMipMaps != this._mask.hasMipMaps || param1.format != this._mask.format)))
         {
            invalidateShaderProgram();
         }
         this._mask = param1;
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         param1.needsNormals = true;
         param1.needsView = true;
         param1.needsUV = this._mask != null;
      }
      
      public function get envMap() : CubeTextureBase
      {
         return this._cubeTexture;
      }
      
      public function set envMap(param1:CubeTextureBase) : void
      {
         this._cubeTexture = param1;
      }
      
      override public function dispose() : void
      {
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         this._alpha = param1;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         var _loc3_:Context3D = param2._context3D;
         param1.fragmentData[param1.fragmentConstantsIndex] = this._alpha;
         _loc3_.setTextureAt(param1.texturesIndex,this._cubeTexture.getTextureForStage3D(param2));
         if(this._mask)
         {
            _loc3_.setTextureAt(param1.texturesIndex + 1,this._mask.getTextureForStage3D(param2));
         }
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc9_:ShaderRegisterElement = null;
         var _loc4_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc5_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         var _loc6_:String = "";
         var _loc7_:ShaderRegisterElement = param2.getFreeTextureReg();
         param1.texturesIndex = _loc7_.index;
         param1.fragmentConstantsIndex = _loc4_.index * 4;
         param2.addFragmentTempUsages(_loc5_,1);
         var _loc8_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         _loc6_ += "dp3 " + _loc5_ + ".w, " + _sharedRegisters.viewDirFragment + ".xyz, " + _sharedRegisters.normalFragment + ".xyz\t\t\n" + "add " + _loc5_ + ".w, " + _loc5_ + ".w, " + _loc5_ + ".w\t\t\t\t\t\t\t\t\t\t\t\n" + "mul " + _loc5_ + ".xyz, " + _sharedRegisters.normalFragment + ".xyz, " + _loc5_ + ".w\t\t\t\t\t\t\n" + "sub " + _loc5_ + ".xyz, " + _loc5_ + ".xyz, " + _sharedRegisters.viewDirFragment + ".xyz\t\t\t\t\t\n" + getTexCubeSampleCode(param1,_loc5_,_loc7_,this._cubeTexture,_loc5_) + "sub " + _loc8_ + ".w, " + _loc5_ + ".w, fc0.x\t\t\t\t\t\t\t\t\t\n" + "kil " + _loc8_ + ".w\n" + "sub " + _loc5_ + ", " + _loc5_ + ", " + param3 + "\t\t\t\t\t\t\t\t\t\t\t\n";
         if(this._mask)
         {
            _loc9_ = param2.getFreeTextureReg();
            _loc6_ += getTex2DSampleCode(param1,_loc8_,_loc9_,this._mask,_sharedRegisters.uvVarying) + "mul " + _loc5_ + ", " + _loc8_ + ", " + _loc5_ + "\n";
         }
         _loc6_ += "mul " + _loc5_ + ", " + _loc5_ + ", " + _loc4_ + ".x\t\t\t\t\t\t\t\t\t\t\n" + "add " + param3 + ", " + param3 + ", " + _loc5_ + "\t\t\t\t\t\t\t\t\t\t\n";
         param2.removeFragmentTempUsage(_loc5_);
         return _loc6_;
      }
   }
}

