package away3d.entities
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.nodes.ParticleFollowNode;
   import away3d.animators.states.ParticleFollowState;
   import away3d.arcane;
   import away3d.bounds.BoundingSphere;
   import away3d.containers.ObjectContainer3D;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class FollowParticleContainer extends ObjectContainer3D
   {
      
      private var _identityTransform:Matrix3D = new Matrix3D();
      
      private var _followTarget:TargetObject3D;
      
      private var _updateBoundMeshes:Vector.<Mesh> = new Vector.<Mesh>();
      
      private var _updatePositionMeshes:Vector.<Mesh> = new Vector.<Mesh>();
      
      private var _tempCenter:Vector3D = new Vector3D();
      
      public function FollowParticleContainer()
      {
         super();
         this._followTarget = new TargetObject3D(this);
         addChild(this._followTarget);
      }
      
      public function addFollowParticle(param1:Mesh) : void
      {
         var _loc2_:ParticleAnimator = param1.animator as ParticleAnimator;
         if(!_loc2_)
         {
            throw new Error("not a particle mesh");
         }
         var _loc3_:ParticleFollowState = _loc2_.getAnimationStateByName("ParticleFollowLocalDynamic") as ParticleFollowState;
         if(!_loc3_)
         {
            throw new Error("not a follow particle");
         }
         _loc3_.followTarget = this._followTarget;
         addChild(param1);
         if((_loc2_.animationSet.getAnimation("ParticleFollowLocalDynamic") as ParticleFollowNode)._usesPosition)
         {
            this._updateBoundMeshes.push(param1);
         }
         else
         {
            this._updatePositionMeshes.push(param1);
         }
      }
      
      public function removeFollowParticle(param1:Mesh) : void
      {
         var _loc2_:ParticleAnimator = param1.animator as ParticleAnimator;
         if(!_loc2_)
         {
            throw new Error("not a particle mesh");
         }
         var _loc3_:ParticleFollowState = _loc2_.getAnimationStateByName("ParticleFollowLocalDynamic") as ParticleFollowState;
         if(!_loc3_)
         {
            throw new Error("not a follow particle");
         }
         _loc3_.followTarget = null;
         removeChild(param1);
         var _loc4_:int = this._updateBoundMeshes.indexOf(param1);
         if(_loc4_ != -1)
         {
            this._updateBoundMeshes.splice(_loc4_,1);
         }
         else
         {
            this._updatePositionMeshes.splice(this._updatePositionMeshes.indexOf(param1),1);
         }
      }
      
      public function get originalSceneTransform() : Matrix3D
      {
         return super.sceneTransform;
      }
      
      override public function get sceneTransform() : Matrix3D
      {
         var _loc1_:Vector.<Vector3D> = null;
         var _loc2_:Vector.<Number> = null;
         if(_sceneTransformDirty)
         {
            _loc1_ = super.sceneTransform.decompose();
            _loc2_ = this._identityTransform.rawData;
            _loc2_[0] = _loc1_[2].x;
            _loc2_[5] = _loc1_[2].y;
            _loc2_[10] = _loc1_[2].z;
            this._identityTransform.copyRawDataFrom(_loc2_);
         }
         if(this._followTarget.sceneTransformDirty)
         {
            this.updateBounds(this._followTarget.position);
         }
         return this._identityTransform;
      }
      
      private function updateBounds(param1:Vector3D) : void
      {
         var _loc2_:Mesh = null;
         var _loc3_:BoundingSphere = null;
         for each(_loc2_ in this._updateBoundMeshes)
         {
            this._tempCenter.copyFrom(param1);
            this._tempCenter.x /= _loc2_.scaleX;
            this._tempCenter.y /= _loc2_.scaleY;
            this._tempCenter.z /= _loc2_.scaleZ;
            _loc3_ = _loc2_.bounds as BoundingSphere;
            _loc3_.fromSphere(this._tempCenter,_loc3_.radius);
         }
         for each(_loc2_ in this._updatePositionMeshes)
         {
            _loc2_.position = this._followTarget.specificPos;
         }
      }
   }
}

import away3d.containers.ObjectContainer3D;
import away3d.entities.FollowParticleContainer;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;

class TargetObject3D extends ObjectContainer3D
{
   
   private var _container:FollowParticleContainer;
   
   private var _helpTransform:Matrix3D = new Matrix3D();
   
   public var specificPos:Vector3D = new Vector3D();
   
   private var specificEulers:Vector3D = new Vector3D();
   
   public function TargetObject3D(param1:FollowParticleContainer)
   {
      super();
      this._container = param1;
   }
   
   public function get sceneTransformDirty() : Boolean
   {
      return _sceneTransformDirty;
   }
   
   private function validateTransform() : void
   {
      var _loc1_:Vector.<Vector3D> = null;
      var _loc2_:ObjectContainer3D = null;
      if(_sceneTransformDirty)
      {
         this._helpTransform.copyFrom(this._container.originalSceneTransform);
         _loc1_ = this._helpTransform.decompose();
         this.specificPos = _loc1_[0];
         this.specificPos.x /= _loc1_[2].x;
         this.specificPos.y /= _loc1_[2].y;
         this.specificPos.z /= _loc1_[2].z;
         this.specificEulers.x = 0;
         this.specificEulers.y = 0;
         this.specificEulers.z = 0;
         _loc2_ = this._container;
         while(_loc2_)
         {
            this.specificEulers.x += _loc2_.rotationX;
            this.specificEulers.y += _loc2_.rotationY;
            this.specificEulers.z += _loc2_.rotationZ;
            _loc2_ = _loc2_.parent;
         }
         _sceneTransformDirty = false;
      }
   }
   
   override public function get x() : Number
   {
      if(_sceneTransformDirty)
      {
         this.validateTransform();
      }
      return this.specificPos.x;
   }
   
   override public function get y() : Number
   {
      if(_sceneTransformDirty)
      {
         this.validateTransform();
      }
      return this.specificPos.y;
   }
   
   override public function get z() : Number
   {
      if(_sceneTransformDirty)
      {
         this.validateTransform();
      }
      return this.specificPos.z;
   }
   
   override public function get position() : Vector3D
   {
      if(_sceneTransformDirty)
      {
         this.validateTransform();
      }
      return this.specificPos;
   }
   
   override public function get rotationX() : Number
   {
      if(_sceneTransformDirty)
      {
         this.validateTransform();
      }
      return this.specificEulers.x;
   }
   
   override public function get rotationY() : Number
   {
      if(_sceneTransformDirty)
      {
         this.validateTransform();
      }
      return this.specificEulers.y;
   }
   
   override public function get rotationZ() : Number
   {
      if(_sceneTransformDirty)
      {
         this.validateTransform();
      }
      return this.specificEulers.z;
   }
}
