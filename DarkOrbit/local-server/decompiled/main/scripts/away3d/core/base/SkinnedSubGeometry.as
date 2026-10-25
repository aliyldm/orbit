package away3d.core.base
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3D;
   import flash.display3D.VertexBuffer3D;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class SkinnedSubGeometry extends CompactSubGeometry
   {
      
      private var _bufferFormat:String;
      
      private var _jointWeightsData:Vector.<Number>;
      
      private var _jointIndexData:Vector.<Number>;
      
      private var _animatedData:Vector.<Number>;
      
      private var _jointWeightsBuffer:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>(8);
      
      private var _jointIndexBuffer:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>(8);
      
      private var _jointWeightsInvalid:Vector.<Boolean> = new Vector.<Boolean>(8,true);
      
      private var _jointIndicesInvalid:Vector.<Boolean> = new Vector.<Boolean>(8,true);
      
      private var _jointWeightContext:Vector.<Context3D> = new Vector.<Context3D>(8);
      
      private var _jointIndexContext:Vector.<Context3D> = new Vector.<Context3D>(8);
      
      private var _jointsPerVertex:int;
      
      private var _condensedJointIndexData:Vector.<Number>;
      
      private var _condensedIndexLookUp:Vector.<uint>;
      
      private var _numCondensedJoints:uint;
      
      public function SkinnedSubGeometry(param1:int)
      {
         super();
         this._jointsPerVertex = param1;
         this._bufferFormat = "float" + this._jointsPerVertex;
      }
      
      public function get condensedIndexLookUp() : Vector.<uint>
      {
         return this._condensedIndexLookUp;
      }
      
      public function get numCondensedJoints() : uint
      {
         return this._numCondensedJoints;
      }
      
      public function get animatedData() : Vector.<Number>
      {
         return this._animatedData || _vertexData.concat();
      }
      
      public function updateAnimatedData(param1:Vector.<Number>) : void
      {
         this._animatedData = param1;
         invalidateBuffers(_vertexDataInvalid);
      }
      
      public function activateJointWeightsBuffer(param1:int, param2:Stage3DProxy) : void
      {
         var _loc3_:int = param2._stage3DIndex;
         var _loc4_:Context3D = param2._context3D;
         if(this._jointWeightContext[_loc3_] != _loc4_ || !this._jointWeightsBuffer[_loc3_])
         {
            this._jointWeightsBuffer[_loc3_] = _loc4_.createVertexBuffer(_numVertices,this._jointsPerVertex);
            this._jointWeightContext[_loc3_] = _loc4_;
            this._jointWeightsInvalid[_loc3_] = true;
         }
         if(this._jointWeightsInvalid[_loc3_])
         {
            this._jointWeightsBuffer[_loc3_].uploadFromVector(this._jointWeightsData,0,this._jointWeightsData.length / this._jointsPerVertex);
            this._jointWeightsInvalid[_loc3_] = false;
         }
         _loc4_.setVertexBufferAt(param1,this._jointWeightsBuffer[_loc3_],0,this._bufferFormat);
      }
      
      public function activateJointIndexBuffer(param1:int, param2:Stage3DProxy) : void
      {
         var _loc3_:int = param2._stage3DIndex;
         var _loc4_:Context3D = param2._context3D;
         if(this._jointIndexContext[_loc3_] != _loc4_ || !this._jointIndexBuffer[_loc3_])
         {
            this._jointIndexBuffer[_loc3_] = _loc4_.createVertexBuffer(_numVertices,this._jointsPerVertex);
            this._jointIndexContext[_loc3_] = _loc4_;
            this._jointIndicesInvalid[_loc3_] = true;
         }
         if(this._jointIndicesInvalid[_loc3_])
         {
            this._jointIndexBuffer[_loc3_].uploadFromVector(this._numCondensedJoints > 0 ? this._condensedJointIndexData : this._jointIndexData,0,this._jointIndexData.length / this._jointsPerVertex);
            this._jointIndicesInvalid[_loc3_] = false;
         }
         _loc4_.setVertexBufferAt(param1,this._jointIndexBuffer[_loc3_],0,this._bufferFormat);
      }
      
      override protected function uploadData(param1:int) : void
      {
         if(this._animatedData)
         {
            _activeBuffer.uploadFromVector(this._animatedData,0,_numVertices);
            _vertexDataInvalid[param1] = _activeDataInvalid = false;
         }
         else
         {
            super.uploadData(param1);
         }
      }
      
      override public function clone() : ISubGeometry
      {
         var _loc1_:SkinnedSubGeometry = new SkinnedSubGeometry(this._jointsPerVertex);
         _loc1_.updateData(_vertexData.concat());
         _loc1_.updateIndexData(_indices.concat());
         _loc1_.updateJointIndexData(this._jointIndexData.concat());
         _loc1_.updateJointWeightsData(this._jointWeightsData.concat());
         _loc1_._autoDeriveVertexNormals = _autoDeriveVertexNormals;
         _loc1_._autoDeriveVertexTangents = _autoDeriveVertexTangents;
         _loc1_._numCondensedJoints = this._numCondensedJoints;
         _loc1_._condensedIndexLookUp = this._condensedIndexLookUp;
         _loc1_._condensedJointIndexData = this._condensedJointIndexData;
         return _loc1_;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         disposeVertexBuffers(this._jointWeightsBuffer);
         disposeVertexBuffers(this._jointIndexBuffer);
      }
      
      arcane function condenseIndexData() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = int(this._jointIndexData.length);
         var _loc3_:* = 0;
         var _loc4_:Dictionary = new Dictionary();
         this._condensedJointIndexData = new Vector.<Number>(_loc1_,true);
         this._condensedIndexLookUp = new Vector.<uint>();
         var _loc5_:int = 0;
         while(_loc5_ < _loc1_)
         {
            _loc2_ = this._jointIndexData[_loc5_];
            if(_loc4_[_loc2_] == undefined)
            {
               _loc4_[_loc2_] = _loc3_;
               var _loc6_:Number;
               this._condensedIndexLookUp[_loc6_ = _loc3_++] = _loc2_;
               var _loc7_:Number;
               this._condensedIndexLookUp[_loc7_ = _loc3_++] = _loc2_ + 1;
               var _loc8_:Number;
               this._condensedIndexLookUp[_loc8_ = _loc3_++] = _loc2_ + 2;
            }
            this._condensedJointIndexData[_loc5_] = _loc4_[_loc2_];
            _loc5_++;
         }
         this._numCondensedJoints = _loc3_ / 3;
         invalidateBuffers(this._jointIndicesInvalid);
      }
      
      arcane function get jointWeightsData() : Vector.<Number>
      {
         return this._jointWeightsData;
      }
      
      arcane function updateJointWeightsData(param1:Vector.<Number>) : void
      {
         this._numCondensedJoints = 0;
         this._condensedIndexLookUp = null;
         this._condensedJointIndexData = null;
         this._jointWeightsData = param1;
         invalidateBuffers(this._jointWeightsInvalid);
      }
      
      arcane function get jointIndexData() : Vector.<Number>
      {
         return this._jointIndexData;
      }
      
      arcane function updateJointIndexData(param1:Vector.<Number>) : void
      {
         this._jointIndexData = param1;
         invalidateBuffers(this._jointIndicesInvalid);
      }
   }
}

