package away3d.containers
{
   import away3d.arcane;
   import away3d.core.base.Object3D;
   import away3d.core.partition.Partition3D;
   import away3d.events.Object3DEvent;
   import away3d.events.Scene3DEvent;
   import away3d.library.assets.AssetType;
   import away3d.library.assets.IAsset;
   import flash.events.Event;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class ObjectContainer3D extends Object3D implements IAsset
   {
      
      arcane var _ancestorsAllowMouseEnabled:Boolean;
      
      arcane var _isRoot:Boolean;
      
      protected var _scene:Scene3D;
      
      protected var _parent:ObjectContainer3D;
      
      protected var _sceneTransform:Matrix3D = new Matrix3D();
      
      protected var _sceneTransformDirty:Boolean = true;
      
      protected var _explicitPartition:Partition3D;
      
      protected var _implicitPartition:Partition3D;
      
      protected var _mouseEnabled:Boolean;
      
      private var _sceneTransformChanged:Object3DEvent;
      
      private var _scenechanged:Object3DEvent;
      
      private var _children:Vector.<ObjectContainer3D> = new Vector.<ObjectContainer3D>();
      
      private var _mouseChildren:Boolean = true;
      
      private var _oldScene:Scene3D;
      
      private var _inverseSceneTransform:Matrix3D = new Matrix3D();
      
      private var _inverseSceneTransformDirty:Boolean = true;
      
      private var _scenePosition:Vector3D = new Vector3D();
      
      private var _scenePositionDirty:Boolean = true;
      
      private var _explicitVisibility:Boolean = true;
      
      private var _implicitVisibility:Boolean = true;
      
      private var _listenToSceneTransformChanged:Boolean;
      
      private var _listenToSceneChanged:Boolean;
      
      protected var _ignoreTransform:Boolean = false;
      
      public function ObjectContainer3D()
      {
         super();
      }
      
      public function get ignoreTransform() : Boolean
      {
         return this._ignoreTransform;
      }
      
      public function set ignoreTransform(param1:Boolean) : void
      {
         this._ignoreTransform = param1;
         this._sceneTransformDirty = !param1;
         this._inverseSceneTransformDirty = !param1;
         this._scenePositionDirty = !param1;
         if(!param1)
         {
            this._sceneTransform.identity();
            this._scenePosition.setTo(0,0,0);
         }
      }
      
      arcane function get implicitPartition() : Partition3D
      {
         return this._implicitPartition;
      }
      
      arcane function set implicitPartition(param1:Partition3D) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:ObjectContainer3D = null;
         if(param1 == this._implicitPartition)
         {
            return;
         }
         var _loc3_:uint = this._children.length;
         this._implicitPartition = param1;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this._children[_loc2_++];
            if(!_loc4_._explicitPartition)
            {
               _loc4_.implicitPartition = param1;
            }
         }
      }
      
      arcane function get isVisible() : Boolean
      {
         return this._implicitVisibility && this._explicitVisibility;
      }
      
      arcane function setParent(param1:ObjectContainer3D) : void
      {
         this._parent = param1;
         this.updateMouseChildren();
         if(param1 == null)
         {
            this.scene = null;
            return;
         }
         this.notifySceneTransformChange();
         this.notifySceneChange();
      }
      
      private function notifySceneTransformChange() : void
      {
         var _loc1_:uint = 0;
         if(this._sceneTransformDirty || this._ignoreTransform)
         {
            return;
         }
         this.invalidateSceneTransform();
         var _loc2_:uint = this._children.length;
         while(_loc1_ < _loc2_)
         {
            this._children[_loc1_++].notifySceneTransformChange();
         }
         if(this._listenToSceneTransformChanged)
         {
            if(!this._sceneTransformChanged)
            {
               this._sceneTransformChanged = new Object3DEvent(Object3DEvent.SCENETRANSFORM_CHANGED,this);
            }
            this.dispatchEvent(this._sceneTransformChanged);
         }
      }
      
      private function notifySceneChange() : void
      {
         var _loc1_:uint = 0;
         this.notifySceneTransformChange();
         var _loc2_:uint = this._children.length;
         while(_loc1_ < _loc2_)
         {
            this._children[_loc1_++].notifySceneChange();
         }
         if(this._listenToSceneChanged)
         {
            if(!this._scenechanged)
            {
               this._scenechanged = new Object3DEvent(Object3DEvent.SCENE_CHANGED,this);
            }
            this.dispatchEvent(this._scenechanged);
         }
      }
      
      protected function updateMouseChildren() : void
      {
         if(Boolean(this._parent) && !this._parent._isRoot)
         {
            this._ancestorsAllowMouseEnabled = this.parent._ancestorsAllowMouseEnabled && this._parent.mouseChildren;
         }
         else
         {
            this._ancestorsAllowMouseEnabled = this.mouseChildren;
         }
         var _loc1_:uint = this._children.length;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            this._children[_loc2_].updateMouseChildren();
            _loc2_++;
         }
      }
      
      public function get mouseEnabled() : Boolean
      {
         return this._mouseEnabled;
      }
      
      public function set mouseEnabled(param1:Boolean) : void
      {
         this._mouseEnabled = param1;
         this.updateMouseChildren();
      }
      
      override arcane function invalidateTransform() : void
      {
         super.arcane::invalidateTransform();
         this.notifySceneTransformChange();
      }
      
      protected function invalidateSceneTransform() : void
      {
         this._sceneTransformDirty = !this._ignoreTransform;
         this._inverseSceneTransformDirty = !this._ignoreTransform;
         this._scenePositionDirty = !this._ignoreTransform;
      }
      
      protected function updateSceneTransform() : void
      {
         if(Boolean(this._parent) && !this._parent._isRoot)
         {
            this._sceneTransform.copyFrom(this._parent.sceneTransform);
            this._sceneTransform.prepend(transform);
         }
         else
         {
            this._sceneTransform.copyFrom(transform);
         }
         this._sceneTransformDirty = false;
      }
      
      public function get mouseChildren() : Boolean
      {
         return this._mouseChildren;
      }
      
      public function set mouseChildren(param1:Boolean) : void
      {
         this._mouseChildren = param1;
         this.updateMouseChildren();
      }
      
      public function get visible() : Boolean
      {
         return this._explicitVisibility;
      }
      
      public function set visible(param1:Boolean) : void
      {
         var _loc2_:uint = this._children.length;
         this._explicitVisibility = param1;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            this._children[_loc3_].updateImplicitVisibility();
            _loc3_++;
         }
      }
      
      public function get assetType() : String
      {
         return AssetType.CONTAINER;
      }
      
      public function get scenePosition() : Vector3D
      {
         if(this._scenePositionDirty)
         {
            this.sceneTransform.copyColumnTo(3,this._scenePosition);
            this._scenePositionDirty = false;
         }
         return this._scenePosition;
      }
      
      public function get minX() : Number
      {
         var _loc1_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:ObjectContainer3D = null;
         var _loc2_:uint = this._children.length;
         var _loc3_:Number = Number.POSITIVE_INFINITY;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this._children[_loc1_++];
            _loc4_ = _loc5_.minX + _loc5_.x;
            if(_loc4_ < _loc3_)
            {
               _loc3_ = _loc4_;
            }
         }
         return _loc3_;
      }
      
      public function get minY() : Number
      {
         var _loc1_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:ObjectContainer3D = null;
         var _loc2_:uint = this._children.length;
         var _loc3_:Number = Number.POSITIVE_INFINITY;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this._children[_loc1_++];
            _loc4_ = _loc5_.minY + _loc5_.y;
            if(_loc4_ < _loc3_)
            {
               _loc3_ = _loc4_;
            }
         }
         return _loc3_;
      }
      
      public function get minZ() : Number
      {
         var _loc1_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:ObjectContainer3D = null;
         var _loc2_:uint = this._children.length;
         var _loc3_:Number = Number.POSITIVE_INFINITY;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this._children[_loc1_++];
            _loc4_ = _loc5_.minZ + _loc5_.z;
            if(_loc4_ < _loc3_)
            {
               _loc3_ = _loc4_;
            }
         }
         return _loc3_;
      }
      
      public function get maxX() : Number
      {
         var _loc1_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:ObjectContainer3D = null;
         var _loc2_:uint = this._children.length;
         var _loc3_:Number = Number.NEGATIVE_INFINITY;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this._children[_loc1_++];
            _loc4_ = _loc5_.maxX + _loc5_.x;
            if(_loc4_ > _loc3_)
            {
               _loc3_ = _loc4_;
            }
         }
         return _loc3_;
      }
      
      public function get maxY() : Number
      {
         var _loc1_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:ObjectContainer3D = null;
         var _loc2_:uint = this._children.length;
         var _loc3_:Number = Number.NEGATIVE_INFINITY;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this._children[_loc1_++];
            _loc4_ = _loc5_.maxY + _loc5_.y;
            if(_loc4_ > _loc3_)
            {
               _loc3_ = _loc4_;
            }
         }
         return _loc3_;
      }
      
      public function get maxZ() : Number
      {
         var _loc1_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:ObjectContainer3D = null;
         var _loc2_:uint = this._children.length;
         var _loc3_:Number = Number.NEGATIVE_INFINITY;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this._children[_loc1_++];
            _loc4_ = _loc5_.maxZ + _loc5_.z;
            if(_loc4_ > _loc3_)
            {
               _loc3_ = _loc4_;
            }
         }
         return _loc3_;
      }
      
      public function get partition() : Partition3D
      {
         return this._explicitPartition;
      }
      
      public function set partition(param1:Partition3D) : void
      {
         this._explicitPartition = param1;
         this.implicitPartition = param1 ? param1 : (this._parent ? this._parent.implicitPartition : null);
      }
      
      public function get sceneTransform() : Matrix3D
      {
         if(this._sceneTransformDirty)
         {
            this.updateSceneTransform();
         }
         return this._sceneTransform;
      }
      
      public function get scene() : Scene3D
      {
         return this._scene;
      }
      
      public function set scene(param1:Scene3D) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = this._children.length;
         while(_loc2_ < _loc3_)
         {
            this._children[_loc2_++].scene = param1;
         }
         if(this._scene == param1)
         {
            return;
         }
         if(param1 == null)
         {
            this._oldScene = this._scene;
         }
         if(Boolean(this._explicitPartition) && Boolean(this._oldScene) && this._oldScene != this._scene)
         {
            this.partition = null;
         }
         if(param1)
         {
            this._oldScene = null;
         }
         this._scene = param1;
         if(this._scene)
         {
            if(this._scene.hasEventListener(Scene3DEvent.ADDED_TO_SCENE))
            {
               this._scene.dispatchEvent(new Scene3DEvent(Scene3DEvent.ADDED_TO_SCENE,this));
            }
         }
         else if(Boolean(this._oldScene) && this._oldScene.hasEventListener(Scene3DEvent.REMOVED_FROM_SCENE))
         {
            this._oldScene.dispatchEvent(new Scene3DEvent(Scene3DEvent.REMOVED_FROM_SCENE,this));
         }
      }
      
      public function get inverseSceneTransform() : Matrix3D
      {
         if(this._inverseSceneTransformDirty)
         {
            this._inverseSceneTransform.copyFrom(this.sceneTransform);
            this._inverseSceneTransform.invert();
            this._inverseSceneTransformDirty = false;
         }
         return this._inverseSceneTransform;
      }
      
      public function get parent() : ObjectContainer3D
      {
         return this._parent;
      }
      
      public function contains(param1:ObjectContainer3D) : Boolean
      {
         return this._children.indexOf(param1) >= 0;
      }
      
      public function addChild(param1:ObjectContainer3D) : ObjectContainer3D
      {
         if(param1 == null)
         {
            throw new Error("Parameter child cannot be null.");
         }
         if(param1._parent)
         {
            param1._parent.removeChild(param1);
         }
         if(!param1._explicitPartition)
         {
            param1.implicitPartition = this._implicitPartition;
         }
         param1.setParent(this);
         param1.scene = this._scene;
         param1.notifySceneTransformChange();
         param1.updateMouseChildren();
         param1.updateImplicitVisibility();
         this._children.push(param1);
         return param1;
      }
      
      public function addChildren(... rest) : void
      {
         var _loc2_:ObjectContainer3D = null;
         for each(_loc2_ in rest)
         {
            this.addChild(_loc2_);
         }
      }
      
      public function removeChild(param1:ObjectContainer3D) : void
      {
         if(param1 == null)
         {
            throw new Error("Parameter child cannot be null");
         }
         var _loc2_:int = this._children.indexOf(param1);
         if(_loc2_ == -1)
         {
            throw new Error("Parameter is not a child of the caller");
         }
         this.removeChildInternal(_loc2_,param1);
      }
      
      public function removeChildAt(param1:uint) : void
      {
         var _loc2_:ObjectContainer3D = this._children[param1];
         this.removeChildInternal(param1,_loc2_);
      }
      
      private function removeChildInternal(param1:uint, param2:ObjectContainer3D) : void
      {
         this._children.splice(param1,1);
         param2.setParent(null);
         if(!param2._explicitPartition)
         {
            param2.implicitPartition = null;
         }
      }
      
      public function getChildAt(param1:uint) : ObjectContainer3D
      {
         return this._children[param1];
      }
      
      public function get numChildren() : uint
      {
         return this._children.length;
      }
      
      override public function lookAt(param1:Vector3D, param2:Vector3D = null) : void
      {
         super.lookAt(param1,param2);
         this.notifySceneTransformChange();
      }
      
      override public function translateLocal(param1:Vector3D, param2:Number) : void
      {
         super.translateLocal(param1,param2);
         this.notifySceneTransformChange();
      }
      
      override public function dispose() : void
      {
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function disposeWithChildren() : void
      {
         this.dispose();
         while(this.numChildren > 0)
         {
            this.getChildAt(0).dispose();
         }
      }
      
      override public function clone() : Object3D
      {
         var _loc1_:ObjectContainer3D = new ObjectContainer3D();
         _loc1_.pivotPoint = pivotPoint;
         _loc1_.transform = transform;
         _loc1_.partition = this.partition;
         _loc1_.name = name;
         var _loc2_:uint = this._children.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_.addChild(ObjectContainer3D(this._children[_loc3_].clone()));
            _loc3_++;
         }
         return _loc1_;
      }
      
      override public function rotate(param1:Vector3D, param2:Number) : void
      {
         super.rotate(param1,param2);
         this.notifySceneTransformChange();
      }
      
      override public function dispatchEvent(param1:Event) : Boolean
      {
         var _loc2_:Boolean = super.dispatchEvent(param1);
         if(param1.bubbles)
         {
            if(this._parent)
            {
               this._parent.dispatchEvent(param1);
            }
            else if(this._scene)
            {
               this._scene.dispatchEvent(param1);
            }
         }
         return _loc2_;
      }
      
      public function updateImplicitVisibility() : void
      {
         var _loc1_:uint = this._children.length;
         this._implicitVisibility = this._parent._explicitVisibility && this._parent._implicitVisibility;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            this._children[_loc2_].updateImplicitVisibility();
            _loc2_++;
         }
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
         switch(param1)
         {
            case Object3DEvent.SCENETRANSFORM_CHANGED:
               this._listenToSceneTransformChanged = true;
               break;
            case Object3DEvent.SCENE_CHANGED:
               this._listenToSceneChanged = true;
         }
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         super.removeEventListener(param1,param2,param3);
         if(hasEventListener(param1))
         {
            return;
         }
         switch(param1)
         {
            case Object3DEvent.SCENETRANSFORM_CHANGED:
               this._listenToSceneTransformChanged = false;
               break;
            case Object3DEvent.SCENE_CHANGED:
               this._listenToSceneChanged = false;
         }
      }
   }
}

