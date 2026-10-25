package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenMax;
   import flash.filters.GlowFilter;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.AbstractShipGlowEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class ShipGlowEffect2D extends AbstractMapObjectEffect2D
   {
      
      private var _tween:TweenMax;
      
      public function ShipGlowEffect2D(param1:MapView2D, param2:AbstractShipGlowEffect)
      {
         super(param1,param2);
         if(Boolean(mapObjectView) && param2.startImmediately)
         {
            this.startTween();
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this._tween != null)
         {
            this._tween.kill();
            this._tween = null;
         }
         if(mapObjectView)
         {
            mapObjectView.filters = null;
         }
         super.disposeView(param1);
      }
      
      private function get glowEffect() : AbstractShipGlowEffect
      {
         return effect as AbstractShipGlowEffect;
      }
      
      private function startTween() : void
      {
         if(this.glowEffect.pulseTime > 0)
         {
            mapObjectView.filters = [new GlowFilter(this.glowEffect.color,0,this.glowEffect.blurRadian,this.glowEffect.blurRadian)];
            this._tween = TweenMax.to(mapObjectView,this.glowEffect.pulseTime,{
               "yoyo":true,
               "repeat":-1,
               "glowFilter":{
                  "strength":this.glowEffect.glowStrength,
                  "color":this.glowEffect.color,
                  "inner":this.glowEffect.innerGlow,
                  "alpha":0.9,
                  "blurX":this.glowEffect.blurRadian,
                  "blurY":this.glowEffect.blurRadian
               }
            });
         }
         else if(this.glowEffect.color == 0)
         {
            mapObjectView.filters = [new GlowFilter(this.glowEffect.color,0.9,this.glowEffect.blurRadian,this.glowEffect.blurRadian)];
         }
         else
         {
            this._tween = TweenMax.to(mapObjectView,0,{
               "yoyo":false,
               "repeat":1,
               "glowFilter":{
                  "color":this.glowEffect.color,
                  "alpha":0.9,
                  "blurX":this.glowEffect.blurRadian,
                  "blurY":this.glowEffect.blurRadian
               }
            });
         }
      }
   }
}

