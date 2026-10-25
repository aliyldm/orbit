package net.bigpoint.darkorbit.map.model.poizones.circle
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.map.model.poizones.POIZone;
   
   public class CircleZone extends POIZone
   {
      
      private static const MAGIC_BORDER_SIZE:int = 384;
      
      private var _radius:BindableInt = new BindableInt(0);
      
      private var _collisionRadius:int;
      
      public function CircleZone(param1:int, param2:String, param3:PointLite, param4:int, param5:Boolean, param6:int, param7:String = null)
      {
         super(param1,param3,param2,param5,param6,new Rectangle(param3.x - param4,param3.y - param4,param4 * 2,param4 * 2),param7);
         this._radius.value = param4;
         this._collisionRadius = param4 + (param5 ? -COLLISION_OFFSET : COLLISION_OFFSET);
         if(param6 > 0)
         {
            addTrait(new CircleZoneDisplayTrait());
         }
         if(param2 == POIZone.ZONE_TYPE_NOA || param2 == POIZone.ZONE_TYPE_CAMERA_ZONE)
         {
            if(param5)
            {
               borderSize.value = MAGIC_BORDER_SIZE;
            }
            addTrait(new CircleZoneCollisionAreaTrait());
         }
         if(visibleOnMinimap())
         {
            addTrait(new CircleZoneMinimapTrait());
         }
      }
      
      public function get radius() : BindableInt
      {
         return this._radius;
      }
      
      public function get collisionRadius() : int
      {
         return this._collisionRadius;
      }
   }
}

