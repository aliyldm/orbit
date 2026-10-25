package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.SpawnEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   
   public class SpawnEffect2D extends AbstractEffect2D
   {
      
      private var _view:MapView2D;
      
      public function SpawnEffect2D(param1:MapView2D, param2:SpawnEffect)
      {
         super(param1,param2);
         this._view = param1;
      }
      
      private function get spawnEffet() : SpawnEffect
      {
         return effect as SpawnEffect;
      }
      
      override protected function initEffectVisuals() : void
      {
         this.addChild(clip);
         this.start();
      }
      
      override protected function start() : void
      {
         this.clip.visible = true;
         this.addAndPosition();
         var _loc1_:Number = MovieClip(this.clip).framesLoaded / 20;
         TweenMax.to(this.clip,_loc1_,{
            "ease":Linear.easeNone,
            "frame":MovieClip(this.clip).framesLoaded,
            "onComplete":this.onEffectComplete
         });
         if(this.spawnEffet.playSound)
         {
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_PIRATE_SPAWN,false,false,x,y,true);
         }
      }
      
      protected function onEffectComplete() : void
      {
         disposeView();
      }
      
      private function addAndPosition() : void
      {
         if(this._view != null)
         {
            this.x = this.spawnEffet.x;
            this.y = this.spawnEffet.y;
         }
         if(parent == null && this._view != null)
         {
            this._view.fxLayer.addChild(this);
         }
      }
   }
}

