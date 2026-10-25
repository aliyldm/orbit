package away3d.core.base
{
   import away3d.animators.IAnimator;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.arcane;
   import away3d.bounds.BoundingVolumeBase;
   import away3d.cameras.Camera3D;
   import away3d.core.managers.Stage3DProxy;
   import away3d.entities.Entity;
   import away3d.entities.Mesh;
   import away3d.materials.MaterialBase;
   import flash.display3D.IndexBuffer3D;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   
   use namespace arcane;
   
   public class SubMesh implements IRenderable
   {
      
      arcane var _material:MaterialBase;
      
      private var _parentMesh:Mesh;
      
      private var _subGeometry:ISubGeometry;
      
      arcane var _index:uint;
      
      private var _uvTransform:Matrix;
      
      private var _uvTransformDirty:Boolean;
      
      private var _uvRotation:Number = 0;
      
      private var _scaleU:Number = 1;
      
      private var _scaleV:Number = 1;
      
      private var _offsetU:Number = 0;
      
      private var _offsetV:Number = 0;
      
      public var animationSubGeometry:AnimationSubGeometry;
      
      public var animatorSubGeometry:AnimationSubGeometry;
      
      public function SubMesh(param1:ISubGeometry, param2:Mesh, param3:MaterialBase = null)
      {
         super();
         this._parentMesh = param2;
         this._subGeometry = param1;
         this.material = param3;
      }
      
      public function get shaderPickingDetails() : Boolean
      {
         return this.sourceEntity.shaderPickingDetails;
      }
      
      public function get offsetU() : Number
      {
         return this._offsetU;
      }
      
      public function set offsetU(param1:Number) : void
      {
         if(param1 == this._offsetU)
         {
            return;
         }
         this._offsetU = param1;
         this._uvTransformDirty = true;
      }
      
      public function get offsetV() : Number
      {
         return this._offsetV;
      }
      
      public function set offsetV(param1:Number) : void
      {
         if(param1 == this._offsetV)
         {
            return;
         }
         this._offsetV = param1;
         this._uvTransformDirty = true;
      }
      
      public function get scaleU() : Number
      {
         return this._scaleU;
      }
      
      public function set scaleU(param1:Number) : void
      {
         if(param1 == this._scaleU)
         {
            return;
         }
         this._scaleU = param1;
         this._uvTransformDirty = true;
      }
      
      public function get scaleV() : Number
      {
         return this._scaleV;
      }
      
      public function set scaleV(param1:Number) : void
      {
         if(param1 == this._scaleV)
         {
            return;
         }
         this._scaleV = param1;
         this._uvTransformDirty = true;
      }
      
      public function get uvRotation() : Number
      {
         return this._uvRotation;
      }
      
      public function set uvRotation(param1:Number) : void
      {
         if(param1 == this._uvRotation)
         {
            return;
         }
         this._uvRotation = param1;
         this._uvTransformDirty = true;
      }
      
      public function get sourceEntity() : Entity
      {
         return this._parentMesh;
      }
      
      public function get subGeometry() : ISubGeometry
      {
         return this._subGeometry;
      }
      
      public function set subGeometry(param1:ISubGeometry) : void
      {
         this._subGeometry = param1;
      }
      
      public function get material() : MaterialBase
      {
         return this._material || this._parentMesh.material;
      }
      
      public function set material(param1:MaterialBase) : void
      {
         if(this._material)
         {
            this._material.removeOwner(this);
         }
         this._material = param1;
         if(this._material)
         {
            this._material.addOwner(this);
         }
      }
      
      public function get sceneTransform() : Matrix3D
      {
         return this._parentMesh.sceneTransform;
      }
      
      public function get inverseSceneTransform() : Matrix3D
      {
         return this._parentMesh.inverseSceneTransform;
      }
      
      public function activateVertexBuffer(param1:int, param2:Stage3DProxy) : void
      {
         this._subGeometry.activateVertexBuffer(param1,param2);
      }
      
      public function activateVertexNormalBuffer(param1:int, param2:Stage3DProxy) : void
      {
         this._subGeometry.activateVertexNormalBuffer(param1,param2);
      }
      
      public function activateVertexTangentBuffer(param1:int, param2:Stage3DProxy) : void
      {
         this._subGeometry.activateVertexTangentBuffer(param1,param2);
      }
      
      public function activateUVBuffer(param1:int, param2:Stage3DProxy) : void
      {
         this._subGeometry.activateUVBuffer(param1,param2);
      }
      
      public function activateSecondaryUVBuffer(param1:int, param2:Stage3DProxy) : void
      {
         this._subGeometry.activateSecondaryUVBuffer(param1,param2);
      }
      
      public function getIndexBuffer(param1:Stage3DProxy) : IndexBuffer3D
      {
         return this._subGeometry.getIndexBuffer(param1);
      }
      
      public function get numTriangles() : uint
      {
         return this._subGeometry.numTriangles;
      }
      
      public function get animator() : IAnimator
      {
         return this._parentMesh.animator;
      }
      
      public function get mouseEnabled() : Boolean
      {
         return this._parentMesh.mouseEnabled || this._parentMesh._ancestorsAllowMouseEnabled;
      }
      
      public function get castsShadows() : Boolean
      {
         return this._parentMesh.castsShadows;
      }
      
      arcane function get parentMesh() : Mesh
      {
         return this._parentMesh;
      }
      
      arcane function set parentMesh(param1:Mesh) : void
      {
         this._parentMesh = param1;
      }
      
      public function get uvTransform() : Matrix
      {
         if(this._uvTransformDirty)
         {
            this.updateUVTransform();
         }
         return this._uvTransform;
      }
      
      private function updateUVTransform() : void
      {
         this._uvTransform = this._uvTransform || new Matrix();
         this._uvTransform.identity();
         if(this._uvRotation != 0)
         {
            this._uvTransform.rotate(this._uvRotation);
         }
         if(this._scaleU != 1 || this._scaleV != 1)
         {
            this._uvTransform.scale(this._scaleU,this._scaleV);
         }
         this._uvTransform.translate(this._offsetU,this._offsetV);
         this._uvTransformDirty = false;
      }
      
      public function dispose() : void
      {
         if(Boolean(this.animationSubGeometry) && !this._parentMesh.shareAnimationGeometry)
         {
            this.animationSubGeometry.dispose();
         }
         this.animationSubGeometry = null;
         this.material = null;
      }
      
      public function get vertexData() : Vector.<Number>
      {
         return this._subGeometry.vertexData;
      }
      
      public function get indexData() : Vector.<uint>
      {
         return this._subGeometry.indexData;
      }
      
      public function get UVData() : Vector.<Number>
      {
         return this._subGeometry.UVData;
      }
      
      public function get bounds() : BoundingVolumeBase
      {
         return this._parentMesh.bounds;
      }
      
      public function get visible() : Boolean
      {
         return this._parentMesh.visible;
      }
      
      public function get numVertices() : uint
      {
         return this._subGeometry.numVertices;
      }
      
      public function get vertexStride() : uint
      {
         return this._subGeometry.vertexStride;
      }
      
      public function get UVStride() : uint
      {
         return this._subGeometry.UVStride;
      }
      
      public function get vertexNormalData() : Vector.<Number>
      {
         return this._subGeometry.vertexNormalData;
      }
      
      public function get vertexTangentData() : Vector.<Number>
      {
         return this._subGeometry.vertexTangentData;
      }
      
      public function get UVOffset() : uint
      {
         return this._subGeometry.UVOffset;
      }
      
      public function get vertexOffset() : uint
      {
         return this._subGeometry.vertexOffset;
      }
      
      public function get vertexNormalOffset() : uint
      {
         return this._subGeometry.vertexNormalOffset;
      }
      
      public function get vertexTangentOffset() : uint
      {
         return this._subGeometry.vertexTangentOffset;
      }
      
      public function getRenderSceneTransform(param1:Camera3D) : Matrix3D
      {
         return this._parentMesh.sceneTransform;
      }
      
      public function get shaderParams() : Object
      {
         return this._parentMesh.shaderParams;
      }
   }
}

