package away3d.core.pick
{
   import away3d.core.base.SubMesh;
   import flash.geom.Vector3D;
   
   public class AutoPickingCollider implements IPickingCollider
   {
      
      private var _pbPickingCollider:PBPickingCollider;
      
      private var _as3PickingCollider:AS3PickingCollider;
      
      private var _activePickingCollider:IPickingCollider;
      
      public var triangleThreshold:uint = 1024;
      
      public function AutoPickingCollider(param1:Boolean = false)
      {
         super();
         this._as3PickingCollider = new AS3PickingCollider(param1);
         this._pbPickingCollider = new PBPickingCollider(param1);
      }
      
      public function setLocalRay(param1:Vector3D, param2:Vector3D) : void
      {
         this._as3PickingCollider.setLocalRay(param1,param2);
         this._pbPickingCollider.setLocalRay(param1,param2);
      }
      
      public function testSubMeshCollision(param1:SubMesh, param2:PickingCollisionVO, param3:Number) : Boolean
      {
         this._activePickingCollider = param1.numTriangles > this.triangleThreshold ? this._pbPickingCollider : this._as3PickingCollider;
         return this._activePickingCollider.testSubMeshCollision(param1,param2,param3);
      }
   }
}

