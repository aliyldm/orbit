package away3d.core.partition
{
   import away3d.arcane;
   import away3d.core.traverse.PartitionTraverser;
   import away3d.entities.Entity;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class Partition3D
   {
      
      protected var _rootNode:NodeBase;
      
      private var _updatesMade:Boolean;
      
      private var _updateQueue:EntityNode;
      
      private var _queuedNodes:Dictionary = new Dictionary();
      
      public function Partition3D(param1:NodeBase)
      {
         super();
         this._rootNode = param1 || new NullNode();
      }
      
      public function get showDebugBounds() : Boolean
      {
         return this._rootNode.showDebugBounds;
      }
      
      public function set showDebugBounds(param1:Boolean) : void
      {
         this._rootNode.showDebugBounds = param1;
      }
      
      public function traverse(param1:PartitionTraverser) : void
      {
         this.updateEntities();
         ++PartitionTraverser._collectionMark;
         this._rootNode.acceptTraverser(param1);
      }
      
      arcane function markForUpdate(param1:Entity) : void
      {
         var _loc2_:EntityNode = param1.getEntityPartitionNode();
         if(this._queuedNodes[_loc2_])
         {
            return;
         }
         this._queuedNodes[_loc2_] = true;
         _loc2_._updateQueueNext = this._updateQueue;
         this._updateQueue = _loc2_;
         this._updatesMade = true;
      }
      
      arcane function removeEntity(param1:Entity) : void
      {
         var _loc3_:EntityNode = null;
         var _loc2_:EntityNode = param1.getEntityPartitionNode();
         _loc2_.removeFromParent();
         if(_loc2_ == this._updateQueue)
         {
            this._updateQueue = _loc2_._updateQueueNext;
         }
         else
         {
            _loc3_ = this._updateQueue;
            while(Boolean(_loc3_) && _loc3_._updateQueueNext != _loc2_)
            {
               _loc3_ = _loc3_._updateQueueNext;
            }
            if(_loc3_)
            {
               _loc3_._updateQueueNext = _loc2_._updateQueueNext;
            }
         }
         _loc2_._updateQueueNext = null;
         delete this._queuedNodes[_loc2_];
         if(!this._updateQueue)
         {
            this._updatesMade = false;
         }
      }
      
      public function updateEntities() : void
      {
         var _loc2_:NodeBase = null;
         var _loc3_:EntityNode = null;
         if(!this._updatesMade)
         {
            return;
         }
         var _loc1_:EntityNode = this._updateQueue;
         this._updateQueue = null;
         this._queuedNodes = new Dictionary();
         this._updatesMade = false;
         do
         {
            _loc2_ = this._rootNode.findPartitionForEntity(_loc1_.entity);
            if(_loc1_.parent != _loc2_)
            {
               if(_loc1_)
               {
                  _loc1_.removeFromParent();
               }
               _loc2_.addNode(_loc1_);
            }
            _loc3_ = _loc1_._updateQueueNext;
            _loc1_._updateQueueNext = null;
            _loc1_.entity.internalUpdate();
         }
         while(_loc1_ = _loc3_, _loc1_ != null);
      }
   }
}

