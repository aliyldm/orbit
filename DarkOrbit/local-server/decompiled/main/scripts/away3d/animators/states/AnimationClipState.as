package away3d.animators.states
{
   import away3d.animators.*;
   import away3d.animators.nodes.*;
   import away3d.events.*;
   
   public class AnimationClipState extends AnimationStateBase
   {
      
      private var _animationClipNode:AnimationClipNodeBase;
      
      private var _animationStatePlaybackComplete:AnimationStateEvent;
      
      protected var _blendWeight:Number;
      
      protected var _currentFrame:uint;
      
      protected var _nextFrame:uint;
      
      protected var _framesDirty:Boolean = true;
      
      public var playReversed:Boolean = false;
      
      public function AnimationClipState(param1:IAnimator, param2:AnimationClipNodeBase)
      {
         super(param1,param2);
         this._animationClipNode = param2;
      }
      
      public function get blendWeight() : Number
      {
         if(this._framesDirty)
         {
            this.updateFrames();
         }
         return this._blendWeight;
      }
      
      public function get currentFrame() : uint
      {
         if(this._framesDirty)
         {
            this.updateFrames();
         }
         return this._currentFrame;
      }
      
      public function get nextFrame() : uint
      {
         if(this._framesDirty)
         {
            this.updateFrames();
         }
         return this._nextFrame;
      }
      
      override public function set time(param1:int) : void
      {
         if(!this._animationClipNode.looping)
         {
            if(param1 > this._animationClipNode.totalDuration)
            {
               param1 = int(this._animationClipNode.totalDuration);
            }
            else if(param1 < 0)
            {
               param1 = 0;
            }
         }
         this._framesDirty = true;
         super.time = param1;
      }
      
      protected function updateFrames() : void
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Vector.<uint> = null;
         this._framesDirty = false;
         var _loc1_:Boolean = this._animationClipNode.looping;
         var _loc2_:uint = this._animationClipNode.totalDuration;
         var _loc3_:uint = this._animationClipNode.lastFrame;
         var _loc4_:uint = 0;
         var _loc5_:int = _time;
         if(this.playReversed)
         {
            _loc6_ = _loc3_;
            _loc3_ = _loc4_;
            _loc4_ = _loc6_;
         }
         if(_loc1_ && (_loc5_ > _loc2_ || _loc5_ < 0))
         {
            _loc5_ %= _loc2_;
            if(_loc5_ < 0)
            {
               _loc5_ += _loc2_;
            }
         }
         if(!_loc1_ && _loc5_ >= _loc2_)
         {
            this.notifyPlaybackComplete();
            this._currentFrame = _loc3_;
            this._nextFrame = _loc3_;
            this._blendWeight = 0;
         }
         else if(!_loc1_ && _loc5_ <= 0)
         {
            this._currentFrame = _loc4_;
            this._nextFrame = _loc4_;
            this._blendWeight = 0;
         }
         else
         {
            this._currentFrame = _loc4_;
            this._nextFrame = _loc4_;
            _loc7_ = 0;
            _loc9_ = this._animationClipNode.durations;
            do
            {
               _loc8_ = _loc7_;
               _loc7_ += _loc9_[this.nextFrame];
               if(this.playReversed)
               {
                  this._currentFrame = this._nextFrame--;
               }
               else
               {
                  this._currentFrame = this._nextFrame++;
               }
            }
            while(_loc5_ > _loc7_);
            if(this._currentFrame == _loc3_)
            {
               this._currentFrame = _loc3_;
               this._nextFrame = this._animationClipNode.stitchFinalFrame ? _loc4_ : _loc3_;
            }
            this._blendWeight = this.calculateBlendWeight(_loc5_ - _loc8_,_loc9_[this._currentFrame]);
         }
      }
      
      protected function calculateBlendWeight(param1:uint, param2:uint) : Number
      {
         return param1 / param2;
      }
      
      private function notifyPlaybackComplete() : void
      {
         this._animationClipNode.dispatchEvent(this._animationStatePlaybackComplete = this._animationStatePlaybackComplete || new AnimationStateEvent(AnimationStateEvent.PLAYBACK_COMPLETE,_animator,this,this._animationClipNode));
      }
   }
}

