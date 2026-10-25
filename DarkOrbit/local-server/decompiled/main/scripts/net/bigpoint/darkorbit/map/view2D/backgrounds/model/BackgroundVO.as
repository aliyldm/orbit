package net.bigpoint.darkorbit.map.view2D.backgrounds.model
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.pattern.BackgroundPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   
   public class BackgroundVO extends BackgroundElementVO
   {
      
      private var _maskID:int;
      
      private var _region:Rectangle;
      
      private var _layerIndex:int;
      
      private var _typeID:int;
      
      private var _isMain:Boolean;
      
      private var _shiftX:int;
      
      private var _shiftY:int;
      
      private var _scale:Number;
      
      private var _tileMapSizeMultiplier:Number = 1;
      
      public function BackgroundVO(param1:int, param2:Boolean, param3:int, param4:int, param5:int, param6:int, param7:Number, param8:int = 0, param9:Rectangle = null, param10:Number = 1)
      {
         this._region = param9;
         super(param4,param3);
         this._layerIndex = param4;
         this._typeID = param1;
         this._isMain = param2;
         this._shiftX = param5;
         this._shiftY = param6;
         this._scale = param7;
         this._maskID = param8;
         this._tileMapSizeMultiplier = param10;
      }
      
      public function get typeID() : int
      {
         return this._typeID;
      }
      
      public function get isMain() : Boolean
      {
         return this._isMain;
      }
      
      public function get shiftX() : int
      {
         return this._shiftX;
      }
      
      public function get shiftY() : int
      {
         return this._shiftY;
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      public function get tileMapSizeMultiplier() : Number
      {
         return this._tileMapSizeMultiplier;
      }
      
      public function get pattern() : BackgroundPattern
      {
         return PatternManager.backgroundPatterns[this._typeID] as BackgroundPattern;
      }
      
      public function get maskBitmapData() : BitmapData
      {
         var _loc1_:ResourcePattern = PatternManager.backgroundMaskPatterns[this._maskID];
         return _loc1_ ? ResourceManager.getBitmapData(_loc1_.resKey,"mask") : null;
      }
      
      public function isBackgroundTiled(param1:Boolean) : Boolean
      {
         if(param1)
         {
            return this.pattern.isTiled && this.pattern.resKeyStarling != null && this.pattern.atlasXml != null;
         }
         return this.pattern.isTiled;
      }
      
      public function get region() : Rectangle
      {
         return this._region;
      }
      
      public function get layerIndex() : int
      {
         return this._layerIndex;
      }
   }
}

