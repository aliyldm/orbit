package away3d.primitives
{
   import away3d.primitives.data.Segment;
   import flash.geom.Vector3D;
   
   public class LineSegment extends Segment
   {
      
      public const TYPE:String = "line";
      
      public function LineSegment(param1:Vector3D, param2:Vector3D, param3:uint = 3355443, param4:uint = 3355443, param5:Number = 1)
      {
         super(param1,param2,null,param3,param4,param5);
      }
   }
}

