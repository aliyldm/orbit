package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AbsorbationBeamEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class AbsorbationBeamEffect2D extends AbstractMapObjectEffect2D implements IFrameObserver
   {
      
      private const RADIANS:Number = 57.29577951308232;
      
      private var _index:uint = 0;
      
      private var _ringCount:int = 2;
      
      private var _timeBetweenRings:uint = 200;
      
      private var _endTime:Number = 0;
      
      private var _rings:Vector.<DisplayObject>;
      
      private var _ringContainer:DisplayObjectContainer;
      
      private var _targetPoint:Point;
      
      private var _effect:AbsorbationBeamEffect;
      
      public function AbsorbationBeamEffect2D(param1:MapView2D, param2:AbsorbationBeamEffect)
      {
         this._effect = param2;
         this._ringCount = param2.isElite ? 4 : 3;
         this._timeBetweenRings = param2.isElite ? 200 : 150;
         super(param1,param2);
         this._endTime = this._timeBetweenRings;
      }
      
      private function updateTargetPoint() : void
      {
         if(this._effect.source)
         {
            this._targetPoint = new Point(this._effect.target.position.x - this._effect.source.position.x,this._effect.target.position.y - this._effect.source.position.y);
         }
      }
      
      private function calcAngle() : Number
      {
         return this.RADIANS * Math.atan2(this._targetPoint.y,this._targetPoint.x);
      }
      
      override protected function initEffectVisuals() : void
      {
         var _loc2_:DisplayObject = null;
         this._ringContainer = this.clip.parent;
         clip.alpha = 0;
         this._rings = new Vector.<DisplayObject>();
         this._rings.push(clip);
         var _loc1_:int = 0;
         while(_loc1_ < this._ringCount)
         {
            _loc2_ = MovieClipUtils.duplicateDisplayObject(clip);
            _loc2_.alpha = 0;
            addChild(_loc2_);
            this._rings.push(_loc2_);
            _loc1_++;
         }
         ScreenManager.addObserver(this);
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:DisplayObject = null;
         this._endTime += param1;
         if(this._endTime > this._timeBetweenRings)
         {
            this._endTime -= this._timeBetweenRings;
            if(this._index <= this._rings.length - 1)
            {
               this.updateTargetPoint();
               _loc2_ = this._rings[this._index];
               _loc2_.alpha = 1;
               _loc2_.x = this._targetPoint.x;
               _loc2_.y = this._targetPoint.y;
               _loc2_.rotation = this.calcAngle();
               TweenLite.to(_loc2_,0.75,{
                  "x":0,
                  "y":0,
                  "scaleX":0.5,
                  "scaleY":0.5,
                  "alpha":0.4,
                  "onComplete":this.handleRingTweenFinished,
                  "onCompleteParams":[_loc2_],
                  "ease":Linear.easeNone
               });
               ++this._index;
            }
         }
      }
      
      private function handleRingTweenFinished(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObject = param1;
         if(_loc2_)
         {
            this._ringContainer.removeChild(_loc2_);
         }
         if(this._ringContainer.numChildren == 0)
         {
            this.disposeView();
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         ScreenManager.removeObserver(this);
         super.disposeView(param1);
      }
   }
}

