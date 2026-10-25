package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import away3d.entities.SegmentSet;
   
   public class CompactCannonBatch3D
   {
      
      public var rim:SegmentSet = new SegmentSet();
      
      public var core:SegmentSet = new SegmentSet();
      
      public var count:int;
      
      public function CompactCannonBatch3D()
      {
         super();
         this.rim.material.dispose();
         this.core.material.dispose();
         this.rim.material = new CompactLightningMaterial3D();
         this.core.material = new CompactLightningMaterial3D();
         this.rim.mouseEnabled = this.core.mouseEnabled = false;
      }
   }
}

