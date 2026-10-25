package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.textures.Texture2DBase;
   
   use namespace arcane;
   
   public class SimpleWaterNormalMethod extends BasicNormalMethod
   {
      
      private var _texture2:Texture2DBase;
      
      private var _normalTextureRegister2:ShaderRegisterElement;
      
      private var _useSecondNormalMap:Boolean;
      
      private var _water1OffsetX:Number = 0;
      
      private var _water1OffsetY:Number = 0;
      
      private var _water2OffsetX:Number = 0;
      
      private var _water2OffsetY:Number = 0;
      
      public function SimpleWaterNormalMethod(param1:Texture2DBase, param2:Texture2DBase)
      {
         super();
         this.normalMap = param1;
         this.secondaryNormalMap = param2;
      }
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         var _loc2_:int = param1.fragmentConstantsIndex;
         param1.fragmentData[_loc2_] = 0.5;
         param1.fragmentData[_loc2_ + 1] = 0;
         param1.fragmentData[_loc2_ + 2] = 0;
         param1.fragmentData[_loc2_ + 3] = 1;
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         super.arcane::initVO(param1);
         this._useSecondNormalMap = normalMap != this.secondaryNormalMap;
      }
      
      public function get water1OffsetX() : Number
      {
         return this._water1OffsetX;
      }
      
      public function set water1OffsetX(param1:Number) : void
      {
         this._water1OffsetX = param1;
      }
      
      public function get water1OffsetY() : Number
      {
         return this._water1OffsetY;
      }
      
      public function set water1OffsetY(param1:Number) : void
      {
         this._water1OffsetY = param1;
      }
      
      public function get water2OffsetX() : Number
      {
         return this._water2OffsetX;
      }
      
      public function set water2OffsetX(param1:Number) : void
      {
         this._water2OffsetX = param1;
      }
      
      public function get water2OffsetY() : Number
      {
         return this._water2OffsetY;
      }
      
      public function set water2OffsetY(param1:Number) : void
      {
         this._water2OffsetY = param1;
      }
      
      override public function set normalMap(param1:Texture2DBase) : void
      {
         if(!param1)
         {
            return;
         }
         super.normalMap = param1;
      }
      
      public function get secondaryNormalMap() : Texture2DBase
      {
         return this._texture2;
      }
      
      public function set secondaryNormalMap(param1:Texture2DBase) : void
      {
         this._texture2 = param1;
      }
      
      override arcane function cleanCompilationData() : void
      {
         super.arcane::cleanCompilationData();
         this._normalTextureRegister2 = null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._texture2 = null;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         super.arcane::activate(param1,param2);
         var _loc3_:Vector.<Number> = param1.fragmentData;
         var _loc4_:int = param1.fragmentConstantsIndex;
         _loc3_[_loc4_ + 4] = this._water1OffsetX;
         _loc3_[_loc4_ + 5] = this._water1OffsetY;
         _loc3_[_loc4_ + 6] = this._water2OffsetX;
         _loc3_[_loc4_ + 7] = this._water2OffsetY;
         if(this._useSecondNormalMap >= 0)
         {
            param2._context3D.setTextureAt(param1.texturesIndex + 1,this._texture2.getTextureForStage3D(param2));
         }
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         var _loc5_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc6_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         _normalTextureRegister = param2.getFreeTextureReg();
         this._normalTextureRegister2 = this._useSecondNormalMap ? param2.getFreeTextureReg() : _normalTextureRegister;
         param1.texturesIndex = _normalTextureRegister.index;
         param1.fragmentConstantsIndex = _loc5_.index * 4;
         return "add " + _loc4_ + ", " + _sharedRegisters.uvVarying + ", " + _loc6_ + ".xyxy\n" + getTex2DSampleCode(param1,param3,_normalTextureRegister,normalMap,_loc4_) + "add " + _loc4_ + ", " + _sharedRegisters.uvVarying + ", " + _loc6_ + ".zwzw\n" + getTex2DSampleCode(param1,_loc4_,this._normalTextureRegister2,this._texture2,_loc4_) + "add " + param3 + ", " + param3 + ", " + _loc4_ + "\t\t\n" + "mul " + param3 + ", " + param3 + ", " + _loc5_ + ".x\t\n" + "sub " + param3 + ".xyz, " + param3 + ".xyz, " + _sharedRegisters.commons + ".xxx\t\n" + "nrm " + param3 + ".xyz, " + param3 + ".xyz\t\t\t\t\t\t\t\n";
      }
   }
}

