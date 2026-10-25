package net.bigpoint.darkorbit.pattern
{
   public class PlanetPattern extends ResourcePattern
   {
      
      private var _radius:int;
      
      private var _typeID:String;
      
      public function PlanetPattern(param1:String, param2:String, param3:int)
      {
         super(0,param2);
         this._typeID = param1;
         this._radius = param3;
      }
      
      public function get radius() : int
      {
         return this._radius;
      }
      
      public function get typeID() : String
      {
         return this._typeID;
      }
   }
}

