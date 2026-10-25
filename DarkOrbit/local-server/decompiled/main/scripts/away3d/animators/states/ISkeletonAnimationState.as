package away3d.animators.states
{
   import away3d.animators.data.Skeleton;
   import away3d.animators.data.SkeletonPose;
   
   public interface ISkeletonAnimationState extends IAnimationState
   {
      
      function getSkeletonPose(param1:Skeleton) : SkeletonPose;
   }
}

