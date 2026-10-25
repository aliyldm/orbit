package away3d.animators.data
{
   import away3d.core.math.Quaternion;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   public class JointPose
   {
      
      public var name:String;
      
      public var orientation:Quaternion = new Quaternion();
      
      public var translation:Vector3D = new Vector3D();
      
      public function JointPose()
      {
         super();
      }
      
      public function toMatrix3D(param1:Matrix3D = null) : Matrix3D
      {
         param1 ||= new Matrix3D();
         this.orientation.toMatrix3D(param1);
         param1.appendTranslation(this.translation.x,this.translation.y,this.translation.z);
         return param1;
      }
      
      public function copyFrom(param1:JointPose) : void
      {
         var _loc2_:Quaternion = param1.orientation;
         var _loc3_:Vector3D = param1.translation;
         this.orientation.x = _loc2_.x;
         this.orientation.y = _loc2_.y;
         this.orientation.z = _loc2_.z;
         this.orientation.w = _loc2_.w;
         this.translation.x = _loc3_.x;
         this.translation.y = _loc3_.y;
         this.translation.z = _loc3_.z;
      }
   }
}

