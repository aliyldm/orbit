package away3d.events
{
   import away3d.animators.IAnimator;
   import away3d.animators.nodes.AnimationNodeBase;
   import away3d.animators.states.IAnimationState;
   import flash.events.Event;
   
   public class AnimationStateEvent extends Event
   {
      
      public static const PLAYBACK_COMPLETE:String = "playbackComplete";
      
      public static const TRANSITION_COMPLETE:String = "transitionComplete";
      
      private var _animator:IAnimator;
      
      private var _animationState:IAnimationState;
      
      private var _animationNode:AnimationNodeBase;
      
      public function AnimationStateEvent(param1:String, param2:IAnimator, param3:IAnimationState, param4:AnimationNodeBase)
      {
         super(param1,false,false);
         this._animator = param2;
         this._animationState = param3;
         this._animationNode = param4;
      }
      
      public function get animator() : IAnimator
      {
         return this._animator;
      }
      
      public function get animationState() : IAnimationState
      {
         return this._animationState;
      }
      
      public function get animationNode() : AnimationNodeBase
      {
         return this._animationNode;
      }
      
      override public function clone() : Event
      {
         return new AnimationStateEvent(type,this._animator,this._animationState,this._animationNode);
      }
   }
}

