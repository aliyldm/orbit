package away3d.core.partition
{
   import away3d.arcane;
   import away3d.core.math.Plane3D;
   import away3d.core.traverse.PartitionTraverser;
   import away3d.entities.Entity;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class EntityNode extends NodeBase
   {
      
      private var _entity:Entity;
      
      arcane var _updateQueueNext:EntityNode;
      
      public function EntityNode(param1:Entity)
      {
         super();
         this._entity = param1;
         arcane::_numEntities = 1;
      }
      
      public function get entity() : Entity
      {
         return this._entity;
      }
      
      override public function acceptTraverser(param1:PartitionTraverser) : void
      {
         param1.applyEntity(this._entity);
      }
      
      public function removeFromParent() : void
      {
         if(_parent)
         {
            _parent.removeNode(this);
         }
         _parent = null;
      }
      
      override public function isInFrustum(param1:Vector.<Plane3D>, param2:int) : Boolean
      {
         if(!this._entity.isVisible)
         {
            return false;
         }
         return this._entity.worldBounds.isInFrustum(param1,param2);
      }
      
      override public function isIntersectingRay(param1:Vector3D, param2:Vector3D) : Boolean
      {
         if(!this._entity.isVisible)
         {
            return false;
         }
         return this._entity.isIntersectingRay(param1,param2);
      }
   }
}

