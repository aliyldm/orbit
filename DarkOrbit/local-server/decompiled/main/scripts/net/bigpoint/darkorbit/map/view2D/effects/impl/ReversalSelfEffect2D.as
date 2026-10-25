package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.impl.ReversalSelfEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.AbstractShipGlowEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractShipEffect2D;
   
   public class ReversalSelfEffect2D extends AbstractShipEffect2D
   {
      
      private var _target:MapEntity;
      
      private var _glowEffect:AbstractShipGlowEffect;
      
      private var _effect:ShipGlowEffect2D;
      
      public function ReversalSelfEffect2D(param1:MapView2D, param2:ReversalSelfEffect)
      {
         super(param1,param2,true);
         this._target = param2.source;
         this._glowEffect = new AbstractShipGlowEffect(param2.id,param2.source,2237183,20);
         this._glowEffect.pulseTime = 1;
         this._glowEffect.glowStrength = 1.5;
         this._glowEffect.innerGlow = true;
         this._effect = new ShipGlowEffect2D(param1,this._glowEffect);
      }
      
      override protected function initEffectVisuals() : void
      {
         start();
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         this._effect.disposeView(param1);
         super.disposeView(param1);
      }
   }
}

