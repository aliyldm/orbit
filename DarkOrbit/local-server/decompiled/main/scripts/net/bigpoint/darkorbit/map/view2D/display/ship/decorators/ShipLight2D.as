package net.bigpoint.darkorbit.map.view2D.display.ship.decorators
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.ship.ShipLightTrait;
   import net.bigpoint.darkorbit.map.view2D.display.ship.Ship2D;
   import net.bigpoint.darkorbit.map.view2D.display.ship.ShipClip;
   
   public class ShipLight2D implements IDisposable
   {
      
      private var _viewOwner:Ship2D;
      
      private var _trait:ShipLightTrait;
      
      private var _lightSetting:int = 0;
      
      private var _lightFlashTime:Number = 0.4;
      
      private var _lightClip:ShipClip;
      
      private var _numberOfFlashes:int = -1;
      
      public function ShipLight2D(param1:ShipLightTrait, param2:Ship2D)
      {
         super();
         this._trait = param1;
         this._viewOwner = param2;
         this._viewOwner.base.loaded.add(this.init);
      }
      
      private function init() : void
      {
         var _loc1_:MovieClip = null;
         if(this._viewOwner.base.clip)
         {
            if(!this._lightClip)
            {
               this._lightClip = new ShipClip();
            }
            _loc1_ = this._viewOwner.base.clip["light"] as MovieClip;
            if(_loc1_)
            {
               _loc1_.stop();
               this._lightClip.loop = false;
               this._lightClip.rotatable = true;
               this._lightClip.clip = _loc1_;
               this._lightClip.rotationSource = this._viewOwner.ship.rotation;
            }
         }
      }
      
      public function startFlashes(param1:int) : void
      {
         if(this._viewOwner.base.clip)
         {
            this._numberOfFlashes = param1;
            this.flashLights();
         }
         else
         {
            TweenLite.delayedCall(1,this.startFlashes,[param1]);
         }
      }
      
      public function flashLights() : void
      {
         --this._numberOfFlashes;
         if(this._viewOwner.base.clip != null)
         {
            if(this._lightSetting == 0)
            {
               TweenLite.to(this._lightClip.clip,this._lightFlashTime,{"colorTransform":{
                  "tint":this._trait.greenColour,
                  "tintAmount":this._trait.tintAmount
               }});
               TweenLite.to(this._lightClip.clip,this._lightFlashTime,{"glowFilter":{
                  "color":this._trait.greenColour,
                  "blurX":this._trait.glowBlurX,
                  "blurY":this._trait.glowBlurY,
                  "strength":this._trait.glowStrength,
                  "alpha":this._trait.glowAlpha
               }});
               this._lightSetting = 1;
            }
            else if(this._lightSetting == 1)
            {
               TweenLite.to(this._lightClip.clip,this._lightFlashTime,{"colorTransform":{
                  "tint":this._trait.whiteColour,
                  "tintAmount":0
               }});
               TweenLite.to(this._lightClip.clip,this._lightFlashTime,{"glowFilter":{
                  "color":this._trait.whiteColour,
                  "blurX":0,
                  "blurY":0,
                  "strength":0,
                  "alpha":0
               }});
               this._lightSetting = 0;
            }
         }
         if(this._numberOfFlashes > -1)
         {
            TweenMax.delayedCall(this._trait.lightFlashTimeDelay,this.flashLights);
         }
      }
      
      public function get numberOfFlashes() : int
      {
         return this._numberOfFlashes;
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(Boolean(this._viewOwner) && Boolean(this._viewOwner.base))
         {
            this._viewOwner.base.loaded.remove(this.init);
         }
      }
   }
}

