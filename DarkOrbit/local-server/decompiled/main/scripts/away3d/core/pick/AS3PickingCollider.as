package away3d.core.pick
{
   import away3d.core.base.*;
   import flash.geom.*;
   
   public class AS3PickingCollider extends PickingColliderBase implements IPickingCollider
   {
      
      private var _findClosestCollision:Boolean;
      
      public function AS3PickingCollider(param1:Boolean = false)
      {
         super();
         this._findClosestCollision = param1;
      }
      
      public function testSubMeshCollision(param1:SubMesh, param2:PickingCollisionVO, param3:Number) : Boolean
      {
         var _loc4_:Number = NaN;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:Number = NaN;
         var _loc40_:Number = NaN;
         var _loc41_:Number = NaN;
         var _loc42_:Number = NaN;
         var _loc43_:Number = NaN;
         var _loc44_:Number = NaN;
         var _loc45_:Vector.<uint> = param1.indexData;
         var _loc46_:Vector.<Number> = param1.vertexData;
         var _loc47_:Vector.<Number> = param1.UVData;
         var _loc48_:int = -1;
         var _loc49_:Boolean = Boolean(param1.material) && param1.material.bothSides;
         var _loc50_:uint = param1.vertexStride;
         var _loc51_:uint = param1.vertexOffset;
         var _loc52_:uint = param1.UVStride;
         var _loc53_:uint = param1.UVOffset;
         var _loc54_:int = int(_loc45_.length);
         var _loc55_:uint = 0;
         while(_loc55_ < _loc54_)
         {
            _loc5_ = _loc51_ + _loc45_[_loc55_] * _loc50_;
            _loc6_ = _loc51_ + _loc45_[uint(_loc55_ + 1)] * _loc50_;
            _loc7_ = _loc51_ + _loc45_[uint(_loc55_ + 2)] * _loc50_;
            _loc21_ = _loc46_[_loc5_];
            _loc22_ = _loc46_[uint(_loc5_ + 1)];
            _loc23_ = _loc46_[uint(_loc5_ + 2)];
            _loc24_ = _loc46_[_loc6_];
            _loc25_ = _loc46_[uint(_loc6_ + 1)];
            _loc26_ = _loc46_[uint(_loc6_ + 2)];
            _loc27_ = _loc46_[_loc7_];
            _loc28_ = _loc46_[uint(_loc7_ + 1)];
            _loc29_ = _loc46_[uint(_loc7_ + 2)];
            _loc30_ = _loc24_ - _loc21_;
            _loc31_ = _loc25_ - _loc22_;
            _loc32_ = _loc26_ - _loc23_;
            _loc33_ = _loc27_ - _loc21_;
            _loc34_ = _loc28_ - _loc22_;
            _loc35_ = _loc29_ - _loc23_;
            _loc11_ = _loc31_ * _loc35_ - _loc32_ * _loc34_;
            _loc12_ = _loc32_ * _loc33_ - _loc30_ * _loc35_;
            _loc13_ = _loc30_ * _loc34_ - _loc31_ * _loc33_;
            _loc36_ = 1 / Math.sqrt(_loc11_ * _loc11_ + _loc12_ * _loc12_ + _loc13_ * _loc13_);
            _loc11_ *= _loc36_;
            _loc12_ *= _loc36_;
            _loc13_ *= _loc36_;
            _loc37_ = _loc11_ * rayDirection.x + _loc12_ * rayDirection.y + _loc13_ * rayDirection.z;
            if(!_loc49_ && _loc37_ < 0 || _loc49_ && _loc37_ != 0)
            {
               _loc38_ = -(_loc11_ * _loc21_ + _loc12_ * _loc22_ + _loc13_ * _loc23_);
               _loc39_ = -(_loc11_ * rayPosition.x + _loc12_ * rayPosition.y + _loc13_ * rayPosition.z + _loc38_);
               _loc4_ = _loc39_ / _loc37_;
               _loc14_ = rayPosition.x + _loc4_ * rayDirection.x;
               _loc15_ = rayPosition.y + _loc4_ * rayDirection.y;
               _loc16_ = rayPosition.z + _loc4_ * rayDirection.z;
               _loc40_ = _loc30_ * _loc33_ + _loc31_ * _loc34_ + _loc32_ * _loc35_;
               _loc41_ = _loc30_ * _loc30_ + _loc31_ * _loc31_ + _loc32_ * _loc32_;
               _loc42_ = _loc33_ * _loc33_ + _loc34_ * _loc34_ + _loc35_ * _loc35_;
               _loc8_ = _loc14_ - _loc21_;
               _loc9_ = _loc15_ - _loc22_;
               _loc10_ = _loc16_ - _loc23_;
               _loc43_ = _loc8_ * _loc30_ + _loc9_ * _loc31_ + _loc10_ * _loc32_;
               _loc44_ = _loc8_ * _loc33_ + _loc9_ * _loc34_ + _loc10_ * _loc35_;
               _loc17_ = 1 / (_loc41_ * _loc42_ - _loc40_ * _loc40_);
               _loc19_ = _loc17_ * (_loc42_ * _loc43_ - _loc40_ * _loc44_);
               _loc20_ = _loc17_ * (-_loc40_ * _loc43_ + _loc41_ * _loc44_);
               if(_loc19_ >= 0)
               {
                  if(_loc20_ >= 0)
                  {
                     _loc18_ = 1 - _loc19_ - _loc20_;
                     if(_loc18_ >= 0 && _loc4_ > 0 && _loc4_ < param3)
                     {
                        param3 = _loc4_;
                        _loc48_ = _loc55_ / 3;
                        param2.rayEntryDistance = _loc4_;
                        param2.localPosition = new Vector3D(_loc14_,_loc15_,_loc16_);
                        param2.localNormal = new Vector3D(_loc11_,_loc12_,_loc13_);
                        param2.uv = getCollisionUV(_loc45_,_loc47_,_loc55_,_loc19_,_loc20_,_loc18_,_loc53_,_loc52_);
                        param2.index = _loc55_;
                        param2.subGeometryIndex = getMeshSubMeshIndex(param1);
                        if(!this._findClosestCollision)
                        {
                           return true;
                        }
                     }
                  }
               }
            }
            _loc55_ += 3;
         }
         if(_loc48_ >= 0)
         {
            return true;
         }
         return false;
      }
   }
}

