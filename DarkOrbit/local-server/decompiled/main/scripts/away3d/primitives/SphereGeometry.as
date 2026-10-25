package away3d.primitives
{
   import away3d.arcane;
   import away3d.core.base.CompactSubGeometry;
   
   use namespace arcane;
   
   public class SphereGeometry extends PrimitiveBase
   {
      
      private var _radius:Number;
      
      private var _segmentsW:uint;
      
      private var _segmentsH:uint;
      
      private var _yUp:Boolean;
      
      public function SphereGeometry(param1:Number = 50, param2:uint = 16, param3:uint = 12, param4:Boolean = true)
      {
         super();
         this._radius = param1;
         this._segmentsW = param2;
         this._segmentsH = param3;
         this._yUp = param4;
      }
      
      override protected function buildGeometry(param1:CompactSubGeometry) : void
      {
         var _loc2_:Vector.<Number> = null;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc10_:uint = 0;
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
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc7_:uint = (this._segmentsH + 1) * (this._segmentsW + 1);
         var _loc8_:uint = param1.vertexStride;
         var _loc9_:uint = _loc8_ - 9;
         if(_loc7_ == param1.numVertices)
         {
            _loc2_ = param1.vertexData;
            _loc3_ = param1.indexData || new Vector.<uint>((this._segmentsH - 1) * this._segmentsW * 6,true);
         }
         else
         {
            _loc2_ = new Vector.<Number>(_loc7_ * _loc8_,true);
            _loc3_ = new Vector.<uint>((this._segmentsH - 1) * this._segmentsW * 6,true);
            invalidateGeometry();
         }
         var _loc11_:uint = uint(param1.vertexOffset);
         _loc5_ = 0;
         while(_loc5_ <= this._segmentsH)
         {
            _loc10_ = _loc11_;
            _loc16_ = Math.PI * _loc5_ / this._segmentsH;
            _loc17_ = -this._radius * Math.cos(_loc16_);
            _loc18_ = this._radius * Math.sin(_loc16_);
            _loc4_ = 0;
            while(_loc4_ <= this._segmentsW)
            {
               _loc19_ = 2 * Math.PI * _loc4_ / this._segmentsW;
               _loc20_ = _loc18_ * Math.cos(_loc19_);
               _loc21_ = _loc18_ * Math.sin(_loc19_);
               _loc22_ = 1 / Math.sqrt(_loc20_ * _loc20_ + _loc21_ * _loc21_ + _loc17_ * _loc17_);
               _loc23_ = Math.sqrt(_loc21_ * _loc21_ + _loc20_ * _loc20_);
               if(this._yUp)
               {
                  _loc14_ = 0;
                  _loc15_ = _loc23_ > 0.007 ? _loc20_ / _loc23_ : 0;
                  _loc12_ = -_loc17_;
                  _loc13_ = _loc21_;
               }
               else
               {
                  _loc14_ = _loc23_ > 0.007 ? _loc20_ / _loc23_ : 0;
                  _loc15_ = 0;
                  _loc12_ = _loc21_;
                  _loc13_ = _loc17_;
               }
               if(_loc4_ == this._segmentsW)
               {
                  var _loc28_:uint;
                  _loc2_[_loc28_ = _loc11_++] = _loc2_[_loc10_];
                  var _loc29_:uint;
                  _loc2_[_loc29_ = _loc11_++] = _loc2_[_loc10_ + 1];
                  var _loc30_:uint;
                  _loc2_[_loc30_ = _loc11_++] = _loc2_[_loc10_ + 2];
                  var _loc31_:uint;
                  _loc2_[_loc31_ = _loc11_++] = _loc2_[_loc10_ + 3] + _loc20_ * _loc22_ * 0.5;
                  var _loc32_:uint;
                  _loc2_[_loc32_ = _loc11_++] = _loc2_[_loc10_ + 4] + _loc12_ * _loc22_ * 0.5;
                  var _loc33_:uint;
                  _loc2_[_loc33_ = _loc11_++] = _loc2_[_loc10_ + 5] + _loc13_ * _loc22_ * 0.5;
                  var _loc34_:uint;
                  _loc2_[_loc34_ = _loc11_++] = _loc23_ > 0.007 ? -_loc21_ / _loc23_ : 1;
                  var _loc35_:uint;
                  _loc2_[_loc35_ = _loc11_++] = _loc14_;
                  var _loc36_:uint;
                  _loc2_[_loc36_ = _loc11_++] = _loc15_;
               }
               else
               {
                  _loc2_[_loc28_ = _loc11_++] = _loc20_;
                  _loc2_[_loc29_ = _loc11_++] = _loc12_;
                  _loc2_[_loc30_ = _loc11_++] = _loc13_;
                  _loc2_[_loc31_ = _loc11_++] = _loc20_ * _loc22_;
                  _loc2_[_loc32_ = _loc11_++] = _loc12_ * _loc22_;
                  _loc2_[_loc33_ = _loc11_++] = _loc13_ * _loc22_;
                  _loc2_[_loc34_ = _loc11_++] = _loc23_ > 0.007 ? -_loc21_ / _loc23_ : 1;
                  _loc2_[_loc35_ = _loc11_++] = _loc14_;
                  _loc2_[_loc36_ = _loc11_++] = _loc15_;
               }
               if(_loc4_ > 0 && _loc5_ > 0)
               {
                  _loc24_ = (this._segmentsW + 1) * _loc5_ + _loc4_;
                  _loc25_ = (this._segmentsW + 1) * _loc5_ + _loc4_ - 1;
                  _loc26_ = (this._segmentsW + 1) * (_loc5_ - 1) + _loc4_ - 1;
                  _loc27_ = (this._segmentsW + 1) * (_loc5_ - 1) + _loc4_;
                  if(_loc5_ == this._segmentsH)
                  {
                     _loc2_[_loc11_ - 9] = _loc2_[_loc10_];
                     _loc2_[_loc11_ - 8] = _loc2_[_loc10_ + 1];
                     _loc2_[_loc11_ - 7] = _loc2_[_loc10_ + 2];
                     _loc3_[_loc28_ = _loc6_++] = _loc24_;
                     _loc3_[_loc29_ = _loc6_++] = _loc26_;
                     _loc3_[_loc30_ = _loc6_++] = _loc27_;
                  }
                  else if(_loc5_ == 1)
                  {
                     _loc3_[_loc28_ = _loc6_++] = _loc24_;
                     _loc3_[_loc29_ = _loc6_++] = _loc25_;
                     _loc3_[_loc30_ = _loc6_++] = _loc26_;
                  }
                  else
                  {
                     _loc3_[_loc28_ = _loc6_++] = _loc24_;
                     _loc3_[_loc29_ = _loc6_++] = _loc25_;
                     _loc3_[_loc30_ = _loc6_++] = _loc26_;
                     _loc3_[_loc31_ = _loc6_++] = _loc24_;
                     _loc3_[_loc32_ = _loc6_++] = _loc26_;
                     _loc3_[_loc33_ = _loc6_++] = _loc27_;
                  }
               }
               _loc11_ += _loc9_;
               _loc4_++;
            }
            _loc5_++;
         }
         param1.updateData(_loc2_);
         param1.updateIndexData(_loc3_);
      }
      
      override protected function buildUVs(param1:CompactSubGeometry) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc6_:Vector.<Number> = null;
         var _loc4_:uint = param1.UVStride;
         var _loc5_:uint = (this._segmentsH + 1) * (this._segmentsW + 1) * _loc4_;
         var _loc7_:uint = _loc4_ - 2;
         if(Boolean(param1.UVData) && _loc5_ == param1.UVData.length)
         {
            _loc6_ = param1.UVData;
         }
         else
         {
            _loc6_ = new Vector.<Number>(_loc5_,true);
            invalidateGeometry();
         }
         var _loc8_:* = param1.UVOffset;
         _loc3_ = 0;
         while(_loc3_ <= this._segmentsH)
         {
            _loc2_ = 0;
            while(_loc2_ <= this._segmentsW)
            {
               var _loc9_:Number;
               _loc6_[_loc9_ = _loc8_++] = _loc2_ / this._segmentsW * param1.scaleU;
               var _loc10_:Number;
               _loc6_[_loc10_ = _loc8_++] = _loc3_ / this._segmentsH * param1.scaleV;
               _loc8_ += _loc7_;
               _loc2_++;
            }
            _loc3_++;
         }
         param1.updateData(_loc6_);
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
   }
}

