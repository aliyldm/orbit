package net.bigpoint.darkorbit.map.view3D.effects.combat.laser
{
   import away3d.entities.SegmentSet;
   import away3d.primitives.LineSegment;
   import away3d.primitives.data.Segment;
   import flash.geom.Vector3D;
   import flash.utils.getTimer;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.TimerEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.SnipedLaserEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import starling.utils.Color;
   
   public class SnipedLaser3D extends MapObjectEffect implements IUpdatable
   {
      
      private var _segmentSet:SegmentSet;
      
      private var _tmpSourcePos:Vector3D = new Vector3D();
      
      private var _tmpTargetPos:Vector3D = new Vector3D();
      
      private var _target:MapEntity;
      
      private var _mapView:MapView3D;
      
      public function SnipedLaser3D(param1:MapView3D, param2:SnipedLaserEffect)
      {
         super(EffectIDList.SNIPED_LASER_EFFECT,param2.source,Effect.TIME_OUT,null,-1);
         this._target = param2.target;
         this.timeOutTime = param2.countDown * 1000;
         this._mapView = param1;
         this._segmentSet = new SegmentSet();
         this.activate();
         ScreenManager.getInstance().map.effects.addEffect(new TimerEffect(this._target,param2.timeOutTime));
      }
      
      public function updateObj(param1:Number) : void
      {
         this._tmpSourcePos.setTo(source.x3D,source.y3D,source.z3D);
         this._tmpTargetPos.setTo(this._target.x3D,this._target.y3D,this._target.z3D);
         var _loc2_:Segment = this._segmentSet.getSegment(0);
         _loc2_.start = this._tmpSourcePos;
         _loc2_.end = this._tmpTargetPos;
         _loc2_.thickness = getTimer() % 200 / 200;
      }
      
      override public function activate() : Boolean
      {
         this._segmentSet.addSegment(new LineSegment(new Vector3D(),new Vector3D(),Color.RED,Color.YELLOW,2));
         this._mapView.gameWorld.addChild(this._segmentSet);
         this._mapView.addUpdatable(this);
         return super.activate();
      }
      
      override public function deactivate() : void
      {
         this._mapView.removeUpdatable(this);
         this._segmentSet.removeAllSegments();
         this._mapView.gameWorld.removeChild(this._segmentSet);
         super.deactivate();
      }
   }
}

