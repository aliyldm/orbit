package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.EMPEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractShipEffect2D;
   
   public class PolarityPowerupEffect2D extends AbstractShipEffect2D implements IFrameObserver
   {
      
      private var _mapView:MapView2D;
      
      public function PolarityPowerupEffect2D(param1:MapView2D, param2:MapObjectEffect)
      {
         this._mapView = param1;
         super(param1,param2);
      }
      
      override protected function get effectMovieClipName() : String
      {
         return "blitzUltimate";
      }
      
      override protected function initEffectVisuals() : void
      {
         this.addChild(effectMc);
         this.scaleX = 0.3;
         this.scaleY = 0.3;
         TweenLite.to(this,1.8,{
            "scaleX":1,
            "scaleY":1
         });
         TweenLite.delayedCall(1.8,this.delayCompleteHandler);
         ScreenManager.addObserver(this);
      }
      
      private function delayCompleteHandler() : void
      {
         if(ScreenManager.getInstance().map)
         {
            ScreenManager.getInstance().map.effects.playEffect(new EMPEffect(ship,EMPEffect.TYPE_EMPEROR));
         }
         this.disposeView();
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         TweenMax.killDelayedCallsTo(this.delayCompleteHandler);
         ScreenManager.removeObserver(this);
         super.disposeView(param1);
      }
      
      public function updateTimer(param1:Number) : void
      {
         if(ship)
         {
            ship.rotation.degrees += 15;
         }
      }
   }
}

