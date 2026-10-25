package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.impl.RapidFireEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractShipEffect2D;
   
   public class RapidFireEffect2D extends AbstractShipEffect2D implements IFrameObserver
   {
      
      private var _target:MapEntity;
      
      private var _shakeOffset:PointLite = new PointLite(-2,-2);
      
      public function RapidFireEffect2D(param1:MapView2D, param2:RapidFireEffect)
      {
         this._target = param2.source;
         super(param1,param2,true);
         this.startShake();
      }
      
      override protected function initEffectVisuals() : void
      {
         start();
      }
      
      private function startShake() : void
      {
         ScreenManager.addObserver(this);
         TweenMax.to(this._shakeOffset,0.075,{
            "y":1.5,
            "x":1.5,
            "repeat":-1,
            "yoyo":true
         });
      }
      
      public function updateTimer(param1:Number) : void
      {
         if(shipView != null)
         {
            shipView.x += this._shakeOffset.x;
            shipView.y += this._shakeOffset.y;
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         ScreenManager.removeObserver(this);
         TweenMax.killTweensOf(this._shakeOffset);
         if(shipView != null)
         {
            shipView.x -= this._shakeOffset.x;
            shipView.y -= this._shakeOffset.y;
         }
         super.disposeView(param1);
      }
   }
}

