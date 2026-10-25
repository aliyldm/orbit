package net.bigpoint.darkorbit.map.model.poizones.polygon
{
   import com.bigpoint.utils.PointLite;
   import flash.geom.Point;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.poizones.IPOIZoneCollisionArea;
   import net.bigpoint.darkorbit.map.model.poizones.Intersection;
   import net.bigpoint.darkorbit.map.model.poizones.Line;
   
   public class PoligonZoneCollisionAreaTrait extends EntityTraitBase implements IPOIZoneCollisionArea
   {
      
      private var _active:Boolean = false;
      
      public function PoligonZoneCollisionAreaTrait(param1:Boolean = true)
      {
         super();
         this._active = param1;
      }
      
      public function hitTest(param1:Point, param2:Point) : Intersection
      {
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc14_:Intersection = null;
         var _loc3_:PoligonZone = owner as PoligonZone;
         var _loc4_:int = 1;
         var _loc5_:int = 1;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:PoliResult = new PoliResult();
         var _loc12_:Vector.<Point> = this.copy(_loc3_.collisionPoints);
         _loc12_.push(_loc12_[0]);
         _loc11_.intersects = false;
         _loc11_.start_inside = false;
         _loc11_.end_inside = false;
         var _loc13_:* = int(_loc12_.length - 1);
         while(_loc13_ > -1)
         {
            _loc6_ = Point(_loc12_[_loc13_]);
            if(_loc13_ > 0)
            {
               _loc9_ += _loc6_.x;
               _loc10_ += _loc6_.y;
               _loc7_ = Point(_loc12_[_loc13_ - 1]) || Point(_loc12_[0]);
               _loc8_ = Intersection.lineIntersectPoints(param1,param2,_loc6_,_loc7_);
               if(_loc8_ != null)
               {
                  _loc14_ = Intersection.fromPointAndStart(_loc8_,param1);
                  _loc14_.intersectionObject = new net.bigpoint.darkorbit.map.model.poizones.Line(_loc6_.x,_loc6_.y,_loc7_.x,_loc7_.y);
                  _loc11_.intersections.push(_loc14_);
               }
               if(Intersection.lineIntersectPoints(param1,new Point(_loc6_.x + _loc7_.x,param1.y),_loc6_,_loc7_) != null)
               {
                  _loc4_++;
               }
               if(Intersection.lineIntersectPoints(param2,new Point(_loc6_.x + _loc7_.x,param2.y),_loc6_,_loc7_) != null)
               {
                  _loc5_++;
               }
            }
            _loc13_--;
         }
         if(_loc4_ % 2 == 0)
         {
            _loc11_.start_inside = true;
         }
         if(_loc5_ % 2 == 0)
         {
            _loc11_.end_inside = true;
         }
         _loc11_.centroid = new Point(_loc9_ / (_loc12_.length - 1),_loc10_ / (_loc12_.length - 1));
         _loc11_.intersects = _loc11_.intersections.length > 0;
         if(_loc11_.intersections.length)
         {
            _loc11_.intersections.sort(Intersection.compare);
            return _loc11_.intersections[0];
         }
         return null;
      }
      
      private function copy(param1:Vector.<PointLite>) : Vector.<Point>
      {
         var _loc2_:int = int(param1.length);
         var _loc3_:Vector.<Point> = new Vector.<Point>(_loc2_);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_[_loc4_] = param1[_loc4_].toPoint();
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function contains(param1:Point) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:PointLite = null;
         var _loc8_:PointLite = null;
         var _loc2_:PoligonZone = owner as PoligonZone;
         if(!_loc2_.collisionBounds.contains(param1.x,param1.y))
         {
            return false;
         }
         var _loc3_:Vector.<PointLite> = _loc2_.collisionPoints;
         var _loc4_:int = 0;
         _loc7_ = _loc3_[0];
         var _loc9_:uint = _loc3_.length;
         _loc5_ = 1;
         while(_loc5_ <= _loc9_)
         {
            _loc8_ = _loc3_[_loc5_ % _loc9_];
            if(param1.y > Math.min(_loc7_.y,_loc8_.y))
            {
               if(param1.y < Math.max(_loc7_.y,_loc8_.y))
               {
                  if(param1.x < Math.max(_loc7_.x,_loc8_.x))
                  {
                     if(_loc7_.y != _loc8_.y)
                     {
                        _loc6_ = (param1.y - _loc7_.y) * (_loc8_.x - _loc7_.x) / (_loc8_.y - _loc7_.y) + _loc7_.x;
                        if(_loc7_.x == _loc8_.x || param1.x < _loc6_)
                        {
                           _loc4_++;
                        }
                     }
                  }
               }
            }
            _loc7_ = _loc8_;
            _loc5_++;
         }
         var _loc10_:Boolean = _loc4_ % 2 != 0;
         return _loc2_.inverted ? !_loc10_ : _loc10_;
      }
      
      private function internalontaines(param1:Point) : *
      {
      }
      
      public function get isActive() : Boolean
      {
         return this._active;
      }
   }
}

import flash.geom.Point;
import net.bigpoint.darkorbit.map.model.poizones.Intersection;

class PoliResult
{
   
   public var intersects:Boolean;
   
   public var intersections:Vector.<Intersection> = new Vector.<Intersection>();
   
   public var start_inside:Boolean;
   
   public var end_inside:Boolean;
   
   public var centroid:Point;
   
   public function PoliResult()
   {
      super();
   }
}
