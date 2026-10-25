package away3d.animators.data
{
   import away3d.library.assets.*;
   
   public class SkeletonPose extends NamedAssetBase implements IAsset
   {
      
      public var jointPoses:Vector.<JointPose>;
      
      public function SkeletonPose()
      {
         super();
         this.jointPoses = new Vector.<JointPose>();
      }
      
      public function get numJointPoses() : uint
      {
         return this.jointPoses.length;
      }
      
      public function get assetType() : String
      {
         return AssetType.SKELETON_POSE;
      }
      
      public function jointPoseFromName(param1:String) : JointPose
      {
         var _loc2_:int = this.jointPoseIndexFromName(param1);
         if(_loc2_ != -1)
         {
            return this.jointPoses[_loc2_];
         }
         return null;
      }
      
      public function jointPoseIndexFromName(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:JointPose = null;
         for each(_loc3_ in this.jointPoses)
         {
            if(_loc3_.name == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function clone() : SkeletonPose
      {
         var _loc4_:JointPose = null;
         var _loc5_:JointPose = null;
         var _loc1_:SkeletonPose = new SkeletonPose();
         var _loc2_:uint = this.jointPoses.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new JointPose();
            _loc5_ = this.jointPoses[_loc3_];
            _loc4_.name = _loc5_.name;
            _loc4_.copyFrom(_loc5_);
            _loc1_.jointPoses[_loc3_] = _loc4_;
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function dispose() : void
      {
         this.jointPoses.length = 0;
      }
   }
}

