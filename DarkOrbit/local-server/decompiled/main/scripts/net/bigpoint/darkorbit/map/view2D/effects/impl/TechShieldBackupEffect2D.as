package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenLite;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class TechShieldBackupEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function TechShieldBackupEffect2D(param1:MapView2D, param2:MapObjectEffect)
      {
         super(param1,param2,true,true,true);
         this.fps = 15;
      }
      
      override protected function initEffectVisuals() : void
      {
         this.playAnimation();
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_SHIELD_SELECTED);
         effectMc.alpha = 0;
         TweenLite.to(effectMc,0.25,{
            "alpha":1,
            "onComplete":this.handleShield
         });
      }
      
      private function handleShield() : void
      {
         TweenLite.to(effectMc,0.25,{
            "delay":1,
            "alpha":0,
            "onComplete":this.disposeView
         });
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         TweenLite.killTweensOf(effectMc);
         super.disposeView(param1);
      }
   }
}

