package away3d.animators.data
{
   import away3d.library.assets.*;
   
   public class Skeleton extends NamedAssetBase implements IAsset
   {
      
      public var joints:Vector.<SkeletonJoint>;
      
      public function Skeleton()
      {
         super();
         this.joints = new Vector.<SkeletonJoint>();
      }
      
      public function get numJoints() : uint
      {
         return this.joints.length;
      }
      
      public function jointFromName(param1:String) : SkeletonJoint
      {
         var _loc2_:int = this.jointIndexFromName(param1);
         if(_loc2_ != -1)
         {
            return this.joints[_loc2_];
         }
         return null;
      }
      
      public function jointIndexFromName(param1:String) : int
      {
         var _loc2_:int = 0;
         var _loc3_:SkeletonJoint = null;
         for each(_loc3_ in this.joints)
         {
            if(_loc3_.name == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function dispose() : void
      {
         this.joints.length = 0;
      }
      
      public function get assetType() : String
      {
         return AssetType.SKELETON;
      }
   }
}

