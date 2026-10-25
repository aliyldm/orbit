package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class ProtectedEffectView2D extends AbstractMapObjectEffect2D
   {
      
      public function ProtectedEffectView2D(param1:MapView2D, param2:MapObjectEffect)
      {
         super(param1,param2,true,false);
      }
      
      override protected function initEffectVisuals() : void
      {
         this.effectMc = ResourceManager.getMovieClip("shockwaves","protectionBuffRing");
         this.addChild(this.effectMc);
         this.setClip(this.effectMc);
         this.playAnimation();
         mapObjectView.addChild(this.effectMc);
      }
   }
}

