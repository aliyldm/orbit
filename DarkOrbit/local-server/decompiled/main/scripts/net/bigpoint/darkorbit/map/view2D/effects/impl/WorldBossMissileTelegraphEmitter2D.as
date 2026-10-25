package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Vector3D;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.map.model.effects.impl.WorldBossMissileTelegraphEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   
   public class WorldBossMissileTelegraphEmitter2D extends AbstractEffect2D
   {
      
      private static const LOGGER:ILogger = Log.getLogger("WorldBossMissileTelegraphEmitter2D");
      
      private static const RECT_WIDTH:Number = 20;
      
      private static const RECT_HEIGHT:Number = 10;
      
      private static const RADIANS:Number = 57.29577951308232;
      
      private static const VELOCITY:Number = 700;
      
      private static const MAX_PARTICLES:Number = 50;
      
      private var _arrSourcePt:PointLite;
      
      private var _arrTargetPt:PointLite;
      
      private var _color:int;
      
      private var _maxDist:Number;
      
      private var _duration:Number;
      
      private var _vec:Vector3D;
      
      private var _angle:Number;
      
      private var _shapes:Vector.<Shape> = new Vector.<Shape>(0);
      
      private var _delay:Number;
      
      public function WorldBossMissileTelegraphEmitter2D(param1:MapView2D, param2:WorldBossMissileTelegraphEffect, param3:int)
      {
         this._arrSourcePt = param2.positions[param3];
         this._arrTargetPt = param2.positions[param3 + 1];
         this._color = param2.color;
         this._maxDist = param2.maxDist;
         this._vec = new Vector3D(this._arrTargetPt.x - this._arrSourcePt.x,this._arrTargetPt.y - this._arrSourcePt.y);
         this._duration = this._vec.length / VELOCITY;
         this._angle = Vector3D.angleBetween(new Vector3D(0,-1,0),this._vec) * RADIANS;
         this._delay = this._duration / MAX_PARTICLES;
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         mapView.fxLayer.addChild(this);
         this.x = this._arrSourcePt.x;
         this.y = this._arrSourcePt.y;
         this.play();
      }
      
      private function play() : void
      {
         this.delaySpawnParticle();
      }
      
      private function delaySpawnParticle() : void
      {
         if(this._shapes.length < MAX_PARTICLES)
         {
            this.createParticle();
            TweenLite.delayedCall(this._delay,this.delaySpawnParticle);
         }
      }
      
      private function createParticle() : void
      {
         var _loc1_:Shape = new Shape();
         var _loc2_:Graphics = _loc1_.graphics;
         _loc2_.beginFill(this._color,0.5);
         _loc2_.drawRect(0,0,1,0.1);
         _loc2_.endFill();
         addChild(_loc1_);
         this._shapes.push(_loc1_);
         _loc1_.width = RECT_WIDTH;
         _loc1_.height = RECT_HEIGHT;
         _loc1_.rotation = this._angle;
         this.playMoveTween(_loc1_);
      }
      
      private function playMoveTween(param1:Shape) : *
      {
         param1.x = 0;
         param1.y = 0;
         param1.alpha = 1;
         TweenLite.to(param1,this._duration,{
            "ease":"none",
            "x":this._vec.x,
            "y":this._vec.y,
            "onComplete":this.playMoveTween,
            "onCompleteParams":[param1]
         });
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         var _loc2_:Shape = null;
         for each(_loc2_ in this._shapes)
         {
            TweenLite.killTweensOf(_loc2_);
         }
         super.disposeView(false);
      }
   }
}

