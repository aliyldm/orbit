package away3d.animators.states
{
   import away3d.animators.*;
   import away3d.animators.data.*;
   import away3d.animators.nodes.*;
   import away3d.arcane;
   
   use namespace arcane;
   
   public class SpriteSheetAnimationState extends AnimationClipState implements ISpriteSheetAnimationState
   {
      
      private var _frames:Vector.<SpriteSheetAnimationFrame>;
      
      private var _clipNode:SpriteSheetClipNode;
      
      private var _currentFrameID:uint = 0;
      
      private var _reverse:Boolean;
      
      private var _back:Boolean;
      
      private var _backAndForth:Boolean;
      
      private var _forcedFrame:Boolean;
      
      public function SpriteSheetAnimationState(param1:IAnimator, param2:SpriteSheetClipNode)
      {
         super(param1,param2);
         this._clipNode = param2;
         this._frames = this._clipNode.frames;
      }
      
      public function set reverse(param1:Boolean) : void
      {
         this._back = false;
         this._reverse = param1;
      }
      
      public function set backAndForth(param1:Boolean) : void
      {
         if(param1)
         {
            this._reverse = false;
         }
         this._back = false;
         this._backAndForth = param1;
      }
      
      public function get currentFrameData() : SpriteSheetAnimationFrame
      {
         if(_framesDirty)
         {
            this.updateFrames();
         }
         return this._frames[this._currentFrameID];
      }
      
      public function get currentFrameNumber() : uint
      {
         return this._currentFrameID;
      }
      
      public function set currentFrameNumber(param1:uint) : void
      {
         this._currentFrameID = param1 > this._frames.length - 1 ? uint(this._frames.length - 1) : param1;
         this._forcedFrame = true;
      }
      
      arcane function get totalFrames() : uint
      {
         return !this._frames ? 0 : this._frames.length;
      }
      
      override protected function updateFrames() : void
      {
         if(this._forcedFrame)
         {
            this._forcedFrame = false;
            return;
         }
         super.updateFrames();
         if(this._reverse)
         {
            if(this._currentFrameID - 1 > -1)
            {
               --this._currentFrameID;
            }
            else
            {
               if(this._clipNode.looping)
               {
                  if(this._backAndForth)
                  {
                     this._reverse = false;
                     ++this._currentFrameID;
                  }
                  else
                  {
                     this._currentFrameID = this._frames.length - 1;
                  }
               }
               SpriteSheetAnimator(_animator).dispatchCycleEvent();
            }
         }
         else if(this._currentFrameID < this._frames.length - 1)
         {
            ++this._currentFrameID;
         }
         else
         {
            if(this._clipNode.looping)
            {
               if(this._backAndForth)
               {
                  this._reverse = true;
                  --this._currentFrameID;
               }
               else
               {
                  this._currentFrameID = 0;
               }
            }
            SpriteSheetAnimator(_animator).dispatchCycleEvent();
         }
      }
   }
}

