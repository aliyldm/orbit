package net.bigpoint.darkorbit.map.model.poizones.polygon
{
   import com.bigpoint.utils.PointLite;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   
   public class PoligonZone extends POIZone
   {
      
      private static const MAGIC_BORDER_SIZE:int = 512;
      
      private var _points:Vector.<PointLite>;
      
      private var _collisionPoints:Vector.<PointLite> = new Vector.<PointLite>(0);
      
      private var _center:* = new PointLite();
      
      private var _collisionBounds:Rectangle;
      
      public function PoligonZone(param1:int, param2:String, param3:Vector.<PointLite>, param4:Boolean, param5:int, param6:String = null)
      {
         var _loc11_:PointLite = null;
         this._points = param3;
         if(!this.isClockwise())
         {
            this._points = this._points.reverse();
         }
         this.createCenter();
         this.scalePoints(param6);
         var _loc7_:Number;
         var _loc8_:Number = _loc7_ = param3[0].x;
         var _loc9_:Number;
         var _loc10_:Number = _loc9_ = param3[0].y;
         var _loc12_:int = 1;
         while(_loc12_ < param3.length)
         {
            _loc11_ = param3[_loc12_];
            _loc7_ = Math.min(_loc7_,_loc11_.x);
            _loc8_ = Math.max(_loc8_,_loc11_.x);
            _loc9_ = Math.min(_loc9_,_loc11_.y);
            _loc10_ = Math.max(_loc10_,_loc11_.y);
            _loc12_++;
         }
         var _loc13_:int = param4 ? int(-COLLISION_OFFSET) : COLLISION_OFFSET;
         this._collisionBounds = new Rectangle(_loc7_ - _loc13_,_loc9_ - _loc13_,_loc8_ + _loc13_,_loc10_ + _loc13_);
         super(param1,new PointLite(_loc7_,_loc9_),param2,param4,param5,new Rectangle(_loc7_,_loc9_,_loc8_,_loc10_),param6);
         if(param5 > 0)
         {
            addTrait(new PoligonZoneDisplayTrait());
         }
         if(param2 == POIZone.ZONE_TYPE_NOA || param2 == POIZone.ZONE_TYPE_CAMERA_ZONE)
         {
            if(param4)
            {
               borderSize.value = MAGIC_BORDER_SIZE;
            }
            addTrait(new PoligonZoneCollisionAreaTrait());
         }
         if(visibleOnMinimap())
         {
            addTrait(new PoligonZoneMinimapTrait());
         }
      }
      
      private function scalePoints(param1:String = null) : void
      {
         var _loc4_:PointLite = null;
         var _loc5_:PointLite = null;
         var _loc6_:PointLite = null;
         var _loc7_:PointLite = null;
         var _loc2_:int = int(this._points.length);
         this._collisionPoints.length = _loc2_;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._points[_loc3_];
            _loc5_ = _loc3_ == 0 ? this._points[_loc2_ - 1] : this._points[_loc3_ - 1];
            _loc6_ = _loc3_ == _loc2_ - 1 ? this._points[0] : this._points[_loc3_ + 1];
            if(_loc4_.equals(_loc5_) || _loc4_.equals(_loc6_))
            {
               this._collisionPoints[_loc3_] = _loc4_.clone();
            }
            else
            {
               _loc5_ = _loc5_.subtract(_loc4_);
               _loc6_ = _loc4_.subtract(_loc6_);
               _loc5_ = this.getNormal(_loc5_);
               _loc6_ = this.getNormal(_loc6_);
               _loc5_.normalize();
               _loc6_.normalize();
               _loc7_ = _loc6_.add(_loc5_);
               _loc7_.normalize(COLLISION_OFFSET);
               this._collisionPoints[_loc3_] = this._points[_loc3_].add(_loc7_);
            }
            _loc3_++;
         }
      }
      
      private function getNormal(param1:PointLite) : PointLite
      {
         return new PointLite(-param1.y,param1.x);
      }
      
      public function isClockwise() : Boolean
      {
         var _loc3_:PointLite = null;
         var _loc6_:PointLite = null;
         var _loc1_:Number = 0;
         var _loc2_:int = int(this._points.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc6_ = this._points[_loc4_];
            _loc3_ = this._points[(_loc4_ + 1) % _loc2_];
            _loc1_ += (_loc3_.x - _loc6_.x) * (_loc3_.y + _loc6_.y);
            _loc4_++;
         }
         return _loc1_ <= 0;
      }
      
      private function createCenter() : void
      {
         var _loc5_:PointLite = null;
         var _loc1_:int = int(this._points.length);
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc1_)
         {
            _loc5_ = this._points[_loc4_];
            _loc2_ += _loc5_.x;
            _loc3_ += _loc5_.y;
            _loc4_++;
         }
         this._center.x = _loc2_ / _loc1_;
         this._center.y = _loc3_ / _loc1_;
      }
      
      public function get points() : Vector.<PointLite>
      {
         return this._points;
      }
      
      public function get center() : *
      {
         return this._center;
      }
      
      public function get collisionPoints() : Vector.<PointLite>
      {
         return this._collisionPoints;
      }
      
      public function get collisionBounds() : Rectangle
      {
         return this._collisionBounds;
      }
   }
}

