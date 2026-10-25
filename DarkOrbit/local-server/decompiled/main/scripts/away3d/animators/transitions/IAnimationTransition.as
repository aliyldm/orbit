package away3d.animators.transitions
{
   import away3d.animators.IAnimator;
   import away3d.animators.nodes.AnimationNodeBase;
   
   public interface IAnimationTransition
   {
      
      function getAnimationNode(param1:IAnimator, param2:AnimationNodeBase, param3:AnimationNodeBase, param4:int) : AnimationNodeBase;
   }
}

