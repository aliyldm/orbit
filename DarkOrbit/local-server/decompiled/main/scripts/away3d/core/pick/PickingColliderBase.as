package away3d.core.pick
{
   import away3d.core.base.SubGeometry;
   import away3d.core.base.SubMesh;
   import away3d.tools.utils.GeomUtil;
   import flash.geom.*;
   
   public class PickingColliderBase
   {
      
      protected var rayPosition:Vector3D;
      
      protected var rayDirection:Vector3D;
      
      public function PickingColliderBase()
      {
         super();
      }
      
      protected function getCollisionNormal(param1:Vector.<uint>, param2:Vector.<Number>, param3:uint, param4:Vector3D = null) : Vector3D
      {
         var _loc5_:uint = param1[param3] * 3;
         var _loc6_:uint = param1[param3 + 1] * 3;
         var _loc7_:uint = param1[param3 + 2] * 3;
         var _loc8_:Number = param2[_loc6_] - param2[_loc5_];
         var _loc9_:Number = param2[_loc6_ + 1] - param2[_loc5_ + 1];
         var _loc10_:Number = param2[_loc6_ + 2] - param2[_loc5_ + 2];
         var _loc11_:Number = param2[_loc7_] - param2[_loc5_];
         var _loc12_:Number = param2[_loc7_ + 1] - param2[_loc5_ + 1];
         var _loc13_:Number = param2[_loc7_ + 2] - param2[_loc5_ + 2];
         if(!param4)
         {
            param4 = new Vector3D();
         }
         param4.x = _loc9_ * _loc13_ - _loc10_ * _loc12_;
         param4.y = _loc10_ * _loc11_ - _loc8_ * _loc13_;
         param4.z = _loc8_ * _loc12_ - _loc9_ * _loc11_;
         param4.w = 1;
         param4.normalize();
         return param4;
      }
      
      protected function getCollisionUV(param1:Vector.<uint>, param2:Vector.<Number>, param3:uint, param4:Number, param5:Number, param6:Number, param7:uint, param8:uint, param9:Point = null) : Point
      {
         var _loc10_:uint = param1[param3] * param8 + param7;
         var _loc11_:Number = param2[_loc10_];
         var _loc12_:Number = param2[_loc10_ + 1];
         _loc10_ = param1[param3 + 1] * param8 + param7;
         var _loc13_:Number = param2[_loc10_];
         var _loc14_:Number = param2[_loc10_ + 1];
         _loc10_ = param1[param3 + 2] * param8 + param7;
         var _loc15_:Number = param2[_loc10_];
         var _loc16_:Number = param2[_loc10_ + 1];
         if(!param9)
         {
            param9 = new Point();
         }
         param9.x = param6 * _loc11_ + param4 * _loc13_ + param5 * _loc15_;
         param9.y = param6 * _loc12_ + param4 * _loc14_ + param5 * _loc16_;
         return param9;
      }
      
      protected function getMeshSubgeometryIndex(param1:SubGeometry) : uint
      {
         return GeomUtil.getMeshSubgeometryIndex(param1);
      }
      
      protected function getMeshSubMeshIndex(param1:SubMesh) : uint
      {
         return GeomUtil.getMeshSubMeshIndex(param1);
      }
      
      public function setLocalRay(param1:Vector3D, param2:Vector3D) : void
      {
         this.rayPosition = param1;
         this.rayDirection = param2;
      }
   }
}

