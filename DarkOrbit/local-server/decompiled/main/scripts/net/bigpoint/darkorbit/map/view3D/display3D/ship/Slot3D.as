package net.bigpoint.darkorbit.map.view3D.display3D.ship
{
   import away3d.entities.Mesh;
   import flash.geom.Vector3D;
   
   public class Slot3D extends Vector3D
   {
      
      private static const _tmp:Vector.<Number> = new Vector.<Number>(3,true);
      
      private var _size:Number = 1;
      
      public function Slot3D(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 1)
      {
         super(param1,param2,param3);
         this._size = param4;
      }
      
      public static function fromMesh(param1:Mesh) : Slot3D
      {
         param1.bounds.fromGeometry(param1.geometry);
         var _loc2_:Vector3D = param1.bounds.min;
         var _loc3_:Vector3D = param1.bounds.max;
         var _loc4_:Slot3D = new Slot3D(_loc2_.x + (_loc3_.x - _loc2_.x) * 0.5,_loc2_.y + (_loc3_.y - _loc2_.y) * 0.5,_loc2_.z + (_loc3_.z - _loc2_.z) * 0.5,Vector3D.distance(_loc3_,_loc2_));
         _tmp[0] = _loc4_.x;
         _tmp[1] = _loc4_.y;
         _tmp[2] = _loc4_.z;
         param1.transform.transformVectors(_tmp,_tmp);
         _loc4_.x = _tmp[0];
         _loc4_.y = _tmp[1];
         _loc4_.z = _tmp[2];
         return _loc4_;
      }
      
      public function get size() : Number
      {
         return this._size;
      }
   }
}

