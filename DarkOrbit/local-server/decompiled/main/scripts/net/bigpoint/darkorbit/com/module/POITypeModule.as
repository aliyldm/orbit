package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class POITypeModule implements IModule
   {
      
      private static var _instance:POITypeModule;
      
      public static const POITYPE_GENERIC:int = 0;
      
      public static const POITYPE_FACTORIZED:int = 1;
      
      public static const POITYPE_TRIGGER:int = 2;
      
      public static const POITYPE_DAMAGE:int = 3;
      
      public static const POITYPE_HEALING:int = 4;
      
      public static const POITYPE_NO_ACCESS:int = 5;
      
      public static const POITYPE_FACTION_NO_ACCESS:int = 6;
      
      public static const POITYPE_ENTER_LEAVE:int = 7;
      
      public static const POITYPE_RADIATION:int = 8;
      
      public static const POITYPE_CAGE:int = 9;
      
      public static const POITYPE_MINE_FIELD:int = 10;
      
      public static const POITYPE_BUFF_ZONE:int = 11;
      
      public static const POITYPE_SECTOR_CONTROL_HOME_ZONE:int = 12;
      
      public static const POITYPE_SECTOR_CONTROL_SECTOR_ZONE:int = 13;
      
      public static const POITYPE_ACTIVATION_ZONE:int = 14;
      
      public static const POITYPE_OUTLINE_ZONE:int = 15;
      
      public static const POITYPE_EQUIPPABLE_ZONE:int = 16;
      
      public static const POITYPE_PET_DISRUPTION_ZONE:int = 17;
      
      public static const POITYPE_Z_GATE_ASTEROIDS:int = 18;
      
      public static const POITYPE__MAX:int = 19;
      
      public var typeValue:int = 0;
      
      public function POITypeModule(param1:int = 0)
      {
         super();
         this.typeValue = param1;
      }
      
      public static function get instance() : POITypeModule
      {
         return _instance || (_instance = new POITypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6674;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.typeValue = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6674);
         param1.writeShort(this.typeValue);
      }
   }
}

