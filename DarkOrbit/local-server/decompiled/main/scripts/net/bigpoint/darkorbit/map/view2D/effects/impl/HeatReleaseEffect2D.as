package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.HeatReleaseEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class HeatReleaseEffect2D extends AbstractMapObjectEffect2D
   {
      
      private var _radius:Number;
      
      public function HeatReleaseEffect2D(param1:MapView2D, param2:HeatReleaseEffect)
      {
         super(param1,param2);
         this._radius = param2.radius / 150;
      }
      
      override protected function initEffectVisuals() : void
      {
         playAnimation();
         this.clip.scaleX = this.clip.scaleY = this.clip.scaleY = this._radius;
      }
   }
}

