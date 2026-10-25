package net.bigpoint.darkorbit.map.view2D.display.ship
{
   import com.bigpoint.utils.bindables.BindableRotation;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import com.greensock.plugins.FramePlugin;
   import com.greensock.plugins.ShortRotationPlugin;
   import com.greensock.plugins.TweenPlugin;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   import org.osflash.signals.Signal;
   
   public class ShipClip extends Sprite implements IDisposable
   {
      
      TweenPlugin.activate([FramePlugin]);
      TweenPlugin.activate([ShortRotationPlugin]);
      
      public const changed:Signal = new Signal();
      
      public const loaded:Signal = new Signal();
      
      private var _rotationSource:BindableRotation;
      
      private var _resKey:String;
      
      private var _linkageId:String;
      
      private var _clip:MovieClip;
      
      private var _loop:Boolean;
      
      private var _rotatable:Boolean = true;
      
      private var _clipRotation:Number = 0;
      
      private var _placeholderResKey:String;
      
      private var _placeholderLinkageId:String;
      
      public function ShipClip(param1:MovieClip = null, param2:BindableRotation = null)
      {
         super();
         if(param1 != null)
         {
            this.clip = param1;
         }
         this.rotationSource = param2;
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this.rotationSource = null;
         this.clip = null;
         ResourceManager.fileCollection.removeCallbacks(this._placeholderResKey,this.handlePlaceholderLoadComplete);
         ResourceManager.fileCollection.removeCallbacks(this._resKey,this.handleResourceLoadComplete);
      }
      
      public function set rotationSource(param1:BindableRotation) : void
      {
         if(this._rotationSource)
         {
            this._rotationSource.changed.remove(this.updateRotation);
         }
         this._rotationSource = param1;
         if(this._rotationSource)
         {
            this._rotationSource.changed.add(this.updateRotation);
            if(this._rotationSource)
            {
               this.clipRotation = this._rotationSource.degrees;
            }
         }
      }
      
      public function loadPlaceholder(param1:String, param2:String) : void
      {
         if(this._placeholderResKey)
         {
            ResourceManager.fileCollection.removeCallbacks(this._placeholderResKey,this.handlePlaceholderLoadComplete);
         }
         if(this._resKey)
         {
            ResourceManager.fileCollection.removeCallbacks(this._resKey,this.handleResourceLoadComplete);
         }
         this._linkageId = this._resKey = null;
         this._placeholderResKey = param1;
         this._placeholderLinkageId = param2;
         ResourceManager.fileCollection.load(this._placeholderResKey,this.handlePlaceholderLoadComplete);
      }
      
      public function load(param1:String, param2:String, param3:Boolean = true, param4:Boolean = false) : void
      {
         if(this._resKey != param1 || this._linkageId != param2)
         {
            if(this._resKey)
            {
               ResourceManager.fileCollection.removeCallbacks(this._resKey,this.handleResourceLoadComplete);
            }
            this._resKey = param1;
            this._linkageId = param2;
            this._rotatable = param3;
            this._loop = param4;
            ResourceManager.fileCollection.load(param1,this.handleResourceLoadComplete);
         }
         else
         {
            this.clip = this.clip;
         }
      }
      
      public function set clipRotation(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         if(this._clip == null)
         {
            return;
         }
         param1 = FastMath.asAbsoluteRadius(param1);
         this._clipRotation = param1;
         if(this._clip.framesLoaded > 1)
         {
            rotation = 0;
            _loc2_ = Math.max(1,Math.min(32,this._clip.totalFrames));
            _loc3_ = (this._clipRotation % 360 + 360) % 360;
            _loc4_ = int(_loc2_ * _loc3_ / 360 + 0.5) % _loc2_ + 1;
            this.renderDirectionalFrame(_loc4_);
         }
         else if(this._rotatable && !this._loop)
         {
            rotation = this._clipRotation;
         }
         this.changed.dispatch();
      }
      
      protected function renderDirectionalFrame(param1:int) : void
      {
         this._clip.gotoAndStop(param1);
      }
      
      public function get clipRotation() : Number
      {
         return this._clipRotation;
      }
      
      public function get clip() : MovieClip
      {
         return this._clip;
      }
      
      public function set clip(param1:MovieClip) : void
      {
         if(this._clip)
         {
            MovieClipUtils.stopAnimation(this._clip);
            MovieClipUtils.removeDisplayObject(this._clip);
         }
         TweenLite.killTweensOf(this);
         this._clip = param1;
         rotation = 0;
         if(this._clip)
         {
            this._clip.gotoAndStop(1);
            if(!this._clip.parent)
            {
               addChild(this._clip);
            }
            this.updateLoop();
            this.loaded.dispatch();
         }
         this.changed.dispatch();
      }
      
      private function updateLoop() : void
      {
         if(this._clip)
         {
            MovieClipUtils.stopAnimation(this._clip);
            if(this._loop)
            {
               MovieClipUtils.playAnimation(this._clip,30,true);
            }
            else if(this._rotationSource)
            {
               this.clipRotation = this._rotationSource.degrees;
            }
         }
      }
      
      public function cleanup() : void
      {
         this.clip = null;
         this.rotationSource = null;
         TweenLite.killTweensOf(this);
      }
      
      private function handlePlaceholderLoadComplete(param1:SWFFinisher) : void
      {
         this.clip = MovieClip(param1.getEmbeddedMovieClip(this._placeholderLinkageId));
      }
      
      private function handleResourceLoadComplete(param1:SWFFinisher) : void
      {
         if(this._placeholderResKey)
         {
            ResourceManager.fileCollection.removeCallbacks(this._placeholderResKey,this.handlePlaceholderLoadComplete);
         }
         this.clip = MovieClip(param1.getEmbeddedMovieClip(this._linkageId));
         GameFacade.getInstance().forwardNotification(AssetNotifications.ADD_UNLOAD_FINISHER,param1);
      }
      
      private function updateRotation() : void
      {
         if(Boolean(this._clip != null && this._rotationSource) && Boolean(this._rotatable) && !this._loop)
         {
            TweenLite.to(this,0.1,{
               "shortRotation":{"clipRotation":this._rotationSource.degrees},
               "ease":Linear.easeNone
            });
         }
      }
      
      public function set rotatable(param1:Boolean) : void
      {
         this._rotatable = param1;
         this.updateRotation();
      }
      
      public function set loop(param1:Boolean) : void
      {
         this._loop = param1;
         this.updateLoop();
      }
      
      public function reset() : void
      {
         if(this._resKey)
         {
            ResourceManager.fileCollection.removeCallbacks(this._resKey,this.handleResourceLoadComplete);
         }
         this._resKey = this._linkageId = null;
         this.clip = null;
      }
   }
}

