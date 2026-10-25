package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.media.SoundChannel;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.DecloakEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class DecloakEffect2D extends AbstractMapObjectEffect2D
   {
      
      private var _ringStartScale:Number = 0.1;
      
      private var _ringTargetScale:Number = 5;
      
      private var _ringStartAlpha:Number = 0.3;
      
      private var _ringTargetAlpha:Number = 0;
      
      private var _soundChannel:SoundChannel = null;
      
      public function DecloakEffect2D(param1:MapView2D, param2:DecloakEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         effectMc = new MovieClip();
         addChild(effectMc);
         setClip(effectMc,false);
         this.showProtectionRing(0);
         playAnimation();
         var _loc1_:PointLite = DecloakEffect(effect).source.position;
         this._soundChannel = AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_CITADEL_PROTECTION,true,false,_loc1_.x,_loc1_.y);
      }
      
      private function showProtectionRing(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = ResourceManager.getMovieClip("shockwaves","shockring0");
         _loc2_.scaleX = this._ringStartScale;
         _loc2_.scaleY = this._ringStartScale;
         _loc2_.alpha = this._ringStartAlpha;
         effectMc.addChild(_loc2_);
         TweenLite.to(_loc2_,1.5,{
            "scaleX":this._ringTargetScale,
            "scaleY":this._ringTargetScale,
            "alpha":this._ringTargetAlpha,
            "onComplete":MovieClipUtils.removeDisplayObject,
            "onCompleteParams":[_loc2_]
         });
         TweenLite.delayedCall(2,this.showProtectionRing,[param1 + 1]);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this._soundChannel != null)
         {
            AudioManager.removeLoop(this._soundChannel);
            this._soundChannel = null;
         }
         TweenLite.killDelayedCallsTo(this.showProtectionRing);
         super.disposeView(param1);
      }
   }
}

