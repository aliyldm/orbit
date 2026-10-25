package away3d.core.pick
{
   import away3d.core.base.*;
   import flash.display.*;
   import flash.geom.*;
   import flash.utils.*;
   
   public class PBPickingCollider extends PickingColliderBase implements IPickingCollider
   {
      
      private var RayTriangleKernelClass:Class = PBPickingCollider_RayTriangleKernelClass;
      
      private var _findClosestCollision:Boolean;
      
      private var _rayTriangleKernel:Shader;
      
      private var _lastSubMeshUploaded:SubMesh;
      
      private var _kernelOutputBuffer:Vector.<Number>;
      
      public function PBPickingCollider(param1:Boolean = false)
      {
         super();
         this._findClosestCollision = param1;
         this._kernelOutputBuffer = new Vector.<Number>();
         this._rayTriangleKernel = new Shader(new this.RayTriangleKernelClass() as ByteArray);
      }
      
      override public function setLocalRay(param1:Vector3D, param2:Vector3D) : void
      {
         super.setLocalRay(param1,param2);
         this._rayTriangleKernel.data.rayStartPoint.value = [rayPosition.x,rayPosition.y,rayPosition.z];
         this._rayTriangleKernel.data.rayDirection.value = [rayDirection.x,rayDirection.y,rayDirection.z];
      }
      
      public function testSubMeshCollision(param1:SubMesh, param2:PickingCollisionVO, param3:Number) : Boolean
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc16_:uint = 0;
         var _loc17_:Number = NaN;
         var _loc20_:Vector.<Number> = null;
         var _loc21_:Point = null;
         var _loc10_:Vector.<uint> = param1.indexData;
         var _loc11_:Vector.<Number> = param1.subGeometry.vertexPositionData;
         var _loc12_:Vector.<Number> = param1.UVData;
         var _loc13_:Vector.<Number> = Vector.<Number>(_loc10_);
         var _loc14_:Point = this.evaluateArrayAsGrid(_loc13_);
         if(!this._lastSubMeshUploaded || this._lastSubMeshUploaded !== param1)
         {
            _loc20_ = _loc11_.concat();
            _loc21_ = this.evaluateArrayAsGrid(_loc20_);
            this._rayTriangleKernel.data.vertexBuffer.width = _loc21_.x;
            this._rayTriangleKernel.data.vertexBuffer.height = _loc21_.y;
            this._rayTriangleKernel.data.vertexBufferWidth.value = [_loc21_.x];
            this._rayTriangleKernel.data.vertexBuffer.input = _loc20_;
            this._rayTriangleKernel.data.bothSides.value = [Boolean(param1.material) && param1.material.bothSides ? 1 : 0];
            this._rayTriangleKernel.data.indexBuffer.width = _loc14_.x;
            this._rayTriangleKernel.data.indexBuffer.height = _loc14_.y;
            this._rayTriangleKernel.data.indexBuffer.input = _loc13_;
         }
         this._lastSubMeshUploaded = param1;
         var _loc15_:ShaderJob = new ShaderJob(this._rayTriangleKernel,this._kernelOutputBuffer,_loc14_.x,_loc14_.y);
         _loc15_.start(true);
         var _loc18_:int = -1;
         var _loc19_:uint = this._kernelOutputBuffer.length;
         _loc16_ = 0;
         while(_loc16_ < _loc19_)
         {
            _loc17_ = this._kernelOutputBuffer[_loc16_];
            if(_loc17_ > 0 && _loc17_ < param3)
            {
               param3 = _loc17_;
               _loc18_ = int(_loc16_);
               if(!this._findClosestCollision)
               {
                  break;
               }
            }
            _loc16_ += 3;
         }
         if(_loc18_ >= 0)
         {
            param2.rayEntryDistance = param3;
            if(param2.localPosition == null)
            {
               param2.localPosition = new Vector3D();
            }
            param2.localPosition.x = rayPosition.x + param3 * rayDirection.x;
            param2.localPosition.y = rayPosition.y + param3 * rayDirection.y;
            param2.localPosition.z = rayPosition.z + param3 * rayDirection.z;
            param2.localNormal = getCollisionNormal(_loc10_,_loc11_,_loc18_,param2.localNormal);
            _loc8_ = this._kernelOutputBuffer[_loc18_ + 1];
            _loc9_ = this._kernelOutputBuffer[_loc18_ + 2];
            _loc7_ = 1 - _loc8_ - _loc9_;
            param2.uv = getCollisionUV(_loc10_,_loc12_,_loc18_,_loc8_,_loc9_,_loc7_,0,2,param2.uv);
            return true;
         }
         return false;
      }
      
      private function evaluateArrayAsGrid(param1:Vector.<Number>) : Point
      {
         var _loc5_:uint = 0;
         var _loc2_:uint = param1.length / 3;
         var _loc3_:uint = Math.floor(Math.sqrt(_loc2_));
         var _loc4_:uint = _loc3_;
         while(_loc3_ * _loc4_ < _loc2_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               param1.push(0,0,0);
               _loc5_++;
            }
            _loc4_++;
         }
         return new Point(_loc3_,_loc4_);
      }
   }
}

