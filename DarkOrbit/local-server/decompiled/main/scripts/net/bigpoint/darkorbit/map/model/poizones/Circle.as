package net.bigpoint.darkorbit.map.model.poizones
{
   import flash.geom.Point;
   
   public class Circle
   {
      
      private var _position:Point;
      
      private var _radius:int;
      
      private var _inverted:Boolean;
      
      public function Circle(param1:Point, param2:int, param3:Boolean)
      {
         super();
         this._inverted = param3;
         this._radius = param2;
         this._position = param1;
      }
      
      public function get position() : Point
      {
         return this._position;
      }
      
      public function get radius() : int
      {
         return this._radius;
      }
      
      public function getNormalOfPoint(param1:Point, param2:Boolean = true) : Point
      {
         return param2 ? this._position.subtract(param1) : param1.subtract(this._position);
      }
      
      public function get inverted() : Boolean
      {
         return this._inverted;
      }
   }
}

