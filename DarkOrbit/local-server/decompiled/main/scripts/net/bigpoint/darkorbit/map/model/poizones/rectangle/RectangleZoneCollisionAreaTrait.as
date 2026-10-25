package net.bigpoint.darkorbit.map.model.poizones.rectangle
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.poizones.IPOIZoneCollisionArea;
   import net.bigpoint.darkorbit.map.model.poizones.Intersection;
   import net.bigpoint.darkorbit.map.model.poizones.Line;
   
   public class RectangleZoneCollisionAreaTrait extends EntityTraitBase implements IPOIZoneCollisionArea
   {
      
      private static const RECT:Rectangle = new Rectangle();
      
      private const intersectionsFound:Vector.<Intersection> = new Vector.<Intersection>();
      
      public function RectangleZoneCollisionAreaTrait()
      {
         super();
      }
      
      public function hitTest(param1:Point, param2:Point) : Intersection
      {
         var _loc3_:RectangleZone = owner as RectangleZone;
         var _loc4_:Boolean = this.contains(param1);
         if(_loc4_)
         {
            return null;
         }
         this.intersectionsFound.length = 0;
         this.addInnerBounds(param1,param2);
         if(_loc3_.inverted)
         {
            this.addOuterBounds(param1,param2);
         }
         if(this.intersectionsFound.length)
         {
            this.intersectionsFound.sort(Intersection.compare);
            return this.intersectionsFound[0];
         }
         return null;
      }
      
      private function addInnerBounds(param1:Point, param2:Point) : void
      {
         var _loc4_:Point = null;
         var _loc5_:Intersection = null;
         var _loc3_:RectangleZone = owner as RectangleZone;
         var _loc6_:int = _loc3_.collisionBounds.x;
         var _loc7_:int = _loc3_.collisionBounds.y;
         var _loc8_:int = _loc3_.collisionBounds.width;
         var _loc9_:int = _loc3_.collisionBounds.height;
         _loc4_ = this.lineIntersect(param1.x,param1.y,param2.x,param2.y,_loc6_,_loc7_,_loc6_ + _loc8_,_loc7_);
         if(_loc4_ != null)
         {
            _loc5_ = Intersection.fromPointAndStart(_loc4_,param1);
            _loc5_.intersectionObject = new net.bigpoint.darkorbit.map.model.poizones.Line(_loc6_,_loc7_,_loc6_ + _loc8_,_loc7_);
            this.intersectionsFound.push(_loc5_);
         }
         _loc4_ = this.lineIntersect(param1.x,param1.y,param2.x,param2.y,_loc6_ + _loc8_,_loc7_,_loc6_ + _loc8_,_loc7_ + _loc9_);
         if(_loc4_ != null)
         {
            _loc5_ = Intersection.fromPointAndStart(_loc4_,param1);
            _loc5_.intersectionObject = new net.bigpoint.darkorbit.map.model.poizones.Line(_loc6_ + _loc8_,_loc7_,_loc6_ + _loc8_,_loc7_ + _loc9_);
            this.intersectionsFound.push(_loc5_);
         }
         _loc4_ = this.lineIntersect(param1.x,param1.y,param2.x,param2.y,_loc6_ + _loc8_,_loc7_ + _loc9_,_loc6_,_loc7_ + _loc9_);
         if(_loc4_ != null)
         {
            _loc5_ = Intersection.fromPointAndStart(_loc4_,param1);
            _loc5_.intersectionObject = new net.bigpoint.darkorbit.map.model.poizones.Line(_loc6_ + _loc8_,_loc7_ + _loc9_,_loc6_,_loc7_ + _loc9_);
            this.intersectionsFound.push(_loc5_);
         }
         _loc4_ = this.lineIntersect(param1.x,param1.y,param2.x,param2.y,_loc6_,_loc7_ + _loc9_,_loc6_,_loc7_);
         if(_loc4_ != null)
         {
            _loc5_ = Intersection.fromPointAndStart(_loc4_,param1);
            _loc5_.intersectionObject = new net.bigpoint.darkorbit.map.model.poizones.Line(_loc6_,_loc7_ + _loc9_,_loc6_,_loc7_);
            this.intersectionsFound.push(_loc5_);
         }
      }
      
      private function addOuterBounds(param1:Point, param2:Point) : void
      {
         var _loc4_:Point = null;
         var _loc5_:Intersection = null;
         var _loc3_:RectangleZone = owner as RectangleZone;
         var _loc6_:int = _loc3_.borderSize.value;
         var _loc7_:int = _loc3_.collisionBounds.x - _loc6_;
         var _loc8_:int = _loc3_.collisionBounds.y - _loc6_;
         var _loc9_:int = _loc3_.collisionBounds.width + _loc6_ * 2;
         var _loc10_:int = _loc3_.collisionBounds.height + _loc6_ * 2;
         _loc4_ = this.lineIntersect(param1.x,param1.y,param2.x,param2.y,_loc7_,_loc8_,_loc7_ + _loc9_,_loc8_);
         if(_loc4_ != null)
         {
            _loc5_ = Intersection.fromPointAndStart(_loc4_,param1);
            _loc5_.intersectionObject = new net.bigpoint.darkorbit.map.model.poizones.Line(_loc7_,_loc8_,_loc7_ + _loc9_,_loc8_);
            this.intersectionsFound.push(_loc5_);
         }
         _loc4_ = this.lineIntersect(param1.x,param1.y,param2.x,param2.y,_loc7_ + _loc9_,_loc8_,_loc7_ + _loc9_,_loc8_ + _loc10_);
         if(_loc4_ != null)
         {
            _loc5_ = Intersection.fromPointAndStart(_loc4_,param1);
            _loc5_.intersectionObject = new net.bigpoint.darkorbit.map.model.poizones.Line(_loc7_ + _loc9_,_loc8_,_loc7_ + _loc9_,_loc8_ + _loc10_);
            this.intersectionsFound.push(_loc5_);
         }
         _loc4_ = this.lineIntersect(param1.x,param1.y,param2.x,param2.y,_loc7_ + _loc9_,_loc8_ + _loc10_,_loc7_,_loc8_ + _loc10_);
         if(_loc4_ != null)
         {
            _loc5_ = Intersection.fromPointAndStart(_loc4_,param1);
            _loc5_.intersectionObject = new net.bigpoint.darkorbit.map.model.poizones.Line(_loc7_ + _loc9_,_loc8_ + _loc10_,_loc7_,_loc8_ + _loc10_);
            this.intersectionsFound.push(_loc5_);
         }
         _loc4_ = this.lineIntersect(param1.x,param1.y,param2.x,param2.y,_loc7_,_loc8_ + _loc10_,_loc7_,_loc8_);
         if(_loc4_ != null)
         {
            _loc5_ = Intersection.fromPointAndStart(_loc4_,param1);
            _loc5_.intersectionObject = new net.bigpoint.darkorbit.map.model.poizones.Line(_loc7_,_loc8_ + _loc10_,_loc7_,_loc8_);
            this.intersectionsFound.push(_loc5_);
         }
      }
      
      private function lineIntersect(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Point
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
      
      public function contains(param1:Point) : Boolean
      {
         var _loc4_:int = 0;
         var _loc2_:RectangleZone = owner as RectangleZone;
         RECT.x = _loc2_.collisionBounds.x;
         RECT.y = _loc2_.collisionBounds.y;
         RECT.width = _loc2_.collisionBounds.width;
         RECT.height = _loc2_.collisionBounds.height;
         var _loc3_:Boolean = RECT.containsPoint(param1);
         if(_loc2_.inverted)
         {
            _loc3_ = !_loc3_;
            _loc4_ = _loc2_.borderSize.value;
            RECT.x = _loc2_.collisionBounds.x - _loc4_;
            RECT.y = _loc2_.collisionBounds.y - _loc4_;
            RECT.width = _loc2_.collisionBounds.width + _loc4_;
            RECT.height = _loc2_.collisionBounds.height + _loc4_;
            _loc3_ &&= RECT.containsPoint(param1);
         }
         return _loc3_;
      }
   }
}

