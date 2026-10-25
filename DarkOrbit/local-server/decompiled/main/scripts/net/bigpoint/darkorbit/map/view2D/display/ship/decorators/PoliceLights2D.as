package net.bigpoint.darkorbit.map.view2D.display.ship.decorators
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.ship.PoliceTrait;
   import net.bigpoint.darkorbit.map.view2D.display.ship.Ship2D;
   import net.bigpoint.darkorbit.map.view2D.display.ship.ShipClip;
   
   public class PoliceLights2D implements IDisposable
   {
      
      private var _trait:PoliceTrait;
      
      private var _viewOwner:Ship2D;
      
      private var _lastShipFrame:Number;
      
      private var lightSetting:int = 1;
      
      private var _lightClip:ShipClip;
      
      private var _lightClip2:ShipClip;
      
      public function PoliceLights2D(param1:PoliceTrait, param2:Ship2D)
      {
         super();
         this._viewOwner = param2;
         this._trait = param1;
         this._viewOwner.base.loaded.add(this.init);
      }
      
      public function stopSirenAnimations() : void
      {
         if(this._viewOwner.base.clip != null)
         {
            this._lightClip.clip.stop();
            this._lightClip2.clip.stop();
         }
      }
      
      public function flashLights() : void
      {
         if(this._viewOwner.base.clip != null)
         {
            if(this.lightSetting == 0)
            {
               TweenLite.to(this._lightClip.clip,this._trait.lightFlashTime,{"colorTransform":{
                  "tint":this._trait.redColour,
                  "tintAmount":this._trait.tintAmount
               }});
               TweenLite.to(this._lightClip.clip,this._trait.lightFlashTime,{"glowFilter":{
                  "color":this._trait.redColour,
                  "blurX":this._trait.glowBlurX,
                  "blurY":this._trait.glowBlurY,
                  "strength":this._trait.glowStrength,
                  "alpha":this._trait.glowAlpha
               }});
               TweenLite.to(this._lightClip2.clip,this._trait.lightFlashTime,{"colorTransform":{
                  "tint":this._trait.blueColour,
                  "tintAmount":this._trait.tintAmount
               }});
               TweenLite.to(this._lightClip2.clip,this._trait.lightFlashTime,{"glowFilter":{
                  "color":this._trait.blueColour,
                  "blurX":this._trait.glowBlurX,
                  "blurY":this._trait.glowBlurY,
                  "strength":this._trait.glowStrength,
                  "alpha":this._trait.glowAlpha
               }});
               this.lightSetting = 1;
            }
            else if(this.lightSetting == 1)
            {
               TweenLite.to(this._lightClip2.clip,this._trait.lightFlashTime,{"colorTransform":{
                  "tint":this._trait.redColour,
                  "tintAmount":this._trait.tintAmount
               }});
               TweenLite.to(this._lightClip2.clip,this._trait.lightFlashTime,{"glowFilter":{
                  "color":this._trait.redColour,
                  "blurX":this._trait.glowBlurX,
                  "blurY":this._trait.glowBlurY,
                  "strength":this._trait.glowStrength,
                  "alpha":this._trait.glowAlpha
               }});
               TweenLite.to(this._lightClip.clip,this._trait.lightFlashTime,{"colorTransform":{
                  "tint":this._trait.blueColour,
                  "tintAmount":this._trait.tintAmount
               }});
               TweenLite.to(this._lightClip.clip,this._trait.lightFlashTime,{"glowFilter":{
                  "color":this._trait.blueColour,
                  "blurX":this._trait.glowBlurX,
                  "blurY":this._trait.glowBlurY,
                  "strength":this._trait.glowStrength,
                  "alpha":this._trait.glowAlpha
               }});
               this.lightSetting = 0;
            }
         }
         TweenMax.delayedCall(this._trait.lightFlashTimeDelay,this.flashLights);
      }
      
      private function init() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         if(this._viewOwner.base.clip)
         {
            if(!this._lightClip)
            {
               this._lightClip = new ShipClip();
            }
            _loc1_ = this._viewOwner.base.clip.light1;
            if(_loc1_)
            {
               _loc1_.stop();
               this._lightClip.loop = false;
               this._lightClip.rotatable = true;
               this._lightClip.clip = _loc1_;
               this._lightClip.rotationSource = this._viewOwner.ship.rotation;
            }
            if(!this._lightClip2)
            {
               this._lightClip2 = new ShipClip();
            }
            _loc2_ = this._viewOwner.base.clip.light2;
            if(_loc2_)
            {
               _loc2_.stop();
               this._lightClip2.loop = false;
               this._lightClip2.rotatable = true;
               this._lightClip2.clip = _loc2_;
               this._lightClip2.rotationSource = this._viewOwner.ship.rotation;
            }
            this.stopSirenAnimations();
            this.flashLights();
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(Boolean(this._lightClip) && Boolean(this._lightClip.clip))
         {
            TweenLite.killTweensOf(this._lightClip.clip);
            this._lightClip.disposeView(param1);
            this._lightClip = null;
         }
         if(Boolean(this._lightClip2) && Boolean(this._lightClip2.clip))
         {
            TweenLite.killTweensOf(this._lightClip2.clip);
            this._lightClip2.disposeView(param1);
            this._lightClip2 = null;
         }
         TweenMax.killDelayedCallsTo(this.flashLights);
         if(Boolean(this._viewOwner) && Boolean(this._viewOwner.base))
         {
            this._viewOwner.base.loaded.remove(this.init);
         }
      }
   }
}

