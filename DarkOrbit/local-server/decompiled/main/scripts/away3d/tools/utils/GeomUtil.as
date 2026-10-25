package away3d.tools.utils
{
   import away3d.arcane;
   import away3d.core.base.CompactSubGeometry;
   import away3d.core.base.ISubGeometry;
   import away3d.core.base.SkinnedSubGeometry;
   import away3d.core.base.SubMesh;
   
   use namespace arcane;
   
   public class GeomUtil
   {
      
      public function GeomUtil()
      {
         super();
      }
      
      public static function fromVectors(param1:Vector.<Number>, param2:Vector.<uint>, param3:Vector.<Number>, param4:Vector.<Number>, param5:Vector.<Number>, param6:Vector.<Number>, param7:Vector.<Number>, param8:Vector.<Number> = null) : Vector.<ISubGeometry>
      {
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:Vector.<Number> = null;
         var _loc17_:Vector.<uint> = null;
         var _loc18_:Vector.<Number> = null;
         var _loc19_:Vector.<Number> = null;
         var _loc20_:Vector.<Number> = null;
         var _loc21_:Vector.<Number> = null;
         var _loc22_:Vector.<Number> = null;
         var _loc23_:Vector.<Number> = null;
         var _loc24_:Vector.<int> = null;
         var _loc25_:uint = 0;
         var _loc26_:uint = 0;
         var _loc27_:uint = 0;
         var _loc28_:uint = 0;
         var _loc29_:uint = 0;
         var _loc30_:uint = 0;
         var _loc31_:uint = 0;
         var _loc32_:uint = 0;
         var _loc33_:uint = 0;
         var _loc34_:uint = 0;
         var _loc35_:uint = 0;
         var _loc36_:uint = 0;
         var _loc9_:uint = 3 * 65535;
         var _loc10_:uint = 15 * 65535;
         var _loc11_:Vector.<ISubGeometry> = new Vector.<ISubGeometry>();
         if(Boolean(param3) && !param3.length)
         {
            param3 = null;
         }
         if(Boolean(param4) && !param4.length)
         {
            param4 = null;
         }
         if(Boolean(param5) && !param5.length)
         {
            param5 = null;
         }
         if(Boolean(param6) && !param6.length)
         {
            param6 = null;
         }
         if(Boolean(param7) && !param7.length)
         {
            param7 = null;
         }
         if(Boolean(param8) && !param8.length)
         {
            param8 = null;
         }
         if(param2.length >= _loc10_ || param1.length >= _loc9_)
         {
            _loc16_ = new Vector.<Number>();
            _loc17_ = new Vector.<uint>();
            _loc18_ = param3 != null ? new Vector.<Number>() : null;
            _loc19_ = param8 != null ? new Vector.<Number>() : null;
            _loc20_ = param4 != null ? new Vector.<Number>() : null;
            _loc21_ = param5 != null ? new Vector.<Number>() : null;
            _loc22_ = param6 != null ? new Vector.<Number>() : null;
            _loc23_ = param7 != null ? new Vector.<Number>() : null;
            _loc24_ = new Vector.<int>(param1.length / 3,true);
            _loc12_ = _loc24_.length;
            while(_loc12_-- > 0)
            {
               _loc24_[_loc12_] = -1;
            }
            _loc14_ = 0;
            _loc13_ = param2.length;
            _loc12_ = 0;
            while(_loc12_ < _loc13_)
            {
               _loc26_ = _loc16_.length + 6;
               if(_loc14_ + 2 >= _loc10_ || _loc26_ >= _loc9_)
               {
                  _loc11_.push(constructSubGeometry(_loc16_,_loc17_,_loc18_,_loc20_,_loc21_,_loc22_,_loc23_,param8));
                  _loc16_ = new Vector.<Number>();
                  _loc17_ = new Vector.<uint>();
                  _loc18_ = param3 != null ? new Vector.<Number>() : null;
                  _loc19_ = param8 != null ? new Vector.<Number>() : null;
                  _loc20_ = param4 != null ? new Vector.<Number>() : null;
                  _loc21_ = param5 != null ? new Vector.<Number>() : null;
                  _loc22_ = param6 != null ? new Vector.<Number>() : null;
                  _loc23_ = param7 != null ? new Vector.<Number>() : null;
                  _loc26_ = 0;
                  _loc15_ = _loc24_.length;
                  while(_loc15_-- > 0)
                  {
                     _loc24_[_loc15_] = -1;
                  }
                  _loc14_ = 0;
               }
               _loc15_ = 0;
               while(_loc15_ < 3)
               {
                  _loc25_ = param2[_loc12_ + _loc15_];
                  if(_loc24_[_loc25_] >= 0)
                  {
                     _loc26_ = uint(_loc24_[_loc25_]);
                  }
                  else
                  {
                     _loc27_ = _loc25_ * 3 + 0;
                     _loc28_ = _loc25_ * 3 + 1;
                     _loc29_ = _loc25_ * 3 + 2;
                     _loc26_ = _loc16_.length / 3;
                     _loc30_ = _loc26_ * 3 + 0;
                     _loc31_ = _loc26_ * 3 + 1;
                     _loc32_ = _loc26_ * 3 + 2;
                     _loc16_[_loc30_] = param1[_loc27_];
                     _loc16_[_loc31_] = param1[_loc28_];
                     _loc16_[_loc32_] = param1[_loc29_];
                     if(param3)
                     {
                        _loc33_ = _loc26_ * 2 + 0;
                        _loc35_ = _loc26_ * 2 + 1;
                        _loc34_ = _loc25_ * 2 + 0;
                        _loc36_ = _loc25_ * 2 + 1;
                        _loc18_[_loc33_] = param3[_loc34_];
                        _loc18_[_loc35_] = param3[_loc36_];
                     }
                     if(param8)
                     {
                        _loc33_ = _loc26_ * 2 + 0;
                        _loc35_ = _loc26_ * 2 + 1;
                        _loc34_ = _loc25_ * 2 + 0;
                        _loc36_ = _loc25_ * 2 + 1;
                        _loc19_[_loc33_] = param8[_loc34_];
                        _loc19_[_loc35_] = param8[_loc36_];
                     }
                     if(param4)
                     {
                        _loc20_[_loc30_] = param4[_loc27_];
                        _loc20_[_loc31_] = param4[_loc28_];
                        _loc20_[_loc32_] = param4[_loc29_];
                     }
                     if(param5)
                     {
                        _loc21_[_loc30_] = param5[_loc27_];
                        _loc21_[_loc31_] = param5[_loc28_];
                        _loc21_[_loc32_] = param5[_loc29_];
                     }
                     if(param6)
                     {
                        _loc22_[_loc30_] = param6[_loc27_];
                        _loc22_[_loc31_] = param6[_loc28_];
                        _loc22_[_loc32_] = param6[_loc29_];
                     }
                     if(param7)
                     {
                        _loc23_[_loc30_] = param7[_loc27_];
                        _loc23_[_loc31_] = param7[_loc28_];
                        _loc23_[_loc32_] = param7[_loc29_];
                     }
                     _loc24_[_loc25_] = _loc26_;
                  }
                  _loc17_[_loc14_ + _loc15_] = _loc26_;
                  _loc15_++;
               }
               _loc14_ += 3;
               _loc12_ += 3;
            }
            if(_loc16_.length > 0)
            {
               _loc11_.push(constructSubGeometry(_loc16_,_loc17_,_loc18_,_loc20_,_loc21_,_loc22_,_loc23_,_loc19_));
            }
         }
         else
         {
            _loc11_.push(constructSubGeometry(param1,param2,param3,param4,param5,param6,param7,param8));
         }
         return _loc11_;
      }
      
      public static function constructSubGeometry(param1:Vector.<Number>, param2:Vector.<uint>, param3:Vector.<Number>, param4:Vector.<Number>, param5:Vector.<Number>, param6:Vector.<Number>, param7:Vector.<Number>, param8:Vector.<Number>) : CompactSubGeometry
      {
         var _loc9_:CompactSubGeometry = null;
         if(Boolean(param6) && Boolean(param7))
         {
            _loc9_ = new SkinnedSubGeometry(param6.length / (param1.length / 3));
            SkinnedSubGeometry(_loc9_).updateJointWeightsData(param6);
            SkinnedSubGeometry(_loc9_).updateJointIndexData(param7);
         }
         else
         {
            _loc9_ = new CompactSubGeometry();
         }
         _loc9_.updateIndexData(param2);
         _loc9_.fromVectors(param1,param3,param4,param5,param8);
         return _loc9_;
      }
      
      public static function interleaveBuffers(param1:uint, param2:Vector.<Number> = null, param3:Vector.<Number> = null, param4:Vector.<Number> = null, param5:Vector.<Number> = null, param6:Vector.<Number> = null) : Vector.<Number>
      {
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:Vector.<Number> = null;
         _loc11_ = new Vector.<Number>();
         _loc7_ = 0;
         while(_loc7_ < param1)
         {
            _loc9_ = _loc7_ * 2;
            _loc8_ = _loc7_ * 3;
            _loc10_ = _loc7_ * 13;
            _loc11_[_loc10_] = param2 ? param2[_loc8_] : 0;
            _loc11_[_loc10_ + 1] = param2 ? param2[_loc8_ + 1] : 0;
            _loc11_[_loc10_ + 2] = param2 ? param2[_loc8_ + 2] : 0;
            _loc11_[_loc10_ + 3] = param3 ? param3[_loc8_] : 0;
            _loc11_[_loc10_ + 4] = param3 ? param3[_loc8_ + 1] : 0;
            _loc11_[_loc10_ + 5] = param3 ? param3[_loc8_ + 2] : 0;
            _loc11_[_loc10_ + 6] = param4 ? param4[_loc8_] : 0;
            _loc11_[_loc10_ + 7] = param4 ? param4[_loc8_ + 1] : 0;
            _loc11_[_loc10_ + 8] = param4 ? param4[_loc8_ + 2] : 0;
            _loc11_[_loc10_ + 9] = param5 ? param5[_loc9_] : 0;
            _loc11_[_loc10_ + 10] = param5 ? param5[_loc9_ + 1] : 0;
            _loc11_[_loc10_ + 11] = param6 ? param6[_loc9_] : 0;
            _loc11_[_loc10_ + 12] = param6 ? param6[_loc9_ + 1] : 0;
            _loc7_++;
         }
         return _loc11_;
      }
      
      public static function getMeshSubgeometryIndex(param1:ISubGeometry) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:Vector.<ISubGeometry> = param1.parentGeometry.subGeometries;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] == param1)
            {
               _loc2_ = _loc4_;
               break;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function getMeshSubMeshIndex(param1:SubMesh) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:Vector.<SubMesh> = param1.parentMesh.subMeshes;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] == param1)
            {
               _loc2_ = _loc4_;
               break;
            }
            _loc4_++;
         }
         return _loc2_;
      }
   }
}

