package net.bigpoint.darkorbit.map.model.poizones.rectangle
{
   import com.bigpoint.utils.PointLite;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   
   public class RectangleZone extends POIZone
   {
      
      private static const MAGIC_BORDER_SIZE:int = 512;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _points:Vector.<PointLite>;
      
      private var _collisionBounds:Rectangle;
      
      public function RectangleZone(param1:int, param2:String, param3:Vector.<PointLite>, param4:Boolean, param5:int, param6:String = null)
      {
         var _loc11_:PointLite = null;
         this._points = param3;
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
         this._width = Math.abs(_loc7_ - _loc8_);
         this._height = Math.abs(_loc9_ - _loc10_);
         var _loc13_:int = param4 ? int(-COLLISION_OFFSET) : COLLISION_OFFSET;
         this._collisionBounds = new Rectangle(_loc7_ - _loc13_,_loc9_ - _loc13_,this._width + _loc13_ * 2,this._height + _loc13_ * 2);
         super(param1,new PointLite(_loc7_,_loc9_),param2,param4,param5,new Rectangle(_loc7_,_loc9_,this._width,this._height),param6);
         if(param5 > 0)
         {
            addTrait(new RectangleZoneDisplayTrait());
         }
         if(param2 == POIZone.ZONE_TYPE_NOA || param2 == POIZone.ZONE_TYPE_CAMERA_ZONE)
         {
            if(param4)
            {
               borderSize.value = MAGIC_BORDER_SIZE;
            }
            addTrait(new RectangleZoneCollisionAreaTrait());
         }
         if(visibleOnMinimap())
         {
            addTrait(new RectangleZoneMinimapTrait());
         }
      }
      
      private function getNormal(param1:PointLite) : PointLite
      {
         return new PointLite(-param1.y,param1.x);
      }
      
      public function get width() : Number
      {
         return this._width;
      }
      
      public function get height() : Number
      {
         return this._height;
      }
      
      public function get points() : Vector.<PointLite>
      {
         return this._points;
      }
      
      public function get collisionBounds() : Rectangle
      {
         return this._collisionBounds;
      }
   }
}

