package net.bigpoint.darkorbit.map.view3D.display3D.ship.drones
{
   import flash.geom.Vector3D;
   
   public class DroneRotationGroup
   {
      
      private var _droneIds:Array = new Array();
      
      private var _rotGroupXml:XML;
      
      private var _rotation:Vector3D = new Vector3D();
      
      public function DroneRotationGroup(param1:Array, param2:XML)
      {
         super();
         this._droneIds = param1;
         this._rotGroupXml = param2;
         this.rotation.x = Number(param2.@rotationX) || 0;
         this.rotation.y = Number(param2.@rotationY) || 0;
         this.rotation.z = Number(param2.@rotationZ) || 0;
      }
      
      public function get droneIds() : Array
      {
         return this._droneIds;
      }
      
      public function get rotGroupXml() : XML
      {
         return this._rotGroupXml;
      }
      
      public function get rotation() : Vector3D
      {
         return this._rotation;
      }
   }
}

