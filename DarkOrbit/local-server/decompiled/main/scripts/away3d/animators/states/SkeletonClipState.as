package away3d.animators.states
{
   import away3d.animators.*;
   import away3d.animators.data.*;
   import away3d.animators.nodes.*;
   import flash.geom.*;
   
   public class SkeletonClipState extends AnimationClipState implements ISkeletonAnimationState
   {
      
      private var _rootPos:Vector3D = new Vector3D();
      
      private var _frames:Vector.<SkeletonPose>;
      
      private var _skeletonClipNode:SkeletonClipNode;
      
      private var _skeletonPose:SkeletonPose = new SkeletonPose();
      
      private var _skeletonPoseDirty:Boolean = true;
      
      private var _currentPose:SkeletonPose;
      
      private var _nextPose:SkeletonPose;
      
      public function SkeletonClipState(param1:IAnimator, param2:SkeletonClipNode)
      {
         super(param1,param2);
         this._skeletonClipNode = param2;
         this._frames = this._skeletonClipNode.frames;
      }
      
      public function get currentPose() : SkeletonPose
      {
         if(_framesDirty)
         {
            this.updateFrames();
         }
         return this._currentPose;
      }
      
      public function get nextPose() : SkeletonPose
      {
         if(_framesDirty)
         {
            this.updateFrames();
         }
         return this._nextPose;
      }
      
      public function getSkeletonPose(param1:Skeleton) : SkeletonPose
      {
         if(this._skeletonPoseDirty)
         {
            this.updateSkeletonPose(param1);
         }
         return this._skeletonPose;
      }
      
      override public function set time(param1:int) : void
      {
         this._skeletonPoseDirty = true;
         super.time = param1;
      }
      
      override protected function updateFrames() : void
      {
         super.updateFrames();
         this._currentPose = this._frames[_currentFrame];
         if(this._skeletonClipNode.looping && this._skeletonClipNode.stitchFinalFrame && _nextFrame > this._skeletonClipNode.lastFrame)
         {
            this._nextPose = this._frames[0];
            SkeletonAnimator(_animator).dispatchCycleEvent();
         }
         else
         {
            this._nextPose = this._frames[_nextFrame % this._frames.length];
         }
      }
      
      private function updateSkeletonPose(param1:Skeleton) : void
      {
         var _loc5_:Vector3D = null;
         var _loc6_:Vector3D = null;
         var _loc7_:JointPose = null;
         var _loc8_:JointPose = null;
         var _loc10_:JointPose = null;
         var _loc11_:Vector3D = null;
         this._skeletonPoseDirty = false;
         if(!this._skeletonClipNode.totalDuration)
         {
            return;
         }
         if(_framesDirty)
         {
            this.updateFrames();
         }
         var _loc2_:Vector.<JointPose> = this._currentPose.jointPoses;
         var _loc3_:Vector.<JointPose> = this._nextPose.jointPoses;
         var _loc4_:uint = param1.numJoints;
         var _loc9_:Vector.<JointPose> = this._skeletonPose.jointPoses;
         if(_loc9_.length != _loc4_)
         {
            _loc9_.length = _loc4_;
         }
         if(_loc4_ != _loc2_.length || _loc4_ != _loc3_.length)
         {
            throw new Error("joint counts don\'t match!");
         }
         var _loc12_:uint = 0;
         while(_loc12_ < _loc4_)
         {
            _loc10_ = _loc9_[_loc12_] = _loc9_[_loc12_] || new JointPose();
            _loc7_ = _loc2_[_loc12_];
            _loc8_ = _loc3_[_loc12_];
            _loc5_ = _loc7_.translation;
            _loc6_ = _loc8_.translation;
            if(this._skeletonClipNode.highQuality)
            {
               _loc10_.orientation.slerp(_loc7_.orientation,_loc8_.orientation,_blendWeight);
            }
            else
            {
               _loc10_.orientation.lerp(_loc7_.orientation,_loc8_.orientation,_blendWeight);
            }
            _loc11_ = _loc10_.translation;
            _loc11_.x = _loc5_.x + _blendWeight * (_loc6_.x - _loc5_.x);
            _loc11_.y = _loc5_.y + _blendWeight * (_loc6_.y - _loc5_.y);
            _loc11_.z = _loc5_.z + _blendWeight * (_loc6_.z - _loc5_.z);
            _loc12_++;
         }
      }
      
      override protected function updatePositionDelta() : void
      {
         _positionDeltaDirty = false;
      }
   }
}

