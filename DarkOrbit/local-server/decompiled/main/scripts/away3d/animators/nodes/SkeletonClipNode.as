package away3d.animators.nodes
{
   import away3d.animators.*;
   import away3d.animators.data.*;
   import away3d.animators.states.*;
   import flash.geom.*;
   
   public class SkeletonClipNode extends AnimationClipNodeBase
   {
      
      private var _frames:Vector.<SkeletonPose> = new Vector.<SkeletonPose>();
      
      public var highQuality:Boolean = false;
      
      public function SkeletonClipNode()
      {
         super();
         _stateClass = SkeletonClipState;
      }
      
      public function get frames() : Vector.<SkeletonPose>
      {
         return this._frames;
      }
      
      public function addFrame(param1:SkeletonPose, param2:uint) : void
      {
         this._frames.push(param1);
         _durations.push(param2);
         _numFrames = _durations.length;
         _stitchDirty = true;
      }
      
      public function getAnimationState(param1:IAnimator) : SkeletonClipState
      {
         return param1.getAnimationState(this) as SkeletonClipState;
      }
      
      override protected function updateStitch() : void
      {
         super.updateStitch();
         var _loc1_:uint = _numFrames;
         if(!looping)
         {
            _loc1_--;
         }
         while(_loc1_)
         {
            _totalDuration += _durations[--_loc1_];
         }
      }
   }
}

