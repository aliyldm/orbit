package net.bigpoint.darkorbit.map.view3D.display3D
{
   import away3d.arcane;
   import away3d.containers.Scene3D;
   import away3d.core.data.EntityListItem;
   import away3d.core.pick.*;
   import away3d.core.traverse.RaycastCollector;
   import away3d.entities.Entity;
   import away3d.entities.Mesh;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.prefab.PrefabView3D;
   
   use namespace arcane;
   
   public class DORaycastPicker
   {
      
      protected var _entities:Vector.<Entity>;
      
      protected var _numEntities:uint;
      
      protected var _hasCollisions:Boolean;
      
      private var _raycastCollector:RaycastCollector = new RaycastCollector();
      
      public function DORaycastPicker()
      {
         super();
         this._entities = new Vector.<Entity>();
      }
      
      public function getSceneCollision(param1:Vector3D, param2:Vector3D, param3:Scene3D) : PickingCollisionVO
      {
         var _loc5_:Entity = null;
         this._raycastCollector.clear();
         this._raycastCollector.rayPosition = param1;
         this._raycastCollector.rayDirection = param2;
         param3.traversePartitions(this._raycastCollector);
         this._numEntities = 0;
         var _loc4_:EntityListItem = this._raycastCollector.entityHead;
         while(_loc4_)
         {
            _loc5_ = _loc4_.entity;
            if(_loc5_ is Mesh && Mesh(_loc5_).parent is PrefabView3D)
            {
               var _loc6_:Number;
               this._entities[_loc6_ = this._numEntities++] = _loc5_;
            }
            _loc4_ = _loc4_.next;
         }
         if(!this._numEntities)
         {
            return null;
         }
         return this.getPickingCollisionVO();
      }
      
      public function dispose() : void
      {
      }
      
      private function getPickingCollisionVO() : PickingCollisionVO
      {
         var _loc2_:PickingCollisionVO = null;
         var _loc3_:PickingCollisionVO = null;
         var _loc4_:Entity = null;
         var _loc5_:uint = 0;
         this._entities.length = this._numEntities;
         var _loc1_:Number = Number.MAX_VALUE;
         _loc5_ = 0;
         while(_loc5_ < this._numEntities)
         {
            _loc4_ = this._entities[_loc5_];
            _loc3_ = _loc4_._pickingCollisionVO;
            if(_loc4_.pickingCollider)
            {
               if((_loc2_ == null || _loc3_.rayEntryDistance < _loc2_.rayEntryDistance) && _loc4_.collidesBefore(_loc1_,false))
               {
                  _loc1_ = _loc3_.rayEntryDistance;
                  _loc2_ = _loc3_;
                  this.updateLocalPosition(_loc3_);
                  return _loc3_;
               }
            }
            else if(_loc2_ == null || _loc3_.rayEntryDistance < _loc2_.rayEntryDistance)
            {
               if(!_loc3_.rayOriginIsInsideBounds)
               {
                  this.updateLocalPosition(_loc3_);
                  return _loc3_;
               }
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      private function updateLocalPosition(param1:PickingCollisionVO) : void
      {
         var _loc2_:Vector3D = param1.localPosition = param1.localPosition || new Vector3D();
         var _loc3_:Vector3D = param1.localRayDirection;
         var _loc4_:Vector3D = param1.localRayPosition;
         var _loc5_:Number = param1.rayEntryDistance;
         _loc2_.x = _loc4_.x + _loc5_ * _loc3_.x;
         _loc2_.y = _loc4_.y + _loc5_ * _loc3_.y;
         _loc2_.z = _loc4_.z + _loc5_ * _loc3_.z;
      }
   }
}

