package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.utils.getTimer;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.TimerEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.SnipedLaserEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   import starling.utils.Color;
   
   public class SnipedLaser2D extends AbstractEffect2D implements IFrameObserver
   {
      
      private var _effect:SnipedLaserEffect;
      
      private var _sprite:Sprite;
      
      private var _lastColor:uint = Color.RED;
      
      public function SnipedLaser2D(param1:MapView2D, param2:SnipedLaserEffect)
      {
         this._effect = param2;
         ScreenManager.getInstance().map.effects.addEffect(new TimerEffect(param2.target,param2.timeOutTime));
         super(param1,param2,true);
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:Graphics = this._sprite.graphics;
         _loc2_.clear();
         this._lastColor = this._lastColor == Color.RED ? Color.YELLOW : Color.RED;
         _loc2_.lineStyle(getTimer() % 200 / 20,this._lastColor,1);
         _loc2_.moveTo(this._effect.source.position.x,this._effect.source.position.y);
         _loc2_.lineTo(this._effect.target.position.x,this._effect.target.position.y);
         var _loc3_:Number = Math.atan2(this._effect.target.y - y,this._effect.target.x - x) * 180 / Math.PI + 180;
         var _loc4_:int = _loc3_ % 360;
         while(_loc4_ < 0)
         {
            _loc4_ = 360 + _loc4_;
         }
         rotation = _loc4_;
      }
      
      override protected function initEffectVisuals() : void
      {
         if(Boolean(this._effect.source) || Boolean(this._effect.target))
         {
            this._sprite = new Sprite();
            mapView.fxLayer.addChild(this._sprite);
            mapView.fxLayer.addChild(this);
            ScreenManager.addObserver(this);
            x = this._effect.source.position.x;
            y = this._effect.source.position.y;
            TweenLite.to(this,this._effect.countDown,{
               "dynamicProps":{
                  "x":this.getX,
                  "y":this.getY
               },
               "onComplete":this.handleTweeenFinish,
               "ease":Linear.easeNone
            });
         }
      }
      
      private function handleTweeenFinish() : void
      {
         this.disposeView(true);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         ScreenManager.removeObserver(this);
         if(Boolean(this._sprite) && Boolean(this._sprite.parent))
         {
            this._sprite.parent.removeChild(this._sprite);
         }
         super.disposeView(true);
      }
      
      private function getX() : Number
      {
         return this._effect.target.position.x;
      }
      
      public function getY() : Number
      {
         return this._effect.target.position.y;
      }
   }
}

