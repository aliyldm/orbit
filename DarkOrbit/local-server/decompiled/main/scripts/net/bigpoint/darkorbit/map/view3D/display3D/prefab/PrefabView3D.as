package net.bigpoint.darkorbit.map.view3D.display3D.prefab
{
   import away3d.animators.AnimatorBase;
   import away3d.animators.SkeletonAnimator;
   import away3d.animators.VertexAnimator;
   import away3d.containers.ObjectContainer3D;
   import away3d.core.pick.PickingColliderType;
   import away3d.entities.Mesh;
   import away3d.events.AnimationStateEvent;
   import away3d.materials.TextureMaterial;
   import away3d.materials.TextureMultiPassMaterial;
   import away3d.materials.methods.EffectMethodBase;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.EntityBasicMaterial;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.IDynamicMethodHolder;
   import net.bigpoint.darkorbit.utils.HashUtils;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Promise;
   import org.osflash.signals.Signal;
   
   public class PrefabView3D extends ObjectContainer3D
   {
      
      public static const ANIM_NONE:String = "";
      
      public static const ANIM_IDLE:String = "idle";
      
      public const changed:ISignal = new Signal();
      
      public const shaderParams:Object = {"glow":1};
      
      private var _geometrySource:ObjectContainer3D;
      
      private var _meshes:Vector.<Mesh> = new Vector.<Mesh>();
      
      private var _triangles:int = 0;
      
      private var _vertices:int = 0;
      
      private var _animators:Vector.<AnimatorBase> = new Vector.<AnimatorBase>();
      
      private var _onComplete:Function;
      
      private var _playingAnimations:int = 0;
      
      private var _currentMethods:Vector.<EffectMethodBase> = new Vector.<EffectMethodBase>();
      
      private var _geometryPromise:Promise;
      
      private var _descriptor:XML;
      
      private var _materials:PrefabMaterialManager;
      
      private var _alpha:Number = 1;
      
      private var _defaultShaderClass:Class;
      
      public function PrefabView3D(param1:XML)
      {
         super();
         this._descriptor = param1;
         this._materials = PrefabMaterialManager.getMaterial(this._descriptor);
         this.log("created");
         this.loadGeometry();
      }
      
      public function set shaderClass(param1:Class) : void
      {
         if(this._materials)
         {
            PrefabMaterialManager.freeMaterial(this._materials);
            this._materials = null;
         }
         this._materials = PrefabMaterialManager.getMaterial(this._descriptor,param1);
         this.reinitializeMaterials();
      }
      
      override public function set zOffset(param1:int) : void
      {
         super.zOffset = param1;
         var _loc2_:* = int(numChildren - 1);
         while(_loc2_ >= 0)
         {
            getChildAt(_loc2_).zOffset = param1;
            _loc2_--;
         }
      }
      
      public function get materials() : PrefabMaterialManager
      {
         return this._materials;
      }
      
      public function set geometry(param1:ObjectContainer3D) : void
      {
         if(this._geometrySource)
         {
            World3D.instance.geometryLoader.freeGeometry(this._geometrySource);
         }
         if(this._geometryPromise)
         {
            this._geometryPromise.remove(this.handleGeometryLoadComplete);
            this._geometryPromise = null;
         }
         this._geometrySource = param1;
         if(this._geometrySource)
         {
            World3D.instance.geometryLoader.useGeometry(param1);
         }
         this.reinitializeMeshes();
         this.changed.dispatch();
      }
      
      public function set alpha(param1:Number) : void
      {
         var _loc2_:Mesh = null;
         var _loc3_:* = 0;
         if(this._alpha == param1)
         {
            return;
         }
         if(param1 < 1)
         {
            if(numChildren > 0)
            {
               _loc2_ = getChildAt(0) as Mesh;
               if(Boolean(_loc2_) && _loc2_.material is TextureMultiPassMaterial)
               {
                  this._materials = PrefabMaterialManager.getMaterial(this._descriptor,EntityBasicMaterial);
                  this.reinitializeMaterials();
               }
            }
         }
         else if(param1 >= 1)
         {
            if(numChildren > 0)
            {
               _loc2_ = getChildAt(0) as Mesh;
               if(Boolean(_loc2_) && _loc2_.material is TextureMaterial)
               {
                  this._materials = PrefabMaterialManager.getMaterial(this._descriptor,this._defaultShaderClass);
                  this.reinitializeMaterials();
               }
            }
         }
         if(this._alpha == 1 != (param1 == 1))
         {
            this._alpha = param1;
            this.reinitializeMaterials();
         }
         else
         {
            this._alpha = param1;
            _loc3_ = int(numChildren - 1);
            while(_loc3_ >= 0)
            {
               _loc2_ = getChildAt(_loc3_) as Mesh;
               if(Boolean(_loc2_) && _loc2_.material is TextureMaterial)
               {
                  TextureMaterial(_loc2_.material).alpha = param1;
               }
               _loc3_--;
            }
         }
      }
      
      override public function dispose() : void
      {
         this.geometry = null;
         if(this._materials)
         {
            PrefabMaterialManager.freeMaterial(this._materials);
            this._materials = null;
         }
         if(this._geometryPromise)
         {
            this._geometryPromise.remove(this.handleGeometryLoadComplete);
            this._geometryPromise = null;
         }
         super.dispose();
      }
      
      public function addMethod(param1:EffectMethodBase) : void
      {
         var _loc2_:Mesh = null;
         var _loc3_:* = 0;
         this.removeMethod(param1);
         this._currentMethods.push(param1);
         if(this._currentMethods.length == 1)
         {
            this.reinitializeMaterials();
         }
         else
         {
            _loc3_ = int(numChildren - 1);
            while(_loc3_ >= 0)
            {
               _loc2_ = getChildAt(_loc3_) as Mesh;
               if(Boolean(_loc2_) && _loc2_.material is IDynamicMethodHolder)
               {
                  IDynamicMethodHolder(_loc2_.material).addDynamicMethod(param1);
               }
               _loc3_--;
            }
         }
      }
      
      public function removeMethod(param1:EffectMethodBase) : void
      {
         var _loc3_:Mesh = null;
         var _loc4_:* = 0;
         var _loc2_:int = this._currentMethods.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._currentMethods.splice(_loc2_,1);
            if(this._currentMethods.length == 0)
            {
               this.reinitializeMaterials();
            }
            else
            {
               _loc4_ = int(numChildren - 1);
               while(_loc4_ >= 0)
               {
                  _loc3_ = getChildAt(_loc4_) as Mesh;
                  if(Boolean(_loc3_) && _loc3_.material is IDynamicMethodHolder)
                  {
                     IDynamicMethodHolder(_loc3_.material).removeDynamicMethod(param1);
                  }
                  _loc4_--;
               }
            }
         }
      }
      
      public function removeAllMethods() : void
      {
         while(this._currentMethods.length)
         {
            this.removeMethod(this._currentMethods[this._currentMethods.length - 1]);
         }
      }
      
      public function playAnimation(param1:String, param2:Function = null, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc6_:AnimatorBase = null;
         var _loc7_:Function = null;
         this._onComplete = param2;
         this._playingAnimations = 0;
         var _loc5_:* = int(this._animators.length - 1);
         while(_loc5_ >= 0)
         {
            _loc6_ = this._animators[_loc5_] as AnimatorBase;
            if(_loc6_.animationSet.hasAnimation(param1))
            {
               if(_loc6_ is VertexAnimator)
               {
                  ++this._playingAnimations;
                  VertexAnimator(_loc6_).play(param1,param3 ? Math.random() * 10000 : 0).addEventListener(AnimationStateEvent.PLAYBACK_COMPLETE,this.handleAnimPlaybackComplete);
               }
               else if(_loc6_ is SkeletonAnimator)
               {
                  ++this._playingAnimations;
                  SkeletonAnimator(_loc6_).play(param1,param4,null,param3 ? Math.random() * 10000 : 0).addEventListener(AnimationStateEvent.PLAYBACK_COMPLETE,this.handleAnimPlaybackComplete);
               }
            }
            else
            {
               _loc6_.stop();
            }
            _loc5_--;
         }
         if(this._playingAnimations == 0 && this._onComplete != null)
         {
            _loc7_ = this._onComplete;
            this._onComplete = null;
            _loc7_();
         }
      }
      
      protected function processMesh(param1:Mesh) : void
      {
         param1 = param1.clone() as Mesh;
         param1.pickingCollider = PickingColliderType.AS3_FIRST_ENCOUNTERED;
         param1.shaderParams = this.shaderParams;
         this.reinitializeMaterialForMesh(param1);
         this._meshes.push(param1);
         param1.zOffset = zOffset;
         if(param1.animator)
         {
            if(param1.animator is VertexAnimator || param1.animator is SkeletonAnimator)
            {
               this._animators.push(param1.animator);
            }
         }
         addChild(param1);
      }
      
      private function reinitializeMeshes() : void
      {
         var _loc1_:Mesh = null;
         var _loc2_:ObjectContainer3D = null;
         var _loc3_:int = 0;
         while(this._meshes.length)
         {
            _loc1_ = this._meshes.pop();
            _loc1_.dispose();
         }
         while(this._animators.length)
         {
            this._animators.pop().dispose();
         }
         this._triangles = 0;
         this._vertices = 0;
         if(this._geometrySource)
         {
            _loc3_ = 0;
            while(_loc3_ < this._geometrySource.numChildren)
            {
               _loc2_ = this._geometrySource.getChildAt(_loc3_);
               if(_loc2_ is Mesh)
               {
                  this.processMesh(_loc2_ as Mesh);
               }
               _loc3_++;
            }
            this.playAnimation(ANIM_IDLE,null,true);
         }
      }
      
      private function reinitializeMaterials() : void
      {
         var _loc1_:Mesh = null;
         for each(_loc1_ in this._meshes)
         {
            this.reinitializeMaterialForMesh(_loc1_);
         }
      }
      
      private function reinitializeMaterialForMesh(param1:Mesh) : void
      {
         var _loc3_:EffectMethodBase = null;
         var _loc2_:Array = [];
         if(param1.animator)
         {
            _loc2_.push(param1.animator.animationSet);
         }
         _loc2_.push(this._alpha < 1);
         for each(_loc3_ in this._currentMethods)
         {
            _loc2_.push(_loc3_);
         }
         param1.material = this._materials.getMaterial(HashUtils.getObjectsHash(_loc2_));
         if(param1.material is IDynamicMethodHolder)
         {
            IDynamicMethodHolder(param1.material).removeDynamicMethods();
            for each(_loc3_ in this._currentMethods)
            {
               IDynamicMethodHolder(param1.material).addDynamicMethod(_loc3_);
            }
         }
         if(param1.material is TextureMaterial)
         {
            TextureMaterial(param1.material).alpha = this._alpha;
         }
      }
      
      private function loadGeometry() : void
      {
         if(this._geometryPromise)
         {
            this._geometryPromise.remove(this.handleGeometryLoadComplete);
            this._geometryPromise = null;
         }
         if(String(this._descriptor.@geometry))
         {
            this._geometryPromise = World3D.instance.geometryLoader.loadGeometry(String(this._descriptor.@geometry),World3D.LIFETIME_USE_COUNTER);
            this._geometryPromise.addOnce(this.handleGeometryLoadComplete);
         }
         else
         {
            this.geometry = null;
         }
      }
      
      private function handleGeometryLoadComplete(param1:ObjectContainer3D) : void
      {
         this.geometry = param1;
      }
      
      private function log(param1:String) : void
      {
      }
      
      private function handleAnimPlaybackComplete(param1:AnimationStateEvent) : void
      {
         var _loc2_:Function = null;
         param1.currentTarget.removeEventListener(AnimationStateEvent.PLAYBACK_COMPLETE,this.handleAnimPlaybackComplete);
         --this._playingAnimations;
         if(this._playingAnimations <= 0 && this._onComplete != null)
         {
            _loc2_ = this._onComplete;
            this._onComplete = null;
            _loc2_();
         }
      }
      
      public function set defaultShaderClass(param1:Class) : void
      {
         this._defaultShaderClass = param1;
      }
   }
}

