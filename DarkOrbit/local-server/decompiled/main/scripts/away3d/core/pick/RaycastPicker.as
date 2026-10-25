package away3d.core.pick
{
   import away3d.arcane;
   import away3d.containers.Scene3D;
   import away3d.containers.View3D;
   import away3d.core.data.EntityListItem;
   import away3d.core.traverse.EntityCollector;
   import away3d.core.traverse.RaycastCollector;
   import away3d.entities.Entity;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class RaycastPicker implements IPicker
   {
      
      private static const tempRayPosition:Vector3D = new Vector3D();
      
      private static const tempRayDirection:Vector3D = new Vector3D();
      
      private var _findClosestCollision:Boolean;
      
      private var _raycastCollector:RaycastCollector = new RaycastCollector();
      
      private var _ignoredEntities:Array = new Array();
      
      private var _onlyMouseEnabled:Boolean = true;
      
      protected var _entities:Vector.<Entity>;
      
      protected var _numEntities:uint;
      
      protected var _hasCollisions:Boolean;
      
      public function RaycastPicker(param1:Boolean)
      {
         super();
         this._findClosestCollision = param1;
         this._entities = new Vector.<Entity>();
      }
      
      public function get onlyMouseEnabled() : Boolean
      {
         return this._onlyMouseEnabled;
      }
      
      public function set onlyMouseEnabled(param1:Boolean) : void
      {
         this._onlyMouseEnabled = param1;
      }
      
      public function getViewCollision(param1:Number, param2:Number, param3:View3D) : PickingCollisionVO
      {
         var _loc8_:Entity = null;
         var _loc4_:EntityCollector = param3.entityCollector;
         if(_loc4_.numMouseEnableds == 0)
         {
            return null;
         }
         var _loc5_:Vector3D = param3.unproject(param1,param2,0,tempRayPosition);
         var _loc6_:Vector3D = param3.unproject(param1,param2,1,tempRayDirection);
         _loc6_.x -= _loc5_.x;
         _loc6_.y -= _loc5_.y;
         _loc6_.z -= _loc5_.z;
         this._numEntities = 0;
         var _loc7_:EntityListItem = _loc4_.entityHead;
         while(_loc7_)
         {
            _loc8_ = _loc7_.entity;
            if(this.isIgnored(_loc8_))
            {
               _loc7_ = _loc7_.next;
            }
            else
            {
               if(_loc8_.isVisible && _loc8_.isIntersectingRay(_loc5_,_loc6_))
               {
                  var _loc9_:Number;
                  this._entities[_loc9_ = this._numEntities++] = _loc8_;
               }
               _loc7_ = _loc7_.next;
            }
         }
         if(!this._numEntities)
         {
            return null;
         }
         return this.getPickingCollisionVO();
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
            if(this.isIgnored(_loc5_))
            {
               _loc4_ = _loc4_.next;
            }
            else
            {
               var _loc6_:Number;
               this._entities[_loc6_ = this._numEntities++] = _loc5_;
               _loc4_ = _loc4_.next;
            }
         }
         if(!this._numEntities)
         {
            return null;
         }
         return this.getPickingCollisionVO();
      }
      
      public function getEntityCollision(param1:Vector3D, param2:Vector3D, param3:Vector.<Entity>) : PickingCollisionVO
      {
         var _loc4_:Entity = null;
         param1 = param1;
         param2 = param2;
         this._numEntities = 0;
         for each(_loc4_ in param3)
         {
            if(_loc4_.isIntersectingRay(param1,param2))
            {
               var _loc7_:Number;
               this._entities[_loc7_ = this._numEntities++] = _loc4_;
            }
         }
         return this.getPickingCollisionVO();
      }
      
      public function setIgnoreList(param1:Array) : void
      {
         this._ignoredEntities = param1;
      }
      
      private function isIgnored(param1:Entity) : Boolean
      {
         var _loc2_:Entity = null;
         if(this._onlyMouseEnabled && (!param1._ancestorsAllowMouseEnabled || !param1.mouseEnabled))
         {
            return true;
         }
         for each(_loc2_ in this._ignoredEntities)
         {
            if(_loc2_ == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function sortOnNearT(param1:Entity, param2:Entity) : Number
      {
         return param1.pickingCollisionVO.rayEntryDistance > param2.pickingCollisionVO.rayEntryDistance ? 1 : -1;
      }
      
      private function getPickingCollisionVO() : PickingCollisionVO
      {
         var _loc2_:PickingCollisionVO = null;
         var _loc3_:PickingCollisionVO = null;
         var _loc4_:Entity = null;
         var _loc5_:uint = 0;
         this._entities.length = this._numEntities;
         this._entities = this._entities.sort(this.sortOnNearT);
         var _loc1_:Number = Number.MAX_VALUE;
         _loc5_ = 0;
         while(_loc5_ < this._numEntities)
         {
            _loc4_ = this._entities[_loc5_];
            _loc3_ = _loc4_._pickingCollisionVO;
            if(_loc4_.pickingCollider)
            {
               if((_loc2_ == null || _loc3_.rayEntryDistance < _loc2_.rayEntryDistance) && _loc4_.collidesBefore(_loc1_,this._findClosestCollision))
               {
                  _loc1_ = _loc3_.rayEntryDistance;
                  _loc2_ = _loc3_;
                  if(!this._findClosestCollision)
                  {
                     this.updateLocalPosition(_loc3_);
                     return _loc3_;
                  }
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
      
      public function dispose() : void
      {
      }
   }
}

