package net.bigpoint.darkorbit.pattern
{
   public class POIPattern
   {
      
      public static const DESIGN_TYPE_BACKGROUND:String = "background";
      
      public static const DESIGN_TYPE_SIMPLE:String = "simple";
      
      public static const DESIGN_TYPE_TEXTURE:String = "texture";
      
      public static const DESIGN_TYPE_SIMPLE_IN_LOW:String = "simple_in_low";
      
      public var id:int;
      
      public var designType:String;
      
      public var radiusOffset:int;
      
      public var useCustomShader:Boolean;
      
      public var textureSize:Number;
      
      private var _additionalUberAssetId:String;
      
      private var _radiusVisualMultiplier:Number = 1;
      
      public function POIPattern(param1:int, param2:String, param3:Boolean = false, param4:Number = 1, param5:String = null, param6:Number = 0)
      {
         super();
         this.id = param1;
         this.designType = param2;
         this.useCustomShader = param3;
         this.textureSize = param4;
         this._additionalUberAssetId = param5;
         this._radiusVisualMultiplier = param6;
      }
      
      public function get additionalUberAssetId() : String
      {
         return this._additionalUberAssetId;
      }
      
      public function get radiusVisualMultiplier() : Number
      {
         return this._radiusVisualMultiplier;
      }
   }
}

