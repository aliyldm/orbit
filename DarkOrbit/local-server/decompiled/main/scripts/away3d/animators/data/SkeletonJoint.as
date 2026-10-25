package away3d.animators.data
{
   public class SkeletonJoint
   {
      
      public var parentIndex:int = -1;
      
      public var name:String;
      
      public var inverseBindPose:Vector.<Number>;
      
      public function SkeletonJoint()
      {
         super();
      }
   }
}

