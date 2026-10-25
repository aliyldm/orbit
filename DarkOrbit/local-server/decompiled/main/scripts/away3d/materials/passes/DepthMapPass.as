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
   
   use namespace arcane;
   
   public class DepthMapPass extends MaterialPassBase
   {
      
      private var _data:Vector.<Number>;
      
      private var _alphaThreshold:Number = 0;
      
      private var _alphaMask:Texture2DBase;
      
      public function DepthMapPass()
      {
         super();
         this._data = Vector.<Number>([1,255,65025,16581375,1 / 255,1 / 255,1 / 255,0,0,0,0,0]);
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
         this._data[8] = this._alphaThreshold;
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
         _loc1_ = "m44 vt1, vt0, vc0\t\t\n" + "mov op, vt1\t\n";
         if(this._alphaThreshold > 0)
         {
            _numUsedTextures = 1;
            _numUsedStreams = 2;
            _loc1_ += "mov v0, vt1\n" + "mov v1, va1\n";
         }
         else
         {
            _numUsedTextures = 0;
            _numUsedStreams = 1;
            _loc1_ += "mov v0, vt1\n";
         }
         return _loc1_;
      }
      
      override arcane function getFragmentCode(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc2_:String = "div ft2, v0, v0.w\t\t\n" + "mul ft0, fc0, ft2.z\t\n" + "frc ft0, ft0\t\t\t\n" + "mul ft1, ft0.yzww, fc1\t\n";
         if(this._alphaThreshold > 0)
         {
            _loc3_ = _repeat ? "wrap" : "clamp";
            _loc6_ = _mipmap && this._alphaMask.hasMipMaps;
            if(_smooth)
            {
               _loc4_ = _loc6_ ? "linear,miplinear" : "linear";
            }
            else
            {
               _loc4_ = _loc6_ ? "nearest,mipnearest" : "nearest";
            }
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
         if(this._alphaThreshold > 0)
         {
            param1.activateUVBuffer(1,param2);
         }
         var _loc5_:Context3D = param2._context3D;
         var _loc6_:Matrix3D = Matrix3DUtils.CALCULATION_MATRIX;
         _loc6_.copyFrom(param1.getRenderSceneTransform(param3));
         _loc6_.append(param4);
         _loc5_.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,_loc6_,true);
         param1.activateVertexBuffer(0,param2);
         _loc5_.drawTriangles(param1.getIndexBuffer(param2),0,param1.numTriangles);
      }
      
      override arcane function activate(param1:Stage3DProxy, param2:Camera3D) : void
      {
         var _loc3_:Context3D = param1._context3D;
         super.arcane::activate(param1,param2);
         if(this._alphaThreshold > 0)
         {
            _loc3_.setTextureAt(0,this._alphaMask.getTextureForStage3D(param1));
            _loc3_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this._data,3);
         }
         else
         {
            _loc3_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this._data,2);
         }
      }
   }
}

