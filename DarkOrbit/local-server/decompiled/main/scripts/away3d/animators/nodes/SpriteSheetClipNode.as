package away3d.animators.nodes
{
   import away3d.animators.data.*;
   import away3d.animators.states.*;
   
   public class SpriteSheetClipNode extends AnimationClipNodeBase
   {
      
      private var _frames:Vector.<SpriteSheetAnimationFrame> = new Vector.<SpriteSheetAnimationFrame>();
      
      public function SpriteSheetClipNode()
      {
         super();
         _stateClass = SpriteSheetAnimationState;
      }
      
      public function get frames() : Vector.<SpriteSheetAnimationFrame>
      {
         return this._frames;
      }
      
      public function addFrame(param1:SpriteSheetAnimationFrame, param2:uint) : void
      {
         this._frames.push(param1);
         _durations.push(param2);
         _numFrames = _durations.length;
         _stitchDirty = false;
      }
   }
}

