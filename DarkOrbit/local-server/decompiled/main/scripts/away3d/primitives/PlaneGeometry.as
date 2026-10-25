package away3d.primitives
{
   import away3d.arcane;
   import away3d.core.base.CompactSubGeometry;
   
   use namespace arcane;
   
   public class PlaneGeometry extends PrimitiveBase
   {
      
      private var _segmentsW:uint;
      
      private var _segmentsH:uint;
      
      private var _yUp:Boolean;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _doubleSided:Boolean;
      
      public function PlaneGeometry(param1:Number = 100, param2:Number = 100, param3:uint = 1, param4:uint = 1, param5:Boolean = true, param6:Boolean = false)
      {
         super();
         this._segmentsW = param3;
         this._segmentsH = param4;
         this._yUp = param5;
         this._width = param1;
         this._height = param2;
         this._doubleSided = param6;
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
      
      public function get yUp() : Boolean
      {
         return this._yUp;
      }
      
      public function set yUp(param1:Boolean) : void
      {
         this._yUp = param1;
         invalidateGeometry();
      }
      
      public function get doubleSided() : Boolean
      {
         return this._doubleSided;
      }
      
      public function set doubleSided(param1:Boolean) : void
      {
         this._doubleSided = param1;
         invalidateGeometry();
      }
      
      public function get width() : Number
      {
         return this._width;
      }
      
      public function set width(param1:Number) : void
      {
         this._width = param1;
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
      
      override protected function buildGeometry(param1:CompactSubGeometry) : void
      {
         var _loc2_:Vector.<Number> = null;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc8_:uint = this._segmentsW + 1;
         var _loc9_:uint = (this._segmentsH + 1) * _loc8_;
         var _loc10_:uint = param1.vertexStride;
         var _loc11_:uint = _loc10_ - 9;
         if(this._doubleSided)
         {
            _loc9_ *= 2;
         }
         _loc6_ = this._segmentsH * this._segmentsW * 6;
         if(this._doubleSided)
         {
            _loc6_ <<= 1;
         }
         if(_loc9_ == param1.numVertices)
         {
            _loc2_ = param1.vertexData;
            _loc3_ = param1.indexData || new Vector.<uint>(_loc6_,true);
         }
         else
         {
            _loc2_ = new Vector.<Number>(_loc9_ * _loc10_,true);
            _loc3_ = new Vector.<uint>(_loc6_,true);
            invalidateUVs();
         }
         _loc6_ = 0;
         var _loc12_:uint = uint(param1.vertexOffset);
         var _loc13_:uint = 0;
         while(_loc13_ <= this._segmentsH)
         {
            _loc14_ = 0;
            while(_loc14_ <= this._segmentsW)
            {
               _loc4_ = (_loc14_ / this._segmentsW - 0.5) * this._width;
               _loc5_ = (_loc13_ / this._segmentsH - 0.5) * this._height;
               var _loc17_:uint;
               _loc2_[_loc17_ = _loc12_++] = _loc4_;
               if(this._yUp)
               {
                  var _loc18_:uint;
                  _loc2_[_loc18_ = _loc12_++] = 0;
                  var _loc19_:uint;
                  _loc2_[_loc19_ = _loc12_++] = _loc5_;
               }
               else
               {
                  _loc2_[_loc18_ = _loc12_++] = _loc5_;
                  _loc2_[_loc19_ = _loc12_++] = 0;
               }
               _loc2_[_loc18_ = _loc12_++] = 0;
               if(this._yUp)
               {
                  _loc2_[_loc19_ = _loc12_++] = 1;
                  var _loc20_:uint;
                  _loc2_[_loc20_ = _loc12_++] = 0;
               }
               else
               {
                  _loc2_[_loc19_ = _loc12_++] = 0;
                  _loc2_[_loc20_ = _loc12_++] = -1;
               }
               _loc2_[_loc19_ = _loc12_++] = 1;
               _loc2_[_loc20_ = _loc12_++] = 0;
               var _loc21_:uint;
               _loc2_[_loc21_ = _loc12_++] = 0;
               _loc12_ += _loc11_;
               if(this._doubleSided)
               {
                  _loc15_ = 0;
                  while(_loc15_ < 3)
                  {
                     _loc2_[_loc12_] = _loc2_[_loc12_ - _loc10_];
                     _loc12_++;
                     _loc15_++;
                  }
                  _loc15_ = 0;
                  while(_loc15_ < 3)
                  {
                     _loc2_[_loc12_] = -_loc2_[_loc12_ - _loc10_];
                     _loc12_++;
                     _loc15_++;
                  }
                  _loc15_ = 0;
                  while(_loc15_ < 3)
                  {
                     _loc2_[_loc12_] = -_loc2_[_loc12_ - _loc10_];
                     _loc12_++;
                     _loc15_++;
                  }
                  _loc12_ += _loc11_;
               }
               if(_loc14_ != this._segmentsW && _loc13_ != this._segmentsH)
               {
                  _loc7_ = _loc14_ + _loc13_ * _loc8_;
                  _loc16_ = this._doubleSided ? 2 : 1;
                  var _loc22_:uint;
                  _loc3_[_loc22_ = _loc6_++] = _loc7_ * _loc16_;
                  var _loc23_:uint;
                  _loc3_[_loc23_ = _loc6_++] = (_loc7_ + _loc8_) * _loc16_;
                  var _loc24_:uint;
                  _loc3_[_loc24_ = _loc6_++] = (_loc7_ + _loc8_ + 1) * _loc16_;
                  var _loc25_:uint;
                  _loc3_[_loc25_ = _loc6_++] = _loc7_ * _loc16_;
                  var _loc26_:uint;
                  _loc3_[_loc26_ = _loc6_++] = (_loc7_ + _loc8_ + 1) * _loc16_;
                  var _loc27_:uint;
                  _loc3_[_loc27_ = _loc6_++] = (_loc7_ + 1) * _loc16_;
                  if(this._doubleSided)
                  {
                     var _loc28_:uint;
                     _loc3_[_loc28_ = _loc6_++] = (_loc7_ + _loc8_ + 1) * _loc16_ + 1;
                     var _loc29_:uint;
                     _loc3_[_loc29_ = _loc6_++] = (_loc7_ + _loc8_) * _loc16_ + 1;
                     var _loc30_:uint;
                     _loc3_[_loc30_ = _loc6_++] = _loc7_ * _loc16_ + 1;
                     var _loc31_:uint;
                     _loc3_[_loc31_ = _loc6_++] = (_loc7_ + 1) * _loc16_ + 1;
                     var _loc32_:uint;
                     _loc3_[_loc32_ = _loc6_++] = (_loc7_ + _loc8_ + 1) * _loc16_ + 1;
                     var _loc33_:uint;
                     _loc3_[_loc33_ = _loc6_++] = _loc7_ * _loc16_ + 1;
                  }
               }
               _loc14_++;
            }
            _loc13_++;
         }
         param1.updateData(_loc2_);
         param1.updateIndexData(_loc3_);
      }
      
      override protected function buildUVs(param1:CompactSubGeometry) : void
      {
         var _loc2_:Vector.<Number> = null;
         var _loc8_:uint = 0;
         var _loc3_:uint = param1.UVStride;
         var _loc4_:uint = (this._segmentsH + 1) * (this._segmentsW + 1) * _loc3_;
         var _loc5_:uint = _loc3_ - 2;
         if(this._doubleSided)
         {
            _loc4_ *= 2;
         }
         if(Boolean(param1.UVData) && _loc4_ == param1.UVData.length)
         {
            _loc2_ = param1.UVData;
         }
         else
         {
            _loc2_ = new Vector.<Number>(_loc4_,true);
            invalidateGeometry();
         }
         var _loc6_:uint = uint(param1.UVOffset);
         var _loc7_:uint = 0;
         while(_loc7_ <= this._segmentsH)
         {
            _loc8_ = 0;
            while(_loc8_ <= this._segmentsW)
            {
               var _loc9_:uint;
               _loc2_[_loc9_ = _loc6_++] = _loc8_ / this._segmentsW * param1.scaleU;
               var _loc10_:uint;
               _loc2_[_loc10_ = _loc6_++] = (1 - _loc7_ / this._segmentsH) * param1.scaleV;
               _loc6_ += _loc5_;
               if(this._doubleSided)
               {
                  var _loc11_:uint;
                  _loc2_[_loc11_ = _loc6_++] = _loc8_ / this._segmentsW * param1.scaleU;
                  var _loc12_:uint;
                  _loc2_[_loc12_ = _loc6_++] = (1 - _loc7_ / this._segmentsH) * param1.scaleV;
                  _loc6_ += _loc5_;
               }
               _loc8_++;
            }
            _loc7_++;
         }
         param1.updateData(_loc2_);
      }
   }
}

