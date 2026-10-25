package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.NeutralizingTargetEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class NeutralizingTargetEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function NeutralizingTargetEffect2D(param1:MapView2D, param2:NeutralizingTargetEffect)
      {
         super(param1,param2);
      }
      
      override protected function get effectMovieClipName() : String
      {
         return "mc";
      }
      
      override protected function initEffectVisuals() : void
      {
         this.clip.scaleX = this.clip.scaleY = this.clip.scaleY = 0.6;
         start();
      }
   }
}

