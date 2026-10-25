package away3d.animators.nodes
{
   import away3d.arcane;
   import flash.geom.*;
   
   use namespace arcane;
   
   public class AnimationClipNodeBase extends AnimationNodeBase
   {
      
      protected var _looping:Boolean = true;
      
      protected var _totalDuration:uint = 0;
      
      protected var _lastFrame:uint;
      
      protected var _stitchDirty:Boolean = true;
      
      protected var _stitchFinalFrame:Boolean = false;
      
      protected var _numFrames:uint = 0;
      
      protected var _durations:Vector.<uint> = new Vector.<uint>();
      
      public function AnimationClipNodeBase()
      {
         super();
      }
      
      public function get looping() : Boolean
      {
         return this._looping;
      }
      
      public function set looping(param1:Boolean) : void
      {
         if(this._looping == param1)
         {
            return;
         }
         this._looping = param1;
         this._stitchDirty = true;
      }
      
      public function get stitchFinalFrame() : Boolean
      {
         return this._stitchFinalFrame;
      }
      
      public function set stitchFinalFrame(param1:Boolean) : void
      {
         if(this._stitchFinalFrame == param1)
         {
            return;
         }
         this._stitchFinalFrame = param1;
         this._stitchDirty = true;
      }
      
      public function get totalDuration() : uint
      {
         if(this._stitchDirty)
         {
            this.updateStitch();
         }
         return this._totalDuration;
      }
      
      public function get lastFrame() : uint
      {
         if(this._stitchDirty)
         {
            this.updateStitch();
         }
         return this._lastFrame;
      }
      
      public function get durations() : Vector.<uint>
      {
         return this._durations;
      }
      
      protected function updateStitch() : void
      {
         this._stitchDirty = false;
         this._lastFrame = this._looping && this._stitchFinalFrame ? this._numFrames : uint(this._numFrames - 1);
         this._totalDuration = 0;
      }
   }
}

