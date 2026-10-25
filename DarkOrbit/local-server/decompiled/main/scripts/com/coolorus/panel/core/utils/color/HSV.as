package com.coolorus.panel.core.utils.color
{
   public class HSV extends ColorBase implements IColor
   {
      
      private var _h:Number;
      
      private var _s:Number;
      
      private var _v:Number;
      
      public function HSV(param1:Number = 0, param2:Number = 1, param3:Number = 1)
      {
         this._h = param1 % 360;
         this._s = Math.max(0,Math.min(param2,1));
         this._v = Math.max(0,Math.min(param3,1));
         super();
      }
      
      public static function fromRawColor(param1:uint) : HSV
      {
         var _loc2_:HSV = new HSV();
         _loc2_.rawColor = param1;
         return _loc2_;
      }
      
      public function get h() : Number
      {
         return this._h;
      }
      
      public function get s() : Number
      {
         return this._s;
      }
      
      public function get v() : Number
      {
         return this._v;
      }
      
      public function set h(param1:Number) : void
      {
         param1 %= 360;
         if(this._h != param1)
         {
            this._h = param1;
            componentChanged();
         }
      }
      
      public function set s(param1:Number) : void
      {
         if(this._s != param1)
         {
            this._s = param1;
            componentChanged();
         }
      }
      
      public function set v(param1:Number) : void
      {
         if(this._v != param1)
         {
            this._v = param1;
            componentChanged();
         }
      }
      
      public function setComponents(param1:Number, param2:Number, param3:Number) : void
      {
         param1 %= 360;
         param2 = Math.max(0,Math.min(param2,1));
         param3 = Math.max(0,Math.min(param3,1));
         if(this._h != param1 || this._s != param2 || this._v != param3)
         {
            this._h = param1;
            this._s = param2;
            this._v = param3;
            componentChanged();
         }
      }
      
      public function clone() : IColor
      {
         return new HSV(this._h,this._s,this._v);
      }
      
      override public function copyFrom(param1:IColor, param2:Boolean = true) : void
      {
         if(param1 is HSV)
         {
            if(param2)
            {
               this.alpha = param1.alpha;
            }
            this.setComponents(HSV(param1).h,HSV(param1).s,HSV(param1).v);
         }
         else
         {
            super.copyFrom(param1,param2);
         }
      }
      
      override protected function updateComponents() : void
      {
         var _loc1_:uint = uint(rawColor >> 16 & 0xFF);
         var _loc2_:uint = uint(rawColor >> 8 & 0xFF);
         var _loc3_:uint = uint(rawColor >> 0 & 0xFF);
         var _loc4_:uint = Math.min(_loc1_,_loc2_,_loc3_);
         var _loc5_:uint = Math.max(_loc1_,_loc2_,_loc3_);
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         if(_loc4_ != _loc5_)
         {
            if(_loc1_ == _loc4_)
            {
               _loc6_ = _loc2_ - _loc3_;
               _loc7_ = 3;
            }
            else if(_loc2_ == _loc4_)
            {
               _loc6_ = _loc3_ - _loc1_;
               _loc7_ = 5;
            }
            else
            {
               _loc6_ = _loc1_ - _loc2_;
               _loc7_ = 1;
            }
         }
         this._h = (_loc7_ - _loc6_ / (_loc5_ - _loc4_)) * 60 % 360 || 0;
         this._s = (_loc5_ - _loc4_) / _loc5_ || 0;
         this._v = _loc5_ / 255;
      }
      
      override protected function calculateRawColor() : uint
      {
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         if(this.v == 1 && this.s == 0)
         {
            _loc1_ = 1;
            _loc2_ = 1;
            _loc3_ = 1;
         }
         else if(this.v != 0)
         {
            _loc4_ = this.h / 60;
            _loc5_ = int(_loc4_);
            _loc6_ = _loc4_ - _loc5_;
            _loc7_ = this.v * (1 - this.s);
            _loc8_ = this.v * (1 - this.s * _loc6_);
            _loc9_ = this.v * (1 - this.s * (1 - _loc6_));
            if(_loc5_ == 0)
            {
               _loc1_ = this.v;
               _loc2_ = _loc9_;
               _loc3_ = _loc7_;
            }
            else if(_loc5_ == 1)
            {
               _loc1_ = _loc8_;
               _loc2_ = this.v;
               _loc3_ = _loc7_;
            }
            else if(_loc5_ == 2)
            {
               _loc1_ = _loc7_;
               _loc2_ = this.v;
               _loc3_ = _loc9_;
            }
            else if(_loc5_ == 3)
            {
               _loc1_ = _loc7_;
               _loc2_ = _loc8_;
               _loc3_ = this.v;
            }
            else if(_loc5_ == 4)
            {
               _loc1_ = _loc9_;
               _loc2_ = _loc7_;
               _loc3_ = this.v;
            }
            else if(_loc5_ == 5)
            {
               _loc1_ = this.v;
               _loc2_ = _loc7_;
               _loc3_ = _loc8_;
            }
         }
         return _loc1_ * 255 << 16 | _loc2_ * 255 << 8 | _loc3_ * 255;
      }
   }
}

