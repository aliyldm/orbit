package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import flash.filters.BlurFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.impl.beam.BeamEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   import org.flintparticles.common.counters.Pulse;
   import org.flintparticles.common.initializers.ColorInit;
   import org.flintparticles.twoD.actions.DeathZone;
   import org.flintparticles.twoD.actions.Move;
   import org.flintparticles.twoD.emitters.Emitter2D;
   import org.flintparticles.twoD.initializers.Position;
   import org.flintparticles.twoD.initializers.Velocity;
   import org.flintparticles.twoD.renderers.PixelRenderer;
   import org.flintparticles.twoD.zones.DiscZone;
   import org.flintparticles.twoD.zones.LineZone;
   import org.flintparticles.twoD.zones.PointZone;
   
   public class EmitterBeamEffectView2D extends AbstractMapObjectEffect2D implements IFrameObserver
   {
      
      private var _removed:Boolean;
      
      private const DIS_X:Number = 550;
      
      private const DIS_Y:Number = 40;
      
      private const RADIANS:Number = 57.29577951308232;
      
      private var _emitter:Emitter2D;
      
      private var _renderer:PixelRenderer;
      
      private var _velocity:Velocity;
      
      private var _move:Move = new Move();
      
      private var _angle:Number;
      
      private var _rayHeight:Number;
      
      private var _distance:Number;
      
      private var _oldDistance:Number;
      
      private var _oldHeight:Number;
      
      private var _particleCount:Number;
      
      private var _pulse:Pulse;
      
      private var _attackerShip:MapEntity;
      
      private var _targetShip:MapEntity;
      
      private var _sourcePos:PointLite;
      
      private var _targetPos:PointLite;
      
      private var _dZone:DiscZone = new DiscZone(new Point(0,0),200);
      
      private var _color:int;
      
      private var _maxDistance:Number;
      
      public function EmitterBeamEffectView2D(param1:MapView2D, param2:BeamEffect)
      {
         this._color = param2.color;
         super(param1,param2);
      }
      
      private function get beamEffect() : BeamEffect
      {
         return effect as BeamEffect;
      }
      
      override protected function initEffectVisuals() : void
      {
         super.initEffectVisuals();
         this._emitter = new Emitter2D();
         this._emitter.addInitializer(new ColorInit(this._color,this._color));
         var _loc1_:PointZone = new PointZone(new Point(0,0));
         var _loc2_:Position = new Position(_loc1_);
         this._emitter.addInitializer(_loc2_);
         this.startEmitter(this.beamEffect.source.position,this.beamEffect.target.position,this.beamEffect.source as MapEntity,this.beamEffect.target as MapEntity);
      }
      
      private function deleteParticles(param1:Point, param2:Number) : void
      {
         this._dZone.center = param1;
         this._dZone.outerRadius = param2 + 200;
      }
      
      private function startEmitter(param1:PointLite, param2:PointLite, param3:MapEntity = null, param4:MapEntity = null) : void
      {
         this._maxDistance = 1280;
         this._sourcePos = param1;
         this._targetPos = param2;
         this._attackerShip = param3;
         this._targetShip = param4;
         if(param1 == null || param2 == null)
         {
            return;
         }
         this._oldDistance = Math.sqrt(Math.pow(param2.y - param1.y,2) + Math.pow(param2.x - param1.x,2));
         this._oldDistance = this._oldDistance > this._maxDistance ? 20 : this._oldDistance;
         this._oldHeight = this._oldDistance * this.DIS_Y / this.DIS_X << 1;
         var _loc5_:BlurFilter = new BlurFilter(4,4,1);
         var _loc6_:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0.99,0]);
         if(this._oldDistance == 0 || this._oldHeight == 0)
         {
            this._oldDistance = 249;
            this._oldHeight = 36;
         }
         this._renderer = new PixelRenderer(new Rectangle(0,this._oldHeight * -0.5,this._oldDistance,this._oldHeight));
         this._renderer.name = "renderer";
         this._renderer.addFilter(_loc5_);
         this._renderer.addFilter(_loc6_);
         this._pulse = new Pulse(0.2,10);
         this.updateTimer(0);
         var _loc7_:Point = new Point(this.DIS_X,this.DIS_Y);
         var _loc8_:Point = new Point(this.DIS_X,~this.DIS_Y + 1);
         var _loc9_:LineZone = new LineZone(_loc7_,_loc8_);
         this._velocity = new Velocity(_loc9_);
         if(this._emitter == null)
         {
            this._emitter = new Emitter2D();
         }
         this._emitter.addInitializer(this._velocity);
         var _loc10_:DeathZone = new DeathZone(this._dZone,true);
         this._emitter.addAction(_loc10_);
         this._emitter.counter = this._pulse;
         this._emitter.addAction(this._move);
         this._renderer.addEmitter(this._emitter);
         if(getChildByName("renderer") == null)
         {
            addChild(this._renderer);
         }
         if(mapObjectView != null)
         {
            mapObjectView.addChild(this);
         }
         this._emitter.start();
         ScreenManager.addObserver(this);
      }
      
      private function stopEmitter() : void
      {
         ScreenManager.removeObserver(this);
         this._pulse.stop();
         this._emitter.killAllParticles();
         this._emitter.removeInitializer(this._velocity);
         this._emitter.removeAction(this._move);
      }
      
      public function updateTimer(param1:Number) : void
      {
         if(!this._removed)
         {
            if(this._targetShip != null && Boolean(ScreenManager.getInstance().map.getShipManager().getShip(this._targetShip.id)))
            {
               this._targetPos.x = this._targetShip.position.x;
               this._targetPos.y = this._targetShip.position.y;
            }
            if(this._attackerShip != null && Boolean(ScreenManager.getInstance().map.getShipManager().getShip(this._attackerShip.id)))
            {
               this._sourcePos.x = this._attackerShip.position.x;
               this._sourcePos.y = this._attackerShip.position.y;
            }
            this._angle = Math.atan2(this._targetPos.y - this._sourcePos.y,this._targetPos.x - this._sourcePos.x) * this.RADIANS;
            this._distance = Math.sqrt(Math.pow(this._targetPos.y - this._sourcePos.y,2) + Math.pow(this._targetPos.x - this._sourcePos.x,2));
            this._distance = this._distance > this._maxDistance ? 20 : this._distance;
            this._rayHeight = this._distance * this.DIS_Y / this.DIS_X << 1;
            this._rayHeight = this._rayHeight > 30 ? 30 : this._rayHeight;
            this._renderer.scaleX = this._distance / this._oldDistance;
            this._renderer.scaleY = this._rayHeight / this._oldHeight;
            this._particleCount = this._distance >> 2;
            this._pulse.quantity = this._particleCount;
            this._renderer.rotation = this._angle;
            this.deleteParticles(new Point(0,this._rayHeight * -0.5),this._distance);
         }
         else
         {
            this.stopEmitter();
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         this._removed = true;
         super.disposeView(param1);
      }
   }
}

