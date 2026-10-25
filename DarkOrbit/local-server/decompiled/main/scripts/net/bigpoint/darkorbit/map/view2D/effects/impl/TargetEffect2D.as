package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.MarkTargetEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class TargetEffect2D extends AbstractMapObjectEffect2D
   {
      
      private var mc:MovieClip;
      
      private var targetStateToColorTransform:Dictionary = new Dictionary();
      
      public function TargetEffect2D(param1:MapView2D, param2:MarkTargetEffect)
      {
         this.targetStateToColorTransform[MarkTargetEffect.IN_RANGE] = new ColorTransform(10,0,10);
         this.targetStateToColorTransform[MarkTargetEffect.OUT_OF_RANGE] = new ColorTransform(0,0,10);
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         this.mc = ResourceManager.getMovieClip("ui","markTarget");
         this.mc.transform.colorTransform = this.targetStateToColorTransform[this.targetEffect.targetState];
         this.addChild(this.mc);
         mapObjectView.addChild(this);
         TweenMax.to(this.mc,1,{
            "alpha":0.2,
            "repeat":-1,
            "yoyo":true
         });
         start();
      }
      
      private function get targetEffect() : MarkTargetEffect
      {
         return effect as MarkTargetEffect;
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this.mc)
         {
            TweenMax.killTweensOf(this.mc);
         }
         super.disposeView(param1);
      }
   }
}

