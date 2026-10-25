package away3d.animators.states
{
   import away3d.animators.IAnimator;
   import away3d.animators.nodes.AnimationNodeBase;
   import flash.geom.Vector3D;
   
   public class AnimationStateBase implements IAnimationState
   {
      
      protected var _animationNode:AnimationNodeBase;
      
      protected var _rootDelta:Vector3D = new Vector3D();
      
      protected var _positionDeltaDirty:Boolean = true;
      
      protected var _time:int;
      
      protected var _animator:IAnimator;
      
      public function AnimationStateBase(param1:IAnimator, param2:AnimationNodeBase)
      {
         super();
         this._animator = param1;
         this._animationNode = param2;
      }
      
      public function get positionDelta() : Vector3D
      {
         if(this._positionDeltaDirty)
         {
            this.updatePositionDelta();
         }
         return this._rootDelta;
      }
      
      public function set time(param1:int) : void
      {
         if(this._time == param1)
         {
            return;
         }
         this._time = param1;
         this._positionDeltaDirty = true;
      }
      
      protected function updatePositionDelta() : void
      {
      }
   }
}

