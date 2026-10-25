package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import away3d.primitives.LineSegment;
   import com.bigpoint.utils.PointLite;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   
   public class CompactCannonLink3D implements IDisposable
   {
      
      public static const PIECES:int = 6;
      
      public var owner:CompactCannonLinks3D;
      
      public var from:PointLite;
      
      public var to:PointLite;
      
      public var batch:CompactCannonBatch3D;
      
      public var start:Vector3D = new Vector3D();
      
      public var end:Vector3D = new Vector3D(1,0,0);
      
      public var points:Vector.<Vector3D> = new Vector.<Vector3D>();
      
      public var rims:Vector.<away3d.primitives.LineSegment> = new Vector.<away3d.primitives.LineSegment>();
      
      public var cores:Vector.<away3d.primitives.LineSegment> = new Vector.<away3d.primitives.LineSegment>();
      
      public var rim:away3d.primitives.LineSegment;
      
      public var core:away3d.primitives.LineSegment;
      
      public var lastTick:int = -1;
      
      public var active:Boolean = false;
      
      public var generation:uint;
      
      public var index:int;
      
      public var elapsed:Number;
      
      public var lifetime:Number;
      
      public var lastColor:uint;
      
      public function CompactCannonLink3D()
      {
         super();
         var _loc1_:int = 0;
         while(_loc1_ <= PIECES)
         {
            this.points.push(new Vector3D());
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < PIECES)
         {
            this.rims.push(new away3d.primitives.LineSegment(this.points[_loc1_],this.points[_loc1_ + 1]));
            this.cores.push(new away3d.primitives.LineSegment(this.points[_loc1_],this.points[_loc1_ + 1]));
            _loc1_++;
         }
         this.rim = this.rims[0];
         this.core = this.cores[0];
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this.active && Boolean(this.owner))
         {
            this.owner.release(this);
         }
      }
   }
}

