package net.bigpoint.darkorbit.map.view2D.backgrounds.model
{
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.PlanetPattern;
   
   public class PlanetVO extends BackgroundElementVO
   {
      
      private var _rotation:Number;
      
      private var _typeID:String;
      
      private var _x:int;
      
      private var _y:int;
      
      private var _scale:Number;
      
      private var _qualitySettings:String;
      
      public function PlanetVO(param1:String, param2:int, param3:int, param4:Number, param5:Number, param6:int, param7:Number, param8:String)
      {
         super(param6,param5);
         this._typeID = param1;
         this._qualitySettings = param8;
         this._x = param2 * 10;
         this._y = param3 * 10;
         this._rotation = param4;
         this._scale = param7;
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      public function get rotation() : Number
      {
         return this._rotation;
      }
      
      public function get pattern() : PlanetPattern
      {
         return PatternManager.planetPatterns[this._typeID];
      }
      
      public function get typeID() : String
      {
         return this._typeID;
      }
      
      public function get x() : int
      {
         return this._x;
      }
      
      public function get y() : int
      {
         return this._y;
      }
      
      public function get getQualitySettings() : String
      {
         return this._qualitySettings;
      }
   }
}

