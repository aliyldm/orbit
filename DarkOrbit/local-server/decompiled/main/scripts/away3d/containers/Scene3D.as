package away3d.containers
{
   import away3d.arcane;
   import away3d.core.partition.NodeBase;
   import away3d.core.partition.Partition3D;
   import away3d.core.traverse.PartitionTraverser;
   import away3d.entities.Entity;
   import away3d.events.Scene3DEvent;
   import flash.events.EventDispatcher;
   
   use namespace arcane;
   
   public class Scene3D extends EventDispatcher
   {
      
      arcane var _sceneGraphRoot:ObjectContainer3D;
      
      private var _partitions:Vector.<Partition3D>;
      
      public function Scene3D()
      {
         super();
         this._partitions = new Vector.<Partition3D>();
         this._sceneGraphRoot = new ObjectContainer3D();
         this._sceneGraphRoot.scene = this;
         this._sceneGraphRoot._isRoot = true;
         this._sceneGraphRoot.partition = new Partition3D(new NodeBase());
      }
      
      public function traversePartitions(param1:PartitionTraverser) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = this._partitions.length;
         param1.scene = this;
         while(_loc2_ < _loc3_)
         {
            this._partitions[_loc2_++].traverse(param1);
         }
      }
      
      public function get partition() : Partition3D
      {
         return this._sceneGraphRoot.partition;
      }
      
      public function set partition(param1:Partition3D) : void
      {
         this._sceneGraphRoot.partition = param1;
         dispatchEvent(new Scene3DEvent(Scene3DEvent.PARTITION_CHANGED,this._sceneGraphRoot));
      }
      
      public function contains(param1:ObjectContainer3D) : Boolean
      {
         return this._sceneGraphRoot.contains(param1);
      }
      
      public function addChild(param1:ObjectContainer3D) : ObjectContainer3D
      {
         return this._sceneGraphRoot.addChild(param1);
      }
      
      public function removeChild(param1:ObjectContainer3D) : void
      {
         this._sceneGraphRoot.removeChild(param1);
      }
      
      public function removeChildAt(param1:uint) : void
      {
         this._sceneGraphRoot.removeChildAt(param1);
      }
      
      public function getChildAt(param1:uint) : ObjectContainer3D
      {
         return this._sceneGraphRoot.getChildAt(param1);
      }
      
      public function get numChildren() : uint
      {
         return this._sceneGraphRoot.numChildren;
      }
      
      arcane function registerEntity(param1:Entity) : void
      {
         var _loc2_:Partition3D = param1.implicitPartition;
         this.addPartitionUnique(_loc2_);
         _loc2_.markForUpdate(param1);
      }
      
      arcane function unregisterEntity(param1:Entity) : void
      {
         param1.implicitPartition.removeEntity(param1);
      }
      
      arcane function invalidateEntityBounds(param1:Entity) : void
      {
         param1.implicitPartition.markForUpdate(param1);
      }
      
      arcane function registerPartition(param1:Entity) : void
      {
         this.addPartitionUnique(param1.implicitPartition);
      }
      
      arcane function unregisterPartition(param1:Entity) : void
      {
         param1.implicitPartition.removeEntity(param1);
      }
      
      protected function addPartitionUnique(param1:Partition3D) : void
      {
         if(this._partitions.indexOf(param1) == -1)
         {
            this._partitions.push(param1);
         }
      }
   }
}

