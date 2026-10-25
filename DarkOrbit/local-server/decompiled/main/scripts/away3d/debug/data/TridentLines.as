package away3d.debug.data
{
   import away3d.entities.SegmentSet;
   import away3d.primitives.LineSegment;
   import flash.geom.Vector3D;
   
   public class TridentLines extends SegmentSet
   {
      
      public function TridentLines(param1:Vector.<Vector.<Vector3D>>, param2:Vector.<uint>)
      {
         super();
         this.build(param1,param2);
      }
      
      private function build(param1:Vector.<Vector.<Vector3D>>, param2:Vector.<uint>) : void
      {
         var _loc3_:Vector.<Vector3D> = null;
         var _loc4_:Vector3D = null;
         var _loc5_:Vector3D = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         while(_loc8_ < param1.length)
         {
            _loc6_ = param2[_loc8_];
            _loc3_ = param1[_loc8_];
            _loc7_ = 0;
            while(_loc7_ < _loc3_.length)
            {
               _loc4_ = _loc3_[_loc7_];
               _loc5_ = _loc3_[_loc7_ + 1];
               addSegment(new away3d.primitives.LineSegment(_loc4_,_loc5_,_loc6_,_loc6_,1));
               _loc7_ += 2;
            }
            _loc8_++;
         }
      }
   }
}

