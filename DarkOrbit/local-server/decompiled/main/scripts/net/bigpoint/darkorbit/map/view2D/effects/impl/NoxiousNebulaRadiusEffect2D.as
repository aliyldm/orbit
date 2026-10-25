package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.NoxiousNebulaRadiusEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   
   public class NoxiousNebulaRadiusEffect2D extends AbstractEffect2D
   {
      
      private static const SCALE_FACTOR:Number = 1.7 / NoxiousNebulaRadiusEffect.MIN_RADIUS;
      
      private var _mapView:MapView2D;
      
      private var _effect:NoxiousNebulaRadiusEffect;
      
      public function NoxiousNebulaRadiusEffect2D(param1:MapView2D, param2:NoxiousNebulaRadiusEffect)
      {
         this._mapView = param1;
         this._effect = param2;
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         this._mapView.fxLayer.addChild(clip);
         this.clip.x = this._effect.position.x;
         this.clip.y = this._effect.position.y;
         this.clip.z = this._effect.position.z;
         playAnimation();
         this.clip.scaleX = this.clip.scaleY = this._effect.radius * SCALE_FACTOR;
      }
   }
}

