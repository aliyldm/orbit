package away3d.animators
{
   import away3d.animators.data.*;
   import away3d.animators.nodes.SkeletonClipNode;
   import away3d.animators.states.*;
   import away3d.animators.transitions.*;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.*;
   import away3d.core.managers.*;
   import away3d.core.math.*;
   import away3d.events.*;
   import away3d.materials.passes.*;
   import flash.display3D.*;
   import flash.geom.*;
   import flash.utils.*;
   
   use namespace arcane;
   
   public class SkeletonAnimator extends AnimatorBase implements IAnimator
   {
      
      private var _globalMatrices:Vector.<Number>;
      
      private var _globalPose:SkeletonPose = new SkeletonPose();
      
      private var _globalPropertiesDirty:Boolean;
      
      private var _numJoints:uint;
      
      private var _animationStates:Dictionary = new Dictionary();
      
      private var _condensedMatrices:Vector.<Number>;
      
      private var _skeleton:Skeleton;
      
      private var _forceCPU:Boolean;
      
      private var _useCondensedIndices:Boolean;
      
      private var _jointsPerVertex:uint;
      
      private var _activeSkeletonState:ISkeletonAnimationState;
      
      public function SkeletonAnimator(param1:SkeletonAnimationSet, param2:Skeleton, param3:Boolean = false)
      {
         var _loc4_:* = 0;
         super(param1);
         this._skeleton = param2;
         this._forceCPU = param3;
         this._jointsPerVertex = param1.jointsPerVertex;
         this._numJoints = this._skeleton.numJoints;
         this._globalMatrices = new Vector.<Number>(this._numJoints * 12,true);
         var _loc5_:uint = 0;
         while(_loc5_ < this._numJoints)
         {
            var _loc6_:Number;
            this._globalMatrices[_loc6_ = _loc4_++] = 1;
            var _loc7_:Number;
            this._globalMatrices[_loc7_ = _loc4_++] = 0;
            var _loc8_:Number;
            this._globalMatrices[_loc8_ = _loc4_++] = 0;
            var _loc9_:Number;
            this._globalMatrices[_loc9_ = _loc4_++] = 0;
            var _loc10_:Number;
            this._globalMatrices[_loc10_ = _loc4_++] = 0;
            var _loc11_:Number;
            this._globalMatrices[_loc11_ = _loc4_++] = 1;
            var _loc12_:Number;
            this._globalMatrices[_loc12_ = _loc4_++] = 0;
            var _loc13_:Number;
            this._globalMatrices[_loc13_ = _loc4_++] = 0;
            var _loc14_:Number;
            this._globalMatrices[_loc14_ = _loc4_++] = 0;
            var _loc15_:Number;
            this._globalMatrices[_loc15_ = _loc4_++] = 0;
            var _loc16_:Number;
            this._globalMatrices[_loc16_ = _loc4_++] = 1;
            var _loc17_:Number;
            this._globalMatrices[_loc17_ = _loc4_++] = 0;
            _loc5_++;
         }
      }
      
      public function get globalMatrices() : Vector.<Number>
      {
         if(this._globalPropertiesDirty)
         {
            this.updateGlobalProperties();
         }
         return this._globalMatrices;
      }
      
      public function get globalPose() : SkeletonPose
      {
         if(this._globalPropertiesDirty)
         {
            this.updateGlobalProperties();
         }
         return this._globalPose;
      }
      
      public function get skeleton() : Skeleton
      {
         return this._skeleton;
      }
      
      public function get forceCPU() : Boolean
      {
         return this._forceCPU;
      }
      
      public function get useCondensedIndices() : Boolean
      {
         return this._useCondensedIndices;
      }
      
      public function set useCondensedIndices(param1:Boolean) : void
      {
         this._useCondensedIndices = param1;
      }
      
      public function clone() : IAnimator
      {
         return new SkeletonAnimator(_animationSet as SkeletonAnimationSet,this._skeleton,this._forceCPU);
      }
      
      public function play(param1:String, param2:Boolean = false, param3:IAnimationTransition = null, param4:Number = NaN) : SkeletonClipNode
      {
         _activeAnimationName = param1;
         if(!_animationSet.hasAnimation(param1))
         {
            throw new Error("Animation root node " + param1 + " not found!");
         }
         if(Boolean(param3) && Boolean(_activeNode))
         {
            _activeNode = param3.getAnimationNode(this,_activeNode,_animationSet.getAnimation(param1),time);
            _activeNode.addEventListener(AnimationStateEvent.TRANSITION_COMPLETE,this.onTransitionComplete);
         }
         else
         {
            _activeNode = _animationSet.getAnimation(param1);
         }
         _activeState = getAnimationState(_activeNode);
         if(_activeState is AnimationClipState)
         {
            (_activeState as AnimationClipState).playReversed = param2;
         }
         if(updatePosition)
         {
            _activeState.time = time;
            _activeState.positionDelta;
         }
         this._activeSkeletonState = _activeState as ISkeletonAnimationState;
         start();
         if(!isNaN(param4))
         {
            reset(param1,param4);
         }
         return _activeNode as SkeletonClipNode;
      }
      
      public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:int, param4:int, param5:Camera3D) : void
      {
         var _loc8_:SubGeomAnimationState = null;
         if(this._globalPropertiesDirty)
         {
            this.updateGlobalProperties();
         }
         var _loc6_:SkinnedSubGeometry = SkinnedSubGeometry(SubMesh(param2).subGeometry);
         var _loc7_:uint = _loc6_.numCondensedJoints;
         if(this._useCondensedIndices)
         {
            if(_loc6_.numCondensedJoints == 0)
            {
               _loc6_.condenseIndexData();
               _loc7_ = _loc6_.numCondensedJoints;
            }
            this.updateCondensedMatrices(_loc6_.condensedIndexLookUp,_loc7_);
            param1._context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,param3,this._condensedMatrices,_loc7_ * 3);
         }
         else
         {
            if(_animationSet.usesCPU)
            {
               _loc8_ = this._animationStates[_loc6_] = this._animationStates[_loc6_] || new SubGeomAnimationState(_loc6_);
               if(_loc8_.dirty)
               {
                  this.morphGeometry(_loc8_,_loc6_);
                  _loc8_.dirty = false;
               }
               _loc6_.updateAnimatedData(_loc8_.animatedVertexData);
               return;
            }
            param1._context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,param3,this._globalMatrices,this._numJoints * 3);
         }
         _loc6_.activateJointIndexBuffer(param4,param1);
         _loc6_.activateJointWeightsBuffer(param4 + 1,param1);
      }
      
      public function testGPUCompatibility(param1:MaterialPassBase) : void
      {
         if(!this._useCondensedIndices && (this._forceCPU || this._jointsPerVertex > 4 || param1.numUsedVertexConstants + this._numJoints * 3 > 128))
         {
            _animationSet.cancelGPUCompatibility();
         }
      }
      
      override public function set time(param1:int) : void
      {
         var _loc2_:Object = null;
         super.time = param1;
         this._globalPropertiesDirty = true;
         for(_loc2_ in this._animationStates)
         {
            SubGeomAnimationState(this._animationStates[_loc2_]).dirty = true;
         }
      }
      
      private function updateCondensedMatrices(param1:Vector.<uint>, param2:uint) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this._condensedMatrices = new Vector.<Number>();
         do
         {
            _loc6_ = param1[_loc3_ * 3] * 4;
            _loc5_ = _loc6_ + 12;
            while(_loc6_ < _loc5_)
            {
               var _loc7_:uint;
               this._condensedMatrices[_loc7_ = _loc4_++] = this._globalMatrices[_loc6_++];
            }
         }
         while(++_loc3_ < param2);
      }
      
      private function updateGlobalProperties() : void
      {
         var _loc1_:uint = 0;
         var _loc3_:Vector.<Number> = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc36_:JointPose = null;
         var _loc37_:Quaternion = null;
         var _loc38_:Vector3D = null;
         var _loc39_:Number = NaN;
         this._globalPropertiesDirty = false;
         this.localToGlobalPose(this._activeSkeletonState.getSkeletonPose(this._skeleton),this._globalPose,this._skeleton);
         var _loc2_:Vector.<JointPose> = this._globalPose.jointPoses;
         var _loc35_:Vector.<SkeletonJoint> = this._skeleton.joints;
         var _loc40_:uint = 0;
         while(_loc40_ < this._numJoints)
         {
            _loc36_ = _loc2_[_loc40_];
            _loc37_ = _loc36_.orientation;
            _loc38_ = _loc36_.translation;
            _loc4_ = _loc37_.x;
            _loc5_ = _loc37_.y;
            _loc6_ = _loc37_.z;
            _loc7_ = _loc37_.w;
            _loc39_ = 2 * _loc4_;
            _loc8_ = _loc39_ * _loc5_;
            _loc9_ = _loc39_ * _loc6_;
            _loc10_ = _loc39_ * _loc7_;
            _loc39_ = 2 * _loc5_;
            _loc11_ = _loc39_ * _loc6_;
            _loc12_ = _loc39_ * _loc7_;
            _loc13_ = 2 * _loc6_ * _loc7_;
            _loc11_ = 2 * _loc5_ * _loc6_;
            _loc12_ = 2 * _loc5_ * _loc7_;
            _loc13_ = 2 * _loc6_ * _loc7_;
            _loc4_ *= _loc4_;
            _loc5_ *= _loc5_;
            _loc6_ *= _loc6_;
            _loc7_ *= _loc7_;
            _loc39_ = _loc4_ - _loc5_;
            _loc14_ = _loc39_ - _loc6_ + _loc7_;
            _loc15_ = _loc8_ - _loc13_;
            _loc16_ = _loc9_ + _loc12_;
            _loc17_ = _loc8_ + _loc13_;
            _loc18_ = -_loc39_ - _loc6_ + _loc7_;
            _loc19_ = _loc11_ - _loc10_;
            _loc20_ = _loc9_ - _loc12_;
            _loc21_ = _loc11_ + _loc10_;
            _loc22_ = -_loc4_ - _loc5_ + _loc6_ + _loc7_;
            _loc3_ = _loc35_[_loc40_].inverseBindPose;
            _loc23_ = _loc3_[0];
            _loc24_ = _loc3_[4];
            _loc25_ = _loc3_[8];
            _loc26_ = _loc3_[12];
            _loc27_ = _loc3_[1];
            _loc28_ = _loc3_[5];
            _loc29_ = _loc3_[9];
            _loc30_ = _loc3_[13];
            _loc31_ = _loc3_[2];
            _loc32_ = _loc3_[6];
            _loc33_ = _loc3_[10];
            _loc34_ = _loc3_[14];
            this._globalMatrices[uint(_loc1_)] = _loc14_ * _loc23_ + _loc15_ * _loc27_ + _loc16_ * _loc31_;
            this._globalMatrices[uint(_loc1_ + 1)] = _loc14_ * _loc24_ + _loc15_ * _loc28_ + _loc16_ * _loc32_;
            this._globalMatrices[uint(_loc1_ + 2)] = _loc14_ * _loc25_ + _loc15_ * _loc29_ + _loc16_ * _loc33_;
            this._globalMatrices[uint(_loc1_ + 3)] = _loc14_ * _loc26_ + _loc15_ * _loc30_ + _loc16_ * _loc34_ + _loc38_.x;
            this._globalMatrices[uint(_loc1_ + 4)] = _loc17_ * _loc23_ + _loc18_ * _loc27_ + _loc19_ * _loc31_;
            this._globalMatrices[uint(_loc1_ + 5)] = _loc17_ * _loc24_ + _loc18_ * _loc28_ + _loc19_ * _loc32_;
            this._globalMatrices[uint(_loc1_ + 6)] = _loc17_ * _loc25_ + _loc18_ * _loc29_ + _loc19_ * _loc33_;
            this._globalMatrices[uint(_loc1_ + 7)] = _loc17_ * _loc26_ + _loc18_ * _loc30_ + _loc19_ * _loc34_ + _loc38_.y;
            this._globalMatrices[uint(_loc1_ + 8)] = _loc20_ * _loc23_ + _loc21_ * _loc27_ + _loc22_ * _loc31_;
            this._globalMatrices[uint(_loc1_ + 9)] = _loc20_ * _loc24_ + _loc21_ * _loc28_ + _loc22_ * _loc32_;
            this._globalMatrices[uint(_loc1_ + 10)] = _loc20_ * _loc25_ + _loc21_ * _loc29_ + _loc22_ * _loc33_;
            this._globalMatrices[uint(_loc1_ + 11)] = _loc20_ * _loc26_ + _loc21_ * _loc30_ + _loc22_ * _loc34_ + _loc38_.z;
            _loc1_ = uint(_loc1_ + 12);
            _loc40_++;
         }
      }
      
      private function morphGeometry(param1:SubGeomAnimationState, param2:SkinnedSubGeometry) : void
      {
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:Number = NaN;
         var _loc40_:Number = NaN;
         var _loc41_:Number = NaN;
         var _loc42_:uint = 0;
         var _loc3_:Vector.<Number> = param2.vertexData;
         var _loc4_:Vector.<Number> = param1.animatedVertexData;
         var _loc5_:Vector.<Number> = param2.jointIndexData;
         var _loc6_:Vector.<Number> = param2.jointWeightsData;
         var _loc19_:int = int(_loc3_.length);
         while(_loc7_ < _loc19_)
         {
            _loc21_ = _loc3_[_loc7_];
            _loc22_ = _loc3_[uint(_loc7_ + 1)];
            _loc23_ = _loc3_[uint(_loc7_ + 2)];
            _loc24_ = _loc3_[uint(_loc7_ + 3)];
            _loc25_ = _loc3_[uint(_loc7_ + 4)];
            _loc26_ = _loc3_[uint(_loc7_ + 5)];
            _loc27_ = _loc3_[uint(_loc7_ + 6)];
            _loc28_ = _loc3_[uint(_loc7_ + 7)];
            _loc29_ = _loc3_[uint(_loc7_ + 8)];
            _loc10_ = 0;
            _loc11_ = 0;
            _loc12_ = 0;
            _loc13_ = 0;
            _loc14_ = 0;
            _loc15_ = 0;
            _loc16_ = 0;
            _loc17_ = 0;
            _loc18_ = 0;
            _loc9_ = 0;
            while(_loc9_ < this._jointsPerVertex)
            {
               _loc20_ = _loc6_[_loc8_];
               if(_loc20_ > 0)
               {
                  _loc42_ = uint(uint(_loc5_[_loc8_++]) << 2);
                  _loc30_ = this._globalMatrices[_loc42_];
                  _loc31_ = this._globalMatrices[uint(_loc42_ + 1)];
                  _loc32_ = this._globalMatrices[uint(_loc42_ + 2)];
                  _loc33_ = this._globalMatrices[uint(_loc42_ + 3)];
                  _loc34_ = this._globalMatrices[uint(_loc42_ + 4)];
                  _loc35_ = this._globalMatrices[uint(_loc42_ + 5)];
                  _loc36_ = this._globalMatrices[uint(_loc42_ + 6)];
                  _loc37_ = this._globalMatrices[uint(_loc42_ + 7)];
                  _loc38_ = this._globalMatrices[uint(_loc42_ + 8)];
                  _loc39_ = this._globalMatrices[uint(_loc42_ + 9)];
                  _loc40_ = this._globalMatrices[uint(_loc42_ + 10)];
                  _loc41_ = this._globalMatrices[uint(_loc42_ + 11)];
                  _loc10_ += _loc20_ * (_loc30_ * _loc21_ + _loc31_ * _loc22_ + _loc32_ * _loc23_ + _loc33_);
                  _loc11_ += _loc20_ * (_loc34_ * _loc21_ + _loc35_ * _loc22_ + _loc36_ * _loc23_ + _loc37_);
                  _loc12_ += _loc20_ * (_loc38_ * _loc21_ + _loc39_ * _loc22_ + _loc40_ * _loc23_ + _loc41_);
                  _loc13_ += _loc20_ * (_loc30_ * _loc24_ + _loc31_ * _loc25_ + _loc32_ * _loc26_);
                  _loc14_ += _loc20_ * (_loc34_ * _loc24_ + _loc35_ * _loc25_ + _loc36_ * _loc26_);
                  _loc15_ += _loc20_ * (_loc38_ * _loc24_ + _loc39_ * _loc25_ + _loc40_ * _loc26_);
                  _loc16_ += _loc20_ * (_loc30_ * _loc27_ + _loc31_ * _loc28_ + _loc32_ * _loc29_);
                  _loc17_ += _loc20_ * (_loc34_ * _loc27_ + _loc35_ * _loc28_ + _loc36_ * _loc29_);
                  _loc18_ += _loc20_ * (_loc38_ * _loc27_ + _loc39_ * _loc28_ + _loc40_ * _loc29_);
                  _loc9_++;
               }
               else
               {
                  _loc8_ += uint(this._jointsPerVertex - _loc9_);
                  _loc9_ = this._jointsPerVertex;
               }
            }
            _loc4_[_loc7_] = _loc10_;
            _loc4_[uint(_loc7_ + 1)] = _loc11_;
            _loc4_[uint(_loc7_ + 2)] = _loc12_;
            _loc4_[uint(_loc7_ + 3)] = _loc13_;
            _loc4_[uint(_loc7_ + 4)] = _loc14_;
            _loc4_[uint(_loc7_ + 5)] = _loc15_;
            _loc4_[uint(_loc7_ + 6)] = _loc16_;
            _loc4_[uint(_loc7_ + 7)] = _loc17_;
            _loc4_[uint(_loc7_ + 8)] = _loc18_;
            _loc7_ = uint(_loc7_ + 13);
         }
      }
      
      private function localToGlobalPose(param1:SkeletonPose, param2:SkeletonPose, param3:Skeleton) : void
      {
         var _loc5_:JointPose = null;
         var _loc9_:int = 0;
         var _loc10_:SkeletonJoint = null;
         var _loc11_:JointPose = null;
         var _loc12_:JointPose = null;
         var _loc13_:Quaternion = null;
         var _loc14_:Vector3D = null;
         var _loc15_:Vector3D = null;
         var _loc16_:Quaternion = null;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc4_:Vector.<JointPose> = param2.jointPoses;
         var _loc6_:Vector.<SkeletonJoint> = param3.joints;
         var _loc7_:uint = param1.numJointPoses;
         var _loc8_:Vector.<JointPose> = param1.jointPoses;
         if(_loc4_.length != _loc7_)
         {
            _loc4_.length = _loc7_;
         }
         var _loc28_:uint = 0;
         while(_loc28_ < _loc7_)
         {
            _loc5_ = _loc4_[_loc28_] = _loc4_[_loc28_] || new JointPose();
            _loc10_ = _loc6_[_loc28_];
            _loc9_ = _loc10_.parentIndex;
            _loc12_ = _loc8_[_loc28_];
            _loc16_ = _loc5_.orientation;
            _loc15_ = _loc5_.translation;
            if(_loc9_ < 0)
            {
               _loc14_ = _loc12_.translation;
               _loc13_ = _loc12_.orientation;
               _loc16_.x = _loc13_.x;
               _loc16_.y = _loc13_.y;
               _loc16_.z = _loc13_.z;
               _loc16_.w = _loc13_.w;
               _loc15_.x = _loc14_.x;
               _loc15_.y = _loc14_.y;
               _loc15_.z = _loc14_.z;
            }
            else
            {
               _loc11_ = _loc4_[_loc9_];
               _loc13_ = _loc11_.orientation;
               _loc14_ = _loc12_.translation;
               _loc21_ = _loc13_.x;
               _loc22_ = _loc13_.y;
               _loc23_ = _loc13_.z;
               _loc24_ = _loc13_.w;
               _loc25_ = _loc14_.x;
               _loc26_ = _loc14_.y;
               _loc27_ = _loc14_.z;
               _loc20_ = -_loc21_ * _loc25_ - _loc22_ * _loc26_ - _loc23_ * _loc27_;
               _loc17_ = _loc24_ * _loc25_ + _loc22_ * _loc27_ - _loc23_ * _loc26_;
               _loc18_ = _loc24_ * _loc26_ - _loc21_ * _loc27_ + _loc23_ * _loc25_;
               _loc19_ = _loc24_ * _loc27_ + _loc21_ * _loc26_ - _loc22_ * _loc25_;
               _loc14_ = _loc11_.translation;
               _loc15_.x = -_loc20_ * _loc21_ + _loc17_ * _loc24_ - _loc18_ * _loc23_ + _loc19_ * _loc22_ + _loc14_.x;
               _loc15_.y = -_loc20_ * _loc22_ + _loc17_ * _loc23_ + _loc18_ * _loc24_ - _loc19_ * _loc21_ + _loc14_.y;
               _loc15_.z = -_loc20_ * _loc23_ - _loc17_ * _loc22_ + _loc18_ * _loc21_ + _loc19_ * _loc24_ + _loc14_.z;
               _loc17_ = _loc13_.x;
               _loc18_ = _loc13_.y;
               _loc19_ = _loc13_.z;
               _loc20_ = _loc13_.w;
               _loc13_ = _loc12_.orientation;
               _loc21_ = _loc13_.x;
               _loc22_ = _loc13_.y;
               _loc23_ = _loc13_.z;
               _loc24_ = _loc13_.w;
               _loc16_.w = _loc20_ * _loc24_ - _loc17_ * _loc21_ - _loc18_ * _loc22_ - _loc19_ * _loc23_;
               _loc16_.x = _loc20_ * _loc21_ + _loc17_ * _loc24_ + _loc18_ * _loc23_ - _loc19_ * _loc22_;
               _loc16_.y = _loc20_ * _loc22_ - _loc17_ * _loc23_ + _loc18_ * _loc24_ + _loc19_ * _loc21_;
               _loc16_.z = _loc20_ * _loc23_ + _loc17_ * _loc22_ - _loc18_ * _loc21_ + _loc19_ * _loc24_;
            }
            _loc28_++;
         }
      }
      
      private function onTransitionComplete(param1:AnimationStateEvent) : void
      {
         if(param1.type == AnimationStateEvent.TRANSITION_COMPLETE)
         {
            param1.animationNode.removeEventListener(AnimationStateEvent.TRANSITION_COMPLETE,this.onTransitionComplete);
            if(_activeState == param1.animationState)
            {
               _activeNode = _animationSet.getAnimation(_activeAnimationName);
               _activeState = getAnimationState(_activeNode);
               this._activeSkeletonState = _activeState as ISkeletonAnimationState;
            }
         }
      }
   }
}

import away3d.core.base.CompactSubGeometry;

class SubGeomAnimationState
{
   
   public var animatedVertexData:Vector.<Number>;
   
   public var dirty:Boolean = true;
   
   public function SubGeomAnimationState(param1:CompactSubGeometry)
   {
      super();
      this.animatedVertexData = param1.vertexData.concat();
   }
}
