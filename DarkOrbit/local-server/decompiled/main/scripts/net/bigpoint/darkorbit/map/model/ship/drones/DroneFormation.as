package net.bigpoint.darkorbit.map.model.ship.drones
{
   import com.bigpoint.utils.PointLite;
   import flash.utils.Dictionary;
   
   public class DroneFormation
   {
      
      public static const STANDARD:int = 0;
      
      public static const TURTLE:int = 1;
      
      public static const ARROW:int = 2;
      
      public static const LANCE:int = 3;
      
      public static const STAR:int = 4;
      
      public static const PINCER:int = 5;
      
      public static const DOUBLE_ARROW:int = 6;
      
      public static const DIAMOND:int = 7;
      
      public static const CHEVRON:int = 8;
      
      public static const MOTH:int = 9;
      
      public static const CRAB:int = 10;
      
      public static const HEART:int = 11;
      
      public static const BARRAGE:int = 12;
      
      public static const BAT:int = 13;
      
      public static const MOSQUITO:int = 14;
      
      public static const X:int = 42;
      
      public static var standardFormations:Dictionary = new Dictionary(true);
      
      public static var standardFormations3D:Dictionary = new Dictionary(true);
      
      private var locations:Array = [];
      
      public var locationsByDroneCount:Array = [];
      
      public var scale:Number;
      
      public var id:int;
      
      public var name:String;
      
      public var rotationGroups:Array;
      
      public function DroneFormation(param1:Array, param2:Array, param3:Number, param4:int, param5:String)
      {
         super();
         this.locations = param1;
         this.locationsByDroneCount = param2;
         this.scale = param3;
         this.id = param4;
         this.name = param5;
      }
      
      public function positionToRelativePoint(param1:int, param2:int) : PointLite
      {
         return this.locations[this.locationsByDroneCount[param1][param2] - 1] as PointLite;
      }
   }
}

