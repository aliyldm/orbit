package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.InstaShieldEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class InstaShieldEffect2D extends AbstractMapObjectEffect2D
   {
      
      private var _effect:InstaShieldEffect;
      
      private var _mapView:MapView2D;
      
      public function InstaShieldEffect2D(param1:MapView2D, param2:InstaShieldEffect)
      {
         this._mapView = param1;
         this._effect = param2;
         super(param1,param2,true,true,true);
      }
      
      override protected function initEffectVisuals() : void
      {
         fps = 25;
         playAnimation(false,1,true,true);
         if(Settings.qualityExplosion.value >= Settings.QUALITY_GOOD && Settings.autoQualityReduction.value < Settings.AQ_LOW_EXPLOSION_DETAIL_LIMIT && Settings.autoQualityReduction.value < Settings.AQ_NO_EXPLOSION_LIMIT)
         {
            this.rotation = Math.random() * 360;
         }
      }
   }
}

