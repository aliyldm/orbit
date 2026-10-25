package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.LongRangeLaserEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   
   public class LongRangeLaser2D extends AbstractEffect2D implements IFrameObserver
   {
      
      private var _effect:LongRangeLaserEffect;
      
      private var _mapView:MapView2D;
      
      private var _sprite:Sprite;
      
      public function LongRangeLaser2D(param1:MapView2D, param2:LongRangeLaserEffect)
      {
         this._effect = param2;
         this._mapView = param1;
         super(param1,param2,true);
      }
      
      override protected function initEffectVisuals() : void
      {
         if(Boolean(this._effect.source) || Boolean(this._effect.target))
         {
            this._sprite = new Sprite();
            this._mapView.fxLayer.addChild(this._sprite);
            this._mapView.fxLayer.addChild(this);
            ScreenManager.addObserver(this);
            x = this._effect.source.position.x;
            y = this._effect.source.position.y;
            playAnimation();
            TweenLite.to(this,1.3,{
               "dynamicProps":{
                  "x":this.getX,
                  "y":this.getY
               },
               "onComplete":this.handleTweeenFinish,
               "ease":Linear.easeNone
            });
            this._effect.playSound();
         }
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:Graphics = this._sprite.graphics;
         _loc2_.clear();
         _loc2_.lineStyle(1,16711935,100);
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
      
      private function handleTweeenFinish() : void
      {
         this.disposeView(true);
      }
      
      private function getX() : Number
      {
         return this._effect.target.position.x;
      }
      
      public function getY() : Number
      {
         return this._effect.target.position.y;
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
   }
}

