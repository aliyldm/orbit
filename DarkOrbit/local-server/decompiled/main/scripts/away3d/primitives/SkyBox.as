package away3d.primitives
{
   import away3d.animators.IAnimator;
   import away3d.arcane;
   import away3d.bounds.BoundingVolumeBase;
   import away3d.bounds.NullBounds;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.base.SubGeometry;
   import away3d.core.managers.Stage3DProxy;
   import away3d.core.partition.EntityNode;
   import away3d.core.partition.SkyBoxNode;
   import away3d.entities.Entity;
   import away3d.errors.AbstractMethodError;
   import away3d.library.assets.AssetType;
   import away3d.materials.MaterialBase;
   import away3d.materials.SkyBoxMaterial;
   import away3d.textures.CubeTextureBase;
   import flash.display3D.IndexBuffer3D;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   
   use namespace arcane;
   
   public class SkyBox extends Entity implements IRenderable
   {
      
      private var _geometry:SubGeometry;
      
      private var _material:SkyBoxMaterial;
      
      private var _uvTransform:Matrix = new Matrix();
      
      private var _animator:IAnimator;
      
      public function SkyBox(param1:CubeTextureBase)
      {
         super();
         this._material = new SkyBoxMaterial(param1);
         this._material.addOwner(this);
         this._geometry = new SubGeometry();
         this.buildGeometry(this._geometry);
      }
      
      public function get animator() : IAnimator
      {
         return this._animator;
      }
      
      override protected function getDefaultBoundingVolume() : BoundingVolumeBase
      {
         return new NullBounds();
      }
      
      public function get shaderParams() : Object
      {
         return null;
      }
      
      public function activateVertexBuffer(param1:int, param2:Stage3DProxy) : void
      {
         this._geometry.activateVertexBuffer(param1,param2);
      }
      
      public function activateUVBuffer(param1:int, param2:Stage3DProxy) : void
      {
      }
      
      public function activateVertexNormalBuffer(param1:int, param2:Stage3DProxy) : void
      {
      }
      
      public function activateVertexTangentBuffer(param1:int, param2:Stage3DProxy) : void
      {
      }
      
      public function activateSecondaryUVBuffer(param1:int, param2:Stage3DProxy) : void
      {
      }
      
      public function getIndexBuffer(param1:Stage3DProxy) : IndexBuffer3D
      {
         return this._geometry.getIndexBuffer(param1);
      }
      
      public function get numTriangles() : uint
      {
         return this._geometry.numTriangles;
      }
      
      public function get sourceEntity() : Entity
      {
         return null;
      }
      
      public function get material() : MaterialBase
      {
         return this._material;
      }
      
      public function set material(param1:MaterialBase) : void
      {
         throw new AbstractMethodError("Unsupported method!");
      }
      
      override public function get assetType() : String
      {
         return AssetType.SKYBOX;
      }
      
      override protected function invalidateBounds() : void
      {
      }
      
      override protected function createEntityPartitionNode() : EntityNode
      {
         return new SkyBoxNode(this);
      }
      
      override protected function updateBounds() : void
      {
         _boundsInvalid = false;
      }
      
      private function buildGeometry(param1:SubGeometry) : void
      {
         var _loc2_:Vector.<Number> = new <Number>[-1,1,-1,1,1,-1,1,1,1,-1,1,1,-1,-1,-1,1,-1,-1,1,-1,1,-1,-1,1];
         _loc2_.fixed = true;
         var _loc3_:Vector.<uint> = new <uint>[0,1,2,2,3,0,6,5,4,4,7,6,2,6,7,7,3,2,4,5,1,1,0,4,4,0,3,3,7,4,2,1,5,5,6,2];
         param1.updateVertexData(_loc2_);
         param1.updateIndexData(_loc3_);
      }
      
      public function get castsShadows() : Boolean
      {
         return false;
      }
      
      public function get uvTransform() : Matrix
      {
         return this._uvTransform;
      }
      
      public function get vertexData() : Vector.<Number>
      {
         return this._geometry.vertexData;
      }
      
      public function get indexData() : Vector.<uint>
      {
         return this._geometry.indexData;
      }
      
      public function get UVData() : Vector.<Number>
      {
         return this._geometry.UVData;
      }
      
      public function get numVertices() : uint
      {
         return this._geometry.numVertices;
      }
      
      public function get vertexStride() : uint
      {
         return this._geometry.vertexStride;
      }
      
      public function get vertexNormalData() : Vector.<Number>
      {
         return this._geometry.vertexNormalData;
      }
      
      public function get vertexTangentData() : Vector.<Number>
      {
         return this._geometry.vertexTangentData;
      }
      
      public function get vertexOffset() : int
      {
         return this._geometry.vertexOffset;
      }
      
      public function get vertexNormalOffset() : int
      {
         return this._geometry.vertexNormalOffset;
      }
      
      public function get vertexTangentOffset() : int
      {
         return this._geometry.vertexTangentOffset;
      }
      
      public function getRenderSceneTransform(param1:Camera3D) : Matrix3D
      {
         return _sceneTransform;
      }
   }
}

