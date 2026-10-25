package away3d.primitives
{
   import away3d.arcane;
   import away3d.core.base.CompactSubGeometry;
   
   use namespace arcane;
   
   public class TorusGeometry extends PrimitiveBase
   {
      
      protected var _radius:Number;
      
      protected var _tubeRadius:Number;
      
      protected var _segmentsR:uint;
      
      protected var _segmentsT:uint;
      
      protected var _yUp:Boolean;
      
      protected var _rawVertexData:Vector.<Number>;
      
      protected var _rawIndices:Vector.<uint>;
      
      protected var _nextVertexIndex:uint;
      
      protected var _currentIndex:uint;
      
      protected var _currentTriangleIndex:uint;
      
      protected var _numVertices:uint;
      
      protected var _vertexStride:uint;
      
      protected var _vertexOffset:int;
      
      public function TorusGeometry(param1:Number = 50, param2:Number = 50, param3:uint = 16, param4:uint = 8, param5:Boolean = true)
      {
         super();
         this._radius = param1;
         this._tubeRadius = param2;
         this._segmentsR = param3;
         this._segmentsT = param4;
         this._yUp = param5;
      }
      
      protected function addVertex(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number) : void
      {
         var _loc10_:uint = this._vertexOffset + this._nextVertexIndex * this._vertexStride;
         var _loc11_:uint;
         this._rawVertexData[_loc11_ = _loc10_++] = param1;
         var _loc12_:uint;
         this._rawVertexData[_loc12_ = _loc10_++] = param2;
         var _loc13_:uint;
         this._rawVertexData[_loc13_ = _loc10_++] = param3;
         var _loc14_:uint;
         this._rawVertexData[_loc14_ = _loc10_++] = param4;
         var _loc15_:uint;
         this._rawVertexData[_loc15_ = _loc10_++] = param5;
         var _loc16_:uint;
         this._rawVertexData[_loc16_ = _loc10_++] = param6;
         var _loc17_:uint;
         this._rawVertexData[_loc17_ = _loc10_++] = param7;
         var _loc18_:uint;
         this._rawVertexData[_loc18_ = _loc10_++] = param8;
         this._rawVertexData[_loc10_] = param9;
         ++this._nextVertexIndex;
      }
      
      protected function addTriangleClockWise(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc4_:Number;
         this._rawIndices[_loc4_ = this._currentIndex++] = param1;
         var _loc5_:Number;
         this._rawIndices[_loc5_ = this._currentIndex++] = param2;
         var _loc6_:Number;
         this._rawIndices[_loc6_ = this._currentIndex++] = param3;
         ++this._currentTriangleIndex;
      }
      
      override protected function buildGeometry(param1:CompactSubGeometry) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:uint = 0;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:uint = 0;
         var _loc22_:uint = 0;
         var _loc23_:uint = 0;
         var _loc24_:uint = 0;
         var _loc25_:uint = 0;
         var _loc26_:Number = NaN;
         var _loc27_:uint = 0;
         this._numVertices = 0;
         this._nextVertexIndex = 0;
         this._currentIndex = 0;
         this._currentTriangleIndex = 0;
         this._vertexStride = param1.vertexStride;
         this._vertexOffset = param1.vertexOffset;
         this._numVertices = (this._segmentsT + 1) * (this._segmentsR + 1);
         _loc12_ = this._segmentsT * this._segmentsR * 2;
         if(this._numVertices == param1.numVertices)
         {
            this._rawVertexData = param1.vertexData;
            this._rawIndices = param1.indexData || new Vector.<uint>(_loc12_ * 3,true);
         }
         else
         {
            _loc27_ = this._numVertices * this._vertexStride;
            this._rawVertexData = new Vector.<Number>(_loc27_,true);
            this._rawIndices = new Vector.<uint>(_loc12_ * 3,true);
            invalidateUVs();
         }
         var _loc13_:Number = 2 * Math.PI / this._segmentsR;
         var _loc14_:Number = 2 * Math.PI / this._segmentsT;
         _loc3_ = 0;
         while(_loc3_ <= this._segmentsT)
         {
            _loc21_ = this._vertexOffset + this._nextVertexIndex * this._vertexStride;
            _loc2_ = 0;
            while(_loc2_ <= this._segmentsR)
            {
               _loc10_ = _loc2_ * _loc13_;
               _loc11_ = _loc3_ * _loc14_;
               _loc26_ = Math.cos(_loc11_);
               _loc7_ = _loc26_ * Math.cos(_loc10_);
               _loc8_ = _loc26_ * Math.sin(_loc10_);
               _loc9_ = Math.sin(_loc11_);
               _loc4_ = this._radius * Math.cos(_loc10_) + this._tubeRadius * _loc7_;
               _loc5_ = this._radius * Math.sin(_loc10_) + this._tubeRadius * _loc8_;
               _loc6_ = _loc3_ == this._segmentsT ? 0 : this._tubeRadius * _loc9_;
               if(this._yUp)
               {
                  _loc19_ = -_loc9_;
                  _loc20_ = _loc8_;
                  _loc17_ = 0;
                  _loc18_ = _loc26_ ? _loc7_ / _loc26_ : _loc4_ / this._radius;
                  _loc15_ = -_loc6_;
                  _loc16_ = _loc5_;
               }
               else
               {
                  _loc19_ = _loc8_;
                  _loc20_ = _loc9_;
                  _loc17_ = _loc26_ ? _loc7_ / _loc26_ : _loc4_ / this._radius;
                  _loc18_ = 0;
                  _loc15_ = _loc5_;
                  _loc16_ = _loc6_;
               }
               if(_loc2_ == this._segmentsR)
               {
                  this.addVertex(_loc4_,this._rawVertexData[_loc21_ + 1],this._rawVertexData[_loc21_ + 2],_loc7_,_loc19_,_loc20_,-(_loc26_ ? _loc8_ / _loc26_ : _loc5_ / this._radius),_loc17_,_loc18_);
               }
               else
               {
                  this.addVertex(_loc4_,_loc15_,_loc16_,_loc7_,_loc19_,_loc20_,-(_loc26_ ? _loc8_ / _loc26_ : _loc5_ / this._radius),_loc17_,_loc18_);
               }
               if(_loc2_ > 0 && _loc3_ > 0)
               {
                  _loc22_ = this._nextVertexIndex - 1;
                  _loc23_ = this._nextVertexIndex - 2;
                  _loc24_ = _loc23_ - this._segmentsR - 1;
                  _loc25_ = _loc22_ - this._segmentsR - 1;
                  this.addTriangleClockWise(_loc22_,_loc23_,_loc24_);
                  this.addTriangleClockWise(_loc22_,_loc24_,_loc25_);
               }
               _loc2_++;
            }
            _loc3_++;
         }
         param1.updateData(this._rawVertexData);
         param1.updateIndexData(this._rawIndices);
      }
      
      override protected function buildUVs(param1:CompactSubGeometry) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<Number> = null;
         var _loc5_:int = int(param1.UVStride);
         var _loc6_:int = param1.UVOffset;
         var _loc7_:int = param1.UVStride - 2;
         var _loc8_:uint = this._numVertices * _loc5_;
         if(Boolean(param1.UVData) && _loc8_ == param1.UVData.length)
         {
            _loc4_ = param1.UVData;
         }
         else
         {
            _loc4_ = new Vector.<Number>(_loc8_,true);
            invalidateGeometry();
         }
         var _loc9_:uint = uint(_loc6_);
         _loc3_ = 0;
         while(_loc3_ <= this._segmentsT)
         {
            _loc2_ = 0;
            while(_loc2_ <= this._segmentsR)
            {
               var _loc10_:uint;
               _loc4_[_loc10_ = _loc9_++] = _loc2_ / this._segmentsR * param1.scaleU;
               var _loc11_:uint;
               _loc4_[_loc11_ = _loc9_++] = _loc3_ / this._segmentsT * param1.scaleV;
               _loc9_ += _loc7_;
               _loc2_++;
            }
            _loc3_++;
         }
         param1.updateData(_loc4_);
      }
      
      public function get radius() : Number
      {
         return this._radius;
      }
      
      public function set radius(param1:Number) : void
      {
         this._radius = param1;
         invalidateGeometry();
      }
      
      public function get tubeRadius() : Number
      {
         return this._tubeRadius;
      }
      
      public function set tubeRadius(param1:Number) : void
      {
         this._tubeRadius = param1;
         invalidateGeometry();
      }
      
      public function get segmentsR() : uint
      {
         return this._segmentsR;
      }
      
      public function set segmentsR(param1:uint) : void
      {
         this._segmentsR = param1;
         invalidateGeometry();
         invalidateUVs();
      }
      
      public function get segmentsT() : uint
      {
         return this._segmentsT;
      }
      
      public function set segmentsT(param1:uint) : void
      {
         this._segmentsT = param1;
         invalidateGeometry();
         invalidateUVs();
      }
      
      public function get yUp() : Boolean
      {
         return this._yUp;
      }
      
      public function set yUp(param1:Boolean) : void
      {
         this._yUp = param1;
         invalidateGeometry();
      }
   }
}

