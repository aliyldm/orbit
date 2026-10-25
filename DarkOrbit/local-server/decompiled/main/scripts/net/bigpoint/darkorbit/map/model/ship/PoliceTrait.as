package net.bigpoint.darkorbit.map.model.ship
{
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   
   public class PoliceTrait extends EntityTraitBase
   {
      
      private const _glowStrength:Number = 9;
      
      private const _glowBlurX:Number = 10;
      
      private const _glowBlurY:Number = 10;
      
      private const _glowAlpha:Number = 0.4;
      
      private const _tintAmount:Number = 0.7;
      
      private const _redColour:uint = 16711680;
      
      private const _blueColour:uint = 255;
      
      private const _lightFlashTime:Number = 0.4;
      
      private const _lightFlashTimeDelay:Number = 0.6;
      
      public function PoliceTrait()
      {
         super();
      }
      
      public function get lightFlashTimeDelay() : Number
      {
         return this._lightFlashTimeDelay;
      }
      
      public function get lightFlashTime() : Number
      {
         return this._lightFlashTime;
      }
      
      public function get blueColour() : uint
      {
         return this._blueColour;
      }
      
      public function get redColour() : uint
      {
         return this._redColour;
      }
      
      public function get tintAmount() : Number
      {
         return this._tintAmount;
      }
      
      public function get glowAlpha() : Number
      {
         return this._glowAlpha;
      }
      
      public function get glowBlurY() : Number
      {
         return this._glowBlurY;
      }
      
      public function get glowBlurX() : Number
      {
         return this._glowBlurX;
      }
      
      public function get glowStrength() : Number
      {
         return this._glowStrength;
      }
   }
}

