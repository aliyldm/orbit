package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.CompactEffectGeometry2D;
   import net.bigpoint.darkorbit.map.view2D.effects.NativeEffectClipPool2D;
   import net.bigpoint.darkorbit.map.view2D.effects.TimedEffectClip2D;
   
   public class StandaloneEffect2D extends Sprite implements IDisposable
   {
      
      protected var _effect:Effect;
      
      protected var _map:MapView2D;
      
      protected var _resKey:String;
      
      protected var _position:PointLite;
      
      protected var _mc:MovieClip;
      
      private var _disposed:Boolean;
      
      public function StandaloneEffect2D(param1:MapView2D, param2:Effect, param3:String, param4:PointLite)
      {
         super();
         this._effect = param2;
         this._map = param1;
         this._resKey = param3;
         this._position = param4;
         this.initEffectVisuals();
      }
      
      protected function get disposed() : Boolean
      {
         return this._disposed;
      }
      
      private function initEffectVisuals() : void
      {
         this._map.fxLayer.addChild(this);
         if(this._position)
         {
            this.x = this._position.x;
            this.y = this._position.y;
         }
         ResourceManager.fileCollection.load(this._resKey,this.onResourceLoaded,this.onResourceLoadError);
      }
      
      protected function onResourceLoaded(param1:SWFFinisher) : void
      {
         if(this._disposed)
         {
            return;
         }
         if(!param1)
         {
            this.disposeView();
            return;
         }
         this._mc = NativeEffectClipPool2D.acquire(param1,this._resKey);
         if(!this._mc)
         {
            this.disposeView();
            return;
         }
         if(this._resKey.indexOf("cannon_") == 0)
         {
            CompactEffectGeometry2D.burst(this._mc);
         }
         addChild(this._mc);
         this._mc.visible = true;
         if(this._resKey.indexOf("cannon_") == 0 || this._resKey.indexOf("drive_") == 0)
         {
            TimedEffectClip2D.play(this._mc,this,false,this.disposeView);
         }
         else
         {
            this._mc.gotoAndPlay(1);
            this._mc.addFrameScript(this._mc.totalFrames - 1,this.disposeView);
         }
      }
      
      private function onResourceLoadError(param1:String) : void
      {
         this.disposeView();
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._disposed)
         {
            return;
         }
         this._disposed = true;
         ResourceManager.fileCollection.removeCallbacks(this._resKey,this.onResourceLoaded);
         ResourceManager.fileCollection.removeCallbacks(this._resKey,this.onResourceLoadError);
         if(this._mc)
         {
            TimedEffectClip2D.stop(this._mc);
            this._mc.stop();
            this._mc.addFrameScript(this._mc.totalFrames - 1,null);
            if(this._mc.parent)
            {
               this._mc.parent.removeChild(this._mc);
            }
            NativeEffectClipPool2D.release(this._mc);
            this._mc = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         this._effect = null;
         this._map = null;
         this._position = null;
      }
   }
}

