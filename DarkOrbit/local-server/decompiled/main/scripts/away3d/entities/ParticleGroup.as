package away3d.entities
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.ParticleGroupAnimator;
   import away3d.animators.data.ParticleGroupEventProperty;
   import away3d.animators.data.ParticleInstanceProperty;
   import away3d.animators.nodes.ParticleFollowNode;
   import away3d.bounds.BoundingSphere;
   import away3d.containers.ObjectContainer3D;
   import away3d.core.base.Object3D;
   import flash.geom.Vector3D;
   import mx.utils.ObjectUtil;
   
   public class ParticleGroup extends ObjectContainer3D
   {
      
      protected var _animator:ParticleGroupAnimator;
      
      protected var _particleMeshes:Vector.<Mesh>;
      
      protected var _instanceProperties:Vector.<ParticleInstanceProperty>;
      
      protected var _followParticleContainer:FollowParticleContainer;
      
      protected var _showBounds:Boolean;
      
      protected var _customParamters:Object;
      
      protected var _eventList:Vector.<ParticleGroupEventProperty>;
      
      public function ParticleGroup(param1:Vector.<Mesh>, param2:Vector.<ParticleInstanceProperty>, param3:Object = null, param4:Vector.<ParticleGroupEventProperty> = null)
      {
         var _loc5_:int = 0;
         var _loc6_:Mesh = null;
         var _loc7_:ParticleInstanceProperty = null;
         super();
         this._followParticleContainer = new FollowParticleContainer();
         addChild(this._followParticleContainer);
         if(param3)
         {
            this._customParamters = ObjectUtil.clone(param3);
         }
         else
         {
            this._customParamters = {};
         }
         this._particleMeshes = param1;
         this._instanceProperties = param2;
         this._eventList = param4;
         this._animator = new ParticleGroupAnimator(param1,param2,this._eventList);
         while(_loc5_ < param1.length)
         {
            _loc6_ = param1[_loc5_];
            _loc7_ = param2[_loc5_];
            if(_loc7_)
            {
               _loc7_.apply(_loc6_);
            }
            if(this.isFollowParticle(_loc6_))
            {
               this._followParticleContainer.addFollowParticle(_loc6_);
            }
            else
            {
               addChild(_loc6_);
            }
            _loc5_++;
         }
      }
      
      override public function get zOffset() : int
      {
         return super.zOffset;
      }
      
      override public function set zOffset(param1:int) : void
      {
         super.zOffset = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this.particleMeshes.length)
         {
            this.particleMeshes[_loc2_].zOffset = param1;
            _loc2_++;
         }
      }
      
      public function get customParamters() : Object
      {
         return this._customParamters;
      }
      
      public function get particleMeshes() : Vector.<Mesh>
      {
         return this._particleMeshes;
      }
      
      public function get showBounds() : Boolean
      {
         return this._showBounds;
      }
      
      public function set showBounds(param1:Boolean) : void
      {
         var _loc2_:Mesh = null;
         this._showBounds = param1;
         for each(_loc2_ in this._particleMeshes)
         {
            _loc2_.showBounds = this._showBounds;
         }
      }
      
      public function get animator() : ParticleGroupAnimator
      {
         return this._animator;
      }
      
      private function isFollowParticle(param1:Mesh) : Boolean
      {
         var _loc3_:ParticleFollowNode = null;
         var _loc2_:ParticleAnimator = param1.animator as ParticleAnimator;
         if(_loc2_)
         {
            _loc3_ = _loc2_.animationSet.getAnimation("ParticleFollowLocalDynamic") as ParticleFollowNode;
            if(_loc3_)
            {
               return true;
            }
         }
         return false;
      }
      
      override public function clone() : Object3D
      {
         var _loc3_:int = 0;
         var _loc5_:BoundingSphere = null;
         var _loc6_:ObjectContainer3D = null;
         var _loc1_:uint = this._particleMeshes.length;
         var _loc2_:Vector.<Mesh> = new Vector.<Mesh>(_loc1_,true);
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_[_loc3_] = this._particleMeshes[_loc3_].clone() as Mesh;
            _loc5_ = this._particleMeshes[_loc3_].bounds as BoundingSphere;
            _loc2_[_loc3_].bounds = new BoundingSphere();
            _loc2_[_loc3_].bounds.fromSphere(new Vector3D(),_loc5_.radius);
            _loc3_++;
         }
         var _loc4_:ParticleGroup = new ParticleGroup(_loc2_,this._instanceProperties,this.customParamters,this._eventList);
         _loc4_.pivotPoint = pivotPoint;
         _loc4_.transform = transform;
         _loc4_.partition = partition;
         _loc4_.name = name;
         _loc4_.showBounds = this.showBounds;
         _loc1_ = numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc6_ = getChildAt(_loc3_);
            if(this._followParticleContainer != _loc6_ && this._particleMeshes.indexOf(_loc6_ as Mesh) == -1)
            {
               _loc4_.addChild(ObjectContainer3D(_loc6_.clone()));
            }
            _loc3_++;
         }
         return _loc4_;
      }
      
      override public function dispose() : void
      {
         var _loc1_:Mesh = null;
         super.dispose();
         this._animator.dispose();
         for each(_loc1_ in this._particleMeshes)
         {
            _loc1_.dispose();
         }
      }
   }
}

