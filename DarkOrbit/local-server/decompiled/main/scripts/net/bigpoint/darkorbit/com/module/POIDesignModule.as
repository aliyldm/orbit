package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class POIDesignModule implements IModule
   {
      
      private static var _instance:POIDesignModule;
      
      public static const POIDESIGN_NONE:int = 0;
      
      public static const POIDESIGN_ASTEROIDS:int = 1;
      
      public static const POIDESIGN_ASTEROIDS_BLUE:int = 2;
      
      public static const POIDESIGN_ASTEROIDS_MIXED_WITH_SCRAP:int = 3;
      
      public static const POIDESIGN_SCRAP:int = 4;
      
      public static const POIDESIGN_NEBULA:int = 5;
      
      public static const POIDESIGN_SIMPLE:int = 6;
      
      public static const POIDESIGN_SECTOR_CONTROL_HOME_ZONE:int = 7;
      
      public static const POIDESIGN_SECTOR_CONTROL_SECTOR_ZONE:int = 8;
      
      public static const POIDESIGN_ACTIVATION_ZONE:int = 9;
      
      public static const POIDESIGN_OUTLINE_ZONE:int = 10;
      
      public static const POIDESIGN_PET_DISRUPTION_ZONE:int = 11;
      
      public static const POIDESIGN_STREUNER_ASTEROIDS:int = 12;
      
      public static const POIDESIGN_SIMPLE_LOW_ONLY:int = 13;
      
      public static const POIDESIGN_Z_GATE_ASTEROIDS:int = 14;
      
      public static const POIDESIGN_Z_GATE_ASTEROIDS_SPARSE:int = 15;
      
      public static const POIDESIGN__MAX:int = 16;
      
      public var designValue:int = 0;
      
      public function POIDesignModule(param1:int = 0)
      {
         super();
         this.designValue = param1;
      }
      
      public static function get instance() : POIDesignModule
      {
         return _instance || (_instance = new POIDesignModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6675;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.designValue = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6675);
         param1.writeShort(this.designValue);
      }
   }
}

