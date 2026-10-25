package away3d.core.base
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.display3D.VertexBuffer3D;
   import flash.geom.Matrix3D;
   
   use namespace arcane;
   
   public class CompactSubGeometry extends SubGeometryBase implements ISubGeometry
   {
      
      protected var _vertexDataInvalid:Vector.<Boolean> = new Vector.<Boolean>(8,true);
      
      protected var _vertexBuffer:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>(8);
      
      protected var _bufferContext:Vector.<Context3D> = new Vector.<Context3D>(8);
      
      protected var _numVertices:uint;
      
      protected var _contextIndex:int;
      
      protected var _activeBuffer:VertexBuffer3D;
      
      protected var _activeContext:Context3D;
      
      protected var _activeDataInvalid:Boolean;
      
      private var _isolatedVertexPositionData:Vector.<Number>;
      
      private var _isolatedVertexPositionDataDirty:Boolean;
      
      public function CompactSubGeometry()
      {
         super();
         _autoDeriveVertexNormals = false;
         _autoDeriveVertexTangents = false;
      }
      
      public function get numVertices() : uint
      {
         return this._numVertices;
      }
      
      public function updateData(param1:Vector.<Number>) : void
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
         _faceTangentsDirty = true;
         this._isolatedVertexPositionDataDirty = true;
         _vertexData = param1;
         var _loc2_:int = _vertexData.length / 13;
         if(_loc2_ != this._numVertices)
         {
            this.disposeVertexBuffers(this._vertexBuffer);
         }
         this._numVertices = _loc2_;
         if(this._numVertices == 0)
         {
            throw new Error("Bad data: geometry can\'t have zero triangles");
         }
         this.invalidateBuffers(this._vertexDataInvalid);
         invalidateBounds();
      }
      
      public function activateVertexBuffer(param1:int, param2:Stage3DProxy) : void
      {
         var _loc3_:int = param2._stage3DIndex;
         var _loc4_:Context3D = param2._context3D;
         if(_loc3_ != this._contextIndex)
         {
            this.updateActiveBuffer(_loc3_);
         }
         if(!this._activeBuffer || this._activeContext != _loc4_)
         {
            this.createBuffer(_loc3_,_loc4_);
         }
         if(this._activeDataInvalid)
         {
            this.uploadData(_loc3_);
         }
         _loc4_.setVertexBufferAt(param1,this._activeBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
      }
      
      public function activateUVBuffer(param1:int, param2:Stage3DProxy) : void
      {
         var _loc3_:int = param2._stage3DIndex;
         var _loc4_:Context3D = param2._context3D;
         if(_uvsDirty && _autoGenerateUVs)
         {
            _vertexData = updateDummyUVs(_vertexData);
            this.invalidateBuffers(this._vertexDataInvalid);
         }
         if(_loc3_ != this._contextIndex)
         {
            this.updateActiveBuffer(_loc3_);
         }
         if(!this._activeBuffer || this._activeContext != _loc4_)
         {
            this.createBuffer(_loc3_,_loc4_);
         }
         if(this._activeDataInvalid)
         {
            this.uploadData(_loc3_);
         }
         _loc4_.setVertexBufferAt(param1,this._activeBuffer,9,Context3DVertexBufferFormat.FLOAT_2);
      }
      
      public function activateSecondaryUVBuffer(param1:int, param2:Stage3DProxy) : void
      {
         var _loc3_:int = param2._stage3DIndex;
         var _loc4_:Context3D = param2._context3D;
         if(_loc3_ != this._contextIndex)
         {
            this.updateActiveBuffer(_loc3_);
         }
         if(!this._activeBuffer || this._activeContext != _loc4_)
         {
            this.createBuffer(_loc3_,_loc4_);
         }
         if(this._activeDataInvalid)
         {
            this.uploadData(_loc3_);
         }
         _loc4_.setVertexBufferAt(param1,this._activeBuffer,11,Context3DVertexBufferFormat.FLOAT_2);
      }
      
      protected function uploadData(param1:int) : void
      {
         this._activeBuffer.uploadFromVector(_vertexData,0,this._numVertices);
         this._vertexDataInvalid[param1] = this._activeDataInvalid = false;
      }
      
      public function activateVertexNormalBuffer(param1:int, param2:Stage3DProxy) : void
      {
         var _loc3_:int = param2._stage3DIndex;
         var _loc4_:Context3D = param2._context3D;
         if(_loc3_ != this._contextIndex)
         {
            this.updateActiveBuffer(_loc3_);
         }
         if(!this._activeBuffer || this._activeContext != _loc4_)
         {
            this.createBuffer(_loc3_,_loc4_);
         }
         if(this._activeDataInvalid)
         {
            this.uploadData(_loc3_);
         }
         _loc4_.setVertexBufferAt(param1,this._activeBuffer,3,Context3DVertexBufferFormat.FLOAT_3);
      }
      
      public function activateVertexTangentBuffer(param1:int, param2:Stage3DProxy) : void
      {
         var _loc3_:int = param2._stage3DIndex;
         var _loc4_:Context3D = param2._context3D;
         if(_loc3_ != this._contextIndex)
         {
            this.updateActiveBuffer(_loc3_);
         }
         if(!this._activeBuffer || this._activeContext != _loc4_)
         {
            this.createBuffer(_loc3_,_loc4_);
         }
         if(this._activeDataInvalid)
         {
            this.uploadData(_loc3_);
         }
         _loc4_.setVertexBufferAt(param1,this._activeBuffer,6,Context3DVertexBufferFormat.FLOAT_3);
      }
      
      protected function createBuffer(param1:int, param2:Context3D) : void
      {
         this._vertexBuffer[param1] = this._activeBuffer = param2.createVertexBuffer(this._numVertices,13);
         this._bufferContext[param1] = this._activeContext = param2;
         this._vertexDataInvalid[param1] = this._activeDataInvalid = true;
      }
      
      protected function updateActiveBuffer(param1:int) : void
      {
         this._contextIndex = param1;
         this._activeDataInvalid = this._vertexDataInvalid[param1];
         this._activeBuffer = this._vertexBuffer[param1];
         this._activeContext = this._bufferContext[param1];
      }
      
      override public function get vertexData() : Vector.<Number>
      {
         if(_autoDeriveVertexNormals && _vertexNormalsDirty)
         {
            _vertexData = this.updateVertexNormals(_vertexData);
         }
         if(_autoDeriveVertexTangents && _vertexTangentsDirty)
         {
            _vertexData = this.updateVertexTangents(_vertexData);
         }
         if(_uvsDirty && _autoGenerateUVs)
         {
            _vertexData = updateDummyUVs(_vertexData);
         }
         return _vertexData;
      }
      
      override protected function updateVertexNormals(param1:Vector.<Number>) : Vector.<Number>
      {
         this.invalidateBuffers(this._vertexDataInvalid);
         return super.updateVertexNormals(param1);
      }
      
      override protected function updateVertexTangents(param1:Vector.<Number>) : Vector.<Number>
      {
         if(_vertexNormalsDirty)
         {
            _vertexData = this.updateVertexNormals(_vertexData);
         }
         this.invalidateBuffers(this._vertexDataInvalid);
         return super.updateVertexTangents(param1);
      }
      
      override public function get vertexNormalData() : Vector.<Number>
      {
         if(_autoDeriveVertexNormals && _vertexNormalsDirty)
         {
            _vertexData = this.updateVertexNormals(_vertexData);
         }
         return _vertexData;
      }
      
      override public function get vertexTangentData() : Vector.<Number>
      {
         if(_autoDeriveVertexTangents && _vertexTangentsDirty)
         {
            _vertexData = this.updateVertexTangents(_vertexData);
         }
         return _vertexData;
      }
      
      override public function get UVData() : Vector.<Number>
      {
         if(_uvsDirty && _autoGenerateUVs)
         {
            _vertexData = updateDummyUVs(_vertexData);
            this.invalidateBuffers(this._vertexDataInvalid);
         }
         return _vertexData;
      }
      
      override public function get SecondaryUVData() : Vector.<Number>
      {
         return _vertexData;
      }
      
      override public function applyTransformation(param1:Matrix3D) : void
      {
         super.applyTransformation(param1);
         this.invalidateBuffers(this._vertexDataInvalid);
      }
      
      override public function scale(param1:Number) : void
      {
         super.scale(param1);
         this.invalidateBuffers(this._vertexDataInvalid);
      }
      
      public function clone() : ISubGeometry
      {
         var _loc1_:CompactSubGeometry = new CompactSubGeometry();
         _loc1_._autoDeriveVertexNormals = _autoDeriveVertexNormals;
         _loc1_._autoDeriveVertexTangents = _autoDeriveVertexTangents;
         _loc1_.updateData(_vertexData.concat());
         _loc1_.updateIndexData(_indices.concat());
         return _loc1_;
      }
      
      override public function scaleUV(param1:Number = 1, param2:Number = 1) : void
      {
         super.scaleUV(param1,param2);
         this.invalidateBuffers(this._vertexDataInvalid);
      }
      
      override public function get vertexStride() : uint
      {
         return 13;
      }
      
      override public function get vertexNormalStride() : uint
      {
         return 13;
      }
      
      override public function get vertexTangentStride() : uint
      {
         return 13;
      }
      
      override public function get UVStride() : uint
      {
         return 13;
      }
      
      public function get secondaryUVStride() : uint
      {
         return 13;
      }
      
      override public function get vertexOffset() : int
      {
         return 0;
      }
      
      override public function get vertexNormalOffset() : int
      {
         return 3;
      }
      
      override public function get vertexTangentOffset() : int
      {
         return 6;
      }
      
      override public function get UVOffset() : int
      {
         return 9;
      }
      
      public function get secondaryUVOffset() : int
      {
         return 11;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.disposeVertexBuffers(this._vertexBuffer);
         this._vertexBuffer = null;
      }
      
      override protected function disposeVertexBuffers(param1:Vector.<VertexBuffer3D>) : void
      {
         super.disposeVertexBuffers(param1);
         this._activeBuffer = null;
      }
      
      override protected function invalidateBuffers(param1:Vector.<Boolean>) : void
      {
         super.invalidateBuffers(param1);
         this._activeDataInvalid = true;
      }
      
      public function cloneWithSeperateBuffers() : SubGeometry
      {
         var _loc1_:SubGeometry = new SubGeometry();
         _loc1_.updateVertexData(this._isolatedVertexPositionData ? this._isolatedVertexPositionData : (this._isolatedVertexPositionData = this.stripBuffer(0,3)));
         _loc1_.autoDeriveVertexNormals = _autoDeriveVertexNormals;
         _loc1_.autoDeriveVertexTangents = _autoDeriveVertexTangents;
         if(!_autoDeriveVertexNormals)
         {
            _loc1_.updateVertexNormalData(this.stripBuffer(3,3));
         }
         if(!_autoDeriveVertexTangents)
         {
            _loc1_.updateVertexTangentData(this.stripBuffer(6,3));
         }
         _loc1_.updateUVData(this.stripBuffer(9,2));
         _loc1_.updateSecondaryUVData(this.stripBuffer(11,2));
         _loc1_.updateIndexData(indexData.concat());
         return _loc1_;
      }
      
      override public function get vertexPositionData() : Vector.<Number>
      {
         if(this._isolatedVertexPositionDataDirty || !this._isolatedVertexPositionData)
         {
            this._isolatedVertexPositionData = this.stripBuffer(0,3);
            this._isolatedVertexPositionDataDirty = false;
         }
         return this._isolatedVertexPositionData;
      }
      
      public function stripBuffer(param1:int, param2:int) : Vector.<Number>
      {
         var _loc8_:int = 0;
         var _loc3_:Vector.<Number> = new Vector.<Number>(this._numVertices * param2);
         var _loc4_:* = 0;
         var _loc5_:* = param1;
         var _loc6_:int = 13 - param2;
         var _loc7_:int = 0;
         while(_loc7_ < this._numVertices)
         {
            _loc8_ = 0;
            while(_loc8_ < param2)
            {
               var _loc9_:Number;
               _loc3_[_loc9_ = _loc4_++] = _vertexData[_loc5_++];
               _loc8_++;
            }
            _loc5_ += _loc6_;
            _loc7_++;
         }
         return _loc3_;
      }
      
      public function fromVectors(param1:Vector.<Number>, param2:Vector.<Number>, param3:Vector.<Number>, param4:Vector.<Number>, param5:Vector.<Number> = null) : void
      {
         var _loc6_:int = param1.length / 3 * 13;
         hasSecondaryUVs = Boolean(param5) && Boolean(param5.length);
         if(!param5)
         {
            param5 = param2;
         }
         else if(param5.length != param2.length)
         {
            param5 = param2;
         }
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc10_:* = 0;
         var _loc11_:* = 0;
         var _loc12_:Vector.<Number> = new Vector.<Number>(_loc6_,true);
         while(_loc7_ < _loc6_)
         {
            if(_loc7_ >= _loc12_.length - 1 || param2 != null && _loc11_ >= param2.length - 1)
            {
               _loc7_++;
            }
            else
            {
               var _loc13_:Number;
               _loc12_[_loc13_ = _loc7_++] = param1[_loc8_++];
               var _loc14_:Number;
               _loc12_[_loc14_ = _loc7_++] = param1[_loc8_++];
               var _loc15_:Number;
               _loc12_[_loc15_ = _loc7_++] = param1[_loc8_++];
               if(Boolean(param3) && Boolean(param3.length))
               {
                  var _loc16_:Number;
                  _loc12_[_loc16_ = _loc7_++] = param3[_loc9_++];
                  var _loc17_:Number;
                  _loc12_[_loc17_ = _loc7_++] = param3[_loc9_++];
                  var _loc18_:Number;
                  _loc12_[_loc18_ = _loc7_++] = param3[_loc9_++];
               }
               else
               {
                  _loc12_[_loc16_ = _loc7_++] = 0;
                  _loc12_[_loc17_ = _loc7_++] = 0;
                  _loc12_[_loc18_ = _loc7_++] = 0;
               }
               if(Boolean(param4) && Boolean(param4.length))
               {
                  _loc12_[_loc16_ = _loc7_++] = param4[_loc10_++];
                  _loc12_[_loc17_ = _loc7_++] = param4[_loc10_++];
                  _loc12_[_loc18_ = _loc7_++] = param4[_loc10_++];
               }
               else
               {
                  _loc12_[_loc16_ = _loc7_++] = 0;
                  _loc12_[_loc17_ = _loc7_++] = 0;
                  _loc12_[_loc18_ = _loc7_++] = 0;
               }
               if(Boolean(param2) && Boolean(param2.length))
               {
                  _loc12_[_loc16_ = _loc7_++] = param2[_loc11_];
                  _loc12_[_loc17_ = _loc7_++] = param2[_loc11_ + 1];
                  if(Boolean(param5) && Boolean(param5.length))
                  {
                     _loc12_[_loc18_ = _loc7_++] = param5[_loc11_++];
                     var _loc19_:Number;
                     _loc12_[_loc19_ = _loc7_++] = param5[_loc11_++];
                  }
                  else
                  {
                     _loc12_[_loc18_ = _loc7_++] = param2[_loc11_++];
                     _loc12_[_loc19_ = _loc7_++] = param2[_loc11_++];
                  }
               }
               else
               {
                  _loc12_[_loc16_ = _loc7_++] = 0;
                  _loc12_[_loc17_ = _loc7_++] = 0;
                  _loc12_[_loc18_ = _loc7_++] = 0;
                  _loc12_[_loc19_ = _loc7_++] = 0;
               }
            }
         }
         autoDeriveVertexNormals = !(param3 && param3.length);
         autoDeriveVertexTangents = !(param4 && param4.length);
         autoGenerateDummyUVs = !(param2 && param2.length);
         this.updateData(_loc12_);
      }
   }
}

