package away3d.materials.passes
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import away3d.textures.CubeTextureBase;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DCompareMode;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DTextureFormat;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class SkyBoxPass extends MaterialPassBase
   {
      
      private var _cubeTexture:CubeTextureBase;
      
      private var _vertexData:Vector.<Number>;
      
      public function SkyBoxPass()
      {
         super();
         mipmap = false;
         _numUsedTextures = 1;
         this._vertexData = new <Number>[0,0,0,0,1,1,1,1];
      }
      
      public function get cubeTexture() : CubeTextureBase
      {
         return this._cubeTexture;
      }
      
      public function set cubeTexture(param1:CubeTextureBase) : void
      {
         this._cubeTexture = param1;
      }
      
      override arcane function getVertexCode() : String
      {
         return "mul vt0, va0, vc5\t\t\n" + "add vt0, vt0, vc4\t\t\n" + "m44 op, vt0, vc0\t\t\n" + "mul v0, va0, vc4.xxxx\n";
      }
      
      override arcane function getFragmentCode(param1:String) : String
      {
         var _loc2_:String = null;
         switch(this._cubeTexture.format)
         {
            case Context3DTextureFormat.COMPRESSED:
               _loc2_ = "dxt1,";
               break;
            case "compressedAlpha":
               _loc2_ = "dxt5,";
               break;
            default:
               _loc2_ = "";
         }
         var _loc3_:String = ",mipnone";
         if(this._cubeTexture.hasMipMaps)
         {
            _loc3_ = ",miplinear";
         }
         return "tex ft0, v0, fs0 <cube," + _loc2_ + "linear,clamp" + _loc3_ + ">\t\n" + "mov oc, ft0\n";
      }
      
      override arcane function render(param1:IRenderable, param2:Stage3DProxy, param3:Camera3D, param4:Matrix3D) : void
      {
         var _loc5_:Context3D = param2._context3D;
         var _loc6_:Vector3D = param3.scenePosition;
         this._vertexData[0] = _loc6_.x;
         this._vertexData[1] = _loc6_.y;
         this._vertexData[2] = _loc6_.z;
         this._vertexData[3] = 0.01;
         this._vertexData[4] = this._vertexData[5] = this._vertexData[6] = param3.lens.far / Math.sqrt(3);
         _loc5_.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,param4,true);
         _loc5_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,this._vertexData,2);
         param1.activateVertexBuffer(0,param2);
         _loc5_.drawTriangles(param1.getIndexBuffer(param2),0,param1.numTriangles);
      }
      
      override arcane function activate(param1:Stage3DProxy, param2:Camera3D) : void
      {
         super.arcane::activate(param1,param2);
         var _loc3_:Context3D = param1._context3D;
         _loc3_.setDepthTest(false,Context3DCompareMode.LESS);
         _loc3_.setTextureAt(0,this._cubeTexture.getTextureForStage3D(param1));
      }
   }
}

