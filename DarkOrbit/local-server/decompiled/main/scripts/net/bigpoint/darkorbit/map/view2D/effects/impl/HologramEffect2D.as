package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenMax;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.HologramEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpawnEffect;
   import net.bigpoint.darkorbit.map.model.traits.ShipDisplayTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   
   public class HologramEffect2D extends SpawnEffect2D
   {
      
      private var _holoEffect:HologramEffect;
      
      public function HologramEffect2D(param1:MapView2D, param2:HologramEffect)
      {
         super(param1,new SpawnEffect(param2.source.x,param2.source.y,false));
         this._holoEffect = param2;
         TweenMax.to(this.mapObjectView,0.3,{
            "autoAlpha":0.1,
            "yoyo":true,
            "repeat":9
         });
      }
      
      protected function get mapObjectView() : Sprite
      {
         return (mapView.entitiesLayer.getViewByTrait(this.mapObject.getFirstTrait(ShipDisplayTrait)) || mapView.entitiesLayer.getViewByTrait(this.mapObject.getFirstTrait(UberDisplayTrait))) as Sprite;
      }
      
      protected function get mapObject() : MapEntity
      {
         return (this._holoEffect as MapObjectEffect).source;
      }
      
      override protected function onEffectComplete() : void
      {
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         TweenMax.killTweensOf(this.mapObjectView);
         this.mapObjectView.alpha = 1;
         super.disposeView(param1);
      }
   }
}

