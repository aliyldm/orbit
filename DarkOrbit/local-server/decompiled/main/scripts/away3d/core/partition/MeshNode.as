package away3d.core.partition
{
   import away3d.core.base.SubMesh;
   import away3d.core.traverse.PartitionTraverser;
   import away3d.entities.Mesh;
   
   public class MeshNode extends EntityNode
   {
      
      private var _mesh:Mesh;
      
      public function MeshNode(param1:Mesh)
      {
         super(param1);
         this._mesh = param1;
      }
      
      public function get mesh() : Mesh
      {
         return this._mesh;
      }
      
      override public function acceptTraverser(param1:PartitionTraverser) : void
      {
         var _loc2_:Vector.<SubMesh> = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param1.enterNode(this))
         {
            super.acceptTraverser(param1);
            _loc2_ = this._mesh.subMeshes;
            _loc4_ = _loc2_.length;
            while(_loc3_ < _loc4_)
            {
               param1.applyRenderable(_loc2_[_loc3_++]);
            }
         }
      }
   }
}

