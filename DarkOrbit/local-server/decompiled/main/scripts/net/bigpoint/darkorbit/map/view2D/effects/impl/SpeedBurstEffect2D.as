package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpeedBurstEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class SpeedBurstEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function SpeedBurstEffect2D(param1:MapView2D, param2:SpeedBurstEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         effectMc.scaleX = 1.8;
         effectMc.scaleY = 1.8;
         start();
      }
      
      override protected function handlePositionChanged() : void
      {
         super.handlePositionChanged();
         this.rotation = this.map.hero.moveTrait.rotation.degrees - 180;
      }
      
      private function get map() : Map
      {
         return ScreenManager.getInstance().map;
      }
   }
}

