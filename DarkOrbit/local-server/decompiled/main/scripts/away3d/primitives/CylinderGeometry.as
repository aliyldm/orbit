package away3d.primitives
{
   import away3d.arcane;
   import away3d.core.base.CompactSubGeometry;
   
   use namespace arcane;
   
   public class CylinderGeometry extends PrimitiveBase
   {
      
      protected var _topRadius:Number;
      
      protected var _bottomRadius:Number;
      
      protected var _height:Number;
      
      protected var _segmentsW:uint;
      
      protected var _segmentsH:uint;
      
      protected var _topClosed:Boolean;
      
      protected var _bottomClosed:Boolean;
      
      protected var _surfaceClosed:Boolean;
      
      protected var _yUp:Boolean;
      
      private var _rawData:Vector.<Number>;
      
      private var _rawIndices:Vector.<uint>;
      
      private var _nextVertexIndex:uint;
      
      private var _currentIndex:uint;
      
      private var _currentTriangleIndex:uint;
      
      private var _numVertices:uint;
      
      private var _stride:uint;
      
      private var _vertexOffset:uint;
      
      public function CylinderGeometry(param1:Number = 50, param2:Number = 50, param3:Number = 100, param4:uint = 16, param5:uint = 1, param6:Boolean = true, param7:Boolean = true, param8:Boolean = true, param9:Boolean = true)
      {
         super();
         this._topRadius = param1;
         this._bottomRadius = param2;
         this._height = param3;
         this._segmentsW = param4;
         this._segmentsH = param5;
         this._topClosed = param6;
         this._bottomClosed = param7;
         this._surfaceClosed = param8;
         this._yUp = param9;
      }
      
      private function addVertex(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number) : void
      {
         var _loc10_:uint = this._vertexOffset + this._nextVertexIndex * this._stride;
         var _loc11_:uint;
         this._rawData[_loc11_ = _loc10_++] = param1;
         var _loc12_:uint;
         this._rawData[_loc12_ = _loc10_++] = param2;
         var _loc13_:uint;
         this._rawData[_loc13_ = _loc10_++] = param3;
         var _loc14_:uint;
         this._rawData[_loc14_ = _loc10_++] = param4;
         var _loc15_:uint;
         this._rawData[_loc15_ = _loc10_++] = param5;
         var _loc16_:uint;
         this._rawData[_loc16_ = _loc10_++] = param6;
         var _loc17_:uint;
         this._rawData[_loc17_ = _loc10_++] = param7;
         var _loc18_:uint;
         this._rawData[_loc18_ = _loc10_++] = param8;
         var _loc19_:uint;
         this._rawData[_loc19_ = _loc10_++] = param9;
         ++this._nextVertexIndex;
      }
      
      private function addTriangleClockWise(param1:uint, param2:uint, param3:uint) : void
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
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:uint = 0;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc21_:uint = 0;
         var _loc22_:uint = 0;
         var _loc23_:uint = 0;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc12_:uint = 0;
         this._stride = param1.vertexStride;
         this._vertexOffset = param1.vertexOffset;
         this._numVertices = 0;
         this._nextVertexIndex = 0;
         this._currentIndex = 0;
         this._currentTriangleIndex = 0;
         if(this._surfaceClosed)
         {
            this._numVertices += (this._segmentsH + 1) * (this._segmentsW + 1);
            _loc12_ += this._segmentsH * this._segmentsW * 2;
         }
         if(this._topClosed)
         {
            this._numVertices += 2 * (this._segmentsW + 1);
            _loc12_ += this._segmentsW;
         }
         if(this._bottomClosed)
         {
            this._numVertices += 2 * (this._segmentsW + 1);
            _loc12_ += this._segmentsW;
         }
         if(this._numVertices == param1.numVertices)
         {
            this._rawData = param1.vertexData;
            this._rawIndices = param1.indexData || new Vector.<uint>(_loc12_ * 3,true);
         }
         else
         {
            _loc19_ = this._numVertices * this._stride;
            this._rawData = new Vector.<Number>(_loc19_,true);
            this._rawIndices = new Vector.<uint>(_loc12_ * 3,true);
         }
         var _loc18_:Number = 2 * Math.PI / this._segmentsW;
         if(this._topClosed && this._topRadius > 0)
         {
            _loc6_ = -0.5 * this._height;
            _loc2_ = 0;
            while(_loc2_ <= this._segmentsW)
            {
               if(this._yUp)
               {
                  _loc16_ = 1;
                  _loc17_ = 0;
                  _loc13_ = -_loc6_;
                  _loc14_ = 0;
               }
               else
               {
                  _loc16_ = 0;
                  _loc17_ = -1;
                  _loc13_ = 0;
                  _loc14_ = _loc6_;
               }
               this.addVertex(0,_loc13_,_loc14_,0,_loc16_,_loc17_,1,0,0);
               _loc8_ = _loc2_ * _loc18_;
               _loc4_ = this._topRadius * Math.cos(_loc8_);
               _loc5_ = this._topRadius * Math.sin(_loc8_);
               if(this._yUp)
               {
                  _loc13_ = -_loc6_;
                  _loc14_ = _loc5_;
               }
               else
               {
                  _loc13_ = _loc5_;
                  _loc14_ = _loc6_;
               }
               if(_loc2_ == this._segmentsW)
               {
                  this.addVertex(this._rawData[_loc15_ + this._stride],this._rawData[_loc15_ + this._stride + 1],this._rawData[_loc15_ + this._stride + 2],0,_loc16_,_loc17_,1,0,0);
               }
               else
               {
                  this.addVertex(_loc4_,_loc13_,_loc14_,0,_loc16_,_loc17_,1,0,0);
               }
               if(_loc2_ > 0)
               {
                  this.addTriangleClockWise(this._nextVertexIndex - 1,this._nextVertexIndex - 3,this._nextVertexIndex - 2);
               }
               _loc2_++;
            }
         }
         if(this._bottomClosed && this._bottomRadius > 0)
         {
            _loc6_ = 0.5 * this._height;
            _loc15_ = this._vertexOffset + this._nextVertexIndex * this._stride;
            _loc2_ = 0;
            while(_loc2_ <= this._segmentsW)
            {
               if(this._yUp)
               {
                  _loc16_ = -1;
                  _loc17_ = 0;
                  _loc13_ = -_loc6_;
                  _loc14_ = 0;
               }
               else
               {
                  _loc16_ = 0;
                  _loc17_ = 1;
                  _loc13_ = 0;
                  _loc14_ = _loc6_;
               }
               this.addVertex(0,_loc13_,_loc14_,0,_loc16_,_loc17_,1,0,0);
               _loc8_ = _loc2_ * _loc18_;
               _loc4_ = this._bottomRadius * Math.cos(_loc8_);
               _loc5_ = this._bottomRadius * Math.sin(_loc8_);
               if(this._yUp)
               {
                  _loc13_ = -_loc6_;
                  _loc14_ = _loc5_;
               }
               else
               {
                  _loc13_ = _loc5_;
                  _loc14_ = _loc6_;
               }
               if(_loc2_ == this._segmentsW)
               {
                  this.addVertex(_loc4_,this._rawData[_loc15_ + 1],this._rawData[_loc15_ + 2],0,_loc16_,_loc17_,1,0,0);
               }
               else
               {
                  this.addVertex(_loc4_,_loc13_,_loc14_,0,_loc16_,_loc17_,1,0,0);
               }
               if(_loc2_ > 0)
               {
                  this.addTriangleClockWise(this._nextVertexIndex - 2,this._nextVertexIndex - 3,this._nextVertexIndex - 1);
               }
               _loc2_++;
            }
         }
         _loc9_ = this._bottomRadius - this._topRadius;
         _loc10_ = _loc9_ / this._height;
         _loc11_ = _loc10_ == 0 ? 1 : this._height / _loc9_;
         if(this._surfaceClosed)
         {
            _loc3_ = 0;
            while(_loc3_ <= this._segmentsH)
            {
               _loc7_ = this._topRadius - _loc3_ / this._segmentsH * (this._topRadius - this._bottomRadius);
               _loc6_ = -(this._height / 2) + _loc3_ / this._segmentsH * this._height;
               _loc15_ = this._vertexOffset + this._nextVertexIndex * this._stride;
               _loc2_ = 0;
               while(_loc2_ <= this._segmentsW)
               {
                  _loc8_ = _loc2_ * _loc18_;
                  _loc4_ = _loc7_ * Math.cos(_loc8_);
                  _loc5_ = _loc7_ * Math.sin(_loc8_);
                  _loc24_ = _loc11_ * Math.cos(_loc8_);
                  _loc25_ = _loc11_ * Math.sin(_loc8_);
                  if(this._yUp)
                  {
                     _loc16_ = 0;
                     _loc17_ = -_loc24_;
                     _loc13_ = -_loc6_;
                     _loc14_ = _loc5_;
                     _loc26_ = _loc10_;
                     _loc27_ = _loc25_;
                  }
                  else
                  {
                     _loc16_ = -_loc24_;
                     _loc17_ = 0;
                     _loc13_ = _loc5_;
                     _loc14_ = _loc6_;
                     _loc26_ = _loc25_;
                     _loc27_ = _loc10_;
                  }
                  if(_loc2_ == this._segmentsW)
                  {
                     this.addVertex(this._rawData[_loc15_],this._rawData[_loc15_ + 1],this._rawData[_loc15_ + 2],_loc24_,_loc10_,_loc25_,_loc25_,_loc16_,_loc17_);
                  }
                  else
                  {
                     this.addVertex(_loc4_,_loc13_,_loc14_,_loc24_,_loc26_,_loc27_,-_loc25_,_loc16_,_loc17_);
                  }
                  if(_loc2_ > 0 && _loc3_ > 0)
                  {
                     _loc20_ = this._nextVertexIndex - 1;
                     _loc21_ = this._nextVertexIndex - 2;
                     _loc22_ = _loc21_ - this._segmentsW - 1;
                     _loc23_ = _loc20_ - this._segmentsW - 1;
                     this.addTriangleClockWise(_loc20_,_loc21_,_loc22_);
                     this.addTriangleClockWise(_loc20_,_loc22_,_loc23_);
                  }
                  _loc2_++;
               }
               _loc3_++;
            }
         }
         param1.updateData(this._rawData);
         param1.updateIndexData(this._rawIndices);
      }
      
      override protected function buildUVs(param1:CompactSubGeometry) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc9_:Vector.<Number> = null;
         var _loc7_:uint = param1.UVStride;
         var _loc8_:uint = _loc7_ - 2;
         var _loc10_:uint = this._numVertices * _loc7_;
         if(Boolean(param1.UVData) && _loc10_ == param1.UVData.length)
         {
            _loc9_ = param1.UVData;
         }
         else
         {
            _loc9_ = new Vector.<Number>(_loc10_,true);
            invalidateGeometry();
         }
         var _loc11_:Number = 2 * Math.PI / this._segmentsW;
         var _loc12_:uint = uint(param1.UVOffset);
         if(this._topClosed)
         {
            _loc2_ = 0;
            while(_loc2_ <= this._segmentsW)
            {
               _loc6_ = _loc2_ * _loc11_;
               _loc4_ = 0.5 + 0.5 * -Math.cos(_loc6_);
               _loc5_ = 0.5 + 0.5 * Math.sin(_loc6_);
               var _loc13_:uint;
               _loc9_[_loc13_ = _loc12_++] = 0.5 * param1.scaleU;
               var _loc14_:uint;
               _loc9_[_loc14_ = _loc12_++] = 0.5 * param1.scaleV;
               _loc12_ += _loc8_;
               var _loc15_:uint;
               _loc9_[_loc15_ = _loc12_++] = _loc4_ * param1.scaleU;
               var _loc16_:uint;
               _loc9_[_loc16_ = _loc12_++] = _loc5_ * param1.scaleV;
               _loc12_ += _loc8_;
               _loc2_++;
            }
         }
         if(this._bottomClosed)
         {
            _loc2_ = 0;
            while(_loc2_ <= this._segmentsW)
            {
               _loc6_ = _loc2_ * _loc11_;
               _loc4_ = 0.5 + 0.5 * Math.cos(_loc6_);
               _loc5_ = 0.5 + 0.5 * Math.sin(_loc6_);
               _loc9_[_loc13_ = _loc12_++] = 0.5 * param1.scaleU;
               _loc9_[_loc14_ = _loc12_++] = 0.5 * param1.scaleV;
               _loc12_ += _loc8_;
               _loc9_[_loc15_ = _loc12_++] = _loc4_ * param1.scaleU;
               _loc9_[_loc16_ = _loc12_++] = _loc5_ * param1.scaleV;
               _loc12_ += _loc8_;
               _loc2_++;
            }
         }
         if(this._surfaceClosed)
         {
            _loc3_ = 0;
            while(_loc3_ <= this._segmentsH)
            {
               _loc2_ = 0;
               while(_loc2_ <= this._segmentsW)
               {
                  _loc9_[_loc13_ = _loc12_++] = _loc2_ / this._segmentsW * param1.scaleU;
                  _loc9_[_loc14_ = _loc12_++] = _loc3_ / this._segmentsH * param1.scaleV;
                  _loc12_ += _loc8_;
                  _loc2_++;
               }
               _loc3_++;
            }
         }
         param1.updateData(_loc9_);
      }
      
      public function get topRadius() : Number
      {
         return this._topRadius;
      }
      
      public function set topRadius(param1:Number) : void
      {
         this._topRadius = param1;
         invalidateGeometry();
      }
      
      public function get bottomRadius() : Number
      {
         return this._bottomRadius;
      }
      
      public function set bottomRadius(param1:Number) : void
      {
         this._bottomRadius = param1;
         invalidateGeometry();
      }
      
      public function get height() : Number
      {
         return this._height;
      }
      
      public function set height(param1:Number) : void
      {
         this._height = param1;
         invalidateGeometry();
      }
      
      public function get segmentsW() : uint
      {
         return this._segmentsW;
      }
      
      public function set segmentsW(param1:uint) : void
      {
         this._segmentsW = param1;
         invalidateGeometry();
         invalidateUVs();
      }
      
      public function get segmentsH() : uint
      {
         return this._segmentsH;
      }
      
      public function set segmentsH(param1:uint) : void
      {
         this._segmentsH = param1;
         invalidateGeometry();
         invalidateUVs();
      }
      
      public function get topClosed() : Boolean
      {
         return this._topClosed;
      }
      
      public function set topClosed(param1:Boolean) : void
      {
         this._topClosed = param1;
         invalidateGeometry();
      }
      
      public function get bottomClosed() : Boolean
      {
         return this._bottomClosed;
      }
      
      public function set bottomClosed(param1:Boolean) : void
      {
         this._bottomClosed = param1;
         invalidateGeometry();
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

