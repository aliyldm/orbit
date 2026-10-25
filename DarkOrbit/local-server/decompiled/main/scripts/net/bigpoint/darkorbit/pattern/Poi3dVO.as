package net.bigpoint.darkorbit.pattern
{
   public class Poi3dVO
   {
      
      private var _geometry:Vector.<String>;
      
      private var _deepTiles:Vector.<String>;
      
      private var _textureDiff:Vector.<String>;
      
      private var _textureNormal:Vector.<String>;
      
      private var _textureSpecular:Vector.<String>;
      
      private var _textureGlow:Vector.<String>;
      
      private var _textureAlphaMask:Vector.<String>;
      
      private var _randomGeometryRotation:Boolean;
      
      private var _alphaBlending:Boolean;
      
      private var _alphaPremultiplied:Boolean;
      
      private var _useLights:Boolean;
      
      private var _ySpread:int;
      
      private var _additionalTilesInGrid:int;
      
      private var _enlargeInnerTilesFactor:Number;
      
      private var _textureIdIsGeoId:Boolean;
      
      private var _meshScale:Number;
      
      public function Poi3dVO(param1:Vector.<String>, param2:Vector.<String>, param3:Vector.<String>, param4:Vector.<String>, param5:Vector.<String>, param6:Vector.<String>, param7:Vector.<String>, param8:Boolean, param9:Boolean, param10:Boolean, param11:Boolean, param12:int, param13:int, param14:Number, param15:Boolean = false, param16:Number = 1)
      {
         super();
         this._geometry = param1;
         this._textureDiff = param3;
         this._textureNormal = param4;
         this._textureSpecular = param5;
         this._textureGlow = param6;
         this._textureAlphaMask = param7;
         this._randomGeometryRotation = param8;
         this._alphaBlending = param9;
         this._alphaPremultiplied = param10;
         this._useLights = param11;
         this._ySpread = param12;
         this._additionalTilesInGrid = param13;
         this._enlargeInnerTilesFactor = param14;
         this._deepTiles = param2;
         this._textureIdIsGeoId = param15;
         this._meshScale = param16;
      }
      
      public function get geometry() : Vector.<String>
      {
         return this._geometry;
      }
      
      public function get textureDiff() : Vector.<String>
      {
         return this._textureDiff;
      }
      
      public function get randomGeometryRotation() : Boolean
      {
         return this._randomGeometryRotation;
      }
      
      public function get alphaBlending() : Boolean
      {
         return this._alphaBlending;
      }
      
      public function get alphaPremultiplied() : Boolean
      {
         return this._alphaPremultiplied;
      }
      
      public function get useLights() : Boolean
      {
         return this._useLights;
      }
      
      public function get ySpread() : int
      {
         return this._ySpread;
      }
      
      public function get textureNormal() : Vector.<String>
      {
         return this._textureNormal;
      }
      
      public function get textureSpecular() : Vector.<String>
      {
         return this._textureSpecular;
      }
      
      public function get textureGlow() : Vector.<String>
      {
         return this._textureGlow;
      }
      
      public function get textureAlphaMask() : Vector.<String>
      {
         return this._textureAlphaMask;
      }
      
      public function get additionalTilesInGrid() : int
      {
         return this._additionalTilesInGrid;
      }
      
      public function get enlargeInnerTilesFactor() : Number
      {
         return this._enlargeInnerTilesFactor;
      }
      
      public function get deepTiles() : Vector.<String>
      {
         return this._deepTiles;
      }
      
      public function get textureIdIsGeoId() : Boolean
      {
         return this._textureIdIsGeoId;
      }
      
      public function get meshScale() : Number
      {
         return this._meshScale;
      }
   }
}

