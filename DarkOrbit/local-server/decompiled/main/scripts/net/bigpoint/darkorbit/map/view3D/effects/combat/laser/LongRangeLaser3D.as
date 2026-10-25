package net.bigpoint.darkorbit.map.view3D.effects.combat.laser
{
   import away3d.core.math.MathConsts;
   import away3d.entities.SegmentSet;
   import away3d.primitives.LineSegment;
   import away3d.primitives.data.Segment;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.map.model.effects.impl.LongRangeLaserEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   
   public class LongRangeLaser3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "plague_alert_laser.zip";
      
      private static var MAX_TIME:Number = 0.5;
      
      private var _segmentSet:SegmentSet = new SegmentSet();
      
      private var _effect:LongRangeLaserEffect;
      
      private var _mapView:MapView3D;
      
      private var _currentTime:Number = 0;
      
      private var _tmpSourcePos:Vector3D = new Vector3D();
      
      private var _tmpTargetPos:Vector3D = new Vector3D();
      
      public function LongRangeLaser3D(param1:MapView3D, param2:LongRangeLaserEffect)
      {
         this._effect = param2;
         this._mapView = param1;
         var _loc3_:uint = 16711935;
         this._segmentSet.addSegment(new LineSegment(new Vector3D(),new Vector3D(),_loc3_,_loc3_,0.2));
         param1.gameWorld.addChild(this._segmentSet);
         super(param2,PARTICLES_FILE,param2.source.position);
      }
      
      override protected function initAndPlay() : void
      {
         super.initAndPlay();
         this._effect.playSound();
      }
      
      override public function updateObj(param1:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Vector3D = null;
         var _loc6_:StandaloneParticle3D = null;
         this._tmpSourcePos.setTo(this._effect.source.x3D,this._effect.source.y3D,this._effect.source.z3D);
         this._tmpTargetPos.setTo(this._effect.target.x3D,this._effect.target.y3D,this._effect.target.z3D);
         var _loc2_:Segment = this._segmentSet.getSegment(0);
         _loc2_.start = this._tmpSourcePos;
         _loc2_.end = this._tmpTargetPos;
         if(view)
         {
            if(this._currentTime < MAX_TIME)
            {
               this._currentTime += param1;
               _loc3_ = this._effect.target.z3D - this._effect.source.z3D;
               _loc4_ = this._effect.target.x3D - this._effect.source.x3D;
               view.rotationY = Math.atan2(_loc4_,_loc3_) * MathConsts.RADIANS_TO_DEGREES;
               _loc5_ = this._tmpTargetPos.subtract(this._tmpSourcePos);
               _loc5_.scaleBy(this._currentTime / MAX_TIME);
               view.position = this._tmpSourcePos.add(_loc5_);
            }
            else
            {
               this._mapView.gameWorld.removeChild(this._segmentSet);
               if(Settings3D.effects.high.value)
               {
                  _loc6_ = new StandaloneParticle3D(this._effect,"ship_debris.zip",this._effect.target.position,this._effect.target,true,0.5);
                  _loc6_.fixedScale = 0.5;
               }
               disposeView(true);
            }
         }
      }
   }
}

