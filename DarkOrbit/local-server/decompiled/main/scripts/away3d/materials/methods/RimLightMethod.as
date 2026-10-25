package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   
   use namespace arcane;
   
   public class RimLightMethod extends EffectMethodBase
   {
      
      public static const ADD:String = "add";
      
      public static const MULTIPLY:String = "multiply";
      
      public static const MIX:String = "mix";
      
      private var _color:uint;
      
      private var _blendMode:String;
      
      private var _colorR:Number;
      
      private var _colorG:Number;
      
      private var _colorB:Number;
      
      private var _strength:Number;
      
      private var _power:Number;
      
      public function RimLightMethod(param1:uint = 16777215, param2:Number = 0.4, param3:Number = 2, param4:String = "mix")
      {
         super();
         this._blendMode = param4;
         this._strength = param2;
         this._power = param3;
         this.color = param1;
      }
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         param1.fragmentData[param1.fragmentConstantsIndex + 3] = 1;
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         param1.needsNormals = true;
         param1.needsView = true;
      }
      
      public function get blendMode() : String
      {
         return this._blendMode;
      }
      
      public function set blendMode(param1:String) : void
      {
         if(this._blendMode == param1)
         {
            return;
         }
         this._blendMode = param1;
         invalidateShaderProgram();
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(param1:uint) : void
      {
         this._color = param1;
         this._colorR = (param1 >> 16 & 0xFF) / 255;
         this._colorG = (param1 >> 8 & 0xFF) / 255;
         this._colorB = (param1 & 0xFF) / 255;
      }
      
      public function get strength() : Number
      {
         return this._strength;
      }
      
      public function set strength(param1:Number) : void
      {
         this._strength = param1;
      }
      
      public function get power() : Number
      {
         return this._power;
      }
      
      public function set power(param1:Number) : void
      {
         this._power = param1;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         var _loc3_:int = param1.fragmentConstantsIndex;
         var _loc4_:Vector.<Number> = param1.fragmentData;
         _loc4_[_loc3_] = this._colorR;
         _loc4_[_loc3_ + 1] = this._colorG;
         _loc4_[_loc3_ + 2] = this._colorB;
         _loc4_[_loc3_ + 4] = this._strength;
         _loc4_[_loc3_ + 5] = this._power;
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc5_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc6_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         var _loc7_:String = "";
         param1.fragmentConstantsIndex = _loc4_.index * 4;
         _loc7_ += "dp3 " + _loc6_ + ".x, " + _sharedRegisters.viewDirFragment + ".xyz, " + _sharedRegisters.normalFragment + ".xyz\t\n" + "sat " + _loc6_ + ".x, " + _loc6_ + ".x\t\t\t\t\t\t\t\t\t\t\t\t\t\t\n" + "sub " + _loc6_ + ".x, " + _loc4_ + ".w, " + _loc6_ + ".x\t\t\t\t\t\t\t\t\n" + "pow " + _loc6_ + ".x, " + _loc6_ + ".x, " + _loc5_ + ".y\t\t\t\t\t\t\t\n" + "mul " + _loc6_ + ".x, " + _loc6_ + ".x, " + _loc5_ + ".x\t\t\t\t\t\t\t\n" + "sub " + _loc6_ + ".x, " + _loc4_ + ".w, " + _loc6_ + ".x\t\t\t\t\t\t\t\t\n" + "mul " + param3 + ".xyz, " + param3 + ".xyz, " + _loc6_ + ".x\t\t\t\t\t\t\n" + "sub " + _loc6_ + ".w, " + _loc4_ + ".w, " + _loc6_ + ".x\t\t\t\t\t\t\t\t\n";
         if(this._blendMode == ADD)
         {
            _loc7_ += "mul " + _loc6_ + ".xyz, " + _loc6_ + ".w, " + _loc4_ + ".xyz\t\t\t\t\t\t\t\n" + "add " + param3 + ".xyz, " + param3 + ".xyz, " + _loc6_ + ".xyz\t\t\t\t\t\t\n";
         }
         else if(this._blendMode == MULTIPLY)
         {
            _loc7_ += "mul " + _loc6_ + ".xyz, " + _loc6_ + ".w, " + _loc4_ + ".xyz\t\t\t\t\t\t\t\n" + "mul " + param3 + ".xyz, " + param3 + ".xyz, " + _loc6_ + ".xyz\t\t\t\t\t\t\n";
         }
         else
         {
            _loc7_ += "sub " + _loc6_ + ".xyz, " + _loc4_ + ".xyz, " + param3 + ".xyz\t\t\t\t\n" + "mul " + _loc6_ + ".xyz, " + _loc6_ + ".xyz, " + _loc6_ + ".w\t\t\t\t\t\t\t\t\n" + "add " + param3 + ".xyz, " + param3 + ".xyz, " + _loc6_ + ".xyz\t\t\t\t\t\n";
         }
         return _loc7_;
      }
   }
}

