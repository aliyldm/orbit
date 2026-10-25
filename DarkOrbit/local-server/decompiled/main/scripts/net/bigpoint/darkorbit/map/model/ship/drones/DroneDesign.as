package net.bigpoint.darkorbit.map.model.ship.drones
{
   import flash.utils.Dictionary;
   
   public class DroneDesign
   {
      
      private static const DESIGNS:Dictionary = new Dictionary();
      
      public static const ALL_DESIGNS:Vector.<DroneDesign> = new Vector.<DroneDesign>();
      
      private var _assetId:String;
      
      private var _color:uint;
      
      public function DroneDesign(param1:String, param2:uint)
      {
         super();
         this._assetId = param1;
         this._color = param2;
      }
      
      public static function registerDesign(param1:int, param2:DroneDesign) : void
      {
         DESIGNS[param1] = param2;
         ALL_DESIGNS.push(param2);
      }
      
      public static function getDesign(param1:int) : DroneDesign
      {
         return DESIGNS[param1] as DroneDesign;
      }
      
      public function get assetId() : String
      {
         return this._assetId;
      }
      
      public function get color() : uint
      {
         return this._color;
      }
   }
}

