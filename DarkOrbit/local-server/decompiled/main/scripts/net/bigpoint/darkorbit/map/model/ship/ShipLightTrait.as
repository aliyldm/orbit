package net.bigpoint.darkorbit.map.model.ship
{
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   
   public class ShipLightTrait extends EntityTraitBase
   {
      
      private const _greenColour:uint = 65280;
      
      private const _whiteColour:uint = 0;
      
      private const _glowStrength:Number = 9;
      
      private const _glowBlurX:Number = 10;
      
      private const _glowBlurY:Number = 10;
      
      private const _glowAlpha:Number = 0.4;
      
      private const _tintAmount:Number = 0.7;
      
      private const _lightFlashTimeDelay:Number = 0.6;
      
      public function ShipLightTrait()
      {
         super();
      }
      
      public function get greenColour() : uint
      {
         return this._greenColour;
      }
      
      public function get whiteColour() : uint
      {
         return this._whiteColour;
      }
      
      public function get glowStrength() : Number
      {
         return this._glowStrength;
      }
      
      public function get glowBlurX() : Number
      {
         return this._glowBlurX;
      }
      
      public function get glowBlurY() : Number
      {
         return this._glowBlurY;
      }
      
      public function get glowAlpha() : Number
      {
         return this._glowAlpha;
      }
      
      public function get tintAmount() : Number
      {
         return this._tintAmount;
      }
      
      public function get lightFlashTimeDelay() : Number
      {
         return this._lightFlashTimeDelay;
      }
   }
}

