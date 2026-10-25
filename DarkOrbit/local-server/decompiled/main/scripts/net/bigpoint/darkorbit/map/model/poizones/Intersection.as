package net.bigpoint.darkorbit.map.model.poizones
{
   import flash.geom.Point;
   
   public class Intersection extends Point
   {
      
      private var _distance:Number;
      
      public var intersectionObject:Object;
      
      public function Intersection(param1:Number, param2:Number, param3:Number)
      {
         super(param1,param2);
         this._distance = param3;
      }
      
      public static function compare(param1:Intersection, param2:Intersection) : int
      {
         if(param1.distance > param2.distance)
         {
            return 1;
         }
         if(param1.distance < param2.distance)
         {
            return -1;
         }
         return 0;
      }
      
      public static function fromPointAndStart(param1:Point, param2:Point) : Intersection
      {
         return new Intersection(param1.x,param1.y,Math.pow(param2.x - param1.x,2) + Math.pow(param2.y - param1.y,2));
      }
      
      public static function lineIntersect(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Point
      {
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc9_:Number = param3 - param1;
         var _loc10_:Number = param4 - param2;
         var _loc11_:Number = param7 - param5;
         var _loc12_:Number = param8 - param6;
         var _loc13_:Number = _loc9_ * _loc12_ - _loc10_ * _loc11_;
         if(_loc13_ == 0)
         {
            return null;
         }
         _loc14_ = param5 - param1;
         _loc15_ = param6 - param2;
         _loc16_ = (_loc14_ * _loc12_ - _loc15_ * _loc11_) / _loc13_;
         if(_loc16_ < 0 || _loc16_ > 1)
         {
            return null;
         }
         _loc17_ = (_loc14_ * _loc10_ - _loc15_ * _loc9_) / _loc13_;
         if(_loc17_ < 0 || _loc17_ > 1)
         {
            return null;
         }
         return new Point(param1 + _loc9_ * _loc16_,param2 + _loc10_ * _loc16_);
      }
      
      public static function lineIntersectPoints(param1:Point, param2:Point, param3:Point, param4:Point) : Point
      {
         return lineIntersect(param1.x,param1.y,param2.x,param2.y,param3.x,param3.y,param4.x,param4.y);
      }
      
      public static function constrainPointToLine(param1:Point, param2:Point, param3:Point, param4:Boolean = false) : Point
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc5_:Point = new Point();
         _loc6_ = param3.x - param2.x;
         _loc7_ = param3.y - param2.y;
         if(_loc6_ == 0 && _loc7_ == 0)
         {
            _loc5_.x = param2.x;
            _loc5_.y = param2.y;
         }
         else
         {
            _loc8_ = ((param1.x - param2.x) * _loc6_ + (param1.y - param2.y) * _loc7_) / (_loc6_ * _loc6_ + _loc7_ * _loc7_);
            if(param4)
            {
               _loc8_ = Math.min(Math.max(0,_loc8_),1);
            }
            _loc5_.x = param2.x + _loc8_ * _loc6_;
            _loc5_.y = param2.y + _loc8_ * _loc7_;
         }
         return _loc5_;
      }
      
      public function get distance() : Number
      {
         return this._distance;
      }
   }
}

