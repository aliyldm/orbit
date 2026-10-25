package away3d.animators.states
{
   import away3d.animators.*;
   import away3d.animators.data.*;
   import away3d.animators.nodes.*;
   
   public class UVClipState extends AnimationClipState implements IUVAnimationState
   {
      
      private var _frames:Vector.<UVAnimationFrame>;
      
      private var _uvClipNode:UVClipNode;
      
      private var _currentUVFrame:UVAnimationFrame;
      
      private var _nextUVFrame:UVAnimationFrame;
      
      public function UVClipState(param1:IAnimator, param2:UVClipNode)
      {
         super(param1,param2);
         this._uvClipNode = param2;
         this._frames = this._uvClipNode.frames;
      }
      
      public function get currentUVFrame() : UVAnimationFrame
      {
         if(_framesDirty)
         {
            this.updateFrames();
         }
         return this._currentUVFrame;
      }
      
      public function get nextUVFrame() : UVAnimationFrame
      {
         if(_framesDirty)
         {
            this.updateFrames();
         }
         return this._nextUVFrame;
      }
      
      override protected function updateFrames() : void
      {
         super.updateFrames();
         if(this._frames.length > 0)
         {
            if(this._frames.length == 2 && _currentFrame == 0)
            {
               this._currentUVFrame = this._frames[1];
               this._nextUVFrame = this._frames[0];
            }
            else
            {
               this._currentUVFrame = this._frames[_currentFrame];
               if(this._uvClipNode.looping && _nextFrame >= this._uvClipNode.lastFrame)
               {
                  this._nextUVFrame = this._frames[0];
               }
               else
               {
                  this._nextUVFrame = this._frames[_nextFrame];
               }
            }
         }
      }
   }
}

