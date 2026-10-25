package away3d.animators.nodes
{
   import away3d.animators.data.*;
   import away3d.animators.states.*;
   
   public class UVClipNode extends AnimationClipNodeBase
   {
      
      private var _frames:Vector.<UVAnimationFrame> = new Vector.<UVAnimationFrame>();
      
      public function UVClipNode()
      {
         super();
         _stateClass = UVClipState;
      }
      
      public function get frames() : Vector.<UVAnimationFrame>
      {
         return this._frames;
      }
      
      public function addFrame(param1:UVAnimationFrame, param2:uint) : void
      {
         this._frames.push(param1);
         _durations.push(param2);
         _numFrames = _durations.length;
         _stitchDirty = true;
      }
      
      override protected function updateStitch() : void
      {
         var _loc1_:uint = 0;
         super.updateStitch();
         if(_durations.length > 0)
         {
            _loc1_ = _numFrames - 1;
            while(_loc1_--)
            {
               _totalDuration += _durations[_loc1_];
            }
            if(_stitchFinalFrame || !_looping)
            {
               _totalDuration += _durations[_numFrames - 1];
            }
         }
      }
   }
}

