package away3d.entities
{
   import away3d.animators.IAnimator;
   import away3d.arcane;
   import away3d.bounds.BoundingSphere;
   import away3d.bounds.BoundingVolumeBase;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import away3d.core.partition.EntityNode;
   import away3d.core.partition.RenderableNode;
   import away3d.library.assets.AssetType;
   import away3d.materials.MaterialBase;
   import away3d.materials.SegmentMaterial;
   import away3d.primitives.data.Segment;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.display3D.IndexBuffer3D;
   import flash.display3D.VertexBuffer3D;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class SegmentSet extends Entity implements IRenderable
   {
      
      private const LIMIT:uint = 196605;
      
      private var _activeSubSet:SubSet;
      
      private var _subSets:Vector.<SubSet>;
      
      private var _subSetCount:uint;
      
      private var _numIndices:uint;
      
      private var _material:MaterialBase;
      
      private var _animator:IAnimator;
      
      private var _hasData:Boolean;
      
      protected var _segments:Dictionary;
      
      private var _indexSegments:uint;
      
      public function SegmentSet()
      {
         super();
         this._subSetCount = 0;
         this._subSets = new Vector.<SubSet>();
         this.addSubSet();
         this._segments = new Dictionary();
         this.material = new SegmentMaterial();
      }
      
      public function addSegment(param1:Segment) : void
      {
         param1.segmentsBase = this;
         this._hasData = true;
         var _loc2_:uint = this._subSets.length - 1;
         var _loc3_:SubSet = this._subSets[_loc2_];
         if(_loc3_.vertices.length + 44 > this.LIMIT)
         {
            _loc3_ = this.addSubSet();
            _loc2_++;
         }
         param1.index = _loc3_.vertices.length;
         param1.subSetIndex = _loc2_;
         this.updateSegment(param1);
         var _loc4_:uint = uint(_loc3_.lineCount << 2);
         _loc3_.indices.push(_loc4_,_loc4_ + 1,_loc4_ + 2,_loc4_ + 3,_loc4_ + 2,_loc4_ + 1);
         _loc3_.numVertices = _loc3_.vertices.length / 11;
         _loc3_.numIndices = _loc3_.indices.length;
         ++_loc3_.lineCount;
         var _loc5_:SegRef = new SegRef();
         _loc5_.index = _loc4_;
         _loc5_.subSetIndex = _loc2_;
         _loc5_.segment = param1;
         this._segments[this._indexSegments] = _loc5_;
         ++this._indexSegments;
      }
      
      public function removeSegmentByIndex(param1:uint, param2:Boolean = false) : void
      {
         var _loc3_:SegRef = null;
         var _loc4_:SubSet = null;
         if(param1 >= this._indexSegments)
         {
            return;
         }
         if(this._segments[param1])
         {
            _loc3_ = this._segments[param1];
            if(!this._subSets[_loc3_.subSetIndex])
            {
               return;
            }
            var _loc5_:int = int(_loc3_.subSetIndex);
            _loc4_ = this._subSets[_loc3_.subSetIndex];
            var _loc6_:Segment = _loc3_.segment;
            var _loc7_:Vector.<uint> = _loc4_.indices;
            var _loc8_:uint;
            var _loc9_:uint = _loc8_ = param1 * 6;
            while(_loc9_ < _loc7_.length)
            {
               _loc7_[_loc9_] -= 4;
               _loc9_++;
            }
            _loc4_.indices.splice(param1 * 6,6);
            _loc4_.vertices.splice(param1 * 44,44);
            _loc4_.numVertices = _loc4_.vertices.length / 11;
            _loc4_.numIndices = _loc7_.length;
            _loc4_.vertexBufferDirty = true;
            _loc4_.indexBufferDirty = true;
            --_loc4_.lineCount;
            if(param2)
            {
               _loc6_.dispose();
               _loc6_ = null;
            }
            else
            {
               _loc6_.index = -1;
               _loc6_.segmentsBase = null;
            }
            if(_loc4_.lineCount == 0)
            {
               if(_loc5_ == 0)
               {
                  this._hasData = false;
               }
               else
               {
                  _loc4_.dispose();
                  this._subSets[_loc5_] = null;
                  this._subSets.splice(_loc5_,1);
               }
            }
            this.reOrderIndices(_loc5_,param1);
            _loc3_ = null;
            this._segments[this._indexSegments] = null;
            --this._indexSegments;
            return;
         }
      }
      
      public function removeSegment(param1:Segment, param2:Boolean = false) : void
      {
         if(param1.index == -1)
         {
            return;
         }
         this.removeSegmentByIndex(param1.index / 44);
      }
      
      public function removeAllSegments() : void
      {
         var _loc1_:SubSet = null;
         var _loc3_:SegRef = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this._subSetCount)
         {
            _loc1_ = this._subSets[_loc2_];
            _loc1_.vertices = null;
            _loc1_.indices = null;
            if(_loc1_.vertexBuffer)
            {
               _loc1_.vertexBuffer.dispose();
            }
            if(_loc1_.indexBuffer)
            {
               _loc1_.indexBuffer.dispose();
            }
            _loc1_ = null;
            _loc2_++;
         }
         for each(_loc3_ in this._segments)
         {
            _loc3_ = null;
         }
         this._segments = null;
         this._subSetCount = 0;
         this._activeSubSet = null;
         this._indexSegments = 0;
         this._subSets = new Vector.<SubSet>();
         this._segments = new Dictionary();
         this.addSubSet();
         this._hasData = false;
      }
      
      public function getSegment(param1:uint) : Segment
      {
         if(param1 > this._indexSegments - 1)
         {
            return null;
         }
         return this._segments[param1].segment;
      }
      
      public function get segmentCount() : uint
      {
         return this._indexSegments;
      }
      
      arcane function get subSetCount() : uint
      {
         return this._subSetCount;
      }
      
      arcane function updateSegment(param1:Segment) : void
      {
         var _loc2_:Vector3D = param1._start;
         var _loc3_:Vector3D = param1._end;
         var _loc4_:Number = _loc2_.x;
         var _loc5_:Number = _loc2_.y;
         var _loc6_:Number = _loc2_.z;
         var _loc7_:Number = _loc3_.x;
         var _loc8_:Number = _loc3_.y;
         var _loc9_:Number = _loc3_.z;
         var _loc10_:Number = param1._startR;
         var _loc11_:Number = param1._startG;
         var _loc12_:Number = param1._startB;
         var _loc13_:Number = param1._endR;
         var _loc14_:Number = param1._endG;
         var _loc15_:Number = param1._endB;
         var _loc16_:uint = uint(param1.index);
         var _loc17_:Number = param1.thickness;
         var _loc18_:SubSet = this._subSets[param1.subSetIndex];
         var _loc19_:Vector.<Number> = _loc18_.vertices;
         var _loc20_:uint;
         _loc19_[_loc20_ = _loc16_++] = _loc4_;
         var _loc21_:uint;
         _loc19_[_loc21_ = _loc16_++] = _loc5_;
         var _loc22_:uint;
         _loc19_[_loc22_ = _loc16_++] = _loc6_;
         var _loc23_:uint;
         _loc19_[_loc23_ = _loc16_++] = _loc7_;
         var _loc24_:uint;
         _loc19_[_loc24_ = _loc16_++] = _loc8_;
         var _loc25_:uint;
         _loc19_[_loc25_ = _loc16_++] = _loc9_;
         var _loc26_:uint;
         _loc19_[_loc26_ = _loc16_++] = _loc17_;
         var _loc27_:uint;
         _loc19_[_loc27_ = _loc16_++] = _loc10_;
         var _loc28_:uint;
         _loc19_[_loc28_ = _loc16_++] = _loc11_;
         var _loc29_:uint;
         _loc19_[_loc29_ = _loc16_++] = _loc12_;
         var _loc30_:uint;
         _loc19_[_loc30_ = _loc16_++] = 1;
         var _loc31_:uint;
         _loc19_[_loc31_ = _loc16_++] = _loc7_;
         var _loc32_:uint;
         _loc19_[_loc32_ = _loc16_++] = _loc8_;
         var _loc33_:uint;
         _loc19_[_loc33_ = _loc16_++] = _loc9_;
         var _loc34_:uint;
         _loc19_[_loc34_ = _loc16_++] = _loc4_;
         var _loc35_:uint;
         _loc19_[_loc35_ = _loc16_++] = _loc5_;
         var _loc36_:uint;
         _loc19_[_loc36_ = _loc16_++] = _loc6_;
         var _loc37_:uint;
         _loc19_[_loc37_ = _loc16_++] = -_loc17_;
         var _loc38_:uint;
         _loc19_[_loc38_ = _loc16_++] = _loc13_;
         var _loc39_:uint;
         _loc19_[_loc39_ = _loc16_++] = _loc14_;
         var _loc40_:uint;
         _loc19_[_loc40_ = _loc16_++] = _loc15_;
         var _loc41_:uint;
         _loc19_[_loc41_ = _loc16_++] = 1;
         var _loc42_:uint;
         _loc19_[_loc42_ = _loc16_++] = _loc4_;
         var _loc43_:uint;
         _loc19_[_loc43_ = _loc16_++] = _loc5_;
         var _loc44_:uint;
         _loc19_[_loc44_ = _loc16_++] = _loc6_;
         var _loc45_:uint;
         _loc19_[_loc45_ = _loc16_++] = _loc7_;
         var _loc46_:uint;
         _loc19_[_loc46_ = _loc16_++] = _loc8_;
         var _loc47_:uint;
         _loc19_[_loc47_ = _loc16_++] = _loc9_;
         var _loc48_:uint;
         _loc19_[_loc48_ = _loc16_++] = -_loc17_;
         var _loc49_:uint;
         _loc19_[_loc49_ = _loc16_++] = _loc10_;
         var _loc50_:uint;
         _loc19_[_loc50_ = _loc16_++] = _loc11_;
         var _loc51_:uint;
         _loc19_[_loc51_ = _loc16_++] = _loc12_;
         var _loc52_:uint;
         _loc19_[_loc52_ = _loc16_++] = 1;
         var _loc53_:uint;
         _loc19_[_loc53_ = _loc16_++] = _loc7_;
         var _loc54_:uint;
         _loc19_[_loc54_ = _loc16_++] = _loc8_;
         var _loc55_:uint;
         _loc19_[_loc55_ = _loc16_++] = _loc9_;
         var _loc56_:uint;
         _loc19_[_loc56_ = _loc16_++] = _loc4_;
         var _loc57_:uint;
         _loc19_[_loc57_ = _loc16_++] = _loc5_;
         var _loc58_:uint;
         _loc19_[_loc58_ = _loc16_++] = _loc6_;
         var _loc59_:uint;
         _loc19_[_loc59_ = _loc16_++] = _loc17_;
         var _loc60_:uint;
         _loc19_[_loc60_ = _loc16_++] = _loc13_;
         var _loc61_:uint;
         _loc19_[_loc61_ = _loc16_++] = _loc14_;
         var _loc62_:uint;
         _loc19_[_loc62_ = _loc16_++] = _loc15_;
         var _loc63_:uint;
         _loc19_[_loc63_ = _loc16_++] = 1;
         _loc18_.vertexBufferDirty = true;
         invalidateBounds();
      }
      
      arcane function get hasData() : Boolean
      {
         return this._hasData;
      }
      
      public function getIndexBuffer(param1:Stage3DProxy) : IndexBuffer3D
      {
         if(this._activeSubSet.indexContext3D != param1.context3D || this._activeSubSet.indexBufferDirty)
         {
            this._activeSubSet.indexBuffer = param1._context3D.createIndexBuffer(this._activeSubSet.numIndices);
            this._activeSubSet.indexBuffer.uploadFromVector(this._activeSubSet.indices,0,this._activeSubSet.numIndices);
            this._activeSubSet.indexBufferDirty = false;
            this._activeSubSet.indexContext3D = param1.context3D;
         }
         return this._activeSubSet.indexBuffer;
      }
      
      public function activateVertexBuffer(param1:int, param2:Stage3DProxy) : void
      {
         var _loc4_:VertexBuffer3D = null;
         var _loc3_:SubSet = this._subSets[param1];
         this._activeSubSet = _loc3_;
         this._numIndices = _loc3_.numIndices;
         if(_loc3_.vertexContext3D != param2.context3D || _loc3_.vertexBufferDirty)
         {
            _loc3_.vertexBuffer = param2._context3D.createVertexBuffer(_loc3_.numVertices,11);
            _loc3_.vertexBuffer.uploadFromVector(_loc3_.vertices,0,_loc3_.numVertices);
            _loc4_ = _loc3_.vertexBuffer;
            _loc3_.vertexBufferDirty = false;
            _loc3_.vertexContext3D = param2.context3D;
         }
         _loc4_ = _loc3_.vertexBuffer;
         var _loc5_:Context3D = param2._context3D;
         _loc5_.setVertexBufferAt(0,_loc4_,0,Context3DVertexBufferFormat.FLOAT_3);
         _loc5_.setVertexBufferAt(1,_loc4_,3,Context3DVertexBufferFormat.FLOAT_3);
         _loc5_.setVertexBufferAt(2,_loc4_,6,Context3DVertexBufferFormat.FLOAT_1);
         _loc5_.setVertexBufferAt(3,_loc4_,7,Context3DVertexBufferFormat.FLOAT_4);
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
      
      private function reOrderIndices(param1:uint, param2:int) : void
      {
         var _loc3_:SegRef = null;
         var _loc4_:uint = uint(param2);
         while(_loc4_ < this._indexSegments - 1)
         {
            _loc3_ = this._segments[_loc4_ + 1];
            _loc3_.index = _loc4_;
            if(_loc3_.subSetIndex == param1)
            {
               _loc3_.segment.index -= 44;
            }
            this._segments[_loc4_] = _loc3_;
            _loc4_++;
         }
      }
      
      private function addSubSet() : SubSet
      {
         var _loc1_:SubSet = new SubSet();
         this._subSets.push(_loc1_);
         _loc1_.vertices = new Vector.<Number>();
         _loc1_.numVertices = 0;
         _loc1_.indices = new Vector.<uint>();
         _loc1_.numIndices = 0;
         _loc1_.vertexBufferDirty = true;
         _loc1_.indexBufferDirty = true;
         _loc1_.lineCount = 0;
         ++this._subSetCount;
         return _loc1_;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeAllSegments();
         this._segments = null;
         this._material = null;
         var _loc1_:SubSet = this._subSets[0];
         _loc1_.vertices = null;
         _loc1_.indices = null;
         this._subSets = null;
      }
      
      override public function get mouseEnabled() : Boolean
      {
         return false;
      }
      
      override protected function getDefaultBoundingVolume() : BoundingVolumeBase
      {
         return new BoundingSphere();
      }
      
      override protected function updateBounds() : void
      {
         var _loc1_:SubSet = null;
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc11_:Vector.<Number> = null;
         var _loc13_:Number = NaN;
         var _loc5_:Number = Infinity;
         var _loc6_:Number = Infinity;
         var _loc7_:Number = Infinity;
         var _loc8_:Number = -Infinity;
         var _loc9_:Number = -Infinity;
         var _loc10_:Number = -Infinity;
         var _loc12_:uint = 0;
         while(_loc12_ < this._subSetCount)
         {
            _loc1_ = this._subSets[_loc12_];
            _loc4_ = 0;
            _loc11_ = _loc1_.vertices;
            _loc2_ = _loc11_.length;
            if(_loc2_ != 0)
            {
               while(_loc4_ < _loc2_)
               {
                  _loc3_ = _loc11_[_loc4_++];
                  if(_loc3_ < _loc5_)
                  {
                     _loc5_ = _loc3_;
                  }
                  else if(_loc3_ > _loc8_)
                  {
                     _loc8_ = _loc3_;
                  }
                  _loc3_ = _loc11_[_loc4_++];
                  if(_loc3_ < _loc6_)
                  {
                     _loc6_ = _loc3_;
                  }
                  else if(_loc3_ > _loc9_)
                  {
                     _loc9_ = _loc3_;
                  }
                  _loc3_ = _loc11_[_loc4_++];
                  if(_loc3_ < _loc7_)
                  {
                     _loc7_ = _loc3_;
                  }
                  else if(_loc3_ > _loc10_)
                  {
                     _loc10_ = _loc3_;
                  }
                  _loc4_ += 8;
               }
            }
            _loc12_++;
         }
         if(_loc5_ != Infinity)
         {
            _bounds.fromExtremes(_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_);
         }
         else
         {
            _loc13_ = 0.5;
            _bounds.fromExtremes(-_loc13_,-_loc13_,-_loc13_,_loc13_,_loc13_,_loc13_);
         }
         _boundsInvalid = false;
      }
      
      override protected function createEntityPartitionNode() : EntityNode
      {
         return new RenderableNode(this);
      }
      
      public function get numTriangles() : uint
      {
         return this._numIndices / 3;
      }
      
      public function get sourceEntity() : Entity
      {
         return this;
      }
      
      public function get castsShadows() : Boolean
      {
         return false;
      }
      
      public function get material() : MaterialBase
      {
         return this._material;
      }
      
      public function get animator() : IAnimator
      {
         return this._animator;
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
      
      public function get uvTransform() : Matrix
      {
         return null;
      }
      
      public function get vertexData() : Vector.<Number>
      {
         return null;
      }
      
      public function get indexData() : Vector.<uint>
      {
         return null;
      }
      
      public function get UVData() : Vector.<Number>
      {
         return null;
      }
      
      public function get numVertices() : uint
      {
         return null;
      }
      
      public function get vertexStride() : uint
      {
         return 11;
      }
      
      public function get vertexNormalData() : Vector.<Number>
      {
         return null;
      }
      
      public function get vertexTangentData() : Vector.<Number>
      {
         return null;
      }
      
      public function get vertexOffset() : int
      {
         return 0;
      }
      
      public function get vertexNormalOffset() : int
      {
         return 0;
      }
      
      public function get vertexTangentOffset() : int
      {
         return 0;
      }
      
      override public function get assetType() : String
      {
         return AssetType.SEGMENT_SET;
      }
      
      public function getRenderSceneTransform(param1:Camera3D) : Matrix3D
      {
         return _sceneTransform;
      }
      
      public function get shaderParams() : Object
      {
         return null;
      }
   }
}

import away3d.primitives.data.Segment;
import flash.display3D.Context3D;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;

final class SegRef
{
   
   public var index:uint;
   
   public var subSetIndex:uint;
   
   public var segment:Segment;
   
   public function SegRef()
   {
      super();
   }
}

final class SubSet
{
   
   public var vertices:Vector.<Number>;
   
   public var numVertices:uint;
   
   public var indices:Vector.<uint>;
   
   public var numIndices:uint;
   
   public var vertexBufferDirty:Boolean;
   
   public var indexBufferDirty:Boolean;
   
   public var vertexContext3D:Context3D;
   
   public var indexContext3D:Context3D;
   
   public var vertexBuffer:VertexBuffer3D;
   
   public var indexBuffer:IndexBuffer3D;
   
   public var lineCount:uint;
   
   public function SubSet()
   {
      super();
   }
   
   public function dispose() : void
   {
      this.vertices = null;
      if(this.vertexBuffer)
      {
         this.vertexBuffer.dispose();
      }
      if(this.indexBuffer)
      {
         this.indexBuffer.dispose();
      }
   }
}
