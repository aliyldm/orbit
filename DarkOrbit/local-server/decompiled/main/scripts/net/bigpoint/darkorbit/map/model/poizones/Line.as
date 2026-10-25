package net.bigpoint.darkorbit.map.model.poizones
{
   import flash.geom.Point;
   
   public class Line
   {
      
      private static const STRING5:String = "";
      
      public static const ON_SEGMENT:String = "onSegment";
      
      public static const RIGHT:String = "right";
      
      public static const LEFT:String = "left";
      
      public static const FRONT:String = "front";
      
      public static const BEHIND:String = "behind";
      
      private var _to:Point = new Point();
      
      private var _from:Point = new Point();
      
      public function Line(param1:Number, param2:Number, param3:Number, param4:Number)
      {
         super();
         this._to.y = param4;
         this._to.x = param3;
         this._from.y = param2;
         this._from.x = param1;
      }
      
      public function getNormal() : Point
      {
         return new Point(this._to.y - this._from.y,-(this._to.x - this._from.x));
      }
      
      public function whereAboutSegment(param1:Point, param2:Boolean = false) : String
      {
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Number = Point.distance(param1,this._from.add(Point.polar(1,Math.atan2(this._from.y - this._to.y,this._from.x - this._to.x) + Math.PI / 2)));
         var _loc10_:Number = Point.distance(param1,this._from.add(Point.polar(-1,Math.atan2(this._from.y - this._to.y,this._from.x - this._to.x) + Math.PI / 2)));
         _loc5_ = _loc9_ == _loc10_;
         if(_loc9_ < _loc10_)
         {
            _loc8_ = true;
         }
         _loc3_ = this._from.add(Point.polar(1,Math.atan2(this._from.y - this._to.y,this._from.x - this._to.x) + Math.PI));
         _loc4_ = this._from.add(Point.polar(-1,Math.atan2(this._from.y - this._to.y,this._from.x - this._to.x) + Math.PI));
         _loc9_ = Point.distance(param1,_loc3_.add(Point.polar(1,Math.atan2(this._from.y - this._to.y,this._from.x - this._to.x) + Math.PI)));
         _loc10_ = Point.distance(param1,_loc4_.add(Point.polar(-1,Math.atan2(this._from.y - this._to.y,this._from.x - this._to.x) + Math.PI)));
         if(_loc9_ < _loc10_)
         {
            _loc7_ = true;
         }
         _loc3_ = this._to.add(Point.polar(1,Math.atan2(this._from.y - this._to.y,this._from.x - this._to.x) + Math.PI));
         _loc4_ = this._to.add(Point.polar(-1,Math.atan2(this._from.y - this._to.y,this._from.x - this._to.x) + Math.PI));
         _loc9_ = Point.distance(param1,_loc3_.add(Point.polar(1,Math.atan2(this._from.y - this._to.y,this._from.x - this._to.x) + Math.PI)));
         _loc10_ = Point.distance(param1,_loc4_.add(Point.polar(-1,Math.atan2(this._from.y - this._to.y,this._from.x - this._to.x) + Math.PI)));
         if(_loc9_ > _loc10_)
         {
            _loc6_ = true;
         }
         if(!param2)
         {
            if(_loc5_)
            {
               return ON_SEGMENT;
            }
            return _loc8_ ? FRONT : BEHIND;
         }
         if(_loc5_ && _loc6_ && _loc7_)
         {
            return ON_SEGMENT;
         }
         if(!_loc8_ && _loc6_ && _loc7_)
         {
            return BEHIND;
         }
         if(_loc8_ && _loc6_ && _loc7_)
         {
            return FRONT;
         }
         if(_loc6_)
         {
            return LEFT;
         }
         if(_loc7_)
         {
            return RIGHT;
         }
         return STRING5;
      }
   }
}

