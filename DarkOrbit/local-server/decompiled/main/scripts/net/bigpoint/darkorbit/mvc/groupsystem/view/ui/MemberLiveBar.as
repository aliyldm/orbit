package net.bigpoint.darkorbit.mvc.groupsystem.view.ui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class MemberLiveBar extends Sprite
   {
      
      private var _base:Bitmap;
      
      private var _valueMaskClip:Bitmap;
      
      private var _lightClip:Bitmap;
      
      private var _liveValue:Number;
      
      private const BAR_WIDTH:int = 62;
      
      private const BAR_HEIGHT:int = 5;
      
      public function MemberLiveBar(param1:int = 62, param2:int = 5)
      {
         super();
         this._valueMaskClip = new Bitmap(new BitmapData(param1,param2,false,16777215));
      }
      
      public function set lightClip(param1:Bitmap) : void
      {
         this._lightClip = param1;
         this._lightClip.mask = this._valueMaskClip;
         addChild(this._lightClip);
         addChild(this._valueMaskClip);
         this.liveValue = this._liveValue;
      }
      
      public function set base(param1:Bitmap) : void
      {
         this._base = param1;
         addChild(this._base);
      }
      
      public function get base() : Bitmap
      {
         return this._base;
      }
      
      public function get lightClip() : Bitmap
      {
         return this._lightClip;
      }
      
      public function get liveValue() : Number
      {
         return this._liveValue;
      }
      
      public function set liveValue(param1:Number) : void
      {
         this._liveValue = param1;
         this._valueMaskClip.scaleX = this._liveValue;
      }
   }
}

