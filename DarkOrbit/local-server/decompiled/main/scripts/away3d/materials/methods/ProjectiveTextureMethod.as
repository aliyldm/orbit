package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import away3d.entities.TextureProjector;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import flash.geom.Matrix3D;
   
   use namespace arcane;
   
   public class ProjectiveTextureMethod extends EffectMethodBase
   {
      
      public static const MULTIPLY:String = "multiply";
      
      public static const ADD:String = "add";
      
      public static const MIX:String = "mix";
      
      private var _projector:TextureProjector;
      
      private var _uvVarying:ShaderRegisterElement;
      
      private var _projMatrix:Matrix3D = new Matrix3D();
      
      private var _mode:String;
      
      public function ProjectiveTextureMethod(param1:TextureProjector, param2:String = "multiply")
      {
         super();
         this._projector = param1;
         this._mode = param2;
      }
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         var _loc2_:int = param1.fragmentConstantsIndex;
         var _loc3_:Vector.<Number> = param1.fragmentData;
         _loc3_[_loc2_] = 0.5;
         _loc3_[_loc2_ + 1] = -0.5;
         _loc3_[_loc2_ + 2] = 1;
         _loc3_[_loc2_ + 3] = 1;
      }
      
      override arcane function cleanCompilationData() : void
      {
         super.arcane::cleanCompilationData();
         this._uvVarying = null;
      }
      
      public function get mode() : String
      {
         return this._mode;
      }
      
      public function set mode(param1:String) : void
      {
         if(this._mode == param1)
         {
            return;
         }
         this._mode = param1;
         invalidateShaderProgram();
      }
      
      public function get projector() : TextureProjector
      {
         return this._projector;
      }
      
      public function set projector(param1:TextureProjector) : void
      {
         this._projector = param1;
      }
      
      override arcane function getVertexCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         var _loc3_:ShaderRegisterElement = param2.getFreeVertexConstant();
         param2.getFreeVertexConstant();
         param2.getFreeVertexConstant();
         param2.getFreeVertexConstant();
         param2.getFreeVertexVectorTemp();
         param1.vertexConstantsIndex = _loc3_.index * 4;
         this._uvVarying = param2.getFreeVarying();
         return "m44 " + this._uvVarying + ", vt0, " + _loc3_ + "\n";
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:String = "";
         var _loc5_:ShaderRegisterElement = param2.getFreeTextureReg();
         var _loc6_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         var _loc7_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         param1.fragmentConstantsIndex = _loc7_.index * 4;
         param1.texturesIndex = _loc5_.index;
         _loc4_ += "div " + _loc6_ + ", " + this._uvVarying + ", " + this._uvVarying + ".w\t\t\t\t\t\t\n" + "mul " + _loc6_ + ".xy, " + _loc6_ + ".xy, " + _loc7_ + ".xy\t\n" + "add " + _loc6_ + ".xy, " + _loc6_ + ".xy, " + _loc7_ + ".xx\t\n";
         _loc4_ = _loc4_ + getTex2DSampleCode(param1,_loc6_,_loc5_,this._projector.texture,_loc6_,"clamp");
         if(this._mode == MULTIPLY)
         {
            _loc4_ += "mul " + param3 + ".xyz, " + param3 + ".xyz, " + _loc6_ + ".xyz\t\t\t\n";
         }
         else if(this._mode == ADD)
         {
            _loc4_ += "add " + param3 + ".xyz, " + param3 + ".xyz, " + _loc6_ + ".xyz\t\t\t\n";
         }
         else
         {
            if(this._mode != MIX)
            {
               throw new Error("Unknown mode \"" + this._mode + "\"");
            }
            _loc4_ += "sub " + _loc6_ + ".xyz, " + _loc6_ + ".xyz, " + param3 + ".xyz\t\t\t\t\n" + "mul " + _loc6_ + ".xyz, " + _loc6_ + ".xyz, " + _loc6_ + ".w\t\t\t\t\t\t\n" + "add " + param3 + ".xyz, " + param3 + ".xyz, " + _loc6_ + ".xyz\t\t\t\n";
         }
         return _loc4_;
      }
      
      override arcane function setRenderState(param1:MethodVO, param2:IRenderable, param3:Stage3DProxy, param4:Camera3D) : void
      {
         this._projMatrix.copyFrom(this._projector.viewProjection);
         this._projMatrix.prepend(param2.getRenderSceneTransform(param4));
         this._projMatrix.copyRawDataTo(param1.vertexData,param1.vertexConstantsIndex,true);
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         param2._context3D.setTextureAt(param1.texturesIndex,this._projector.texture.getTextureForStage3D(param2));
      }
   }
}

