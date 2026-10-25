package away3d.entities
{
   import away3d.animators.IAnimator;
   import away3d.arcane;
   import away3d.bounds.AxisAlignedBoundingBox;
   import away3d.bounds.BoundingVolumeBase;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.base.SubGeometry;
   import away3d.core.base.SubMesh;
   import away3d.core.managers.Stage3DProxy;
   import away3d.core.math.Matrix3DUtils;
   import away3d.core.partition.EntityNode;
   import away3d.core.partition.RenderableNode;
   import away3d.core.pick.IPickingCollider;
   import away3d.materials.MaterialBase;
   import flash.display3D.IndexBuffer3D;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class Sprite3D extends Entity implements IRenderable
   {
      
      private static var _geometry:SubGeometry;
      
      private var _material:MaterialBase;
      
      private var _spriteMatrix:Matrix3D;
      
      private var _animator:IAnimator;
      
      private var _pickingSubMesh:SubMesh;
      
      private var _pickingTransform:Matrix3D;
      
      private var _camera:Camera3D;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _shadowCaster:Boolean = false;
      
      public function Sprite3D(param1:MaterialBase, param2:Number, param3:Number)
      {
         super();
         this.material = param1;
         this._width = param2;
         this._height = param3;
         this._spriteMatrix = new Matrix3D();
         if(!_geometry)
         {
            _geometry = new SubGeometry();
            _geometry.updateVertexData(Vector.<Number>([-0.5,0.5,0,0.5,0.5,0,0.5,-0.5,0,-0.5,-0.5,0]));
            _geometry.updateUVData(Vector.<Number>([0,0,1,0,1,1,0,1]));
            _geometry.updateIndexData(Vector.<uint>([0,1,2,0,2,3]));
            _geometry.updateVertexTangentData(Vector.<Number>([1,0,0,1,0,0,1,0,0,1,0,0]));
            _geometry.updateVertexNormalData(Vector.<Number>([0,0,-1,0,0,-1,0,0,-1,0,0,-1]));
         }
      }
      
      override public function set pickingCollider(param1:IPickingCollider) : void
      {
         super.pickingCollider = param1;
         if(param1)
         {
            this._pickingSubMesh = new SubMesh(_geometry,null);
            this._pickingTransform = new Matrix3D();
         }
      }
      
      public function get width() : Number
      {
         return this._width;
      }
      
      public function set width(param1:Number) : void
      {
         if(this._width == param1)
         {
            return;
         }
         this._width = param1;
         invalidateTransform();
      }
      
      public function get height() : Number
      {
         return this._height;
      }
      
      public function set height(param1:Number) : void
      {
         if(this._height == param1)
         {
            return;
         }
         this._height = param1;
         invalidateTransform();
      }
      
      public function activateVertexBuffer(param1:int, param2:Stage3DProxy) : void
      {
         _geometry.activateVertexBuffer(param1,param2);
      }
      
      public function activateUVBuffer(param1:int, param2:Stage3DProxy) : void
      {
         _geometry.activateUVBuffer(param1,param2);
      }
      
      public function activateSecondaryUVBuffer(param1:int, param2:Stage3DProxy) : void
      {
         _geometry.activateSecondaryUVBuffer(param1,param2);
      }
      
      public function activateVertexNormalBuffer(param1:int, param2:Stage3DProxy) : void
      {
         _geometry.activateVertexNormalBuffer(param1,param2);
      }
      
      public function activateVertexTangentBuffer(param1:int, param2:Stage3DProxy) : void
      {
         _geometry.activateVertexTangentBuffer(param1,param2);
      }
      
      public function getIndexBuffer(param1:Stage3DProxy) : IndexBuffer3D
      {
         return _geometry.getIndexBuffer(param1);
      }
      
      public function get numTriangles() : uint
      {
         return 2;
      }
      
      public function get sourceEntity() : Entity
      {
         return this;
      }
      
      public function get material() : MaterialBase
      {
         return this._material;
      }
      
      public function set material(param1:MaterialBase) : void
      {
         if(param1 == this._material)
         {
            return;
         }
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
      
      public function get animator() : IAnimator
      {
         return this._animator;
      }
      
      public function get castsShadows() : Boolean
      {
         return this._shadowCaster;
      }
      
      override protected function getDefaultBoundingVolume() : BoundingVolumeBase
      {
         return new AxisAlignedBoundingBox();
      }
      
      override protected function updateBounds() : void
      {
         _bounds.fromExtremes(-0.5 * _scaleX,-0.5 * _scaleY,-0.5 * _scaleZ,0.5 * _scaleX,0.5 * _scaleY,0.5 * _scaleZ);
         _boundsInvalid = false;
      }
      
      override protected function createEntityPartitionNode() : EntityNode
      {
         return new RenderableNode(this);
      }
      
      override protected function updateTransform() : void
      {
         super.updateTransform();
         _transform.prependScale(this._width,this._height,Math.max(this._width,this._height));
      }
      
      public function get uvTransform() : Matrix
      {
         return null;
      }
      
      public function get vertexData() : Vector.<Number>
      {
         return _geometry.vertexData;
      }
      
      public function get indexData() : Vector.<uint>
      {
         return _geometry.indexData;
      }
      
      public function get UVData() : Vector.<Number>
      {
         return _geometry.UVData;
      }
      
      public function get numVertices() : uint
      {
         return _geometry.numVertices;
      }
      
      public function get vertexStride() : uint
      {
         return _geometry.vertexStride;
      }
      
      public function get vertexNormalData() : Vector.<Number>
      {
         return _geometry.vertexNormalData;
      }
      
      public function get vertexTangentData() : Vector.<Number>
      {
         return _geometry.vertexTangentData;
      }
      
      public function get vertexOffset() : int
      {
         return _geometry.vertexOffset;
      }
      
      public function get vertexNormalOffset() : int
      {
         return _geometry.vertexNormalOffset;
      }
      
      public function get vertexTangentOffset() : int
      {
         return _geometry.vertexTangentOffset;
      }
      
      override arcane function collidesBefore(param1:Number, param2:Boolean) : Boolean
      {
         param2 = param2;
         var _loc3_:Matrix3D = this._camera.inverseSceneTransform.clone();
         _loc3_.transpose();
         var _loc4_:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
         _loc3_.copyRawDataTo(_loc4_);
         _loc4_[3] = 0;
         _loc4_[7] = 0;
         _loc4_[11] = 0;
         _loc4_[12] = 0;
         _loc4_[13] = 0;
         _loc4_[14] = 0;
         this._pickingTransform.copyRawDataFrom(_loc4_);
         this._pickingTransform.prependScale(this._width,this._height,Math.max(this._width,this._height));
         this._pickingTransform.appendTranslation(scenePosition.x,scenePosition.y,scenePosition.z);
         this._pickingTransform.invert();
         var _loc5_:Vector3D = this._pickingTransform.transformVector(_pickingCollisionVO.rayPosition);
         var _loc6_:Vector3D = this._pickingTransform.deltaTransformVector(_pickingCollisionVO.rayDirection);
         _pickingCollider.setLocalRay(_loc5_,_loc6_);
         _pickingCollisionVO.renderable = null;
         if(_pickingCollider.testSubMeshCollision(this._pickingSubMesh,_pickingCollisionVO,param1))
         {
            _pickingCollisionVO.renderable = this._pickingSubMesh;
         }
         return _pickingCollisionVO.renderable != null;
      }
      
      public function getRenderSceneTransform(param1:Camera3D) : Matrix3D
      {
         var _loc2_:Vector.<Vector3D> = Matrix3DUtils.decompose(param1.sceneTransform);
         var _loc3_:Vector3D = _loc2_[2];
         _loc2_[0].x = scenePosition.x;
         _loc2_[0].y = scenePosition.y;
         _loc2_[0].z = scenePosition.z;
         _loc3_.x = this._width * _scaleX;
         _loc3_.y = this._height * _scaleY;
         this._spriteMatrix.recompose(_loc2_);
         return this._spriteMatrix;
      }
      
      public function get shaderParams() : Object
      {
         return null;
      }
   }
}

