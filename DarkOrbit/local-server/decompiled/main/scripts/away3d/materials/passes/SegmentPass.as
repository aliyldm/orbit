package away3d.materials.passes
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.RTTBufferManager;
   import away3d.core.managers.Stage3DProxy;
   import away3d.entities.SegmentSet;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DProgramType;
   import flash.geom.Matrix3D;
   
   use namespace arcane;
   
   public class SegmentPass extends MaterialPassBase
   {
      
      protected static const ONE_VECTOR:Vector.<Number> = Vector.<Number>([1,1,1,1]);
      
      protected static const FRONT_VECTOR:Vector.<Number> = Vector.<Number>([0,0,-1,0]);
      
      private var _constants:Vector.<Number> = new Vector.<Number>(4,true);
      
      private var _calcMatrix:Matrix3D = new Matrix3D();
      
      private var _thickness:Number;
      
      public function SegmentPass(param1:Number)
      {
         this._thickness = param1;
         this._constants[1] = 1 / 255;
         super();
      }
      
      override arcane function getVertexCode() : String
      {
         return "m44 vt0, va0, vc8\t\t\t\n" + "m44 vt1, va1, vc8\t\t\t\n" + "sub vt2, vt1, vt0 \t\t\t\n" + "slt vt5.x, vt0.z, vc7.z\t\t\t\n" + "sub vt5.y, vc5.x, vt5.x\t\t\t\n" + "add vt4.x, vt0.z, vc7.z\t\t\t\n" + "sub vt4.y, vt0.z, vt1.z\t\t\t\n" + "seq vt4.z, vt4.y vc6.x\t\t\t\n" + "add vt4.y, vt4.y, vt4.z\t\t\t\n" + "div vt4.z, vt4.x, vt4.y\t\t\t\n" + "mul vt4.xyz, vt4.zzz, vt2.xyz\t\n" + "add vt3.xyz, vt0.xyz, vt4.xyz\t\n" + "mov vt3.w, vc5.x\t\t\t\n" + "mul vt0, vt0, vt5.yyyy\t\t\t\n" + "mul vt3, vt3, vt5.xxxx\t\t\t\n" + "add vt0, vt0, vt3\t\t\t\t\n" + "sub vt2, vt1, vt0 \t\t\t\n" + "nrm vt2.xyz, vt2.xyz\t\t\t\n" + "nrm vt5.xyz, vt0.xyz\t\t\t\n" + "mov vt5.w, vc5.x\t\t\t\t\n" + "crs vt3.xyz, vt2, vt5\t\t\t\n" + "nrm vt3.xyz, vt3.xyz\t\t\t\n" + "mul vt3.xyz, vt3.xyz, va2.xxx\t\n" + "mov vt3.w, vc5.x\t\t\t\n" + "dp3 vt4.x, vt0, vc6\t\t\t\n" + "mul vt4.x, vt4.x, vc7.x\t\t\t\n" + "mul vt3.xyz, vt3.xyz, vt4.xxx\t\n" + "add vt0.xyz, vt0.xyz, vt3.xyz\t\n" + "m44 op, vt0, vc0\t\t\t\n" + "mov v0, va3\t\t\t\t\n";
      }
      
      override arcane function getFragmentCode(param1:String) : String
      {
         return "mov oc, v0\n";
      }
      
      override arcane function render(param1:IRenderable, param2:Stage3DProxy, param3:Camera3D, param4:Matrix3D) : void
      {
         var _loc7_:uint = 0;
         var _loc5_:Context3D = param2._context3D;
         this._calcMatrix.copyFrom(param1.sourceEntity.sceneTransform);
         this._calcMatrix.append(param3.inverseSceneTransform);
         var _loc6_:uint = SegmentSet(param1).subSetCount;
         if(SegmentSet(param1).hasData)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               param1.activateVertexBuffer(_loc7_,param2);
               _loc5_.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,8,this._calcMatrix,true);
               _loc5_.drawTriangles(param1.getIndexBuffer(param2),0,param1.numTriangles);
               _loc7_++;
            }
         }
      }
      
      override arcane function activate(param1:Stage3DProxy, param2:Camera3D) : void
      {
         var _loc4_:RTTBufferManager = null;
         var _loc3_:Context3D = param1._context3D;
         super.arcane::activate(param1,param2);
         if(param1.scissorRect)
         {
            this._constants[0] = this._thickness / Math.min(param1.scissorRect.width,param1.scissorRect.height);
         }
         else
         {
            this._constants[0] = this._thickness / Math.min(param1.width,param1.height);
         }
         this._constants[2] = param2.lens.near;
         _loc3_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,5,ONE_VECTOR);
         _loc3_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,6,FRONT_VECTOR);
         _loc3_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,7,this._constants);
         if(!param1.renderTarget)
         {
            _loc3_.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,param2.lens.matrix,true);
         }
         else
         {
            this._calcMatrix.copyFrom(param2.lens.matrix);
            _loc4_ = RTTBufferManager.getInstance(param1);
            this._calcMatrix.appendScale(_loc4_.textureRatioX,_loc4_.textureRatioY,1);
            _loc3_.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,this._calcMatrix,true);
         }
      }
      
      override arcane function deactivate(param1:Stage3DProxy) : void
      {
         var _loc2_:Context3D = param1._context3D;
         _loc2_.setVertexBufferAt(0,null);
         _loc2_.setVertexBufferAt(1,null);
         _loc2_.setVertexBufferAt(2,null);
         _loc2_.setVertexBufferAt(3,null);
      }
   }
}

