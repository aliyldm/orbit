package net.bigpoint.darkorbit.map.model.poizones
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableInt;
   import com.bigpoint.utils.bindables.BindableNumber;
   import com.bigpoint.utils.bindables.BindableString;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   
   public class POIZone extends MapEntity
   {
      
      public static const COLLISION_OFFSET:int = 20;
      
      public static const ZONE_TYPE_NOA:String = "NOA";
      
      public static const ZONE_TYPE_HEA:String = "HEA";
      
      public static const ZONE_TYPE_TRG:String = "TRG";
      
      public static const ZONE_TYPE_DMG:String = "DMG";
      
      public static const ZONE_TYPE_RAD:String = "RAD";
      
      public static const ZONE_TYPE_SECTOR_CONTROL_HOME_ZONE:String = "HZ";
      
      public static const ZONE_TYPE_SECTOR_CONTROL_SECTOR_ZONE:String = "SZ";
      
      public static const ZONE_TYPE_BST:String = "BST";
      
      public static const ZONE_TYPE_ACTIVATION_ZONE:String = "AZ";
      
      public static const ZONE_TYPE_ACTIVATION_ZONE_OUTLINE:String = "AZO";
      
      public static const ZONE_TYPE_PET_DISRUPTION:String = "PD";
      
      public static const ZONE_TYPE_EQUIPPABLE_ZONE:String = "EQ";
      
      public static const ZONE_TYPE_CAMERA_ZONE:String = "CAMERA";
      
      public static const SHAPE_CIRCLE:String = "CIR";
      
      public static const SHAPE_RECT:String = "REC";
      
      public static const SHAPE_POLYGON:String = "POL";
      
      public static const ZONE_TYPE_NOA_INVERS_LINETHICKNESS:uint = 384;
      
      private static const MINIMAP_TYPES:Vector.<String> = Vector.<String>([ZONE_TYPE_BST,ZONE_TYPE_SECTOR_CONTROL_HOME_ZONE,ZONE_TYPE_SECTOR_CONTROL_SECTOR_ZONE,ZONE_TYPE_RAD,ZONE_TYPE_ACTIVATION_ZONE_OUTLINE]);
      
      public const zoneTypeSpecification:BindableString = new BindableString();
      
      public const zoneTargetTypeSpecification:BindableString = new BindableString();
      
      private var _zoneType:String;
      
      private var _designID:int;
      
      private var _inverted:Boolean;
      
      private var _bounds:Rectangle;
      
      private var _borderSize:BindableInt = new BindableInt(100000);
      
      private var _rotationSpeed:BindableNumber = new BindableNumber(0);
      
      private var _scaling:BindableNumber = new BindableNumber(0);
      
      private var _pulseSpeed:BindableNumber = new BindableNumber(0);
      
      private var _movingSpeedX:BindableNumber = new BindableNumber(0);
      
      private var _movingSpeedY:BindableNumber = new BindableNumber(0);
      
      private var _useCustomShader:BindableBoolean;
      
      private var _zoneId:String;
      
      public function POIZone(param1:int, param2:PointLite, param3:String, param4:Boolean, param5:int, param6:Rectangle, param7:String)
      {
         super(param1,param2);
         this._zoneType = param3;
         this._designID = param5;
         this._inverted = param4;
         this._bounds = param6;
         this._zoneId = param7;
         addTrait(new POIZoneTrait());
      }
      
      public function get designID() : int
      {
         return this._designID;
      }
      
      public function get inverted() : Boolean
      {
         return this._inverted;
      }
      
      public function get zoneType() : String
      {
         return this._zoneType;
      }
      
      public function get bounds() : Rectangle
      {
         return this._bounds;
      }
      
      protected function visibleOnMinimap() : Boolean
      {
         return MINIMAP_TYPES.indexOf(this.zoneType) != -1 || this.designID > 0 && this.zoneType == ZONE_TYPE_NOA;
      }
      
      public function get borderSize() : BindableInt
      {
         return this._borderSize;
      }
      
      public function get rotationSpeed() : BindableNumber
      {
         return this._rotationSpeed;
      }
      
      public function get scaling() : BindableNumber
      {
         return this._scaling;
      }
      
      public function get pulseSpeed() : BindableNumber
      {
         return this._pulseSpeed;
      }
      
      public function get useCustomShader() : BindableBoolean
      {
         return this._useCustomShader;
      }
      
      public function set useCustomShader(param1:BindableBoolean) : void
      {
         this._useCustomShader = param1;
      }
      
      public function get movingSpeedX() : BindableNumber
      {
         return this._movingSpeedX;
      }
      
      public function get movingSpeedY() : BindableNumber
      {
         return this._movingSpeedY;
      }
      
      public function get zoneId() : String
      {
         return this._zoneId;
      }
   }
}

