package net.bigpoint.darkorbit.map.model.poizones
{
   import flash.geom.Point;
   
   public interface IPOIZoneCollisionArea
   {
      
      function hitTest(param1:Point, param2:Point) : Intersection;
      
      function contains(param1:Point) : Boolean;
   }
}

