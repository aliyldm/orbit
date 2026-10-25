package away3d.primitives
{
   import flash.geom.Vector3D;
   
   public class WireframeSphere extends WireframePrimitiveBase
   {
      
      private var _segmentsW:uint;
      
      private var _segmentsH:uint;
      
      private var _radius:Number;
      
      public function WireframeSphere(param1:Number = 50, param2:uint = 16, param3:uint = 12, param4:uint = 16777215, param5:Number = 1)
      {
         super(param4,param5);
         this._radius = param1;
         this._segmentsW = param2;
         this._segmentsH = param3;
      }
      
      override protected function buildGeometry() : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc7_:* = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc1_:Vector.<Number> = new Vector.<Number>();
         var _loc2_:Vector3D = new Vector3D();
         var _loc3_:Vector3D = new Vector3D();
         var _loc6_:uint = 0;
         _loc5_ = 0;
         while(_loc5_ <= this._segmentsH)
         {
            _loc8_ = Math.PI * _loc5_ / this._segmentsH;
            _loc9_ = -this._radius * Math.cos(_loc8_);
            _loc10_ = this._radius * Math.sin(_loc8_);
            _loc4_ = 0;
            while(_loc4_ <= this._segmentsW)
            {
               _loc11_ = 2 * Math.PI * _loc4_ / this._segmentsW;
               _loc12_ = _loc10_ * Math.cos(_loc11_);
               _loc13_ = _loc10_ * Math.sin(_loc11_);
               var _loc18_:uint;
               _loc1_[_loc18_ = _loc6_++] = _loc12_;
               var _loc19_:uint;
               _loc1_[_loc19_ = _loc6_++] = -_loc9_;
               var _loc20_:uint;
               _loc1_[_loc20_ = _loc6_++] = _loc13_;
               _loc4_++;
            }
            _loc5_++;
         }
         _loc5_ = 1;
         while(_loc5_ <= this._segmentsH)
         {
            _loc4_ = 1;
            while(_loc4_ <= this._segmentsW)
            {
               _loc14_ = ((this._segmentsW + 1) * _loc5_ + _loc4_) * 3;
               _loc15_ = ((this._segmentsW + 1) * _loc5_ + _loc4_ - 1) * 3;
               _loc16_ = ((this._segmentsW + 1) * (_loc5_ - 1) + _loc4_ - 1) * 3;
               _loc17_ = ((this._segmentsW + 1) * (_loc5_ - 1) + _loc4_) * 3;
               if(_loc5_ == this._segmentsH)
               {
                  _loc2_.x = _loc1_[_loc16_];
                  _loc2_.y = _loc1_[_loc16_ + 1];
                  _loc2_.z = _loc1_[_loc16_ + 2];
                  _loc3_.x = _loc1_[_loc17_];
                  _loc3_.y = _loc1_[_loc17_ + 1];
                  _loc3_.z = _loc1_[_loc17_ + 2];
                  updateOrAddSegment(_loc7_++,_loc2_,_loc3_);
                  _loc2_.x = _loc1_[_loc14_];
                  _loc2_.y = _loc1_[_loc14_ + 1];
                  _loc2_.z = _loc1_[_loc14_ + 2];
                  updateOrAddSegment(_loc7_++,_loc2_,_loc3_);
               }
               else if(_loc5_ == 1)
               {
                  _loc3_.x = _loc1_[_loc15_];
                  _loc3_.y = _loc1_[_loc15_ + 1];
                  _loc3_.z = _loc1_[_loc15_ + 2];
                  _loc2_.x = _loc1_[_loc16_];
                  _loc2_.y = _loc1_[_loc16_ + 1];
                  _loc2_.z = _loc1_[_loc16_ + 2];
                  updateOrAddSegment(_loc7_++,_loc2_,_loc3_);
               }
               else
               {
                  _loc3_.x = _loc1_[_loc15_];
                  _loc3_.y = _loc1_[_loc15_ + 1];
                  _loc3_.z = _loc1_[_loc15_ + 2];
                  _loc2_.x = _loc1_[_loc16_];
                  _loc2_.y = _loc1_[_loc16_ + 1];
                  _loc2_.z = _loc1_[_loc16_ + 2];
                  updateOrAddSegment(_loc7_++,_loc2_,_loc3_);
                  _loc3_.x = _loc1_[_loc17_];
                  _loc3_.y = _loc1_[_loc17_ + 1];
                  _loc3_.z = _loc1_[_loc17_ + 2];
                  updateOrAddSegment(_loc7_++,_loc2_,_loc3_);
               }
               _loc4_++;
            }
            _loc5_++;
         }
      }
   }
}

