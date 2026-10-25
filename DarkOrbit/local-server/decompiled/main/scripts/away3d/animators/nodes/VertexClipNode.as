package away3d.animators.nodes
{
   import away3d.animators.states.*;
   import away3d.core.base.*;
   import flash.geom.*;
   
   public class VertexClipNode extends AnimationClipNodeBase
   {
      
      public static const BLEND_LINEAR:uint = 0;
      
      public static const BLEND_QUAD_IN_OUT:uint = 1;
      
      public static const BLEND_QUAD_IN:uint = 2;
      
      public static const BLEND_QUAD_OUT:uint = 3;
      
      public static const AVAILABLE_BLEND_TYPES:Array = [BLEND_LINEAR,BLEND_QUAD_IN_OUT,BLEND_QUAD_IN,BLEND_QUAD_OUT];
      
      private var _frames:Vector.<VertexClipFrame> = new Vector.<VertexClipFrame>();
      
      public function VertexClipNode()
      {
         super();
         _stateClass = VertexClipState;
      }
      
      public function get frames() : Vector.<VertexClipFrame>
      {
         return this._frames;
      }
      
      public function addFrame(param1:VertexClipFrame) : void
      {
         this._frames.push(param1);
         _durations.push(param1.duration);
         _numFrames = this._frames.length;
         _stitchDirty = true;
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
      
      public function removeAllFrames() : void
      {
         this._frames.length = 0;
         _durations.length = 0;
         _numFrames = 0;
         _totalDuration = 0;
         _lastFrame = 0;
         _stitchDirty = true;
      }
   }
}

