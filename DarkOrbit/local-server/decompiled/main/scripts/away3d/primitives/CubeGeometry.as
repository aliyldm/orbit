package away3d.primitives
{
   import away3d.arcane;
   import away3d.core.base.CompactSubGeometry;
   
   use namespace arcane;
   
   public class CubeGeometry extends PrimitiveBase
   {
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _depth:Number;
      
      private var _tile6:Boolean;
      
      private var _segmentsW:Number;
      
      private var _segmentsH:Number;
      
      private var _segmentsD:Number;
      
      public function CubeGeometry(param1:Number = 100, param2:Number = 100, param3:Number = 100, param4:uint = 1, param5:uint = 1, param6:uint = 1, param7:Boolean = true)
      {
         super();
         this._width = param1;
         this._height = param2;
         this._depth = param3;
         this._segmentsW = param4;
         this._segmentsH = param5;
         this._segmentsD = param6;
         this._tile6 = param7;
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
      
      public function get depth() : Number
      {
         return this._depth;
      }
      
      public function set depth(param1:Number) : void
      {
         this._depth = param1;
         invalidateGeometry();
      }
      
      public function get tile6() : Boolean
      {
         return this._tile6;
      }
      
      public function set tile6(param1:Boolean) : void
      {
         this._tile6 = param1;
         invalidateUVs();
      }
      
      public function get segmentsW() : Number
      {
         return this._segmentsW;
      }
      
      public function set segmentsW(param1:Number) : void
      {
         this._segmentsW = param1;
         invalidateGeometry();
         invalidateUVs();
      }
      
      public function get segmentsH() : Number
      {
         return this._segmentsH;
      }
      
      public function set segmentsH(param1:Number) : void
      {
         this._segmentsH = param1;
         invalidateGeometry();
         invalidateUVs();
      }
      
      public function get segmentsD() : Number
      {
         return this._segmentsD;
      }
      
      public function set segmentsD(param1:Number) : void
      {
         this._segmentsD = param1;
         invalidateGeometry();
         invalidateUVs();
      }
      
      override protected function buildGeometry(param1:CompactSubGeometry) : void
      {
         var _loc2_:Vector.<Number> = null;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc10_:uint = 0;
         var _loc20_:uint = ((this._segmentsW + 1) * (this._segmentsH + 1) + (this._segmentsW + 1) * (this._segmentsD + 1) + (this._segmentsH + 1) * (this._segmentsD + 1)) * 2;
         var _loc21_:uint = param1.vertexStride;
         var _loc22_:uint = _loc21_ - 9;
         if(_loc20_ == param1.numVertices)
         {
            _loc2_ = param1.vertexData;
            _loc3_ = param1.indexData || new Vector.<uint>((this._segmentsW * this._segmentsH + this._segmentsW * this._segmentsD + this._segmentsH * this._segmentsD) * 12,true);
         }
         else
         {
            _loc2_ = new Vector.<Number>(_loc20_ * _loc21_,true);
            _loc3_ = new Vector.<uint>((this._segmentsW * this._segmentsH + this._segmentsW * this._segmentsD + this._segmentsH * this._segmentsD) * 12,true);
            invalidateUVs();
         }
         _loc11_ = uint(param1.vertexOffset);
         _loc12_ = 0;
         _loc13_ = this._width / 2;
         _loc14_ = this._height / 2;
         _loc15_ = this._depth / 2;
         _loc16_ = this._width / this._segmentsW;
         _loc17_ = this._height / this._segmentsH;
         _loc18_ = this._depth / this._segmentsD;
         _loc8_ = 0;
         while(_loc8_ <= this._segmentsW)
         {
            _loc19_ = -_loc13_ + _loc8_ * _loc16_;
            _loc9_ = 0;
            while(_loc9_ <= this._segmentsH)
            {
               var _loc23_:uint;
               _loc2_[_loc23_ = _loc11_++] = _loc19_;
               var _loc24_:uint;
               _loc2_[_loc24_ = _loc11_++] = -_loc14_ + _loc9_ * _loc17_;
               var _loc25_:uint;
               _loc2_[_loc25_ = _loc11_++] = -_loc15_;
               var _loc26_:uint;
               _loc2_[_loc26_ = _loc11_++] = 0;
               var _loc27_:uint;
               _loc2_[_loc27_ = _loc11_++] = 0;
               var _loc28_:uint;
               _loc2_[_loc28_ = _loc11_++] = -1;
               var _loc29_:uint;
               _loc2_[_loc29_ = _loc11_++] = 1;
               var _loc30_:uint;
               _loc2_[_loc30_ = _loc11_++] = 0;
               var _loc31_:uint;
               _loc2_[_loc31_ = _loc11_++] = 0;
               _loc11_ += _loc22_;
               var _loc32_:uint;
               _loc2_[_loc32_ = _loc11_++] = _loc19_;
               var _loc33_:uint;
               _loc2_[_loc33_ = _loc11_++] = -_loc14_ + _loc9_ * _loc17_;
               var _loc34_:uint;
               _loc2_[_loc34_ = _loc11_++] = _loc15_;
               var _loc35_:uint;
               _loc2_[_loc35_ = _loc11_++] = 0;
               var _loc36_:uint;
               _loc2_[_loc36_ = _loc11_++] = 0;
               var _loc37_:uint;
               _loc2_[_loc37_ = _loc11_++] = 1;
               var _loc38_:uint;
               _loc2_[_loc38_ = _loc11_++] = -1;
               var _loc39_:uint;
               _loc2_[_loc39_ = _loc11_++] = 0;
               var _loc40_:uint;
               _loc2_[_loc40_ = _loc11_++] = 0;
               _loc11_ += _loc22_;
               if(Boolean(_loc8_) && Boolean(_loc9_))
               {
                  _loc4_ = 2 * ((_loc8_ - 1) * (this._segmentsH + 1) + (_loc9_ - 1));
                  _loc5_ = 2 * (_loc8_ * (this._segmentsH + 1) + (_loc9_ - 1));
                  _loc6_ = _loc4_ + 2;
                  _loc7_ = _loc5_ + 2;
                  var _loc41_:uint;
                  _loc3_[_loc41_ = _loc12_++] = _loc4_;
                  var _loc42_:uint;
                  _loc3_[_loc42_ = _loc12_++] = _loc6_;
                  var _loc43_:uint;
                  _loc3_[_loc43_ = _loc12_++] = _loc7_;
                  var _loc44_:uint;
                  _loc3_[_loc44_ = _loc12_++] = _loc4_;
                  var _loc45_:uint;
                  _loc3_[_loc45_ = _loc12_++] = _loc7_;
                  var _loc46_:uint;
                  _loc3_[_loc46_ = _loc12_++] = _loc5_;
                  var _loc47_:uint;
                  _loc3_[_loc47_ = _loc12_++] = _loc5_ + 1;
                  var _loc48_:uint;
                  _loc3_[_loc48_ = _loc12_++] = _loc7_ + 1;
                  var _loc49_:uint;
                  _loc3_[_loc49_ = _loc12_++] = _loc6_ + 1;
                  var _loc50_:uint;
                  _loc3_[_loc50_ = _loc12_++] = _loc5_ + 1;
                  var _loc51_:uint;
                  _loc3_[_loc51_ = _loc12_++] = _loc6_ + 1;
                  var _loc52_:uint;
                  _loc3_[_loc52_ = _loc12_++] = _loc4_ + 1;
               }
               _loc9_++;
            }
            _loc8_++;
         }
         _loc10_ += 2 * (this._segmentsW + 1) * (this._segmentsH + 1);
         _loc8_ = 0;
         while(_loc8_ <= this._segmentsW)
         {
            _loc19_ = -_loc13_ + _loc8_ * _loc16_;
            _loc9_ = 0;
            while(_loc9_ <= this._segmentsD)
            {
               _loc2_[_loc23_ = _loc11_++] = _loc19_;
               _loc2_[_loc24_ = _loc11_++] = _loc14_;
               _loc2_[_loc25_ = _loc11_++] = -_loc15_ + _loc9_ * _loc18_;
               _loc2_[_loc26_ = _loc11_++] = 0;
               _loc2_[_loc27_ = _loc11_++] = 1;
               _loc2_[_loc28_ = _loc11_++] = 0;
               _loc2_[_loc29_ = _loc11_++] = 1;
               _loc2_[_loc30_ = _loc11_++] = 0;
               _loc2_[_loc31_ = _loc11_++] = 0;
               _loc11_ += _loc22_;
               _loc2_[_loc32_ = _loc11_++] = _loc19_;
               _loc2_[_loc33_ = _loc11_++] = -_loc14_;
               _loc2_[_loc34_ = _loc11_++] = -_loc15_ + _loc9_ * _loc18_;
               _loc2_[_loc35_ = _loc11_++] = 0;
               _loc2_[_loc36_ = _loc11_++] = -1;
               _loc2_[_loc37_ = _loc11_++] = 0;
               _loc2_[_loc38_ = _loc11_++] = 1;
               _loc2_[_loc39_ = _loc11_++] = 0;
               _loc2_[_loc40_ = _loc11_++] = 0;
               _loc11_ += _loc22_;
               if(Boolean(_loc8_) && Boolean(_loc9_))
               {
                  _loc4_ = _loc10_ + 2 * ((_loc8_ - 1) * (this._segmentsD + 1) + (_loc9_ - 1));
                  _loc5_ = _loc10_ + 2 * (_loc8_ * (this._segmentsD + 1) + (_loc9_ - 1));
                  _loc6_ = _loc4_ + 2;
                  _loc7_ = _loc5_ + 2;
                  _loc3_[_loc41_ = _loc12_++] = _loc4_;
                  _loc3_[_loc42_ = _loc12_++] = _loc6_;
                  _loc3_[_loc43_ = _loc12_++] = _loc7_;
                  _loc3_[_loc44_ = _loc12_++] = _loc4_;
                  _loc3_[_loc45_ = _loc12_++] = _loc7_;
                  _loc3_[_loc46_ = _loc12_++] = _loc5_;
                  _loc3_[_loc47_ = _loc12_++] = _loc5_ + 1;
                  _loc3_[_loc48_ = _loc12_++] = _loc7_ + 1;
                  _loc3_[_loc49_ = _loc12_++] = _loc6_ + 1;
                  _loc3_[_loc50_ = _loc12_++] = _loc5_ + 1;
                  _loc3_[_loc51_ = _loc12_++] = _loc6_ + 1;
                  _loc3_[_loc52_ = _loc12_++] = _loc4_ + 1;
               }
               _loc9_++;
            }
            _loc8_++;
         }
         _loc10_ += 2 * (this._segmentsW + 1) * (this._segmentsD + 1);
         _loc8_ = 0;
         while(_loc8_ <= this._segmentsD)
         {
            _loc19_ = _loc15_ - _loc8_ * _loc18_;
            _loc9_ = 0;
            while(_loc9_ <= this._segmentsH)
            {
               _loc2_[_loc23_ = _loc11_++] = -_loc13_;
               _loc2_[_loc24_ = _loc11_++] = -_loc14_ + _loc9_ * _loc17_;
               _loc2_[_loc25_ = _loc11_++] = _loc19_;
               _loc2_[_loc26_ = _loc11_++] = -1;
               _loc2_[_loc27_ = _loc11_++] = 0;
               _loc2_[_loc28_ = _loc11_++] = 0;
               _loc2_[_loc29_ = _loc11_++] = 0;
               _loc2_[_loc30_ = _loc11_++] = 0;
               _loc2_[_loc31_ = _loc11_++] = -1;
               _loc11_ += _loc22_;
               _loc2_[_loc32_ = _loc11_++] = _loc13_;
               _loc2_[_loc33_ = _loc11_++] = -_loc14_ + _loc9_ * _loc17_;
               _loc2_[_loc34_ = _loc11_++] = _loc19_;
               _loc2_[_loc35_ = _loc11_++] = 1;
               _loc2_[_loc36_ = _loc11_++] = 0;
               _loc2_[_loc37_ = _loc11_++] = 0;
               _loc2_[_loc38_ = _loc11_++] = 0;
               _loc2_[_loc39_ = _loc11_++] = 0;
               _loc2_[_loc40_ = _loc11_++] = 1;
               _loc11_ += _loc22_;
               if(Boolean(_loc8_) && Boolean(_loc9_))
               {
                  _loc4_ = _loc10_ + 2 * ((_loc8_ - 1) * (this._segmentsH + 1) + (_loc9_ - 1));
                  _loc5_ = _loc10_ + 2 * (_loc8_ * (this._segmentsH + 1) + (_loc9_ - 1));
                  _loc6_ = _loc4_ + 2;
                  _loc7_ = _loc5_ + 2;
                  _loc3_[_loc41_ = _loc12_++] = _loc4_;
                  _loc3_[_loc42_ = _loc12_++] = _loc6_;
                  _loc3_[_loc43_ = _loc12_++] = _loc7_;
                  _loc3_[_loc44_ = _loc12_++] = _loc4_;
                  _loc3_[_loc45_ = _loc12_++] = _loc7_;
                  _loc3_[_loc46_ = _loc12_++] = _loc5_;
                  _loc3_[_loc47_ = _loc12_++] = _loc5_ + 1;
                  _loc3_[_loc48_ = _loc12_++] = _loc7_ + 1;
                  _loc3_[_loc49_ = _loc12_++] = _loc6_ + 1;
                  _loc3_[_loc50_ = _loc12_++] = _loc5_ + 1;
                  _loc3_[_loc51_ = _loc12_++] = _loc6_ + 1;
                  _loc3_[_loc52_ = _loc12_++] = _loc4_ + 1;
               }
               _loc9_++;
            }
            _loc8_++;
         }
         param1.updateData(_loc2_);
         param1.updateIndexData(_loc3_);
      }
      
      override protected function buildUVs(param1:CompactSubGeometry) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<Number> = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:uint = param1.UVStride;
         var _loc17_:uint = ((this._segmentsW + 1) * (this._segmentsH + 1) + (this._segmentsW + 1) * (this._segmentsD + 1) + (this._segmentsH + 1) * (this._segmentsD + 1)) * 2 * _loc16_;
         var _loc18_:uint = _loc16_ - 2;
         if(Boolean(param1.UVData) && _loc17_ == param1.UVData.length)
         {
            _loc5_ = param1.UVData;
         }
         else
         {
            _loc5_ = new Vector.<Number>(_loc17_,true);
            invalidateGeometry();
         }
         if(this._tile6)
         {
            _loc6_ = _loc8_ = 1 / 3;
            _loc7_ = _loc9_ = 1 / 2;
         }
         else
         {
            _loc6_ = _loc7_ = 1;
            _loc8_ = _loc9_ = 0;
         }
         _loc4_ = uint(param1.UVOffset);
         _loc10_ = 1 * _loc8_;
         _loc11_ = 1 * _loc9_;
         _loc12_ = 2 * _loc8_;
         _loc13_ = 0 * _loc9_;
         _loc14_ = _loc6_ / this._segmentsW;
         _loc15_ = _loc7_ / this._segmentsH;
         _loc2_ = 0;
         while(_loc2_ <= this._segmentsW)
         {
            _loc3_ = 0;
            while(_loc3_ <= this._segmentsH)
            {
               var _loc19_:uint;
               _loc5_[_loc19_ = _loc4_++] = (_loc10_ + _loc2_ * _loc14_) * param1.scaleU;
               var _loc20_:uint;
               _loc5_[_loc20_ = _loc4_++] = (_loc11_ + (_loc7_ - _loc3_ * _loc15_)) * param1.scaleV;
               _loc4_ += _loc18_;
               var _loc21_:uint;
               _loc5_[_loc21_ = _loc4_++] = (_loc12_ + (_loc6_ - _loc2_ * _loc14_)) * param1.scaleU;
               var _loc22_:uint;
               _loc5_[_loc22_ = _loc4_++] = (_loc13_ + (_loc7_ - _loc3_ * _loc15_)) * param1.scaleV;
               _loc4_ += _loc18_;
               _loc3_++;
            }
            _loc2_++;
         }
         _loc10_ = 1 * _loc8_;
         _loc11_ = 0 * _loc9_;
         _loc12_ = 0 * _loc8_;
         _loc13_ = 0 * _loc9_;
         _loc14_ = _loc6_ / this._segmentsW;
         _loc15_ = _loc7_ / this._segmentsD;
         _loc2_ = 0;
         while(_loc2_ <= this._segmentsW)
         {
            _loc3_ = 0;
            while(_loc3_ <= this._segmentsD)
            {
               _loc5_[_loc19_ = _loc4_++] = (_loc10_ + _loc2_ * _loc14_) * param1.scaleU;
               _loc5_[_loc20_ = _loc4_++] = (_loc11_ + (_loc7_ - _loc3_ * _loc15_)) * param1.scaleV;
               _loc4_ += _loc18_;
               _loc5_[_loc21_ = _loc4_++] = (_loc12_ + _loc2_ * _loc14_) * param1.scaleU;
               _loc5_[_loc22_ = _loc4_++] = (_loc13_ + _loc3_ * _loc15_) * param1.scaleV;
               _loc4_ += _loc18_;
               _loc3_++;
            }
            _loc2_++;
         }
         _loc10_ = 0 * _loc8_;
         _loc11_ = 1 * _loc9_;
         _loc12_ = 2 * _loc8_;
         _loc13_ = 1 * _loc9_;
         _loc14_ = _loc6_ / this._segmentsD;
         _loc15_ = _loc7_ / this._segmentsH;
         _loc2_ = 0;
         while(_loc2_ <= this._segmentsD)
         {
            _loc3_ = 0;
            while(_loc3_ <= this._segmentsH)
            {
               _loc5_[_loc19_ = _loc4_++] = (_loc10_ + _loc2_ * _loc14_) * param1.scaleU;
               _loc5_[_loc20_ = _loc4_++] = (_loc11_ + (_loc7_ - _loc3_ * _loc15_)) * param1.scaleV;
               _loc4_ += _loc18_;
               _loc5_[_loc21_ = _loc4_++] = (_loc12_ + (_loc6_ - _loc2_ * _loc14_)) * param1.scaleU;
               _loc5_[_loc22_ = _loc4_++] = (_loc13_ + (_loc7_ - _loc3_ * _loc15_)) * param1.scaleV;
               _loc4_ += _loc18_;
               _loc3_++;
            }
            _loc2_++;
         }
         param1.updateData(_loc5_);
      }
   }
}

