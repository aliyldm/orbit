package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class DrawFireEffect2D extends AbstractMapObjectEffect2D
   {
      
      private var _ringStartScale:Number = 7;
      
      private var _ringTargetScale:Number = 0.1;
      
      private var _ringStartAlpha:Number = 0;
      
      private var _ringTargetAlpha:Number = 0.2;
      
      public function DrawFireEffect2D(param1:MapView2D, param2:MapObjectEffect)
      {
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         effectMc = ResourceManager.getMovieClip("shockwaves","drawFireVortex");
         addChild(effectMc);
         setClip(effectMc,false);
         this.showDrawFireRing();
         TweenMax.delayedCall(0.1,this.showDrawFireRing);
         TweenMax.delayedCall(0.2,this.showDrawFireRing);
         playAnimation();
         var _loc1_:PointLite = (effect as MapObjectEffect).source.position;
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_CITADEL_DRAW_FIRE,false,false,_loc1_.x,_loc1_.y);
      }
      
      private function showDrawFireRing() : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = ResourceManager.getMovieClip("shockwaves","drawFireRing");
         _loc1_.scaleX = this._ringStartScale;
         _loc1_.scaleY = this._ringStartScale;
         _loc1_.alpha = this._ringStartAlpha;
         effectMc.addChild(_loc1_);
         TweenLite.to(_loc1_,2.5,{
            "scaleX":this._ringTargetScale,
            "scaleY":this._ringTargetScale,
            "alpha":this._ringTargetAlpha,
            "onComplete":MovieClipUtils.removeDisplayObject,
            "onCompleteParams":[_loc1_]
         });
         TweenLite.delayedCall(1,this.showDrawFireRing);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         TweenMax.killDelayedCallsTo(this.showDrawFireRing);
         super.disposeView(param1);
      }
   }
}

