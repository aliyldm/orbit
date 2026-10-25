package net.bigpoint.darkorbit.map.model.traits
{
   import com.bigpoint.utils.PointLite;
   import flash.geom.Point;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.env.collectable.CaptchaBox;
   import net.bigpoint.darkorbit.map.model.poizones.circle.CircleZone;
   
   public class BoxCaptchaTrait extends EntityTraitBase
   {
      
      private static const FAKE_HASH:String = "0123456789";
      
      private static const BLACK_BOX_TYPE:String = "POISON_PUSAT_BOX_BLACK";
      
      private static const RED_BOX_TYPE:String = "BONUS_BOX_RED";
      
      private var centerX:int;
      
      private var centerY:int;
      
      private var radius:int;
      
      private var captchaBoxes:Vector.<CaptchaBox> = new Vector.<CaptchaBox>(0);
      
      private var poiVisual:CircleZone;
      
      public function BoxCaptchaTrait(param1:int, param2:int, param3:int, param4:int, param5:int)
      {
         super();
         this.centerX = param1;
         this.centerY = param2;
         this.radius = param3;
         this.addBoxes(param4,param5);
         this.poiVisual = new CircleZone(Map.NEXT_FREE_ID,"NOA",new PointLite(param1,param2),param3 + 100,true,6);
         this.map.addEntity(this.poiVisual);
      }
      
      override public function deactivateTrait() : void
      {
         this.removeBoxes();
         this.map.removeEntity(this.poiVisual);
         super.deactivateTrait();
      }
      
      public function getBoundedPoint(param1:Point, param2:Point) : Point
      {
         var _loc3_:* = param2.x - param1.x;
         var _loc4_:* = param2.y - param1.y;
         var _loc5_:* = param1.x - this.centerX;
         var _loc6_:* = param1.y - this.centerY;
         var _loc7_:Number = _loc3_ * _loc3_ + _loc4_ * _loc4_;
         var _loc8_:Number = 2 * _loc3_ * _loc5_ + 2 * _loc4_ * _loc6_;
         var _loc9_:Number = _loc5_ * _loc5_ + _loc6_ * _loc6_ - this.radius * this.radius;
         var _loc10_:Number = _loc8_ * _loc8_ - 4 * _loc7_ * _loc9_;
         var _loc11_:Number = 2 * _loc9_ / (-1 * _loc8_ - Math.sqrt(_loc10_));
         if(_loc10_ <= 0 || _loc11_ < 0)
         {
            return param1;
         }
         if(_loc11_ > 1)
         {
            return param2;
         }
         return new Point(int(_loc3_ * _loc11_ + param1.x),int(_loc4_ * _loc11_ + param1.y));
      }
      
      private function addBoxes(param1:int, param2:int) : *
      {
         var _loc10_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:String = null;
         var _loc3_:* = param1 + param2;
         var _loc4_:Number = Math.PI / 180;
         var _loc5_:Number = Math.random() * 360 * _loc4_;
         var _loc6_:Number = 360 / _loc3_ * _loc4_;
         var _loc7_:Number = (Math.random() / 3 + 0.6) * this.radius;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc11_:int = 0;
         while(_loc11_ < _loc3_)
         {
            _loc12_ = Math.floor(Math.random() * (param1 + param2));
            _loc13_ = this.centerX + Math.sin(_loc5_) * _loc7_;
            _loc14_ = this.centerY + Math.cos(_loc5_) * _loc7_;
            _loc15_ = _loc12_ < param1 ? BLACK_BOX_TYPE : RED_BOX_TYPE;
            if(_loc15_ == BLACK_BOX_TYPE)
            {
               param1--;
               _loc10_ = ++_loc8_ - 1;
            }
            else
            {
               param2--;
               _loc9_++;
               _loc10_ = _loc3_ - _loc9_;
            }
            this.captchaBoxes[_loc11_] = new CaptchaBox(_loc15_,FAKE_HASH,_loc13_,_loc14_,true,_loc10_);
            this.map.addEntity(this.captchaBoxes[_loc11_]);
            _loc5_ += _loc6_;
            _loc11_++;
         }
      }
      
      private function removeBoxes() : *
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.captchaBoxes.length)
         {
            if(!this.captchaBoxes[_loc1_].isCollected)
            {
               this.map.removeEntity(this.captchaBoxes[_loc1_]);
            }
            _loc1_++;
         }
      }
      
      public function removeBox(param1:CaptchaBox) : *
      {
         this.captchaBoxes.splice(this.captchaBoxes.indexOf(param1),1);
         this.map.removeEntity(param1);
      }
      
      private function get map() : Map
      {
         return ScreenManager.getInstance().map;
      }
   }
}

