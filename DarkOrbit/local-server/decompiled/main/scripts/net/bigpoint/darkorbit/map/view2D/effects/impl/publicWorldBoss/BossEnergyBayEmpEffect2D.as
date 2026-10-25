package net.bigpoint.darkorbit.map.view2D.effects.impl.publicWorldBoss
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossEnergyBayEmpEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.template.SimpleEffect2D;
   
   public class BossEnergyBayEmpEffect2D extends SimpleEffect2D
   {
      
      private var _range:int;
      
      public function BossEnergyBayEmpEffect2D(param1:MapView2D, param2:BossEnergyBayEmpEffect)
      {
         super(param1,param2);
         this._range = param2.range;
      }
      
      override protected function initEffectVisuals() : void
      {
         this.clip.visible = true;
         this.clip.scaleX = this.clip.scaleY = 2;
         var _loc1_:Number = MovieClip(this.clip).framesLoaded * frameDuration;
         TweenMax.to(this.clip,_loc1_,{
            "ease":Linear.easeNone,
            "frame":MovieClip(this.clip).framesLoaded,
            "onComplete":this.handleEffectComplete,
            "width":this._range * 2,
            "height":this._range * 2
         });
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this.disposed)
         {
            return;
         }
         super.disposeView(param1);
      }
      
      private function handleEffectComplete() : void
      {
         if(effect.activate())
         {
            playAnimation();
         }
      }
   }
}

