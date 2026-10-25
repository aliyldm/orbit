package away3d.tools.helpers
{
   import away3d.core.base.CompactSubGeometry;
   import away3d.core.base.Geometry;
   import away3d.core.base.ISubGeometry;
   import away3d.core.base.ParticleGeometry;
   import away3d.core.base.data.ParticleData;
   import away3d.tools.helpers.data.ParticleGeometryTransform;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   
   public class ParticleGeometryHelper
   {
      
      public static const MAX_VERTEX:int = 65535;
      
      public function ParticleGeometryHelper()
      {
         super();
      }
      
      public static function generateGeometry(param1:Vector.<Geometry>, param2:Vector.<ParticleGeometryTransform> = null) : ParticleGeometry
      {
         var _loc9_:Vector.<ISubGeometry> = null;
         var _loc10_:ISubGeometry = null;
         var _loc11_:uint = 0;
         var _loc12_:Vector.<Number> = null;
         var _loc13_:Vector.<uint> = null;
         var _loc14_:uint = 0;
         var _loc15_:CompactSubGeometry = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:ParticleData = null;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:CompactSubGeometry = null;
         var _loc29_:uint = 0;
         var _loc30_:Vector.<Number> = null;
         var _loc31_:Vector.<uint> = null;
         var _loc32_:ParticleGeometryTransform = null;
         var _loc33_:Matrix3D = null;
         var _loc34_:Matrix3D = null;
         var _loc35_:Matrix = null;
         var _loc3_:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
         var _loc4_:Vector.<Vector.<uint>> = new Vector.<Vector.<uint>>();
         var _loc5_:Vector.<uint> = new Vector.<uint>();
         var _loc6_:Vector.<ParticleData> = new Vector.<ParticleData>();
         var _loc7_:Vector.<CompactSubGeometry> = new Vector.<CompactSubGeometry>();
         var _loc8_:uint = param1.length;
         var _loc18_:Vector.<int> = new Vector.<int>();
         var _loc19_:Vector3D = new Vector3D();
         var _loc20_:Vector3D = new Vector3D();
         var _loc21_:Vector3D = new Vector3D();
         var _loc22_:Point = new Point();
         _loc16_ = 0;
         while(_loc16_ < _loc8_)
         {
            _loc9_ = param1[_loc16_].subGeometries;
            _loc11_ = _loc9_.length;
            _loc24_ = 0;
            while(_loc24_ < _loc11_)
            {
               if(_loc18_.length <= _loc24_)
               {
                  _loc18_.push(_loc7_.length);
                  _loc3_.push(new Vector.<Number>());
                  _loc4_.push(new Vector.<uint>());
                  _loc7_.push(new CompactSubGeometry());
                  _loc5_.push(0);
               }
               _loc10_ = _loc9_[_loc24_];
               if(_loc10_.numVertices + _loc5_[_loc18_[_loc24_]] > MAX_VERTEX)
               {
                  _loc18_[_loc24_] = _loc7_.length;
                  _loc3_.push(new Vector.<Number>());
                  _loc4_.push(new Vector.<uint>());
                  _loc7_.push(new CompactSubGeometry());
                  _loc5_.push(0);
               }
               _loc17_ = _loc18_[_loc24_];
               _loc12_ = _loc3_[_loc17_];
               _loc13_ = _loc4_[_loc17_];
               _loc14_ = _loc5_[_loc17_];
               _loc15_ = _loc7_[_loc17_];
               _loc25_ = new ParticleData();
               _loc25_.numVertices = _loc10_.numVertices;
               _loc25_.startVertexIndex = _loc14_;
               _loc25_.particleIndex = _loc16_;
               _loc25_.subGeometry = _loc15_;
               _loc6_.push(_loc25_);
               _loc5_[_loc17_] += _loc10_.numVertices;
               _loc28_ = _loc10_ as CompactSubGeometry;
               if(_loc28_)
               {
                  _loc27_ = int(_loc28_.numVertices);
                  _loc28_.numTriangles;
                  _loc30_ = _loc28_.vertexData;
                  if(param2)
                  {
                     _loc32_ = param2[_loc16_];
                     _loc33_ = _loc32_.vertexTransform;
                     _loc34_ = _loc32_.invVertexTransform;
                     _loc35_ = _loc32_.UVTransform;
                     _loc26_ = 0;
                     while(_loc26_ < _loc27_)
                     {
                        _loc29_ = _loc26_ * 13;
                        _loc19_.x = _loc30_[_loc29_];
                        _loc19_.y = _loc30_[_loc29_ + 1];
                        _loc19_.z = _loc30_[_loc29_ + 2];
                        _loc20_.x = _loc30_[_loc29_ + 3];
                        _loc20_.y = _loc30_[_loc29_ + 4];
                        _loc20_.z = _loc30_[_loc29_ + 5];
                        _loc21_.x = _loc30_[_loc29_ + 6];
                        _loc21_.y = _loc30_[_loc29_ + 7];
                        _loc21_.z = _loc30_[_loc29_ + 8];
                        _loc22_.x = _loc30_[_loc29_ + 9];
                        _loc22_.y = _loc30_[_loc29_ + 10];
                        if(_loc33_)
                        {
                           _loc19_ = _loc33_.transformVector(_loc19_);
                           _loc20_ = _loc34_.deltaTransformVector(_loc20_);
                           _loc21_ = _loc34_.deltaTransformVector(_loc20_);
                        }
                        if(_loc35_)
                        {
                           _loc22_ = _loc35_.transformPoint(_loc22_);
                        }
                        _loc12_.push(_loc19_.x,_loc19_.y,_loc19_.z,_loc20_.x,_loc20_.y,_loc20_.z,_loc21_.x,_loc21_.y,_loc21_.z,_loc22_.x,_loc22_.y,_loc30_[_loc29_ + 11],_loc30_[_loc29_ + 12]);
                        _loc26_++;
                     }
                  }
                  else
                  {
                     _loc26_ = 0;
                     while(_loc26_ < _loc27_)
                     {
                        _loc29_ = _loc26_ * 13;
                        _loc12_.push(_loc30_[_loc29_],_loc30_[_loc29_ + 1],_loc30_[_loc29_ + 2],_loc30_[_loc29_ + 3],_loc30_[_loc29_ + 4],_loc30_[_loc29_ + 5],_loc30_[_loc29_ + 6],_loc30_[_loc29_ + 7],_loc30_[_loc29_ + 8],_loc30_[_loc29_ + 9],_loc30_[_loc29_ + 10],_loc30_[_loc29_ + 11],_loc30_[_loc29_ + 12]);
                        _loc26_++;
                     }
                  }
               }
               _loc31_ = _loc10_.indexData;
               _loc27_ = int(_loc10_.numTriangles);
               _loc26_ = 0;
               while(_loc26_ < _loc27_)
               {
                  _loc29_ = _loc26_ * 3;
                  _loc13_.push(_loc31_[_loc29_] + _loc14_,_loc31_[_loc29_ + 1] + _loc14_,_loc31_[_loc29_ + 2] + _loc14_);
                  _loc26_++;
               }
               _loc24_++;
            }
            _loc16_++;
         }
         var _loc23_:ParticleGeometry = new ParticleGeometry();
         _loc23_.particles = _loc6_;
         _loc23_.numParticles = _loc8_;
         _loc8_ = _loc7_.length;
         _loc16_ = 0;
         while(_loc16_ < _loc8_)
         {
            _loc15_ = _loc7_[_loc16_];
            _loc15_.updateData(_loc3_[_loc16_]);
            _loc15_.updateIndexData(_loc4_[_loc16_]);
            _loc23_.addSubGeometry(_loc15_);
            _loc16_++;
         }
         return _loc23_;
      }
   }
}

