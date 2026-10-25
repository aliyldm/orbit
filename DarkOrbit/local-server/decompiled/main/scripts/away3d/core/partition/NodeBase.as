package away3d.core.partition
{
   import away3d.arcane;
   import away3d.core.math.Plane3D;
   import away3d.core.traverse.PartitionTraverser;
   import away3d.entities.Entity;
   import away3d.primitives.WireframePrimitiveBase;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class NodeBase
   {
      
      arcane var _parent:NodeBase;
      
      private var _indexInParent:int = -1;
      
      protected var _childNodes:Vector.<NodeBase>;
      
      protected var _numChildNodes:uint;
      
      protected var _debugPrimitive:WireframePrimitiveBase;
      
      arcane var _numEntities:int;
      
      arcane var _collectionMark:uint;
      
      public function NodeBase()
      {
         super();
         this._childNodes = new Vector.<NodeBase>();
      }
      
      public function get showDebugBounds() : Boolean
      {
         return this._debugPrimitive != null;
      }
      
      public function set showDebugBounds(param1:Boolean) : void
      {
         if(Boolean(this._debugPrimitive) == param1)
         {
            return;
         }
         if(param1)
         {
            this._debugPrimitive = this.createDebugBounds();
         }
         else
         {
            this._debugPrimitive.dispose();
            this._debugPrimitive = null;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this._numChildNodes)
         {
            this._childNodes[_loc2_].showDebugBounds = param1;
            _loc2_++;
         }
      }
      
      public function get parent() : NodeBase
      {
         return this._parent;
      }
      
      arcane function addNode(param1:NodeBase) : void
      {
         param1._parent = this;
         this._numEntities += param1._numEntities;
         param1._indexInParent = this._numChildNodes;
         this._childNodes[this._numChildNodes++] = param1;
         param1.showDebugBounds = this._debugPrimitive != null;
         var _loc2_:int = param1._numEntities;
         param1 = this;
         do
         {
            param1._numEntities += _loc2_;
         }
         while(param1 = param1._parent, param1 != null);
      }
      
      arcane function removeNode(param1:NodeBase) : void
      {
         var _loc2_:int = param1._indexInParent;
         if(param1._parent != this || _loc2_ < 0 || _loc2_ >= this._numChildNodes || this._childNodes[_loc2_] != param1)
         {
            _loc2_ = this._childNodes.indexOf(param1);
         }
         var _loc3_:NodeBase = this._childNodes[--this._numChildNodes];
         this._childNodes[_loc2_] = _loc3_;
         _loc3_._indexInParent = _loc2_;
         this._childNodes.pop();
         param1._indexInParent = -1;
         var _loc4_:int = param1._numEntities;
         param1 = this;
         do
         {
            param1._numEntities -= _loc4_;
         }
         while(param1 = param1._parent, param1 != null);
      }
      
      public function isInFrustum(param1:Vector.<Plane3D>, param2:int) : Boolean
      {
         param1 = param1;
         param2 = param2;
         return true;
      }
      
      public function isIntersectingRay(param1:Vector3D, param2:Vector3D) : Boolean
      {
         param1 = param1;
         param2 = param2;
         return true;
      }
      
      public function findPartitionForEntity(param1:Entity) : NodeBase
      {
         param1 = param1;
         return this;
      }
      
      public function acceptTraverser(param1:PartitionTraverser) : void
      {
         var _loc2_:uint = 0;
         if(this._numEntities == 0 && !this._debugPrimitive)
         {
            return;
         }
         if(param1.enterNode(this))
         {
            while(_loc2_ < this._numChildNodes)
            {
               this._childNodes[_loc2_++].acceptTraverser(param1);
            }
            if(this._debugPrimitive)
            {
               param1.applyRenderable(this._debugPrimitive);
            }
         }
      }
      
      protected function createDebugBounds() : WireframePrimitiveBase
      {
         return null;
      }
      
      protected function get numEntities() : int
      {
         return this._numEntities;
      }
      
      protected function updateNumEntities(param1:int) : void
      {
         var _loc2_:int = param1 - this._numEntities;
         var _loc3_:NodeBase = this;
         do
         {
            _loc3_._numEntities += _loc2_;
         }
         while(_loc3_ = _loc3_._parent, _loc3_ != null);
      }
   }
}

