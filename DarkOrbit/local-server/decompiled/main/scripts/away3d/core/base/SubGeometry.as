package away3d.core.base
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.display3D.VertexBuffer3D;
   import flash.geom.Matrix3D;
   
   use namespace arcane;
   
   public class SubGeometry extends SubGeometryBase implements ISubGeometry
   {
      
      protected var _uvs:Vector.<Number>;
      
      protected var _secondaryUvs:Vector.<Number>;
      
      protected var _vertexNormals:Vector.<Number>;
      
      protected var _vertexTangents:Vector.<Number>;
      
      protected var _verticesInvalid:Vector.<Boolean> = new Vector.<Boolean>(8,true);
      
      protected var _uvsInvalid:Vector.<Boolean> = new Vector.<Boolean>(8,true);
      
      protected var _secondaryUvsInvalid:Vector.<Boolean> = new Vector.<Boolean>(8,true);
      
      protected var _normalsInvalid:Vector.<Boolean> = new Vector.<Boolean>(8,true);
      
      protected var _tangentsInvalid:Vector.<Boolean> = new Vector.<Boolean>(8,true);
      
      protected var _vertexBuffer:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>(8);
      
      protected var _uvBuffer:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>(8);
      
      protected var _secondaryUvBuffer:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>(8);
      
      protected var _vertexNormalBuffer:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>(8);
      
      protected var _vertexTangentBuffer:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>(8);
      
      protected var _vertexBufferContext:Vector.<Context3D> = new Vector.<Context3D>(8);
      
      protected var _uvBufferContext:Vector.<Context3D> = new Vector.<Context3D>(8);
      
      protected var _secondaryUvBufferContext:Vector.<Context3D> = new Vector.<Context3D>(8);
      
      protected var _vertexNormalBufferContext:Vector.<Context3D> = new Vector.<Context3D>(8);
      
      protected var _vertexTangentBufferContext:Vector.<Context3D> = new Vector.<Context3D>(8);
      
      protected var _numVertices:uint;
      
      public function SubGeometry()
      {
         super();
      }
      
      public function get numVertices() : uint
      {
         return this._numVertices;
      }
      
      public function activateVertexBuffer(param1:int, param2:Stage3DProxy) : void
      {
         var _loc3_:int = param2._stage3DIndex;
         var _loc4_:Context3D = param2._context3D;
         if(!this._vertexBuffer[_loc3_] || this._vertexBufferContext[_loc3_] != _loc4_)
         {
            this._vertexBuffer[_loc3_] = _loc4_.createVertexBuffer(this._numVertices,3);
            this._vertexBufferContext[_loc3_] = _loc4_;
            this._verticesInvalid[_loc3_] = true;
         }
         if(this._verticesInvalid[_loc3_])
         {
            this._vertexBuffer[_loc3_].uploadFromVector(_vertexData,0,this._numVertices);
            this._verticesInvalid[_loc3_] = false;
         }
         _loc4_.setVertexBufferAt(param1,this._vertexBuffer[_loc3_],0,Context3DVertexBufferFormat.FLOAT_3);
      }
      
      public function activateUVBuffer(param1:int, param2:Stage3DProxy) : void
      {
         var _loc3_:int = param2._stage3DIndex;
         var _loc4_:Context3D = param2._context3D;
         if(_autoGenerateUVs && _uvsDirty)
         {
            this._uvs = this.updateDummyUVs(this._uvs);
         }
         if(!this._uvBuffer[_loc3_] || this._uvBufferContext[_loc3_] != _loc4_)
         {
            this._uvBuffer[_loc3_] = _loc4_.createVertexBuffer(this._numVertices,2);
            this._uvBufferContext[_loc3_] = _loc4_;
            this._uvsInvalid[_loc3_] = true;
         }
         if(this._uvsInvalid[_loc3_])
         {
            this._uvBuffer[_loc3_].uploadFromVector(this._uvs,0,this._numVertices);
            this._uvsInvalid[_loc3_] = false;
         }
         _loc4_.setVertexBufferAt(param1,this._uvBuffer[_loc3_],0,Context3DVertexBufferFormat.FLOAT_2);
      }
      
      public function activateSecondaryUVBuffer(param1:int, param2:Stage3DProxy) : void
      {
         var _loc3_:int = param2._stage3DIndex;
         var _loc4_:Context3D = param2._context3D;
         if(!this._secondaryUvBuffer[_loc3_] || this._secondaryUvBufferContext[_loc3_] != _loc4_)
         {
            this._secondaryUvBuffer[_loc3_] = _loc4_.createVertexBuffer(this._numVertices,2);
            this._secondaryUvBufferContext[_loc3_] = _loc4_;
            this._secondaryUvsInvalid[_loc3_] = true;
         }
         if(this._secondaryUvsInvalid[_loc3_])
         {
            this._secondaryUvBuffer[_loc3_].uploadFromVector(this._secondaryUvs,0,this._numVertices);
            this._secondaryUvsInvalid[_loc3_] = false;
         }
         _loc4_.setVertexBufferAt(param1,this._secondaryUvBuffer[_loc3_],0,Context3DVertexBufferFormat.FLOAT_2);
      }
      
      public function activateVertexNormalBuffer(param1:int, param2:Stage3DProxy) : void
      {
         var _loc3_:int = param2._stage3DIndex;
         var _loc4_:Context3D = param2._context3D;
         if(_autoDeriveVertexNormals && _vertexNormalsDirty)
         {
            this._vertexNormals = this.updateVertexNormals(this._vertexNormals);
         }
         if(!this._vertexNormalBuffer[_loc3_] || this._vertexNormalBufferContext[_loc3_] != _loc4_)
         {
            this._vertexNormalBuffer[_loc3_] = _loc4_.createVertexBuffer(this._numVertices,3);
            this._vertexNormalBufferContext[_loc3_] = _loc4_;
            this._normalsInvalid[_loc3_] = true;
         }
         if(this._normalsInvalid[_loc3_])
         {
            this._vertexNormalBuffer[_loc3_].uploadFromVector(this._vertexNormals,0,this._numVertices);
            this._normalsInvalid[_loc3_] = false;
         }
         _loc4_.setVertexBufferAt(param1,this._vertexNormalBuffer[_loc3_],0,Context3DVertexBufferFormat.FLOAT_3);
      }
      
      public function activateVertexTangentBuffer(param1:int, param2:Stage3DProxy) : void
      {
         var _loc3_:int = param2._stage3DIndex;
         var _loc4_:Context3D = param2._context3D;
         if(_vertexTangentsDirty)
         {
            this._vertexTangents = this.updateVertexTangents(this._vertexTangents);
         }
         if(!this._vertexTangentBuffer[_loc3_] || this._vertexTangentBufferContext[_loc3_] != _loc4_)
         {
            this._vertexTangentBuffer[_loc3_] = _loc4_.createVertexBuffer(this._numVertices,3);
            this._vertexTangentBufferContext[_loc3_] = _loc4_;
            this._tangentsInvalid[_loc3_] = true;
         }
         if(this._tangentsInvalid[_loc3_])
         {
            this._vertexTangentBuffer[_loc3_].uploadFromVector(this._vertexTangents,0,this._numVertices);
            this._tangentsInvalid[_loc3_] = false;
         }
         _loc4_.setVertexBufferAt(param1,this._vertexTangentBuffer[_loc3_],0,Context3DVertexBufferFormat.FLOAT_3);
      }
      
      override public function applyTransformation(param1:Matrix3D) : void
      {
         super.applyTransformation(param1);
         invalidateBuffers(this._verticesInvalid);
         invalidateBuffers(this._normalsInvalid);
         invalidateBuffers(this._tangentsInvalid);
      }
      
      public function clone() : ISubGeometry
      {
         var _loc1_:SubGeometry = new SubGeometry();
         _loc1_.updateVertexData(_vertexData.concat());
         _loc1_.updateUVData(this._uvs.concat());
         _loc1_.updateIndexData(_indices.concat());
         if(this._secondaryUvs)
         {
            _loc1_.updateSecondaryUVData(this._secondaryUvs.concat());
         }
         if(!_autoDeriveVertexNormals)
         {
            _loc1_.updateVertexNormalData(this._vertexNormals.concat());
         }
         if(!_autoDeriveVertexTangents)
         {
            _loc1_.updateVertexTangentData(this._vertexTangents.concat());
         }
         return _loc1_;
      }
      
      override public function scale(param1:Number) : void
      {
         super.scale(param1);
         invalidateBuffers(this._verticesInvalid);
      }
      
      override public function scaleUV(param1:Number = 1, param2:Number = 1) : void
      {
         super.scaleUV(param1,param2);
         invalidateBuffers(this._uvsInvalid);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.disposeAllVertexBuffers();
         this._vertexBuffer = null;
         this._vertexNormalBuffer = null;
         this._uvBuffer = null;
         this._secondaryUvBuffer = null;
         this._vertexTangentBuffer = null;
         _indexBuffer = null;
         this._uvs = null;
         this._secondaryUvs = null;
         this._vertexNormals = null;
         this._vertexTangents = null;
         this._vertexBufferContext = null;
         this._uvBufferContext = null;
         this._secondaryUvBufferContext = null;
         this._vertexNormalBufferContext = null;
         this._vertexTangentBufferContext = null;
      }
      
      protected function disposeAllVertexBuffers() : void
      {
         disposeVertexBuffers(this._vertexBuffer);
         disposeVertexBuffers(this._vertexNormalBuffer);
         disposeVertexBuffers(this._uvBuffer);
         disposeVertexBuffers(this._secondaryUvBuffer);
         disposeVertexBuffers(this._vertexTangentBuffer);
      }
      
      override public function get vertexData() : Vector.<Number>
      {
         return _vertexData;
      }
      
      override public function get vertexPositionData() : Vector.<Number>
      {
         return _vertexData;
      }
      
      public function updateVertexData(param1:Vector.<Number>) : void
      {
         if(_autoDeriveVertexNormals)
         {
            _vertexNormalsDirty = true;
         }
         if(_autoDeriveVertexTangents)
         {
            _vertexTangentsDirty = true;
         }
         _faceNormalsDirty = true;
         _vertexData = param1;
         var _loc2_:int = param1.length / 3;
         if(_loc2_ != this._numVertices)
         {
            this.disposeAllVertexBuffers();
         }
         this._numVertices = _loc2_;
         invalidateBuffers(this._verticesInvalid);
         invalidateBounds();
      }
      
      override public function get UVData() : Vector.<Number>
      {
         if(_uvsDirty && _autoGenerateUVs)
         {
            this._uvs = this.updateDummyUVs(this._uvs);
         }
         return this._uvs;
      }
      
      override public function get SecondaryUVData() : Vector.<Number>
      {
         return this._secondaryUvs;
      }
      
      public function updateUVData(param1:Vector.<Number>) : void
      {
         if(_autoDeriveVertexTangents)
         {
            _vertexTangentsDirty = true;
         }
         _faceTangentsDirty = true;
         this._uvs = param1;
         invalidateBuffers(this._uvsInvalid);
      }
      
      public function updateSecondaryUVData(param1:Vector.<Number>) : void
      {
         this._secondaryUvs = param1;
         invalidateBuffers(this._secondaryUvsInvalid);
      }
      
      override public function get vertexNormalData() : Vector.<Number>
      {
         if(_autoDeriveVertexNormals && _vertexNormalsDirty)
         {
            this._vertexNormals = this.updateVertexNormals(this._vertexNormals);
         }
         return this._vertexNormals;
      }
      
      public function updateVertexNormalData(param1:Vector.<Number>) : void
      {
         _vertexNormalsDirty = false;
         _autoDeriveVertexNormals = param1 == null;
         this._vertexNormals = param1;
         invalidateBuffers(this._normalsInvalid);
      }
      
      override public function get vertexTangentData() : Vector.<Number>
      {
         if(_autoDeriveVertexTangents && _vertexTangentsDirty)
         {
            this._vertexTangents = this.updateVertexTangents(this._vertexTangents);
         }
         return this._vertexTangents;
      }
      
      public function updateVertexTangentData(param1:Vector.<Number>) : void
      {
         _vertexTangentsDirty = false;
         _autoDeriveVertexTangents = param1 == null;
         this._vertexTangents = param1;
         invalidateBuffers(this._tangentsInvalid);
      }
      
      public function fromVectors(param1:Vector.<Number>, param2:Vector.<Number>, param3:Vector.<Number>, param4:Vector.<Number>, param5:Vector.<Number> = null) : void
      {
         this.updateVertexData(param1);
         this.updateUVData(param2);
         this.updateVertexNormalData(param3);
         this.updateVertexTangentData(param4);
         if(Boolean(param5) && Boolean(param5.length))
         {
            this.updateSecondaryUVData(param5);
            hasSecondaryUVs = true;
         }
      }
      
      override protected function updateVertexNormals(param1:Vector.<Number>) : Vector.<Number>
      {
         invalidateBuffers(this._normalsInvalid);
         return super.updateVertexNormals(param1);
      }
      
      override protected function updateVertexTangents(param1:Vector.<Number>) : Vector.<Number>
      {
         if(_vertexNormalsDirty)
         {
            this._vertexNormals = this.updateVertexNormals(this._vertexNormals);
         }
         invalidateBuffers(this._tangentsInvalid);
         return super.updateVertexTangents(param1);
      }
      
      override protected function updateDummyUVs(param1:Vector.<Number>) : Vector.<Number>
      {
         invalidateBuffers(this._uvsInvalid);
         return super.updateDummyUVs(param1);
      }
      
      protected function disposeForStage3D(param1:Stage3DProxy) : void
      {
         var _loc2_:int = param1._stage3DIndex;
         if(this._vertexBuffer[_loc2_])
         {
            this._vertexBuffer[_loc2_].dispose();
            this._vertexBuffer[_loc2_] = null;
         }
         if(this._uvBuffer[_loc2_])
         {
            this._uvBuffer[_loc2_].dispose();
            this._uvBuffer[_loc2_] = null;
         }
         if(this._secondaryUvBuffer[_loc2_])
         {
            this._secondaryUvBuffer[_loc2_].dispose();
            this._secondaryUvBuffer[_loc2_] = null;
         }
         if(this._vertexNormalBuffer[_loc2_])
         {
            this._vertexNormalBuffer[_loc2_].dispose();
            this._vertexNormalBuffer[_loc2_] = null;
         }
         if(this._vertexTangentBuffer[_loc2_])
         {
            this._vertexTangentBuffer[_loc2_].dispose();
            this._vertexTangentBuffer[_loc2_] = null;
         }
         if(_indexBuffer[_loc2_])
         {
            _indexBuffer[_loc2_].dispose();
            _indexBuffer[_loc2_] = null;
         }
      }
      
      override public function get vertexStride() : uint
      {
         return 3;
      }
      
      override public function get vertexTangentStride() : uint
      {
         return 3;
      }
      
      override public function get vertexNormalStride() : uint
      {
         return 3;
      }
      
      override public function get UVStride() : uint
      {
         return 2;
      }
      
      public function get secondaryUVStride() : uint
      {
         return 2;
      }
      
      override public function get vertexOffset() : int
      {
         return 0;
      }
      
      override public function get vertexNormalOffset() : int
      {
         return 0;
      }
      
      override public function get vertexTangentOffset() : int
      {
         return 0;
      }
      
      override public function get UVOffset() : int
      {
         return 0;
      }
      
      public function get secondaryUVOffset() : int
      {
         return 0;
      }
      
      public function cloneWithSeperateBuffers() : SubGeometry
      {
         return SubGeometry(this.clone());
      }
   }
}

