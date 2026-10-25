package net.bigpoint.darkorbit.map.view2D.effects
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.PyroEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   import net.bigpoint.darkorbit.utils.TweenClip;
   
   public class AbstractEffect2D extends TweenClip implements IDisposable
   {
      
      protected var effectMc:MovieClip;
      
      private var _mapView:MapView2D;
      
      private var _addEffectMovieClip:Boolean;
      
      private var _effect:Effect;
      
      public function AbstractEffect2D(param1:MapView2D, param2:Effect, param3:Boolean = true)
      {
         super();
         this._addEffectMovieClip = param3;
         this._effect = param2;
         this._mapView = param1;
         this.load();
      }
      
      public function get effect() : Effect
      {
         return this._effect;
      }
      
      public function get id() : int
      {
         return this._effect.id;
      }
      
      protected function get pattern() : EffectPattern
      {
         return this._effect.pattern;
      }
      
      protected function get effectMovieClipName() : String
      {
         return "mc";
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(Boolean(this._effect.pattern) && Boolean(this._effect.pattern.resKey))
         {
            ResourceManager.fileCollection.removeCallbacks(this._effect.pattern.resKey,this.resourceLoadedHandler);
         }
         stopAnimation();
         if(clip)
         {
            TweenLite.killTweensOf(this.clip);
         }
         if(this.effectMc)
         {
            TweenLite.killTweensOf(this.effectMc);
         }
         TweenLite.killTweensOf(this);
         if(parent)
         {
            parent.removeChild(this);
         }
         super.disposeView(param1);
         NativeEffectClipPool2D.release(this.effectMc);
         this.effectMc = null;
      }
      
      protected function initEffectVisuals() : void
      {
      }
      
      protected function start() : void
      {
         playAnimation();
      }
      
      protected function load() : void
      {
         if(Boolean(this._effect.pattern) && Boolean(this._effect.pattern.resKey))
         {
            ResourceManager.fileCollection.load(this._effect.pattern.resKey,this.resourceLoadedHandler);
         }
         else
         {
            this.initEffectVisuals();
         }
      }
      
      private function resourceLoadedHandler(param1:SWFFinisher) : void
      {
         if(disposed || !this._effect || !param1)
         {
            return;
         }
         if(param1.hasEmbeddedObject(this.effectMovieClipName))
         {
            if(this._effect is PyroEffect && ImpactFrames2D.supports(this.pattern.resKey) && this.effectMovieClipName == "mc")
            {
               setClip(ImpactFrames2D.create(param1,this.pattern.resKey),this._addEffectMovieClip);
            }
            else
            {
               this.effectMc = this.effectMovieClipName == "mc" ? NativeEffectClipPool2D.acquire(param1,this.pattern.resKey) : param1.getEmbeddedMovieClip(this.effectMovieClipName);
               setClip(this.effectMc,this._addEffectMovieClip);
            }
         }
         if(Boolean(this._effect) && !disposed)
         {
            this.initEffectVisuals();
         }
      }
      
      public function get mapView() : MapView2D
      {
         return this._mapView;
      }
   }
}

