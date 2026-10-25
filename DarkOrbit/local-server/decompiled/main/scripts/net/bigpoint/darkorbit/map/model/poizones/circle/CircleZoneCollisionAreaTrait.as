package net.bigpoint.darkorbit.map.model.poizones.circle
{
   import com.bigpoint.utils.PointLite;
   import flash.geom.Point;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.poizones.Circle;
   import net.bigpoint.darkorbit.map.model.poizones.IPOIZoneCollisionArea;
   import net.bigpoint.darkorbit.map.model.poizones.Intersection;
   
   public class CircleZoneCollisionAreaTrait extends EntityTraitBase implements IPOIZoneCollisionArea
   {
      
      private const tempVec:Vector.<Intersection> = new Vector.<Intersection>();
      
      public function CircleZoneCollisionAreaTrait()
      {
         super();
      }
      
      public function hitTest(param1:Point, param2:Point) : Intersection
      {
         var _loc4_:Intersection = null;
         var _loc5_:Intersection = null;
         if(this.contains(param1))
         {
            return null;
         }
         var _loc3_:CircleZone = owner as CircleZone;
         if(_loc3_.inverted)
         {
            _loc4_ = this.lineIntersectCircle(param1,param2,_loc3_.position,_loc3_.inverted,_loc3_.collisionRadius);
            if(_loc4_)
            {
               _loc4_.intersectionObject = new Circle(_loc3_.position.toPoint(),_loc3_.collisionRadius,_loc3_.inverted);
            }
            _loc5_ = this.lineIntersectCircle(param1,param2,_loc3_.position,false,_loc3_.collisionRadius + _loc3_.borderSize.value);
            if(_loc5_)
            {
               _loc5_.intersectionObject = new Circle(_loc3_.position.toPoint(),_loc3_.collisionRadius + _loc3_.borderSize.value,false);
            }
            if(Boolean(_loc4_) && Boolean(_loc5_))
            {
               this.tempVec.length = 0;
               this.tempVec.push(_loc4_,_loc5_);
               this.tempVec.sort(Intersection.compare);
               _loc4_ = this.tempVec[0];
               this.tempVec.length = 0;
            }
            else
            {
               _loc4_ = _loc5_ || _loc4_;
            }
         }
         else
         {
            _loc4_ = this.lineIntersectCircle(param1,param2,_loc3_.position,_loc3_.inverted,_loc3_.collisionRadius);
            if(_loc4_)
            {
               _loc4_.intersectionObject = new Circle(_loc3_.position.toPoint(),_loc3_.collisionRadius,_loc3_.inverted);
            }
         }
         return _loc4_;
      }
      
      private function lineIntersectCircle(param1:Point, param2:Point, param3:PointLite, param4:Boolean, param5:Number = 1) : Intersection
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc6_:Number = (param2.x - param1.x) * (param2.x - param1.x) + (param2.y - param1.y) * (param2.y - param1.y);
         var _loc7_:Number = 2 * ((param2.x - param1.x) * (param1.x - param3.x) + (param2.y - param1.y) * (param1.y - param3.y));
         var _loc8_:Number = param3.x * param3.x + param3.y * param3.y + param1.x * param1.x + param1.y * param1.y - 2 * (param3.x * param1.x + param3.y * param1.y) - param5 * param5;
         var _loc9_:Number = _loc7_ * _loc7_ - 4 * _loc6_ * _loc8_;
         if(_loc9_ <= 0)
         {
            return null;
         }
         _loc10_ = Math.sqrt(_loc9_);
         _loc11_ = (-_loc7_ + _loc10_) / (2 * _loc6_);
         _loc12_ = (-_loc7_ - _loc10_) / (2 * _loc6_);
         if(0 <= _loc12_ && _loc12_ <= 1)
         {
            return param4 ? null : Intersection.fromPointAndStart(Point.interpolate(param1,param2,1 - _loc12_),param1);
         }
         if(0 <= _loc11_ && _loc11_ <= 1)
         {
            return param4 ? Intersection.fromPointAndStart(Point.interpolate(param1,param2,1 - _loc11_),param1) : null;
         }
         return null;
      }
      
      public function contains(param1:Point) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc2_:CircleZone = owner as CircleZone;
         var _loc4_:Number = Math.pow(param1.x - _loc2_.x,2) + Math.pow(param1.y - _loc2_.y,2);
         if(_loc2_.inverted)
         {
            _loc3_ = _loc4_ > Math.pow(_loc2_.collisionRadius,2) && _loc4_ < Math.pow(_loc2_.collisionRadius + _loc2_.borderSize.value,2);
         }
         else
         {
            _loc3_ = _loc4_ < Math.pow(_loc2_.collisionRadius,2);
         }
         return _loc3_;
      }
   }
}

