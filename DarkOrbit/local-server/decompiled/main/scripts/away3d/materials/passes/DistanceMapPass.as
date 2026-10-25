package away3d.materials.passes
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import away3d.core.math.Matrix3DUtils;
   import away3d.textures.Texture2DBase;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DTextureFormat;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class DistanceMapPass extends MaterialPassBase
   {
      
      private var _fragmentData:Vector.<Number>;
      
      private var _vertexData:Vector.<Number>;
      
      private var _alphaThreshold:Number;
      
      private var _alphaMask:Texture2DBase;
      
      public function DistanceMapPass()
      {
         super();
         this._fragmentData = Vector.<Number>([1,255,65025,16581375,1 / 255,1 / 255,1 / 255,0,0,0,0,0]);
         this._vertexData = new Vector.<Number>(4,true);
         this._vertexData[3] = 1;
         _numUsedVertexConstants = 9;
      }
      
      public function get alphaThreshold() : Number
      {
         return this._alphaThreshold;
      }
      
      public function set alphaThreshold(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > 1)
         {
            param1 = 1;
         }
         if(param1 == this._alphaThreshold)
         {
            return;
         }
         if(param1 == 0 || this._alphaThreshold == 0)
         {
            invalidateShaderProgram();
         }
         this._alphaThreshold = param1;
         this._fragmentData[8] = this._alphaThreshold;
      }
      
      public function get alphaMask() : Texture2DBase
      {
         return this._alphaMask;
      }
      
      public function set alphaMask(param1:Texture2DBase) : void
      {
         this._alphaMask = param1;
      }
      
      override arcane function getVertexCode() : String
      {
         var _loc1_:String = null;
         _loc1_ = "m44 op, vt0, vc0\t\t\n" + "m44 vt1, vt0, vc5\t\t\n" + "sub v0, vt1, vc9\t\t\n";
         if(this._alphaThreshold > 0)
         {
            _loc1_ += "mov v1, va1\n";
            _numUsedTextures = 1;
            _numUsedStreams = 2;
         }
         else
         {
            _numUsedTextures = 0;
            _numUsedStreams = 1;
         }
         return _loc1_;
      }
      
      override arcane function getFragmentCode(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         param1 = param1;
         var _loc3_:String = _repeat ? "wrap" : "clamp";
         if(_smooth)
         {
            _loc4_ = _mipmap ? "linear,miplinear" : "linear";
         }
         else
         {
            _loc4_ = _mipmap ? "nearest,mipnearest" : "nearest";
         }
         _loc2_ = "dp3 ft2.z, v0.xyz, v0.xyz\t\n" + "mul ft0, fc0, ft2.z\t\n" + "frc ft0, ft0\t\t\t\n" + "mul ft1, ft0.yzww, fc1\t\n";
         if(this._alphaThreshold > 0)
         {
            switch(this._alphaMask.format)
            {
               case Context3DTextureFormat.COMPRESSED:
                  _loc5_ = "dxt1,";
                  break;
               case "compressedAlpha":
                  _loc5_ = "dxt5,";
                  break;
               default:
                  _loc5_ = "";
            }
            _loc2_ += "tex ft3, v1, fs0 <2d," + _loc4_ + "," + _loc5_ + _loc3_ + ">\n" + "sub ft3.w, ft3.w, fc2.x\n" + "kil ft3.w\n";
         }
         return _loc2_ + "sub oc, ft0, ft1\t\t\n";
      }
      
      override arcane function render(param1:IRenderable, param2:Stage3DProxy, param3:Camera3D, param4:Matrix3D) : void
      {
         var _loc5_:Context3D = param2._context3D;
         var _loc6_:Vector3D = param3.scenePosition;
         this._vertexData[0] = _loc6_.x;
         this._vertexData[1] = _loc6_.y;
         this._vertexData[2] = _loc6_.z;
         this._vertexData[3] = 1;
         var _loc7_:Matrix3D = param1.getRenderSceneTransform(param3);
         _loc5_.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,5,_loc7_,true);
         _loc5_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,9,this._vertexData,1);
         if(this._alphaThreshold > 0)
         {
            param1.activateUVBuffer(1,param2);
         }
         var _loc8_:Matrix3D = Matrix3DUtils.CALCULATION_MATRIX;
         _loc8_.copyFrom(_loc7_);
         _loc8_.append(param4);
         _loc5_.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,_loc8_,true);
         param1.activateVertexBuffer(0,param2);
         _loc5_.drawTriangles(param1.getIndexBuffer(param2),0,param1.numTriangles);
      }
      
      override arcane function activate(param1:Stage3DProxy, param2:Camera3D) : void
      {
         var _loc3_:Context3D = param1._context3D;
         super.arcane::activate(param1,param2);
         var _loc4_:Number = param2.lens.far;
         _loc4_ = 1 / (2 * _loc4_ * _loc4_);
         this._fragmentData[0] = 1 * _loc4_;
         this._fragmentData[1] = 255 * _loc4_;
         this._fragmentData[2] = 65025 * _loc4_;
         this._fragmentData[3] = 16581375 * _loc4_;
         if(this._alphaThreshold > 0)
         {
            _loc3_.setTextureAt(0,this._alphaMask.getTextureForStage3D(param1));
            _loc3_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this._fragmentData,3);
         }
         else
         {
            _loc3_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this._fragmentData,2);
         }
      }
   }
}

