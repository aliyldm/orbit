package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.media.SoundChannel;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class ProtectionEffectView2D extends AbstractMapObjectEffect2D
   {
      
      private var _ringStartScale:Number = 5;
      
      private var _ringTargetScale:Number = 0.1;
      
      private var _ringStartAlpha:Number = 0;
      
      private var _ringTargetAlpha:Number = 0.3;
      
      private var _soundChannel:SoundChannel = null;
      
      public function ProtectionEffectView2D(param1:MapView2D, param2:MapObjectEffect)
      {
         super(param1,param2);
      }
      
      override protected function get effectMovieClipName() : String
      {
         return super.effectMovieClipName;
      }
      
      override protected function initEffectVisuals() : void
      {
         this.effectMc = new MovieClip();
         this.addChild(effectMc);
         this.setClip(effectMc,false);
         this.showProtectionRing(0);
         this.playAnimation();
         var _loc1_:PointLite = (effect as MapObjectEffect).source.position;
         this._soundChannel = AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_CITADEL_PROTECTION,false,false,_loc1_.x,_loc1_.y);
      }
      
      private function showProtectionRing(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = ResourceManager.getMovieClip("shockwaves","fireProtectionRing");
         _loc2_.scaleX = this._ringStartScale;
         _loc2_.scaleY = this._ringStartScale;
         _loc2_.alpha = this._ringStartAlpha;
         this.effectMc.addChild(_loc2_);
         TweenLite.to(_loc2_,1.5,{
            "scaleX":this._ringTargetScale,
            "scaleY":this._ringTargetScale,
            "alpha":this._ringTargetAlpha,
            "onComplete":MovieClipUtils.removeDisplayObject,
            "onCompleteParams":[_loc2_]
         });
         TweenLite.delayedCall(1,this.showProtectionRing,[param1 + 1]);
      }
      
      public function stopSound() : void
      {
         if(this._soundChannel != null)
         {
            AudioManager.removeLoop(this._soundChannel);
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         this.stopSound();
         TweenLite.killTweensOf(this.showProtectionRing);
         super.disposeView(param1);
      }
   }
}

