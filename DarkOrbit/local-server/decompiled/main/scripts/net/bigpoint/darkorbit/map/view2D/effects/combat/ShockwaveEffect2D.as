package net.bigpoint.darkorbit.map.view2D.effects.combat
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Quint;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.ShockwaveEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.ShockwavePattern;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class ShockwaveEffect2D extends AbstractEffect2D
   {
      
      private static const DEGTORAD:Number = 0.017453292519943295;
      
      private static const shockwaveBitmaps:Array = [];
      
      private static const coordMultiplier:Array = [];
      
      private var shockwaveID:int;
      
      private var shockwavePattern:ShockwavePattern;
      
      private var _mapView:MapView2D;
      
      private var _effect:ShockwaveEffect;
      
      public function ShockwaveEffect2D(param1:MapView2D, param2:ShockwaveEffect)
      {
         this._effect = param2;
         this._mapView = param1;
         this.shockwaveID = param2.shockwaveId;
         this.shockwavePattern = PatternManager.shockwavePatterns[this.shockwaveID];
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         ScreenManager.getInstance().flashScreen(16777215,0.75,0.25,2);
         ResourceManager.fileCollection.load("shockwaves",this.handleResourceReady);
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_EXPLOSION_2,false,false,this._effect.x,this._effect.y);
         ScreenManager.getInstance().flashScreen(16777215,0.75,0.25,2);
         if(this.shockwavePattern.shakeScreen)
         {
            ScreenManager.getInstance().shakeScreen();
         }
      }
      
      private function handleResourceReady(param1:SWFFinisher) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Bitmap = null;
         var _loc5_:Sprite = null;
         var _loc6_:int = 0;
         if(shockwaveBitmaps[this.shockwaveID] == null)
         {
            shockwaveBitmaps[this.shockwaveID] = param1.getEmbeddedBitmapData(this.shockwavePattern.getResKey());
         }
         if(shockwaveBitmaps != null)
         {
            _loc2_ = 360 / this.shockwavePattern.maxShockwaves;
            _loc3_ = 0;
            while(_loc3_ < this.shockwavePattern.maxShockwaves)
            {
               _loc4_ = new Bitmap(shockwaveBitmaps[this.shockwaveID]);
               _loc5_ = new Sprite();
               _loc5_.addChild(_loc4_);
               _loc4_.y = -_loc4_.height / 2;
               _loc5_.scaleX = this.shockwavePattern.beginScale;
               _loc5_.scaleY = this.shockwavePattern.beginScale;
               _loc6_ = _loc3_ * _loc2_;
               _loc5_.rotation = _loc6_ + 180;
               if(coordMultiplier[this.shockwavePattern.maxShockwaves] == null)
               {
                  coordMultiplier[this.shockwavePattern.maxShockwaves] = [];
               }
               if(coordMultiplier[this.shockwavePattern.maxShockwaves][_loc3_] == null)
               {
                  coordMultiplier[this.shockwavePattern.maxShockwaves][_loc3_] = [];
                  coordMultiplier[this.shockwavePattern.maxShockwaves][_loc3_][0] = Math.cos(_loc6_ * DEGTORAD);
                  coordMultiplier[this.shockwavePattern.maxShockwaves][_loc3_][1] = Math.sin(_loc6_ * DEGTORAD);
               }
               addChild(_loc5_);
               this.x = this._effect.x;
               this.y = this._effect.y;
               this._mapView.fxLayer.addChild(this);
               TweenLite.to(_loc5_,this.shockwavePattern.duration,{
                  "ease":Quint.easeOut,
                  "x":this.shockwavePattern.radius * coordMultiplier[this.shockwavePattern.maxShockwaves][_loc3_][0],
                  "y":this.shockwavePattern.radius * coordMultiplier[this.shockwavePattern.maxShockwaves][_loc3_][1],
                  "scaleX":this.shockwavePattern.endScale,
                  "scaleY":this.shockwavePattern.endScale,
                  "alpha":0,
                  "onComplete":this.handleShockwaveCompleted,
                  "onCompleteParams":[_loc5_]
               });
               _loc3_++;
            }
         }
      }
      
      private function handleShockwaveCompleted(param1:Sprite) : void
      {
         MovieClipUtils.removeDisplayObject(param1);
      }
   }
}

